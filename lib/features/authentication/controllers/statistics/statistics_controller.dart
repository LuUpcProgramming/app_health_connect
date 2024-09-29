import 'dart:async';

import 'package:app_health_connect/config/constants/environment.dart';
import 'package:app_health_connect/config/helper/logging.dart';
import 'package:app_health_connect/data/repositories/authentication/authentication_repository.dart';
import 'package:app_health_connect/data/repositories/statistics/statistics_repository.dart';
import 'package:app_health_connect/features/authentication/models/statistics.dart';
import 'package:app_health_connect/utils/constants/text_strings.dart';
import 'package:app_health_connect/utils/popups/loaders.dart';
import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class EstadisticaController extends GetxController {
  static EstadisticaController get instance => Get.find();

  //***************Variables***************/
  final selectedDate = TTexts.semanal.obs;
  final log = logger(EstadisticaController);
  final List<String> listaTipoFecha = [TTexts.semanal, TTexts.mensual];
  var isLoading = true.obs;
  late final OpenAI openAI;
  final openAiKey = Environment.openAiKey;
  RxList<Logro> logroConIcono = <Logro>[].obs;
  final statsRepository = Get.put(StatisticsRepository());
  var cargaEstadisticaCompleto = false;
//  StreamSubscription<DocumentSnapshot>? _subscriptionSemanal;
//  StreamSubscription<DocumentSnapshot>? _subscriptionMensual;
  StreamSubscription<DocumentSnapshot>? _subscription;
  var estadisticasDiarias7 = <EstadisticasDiaria>[].obs;
  var estadisticasDiarias30 = <EstadisticasDiaria>[].obs;
  //RxBool get hasDataChanged => statsRepository.hasDataChanged;
  // Existing variables...
  var estadoAnimoPromedio = ''.obs;
  var descripcionEstadoAnimoPromedio = ''.obs;
  var progresoSemanal = <int>[].obs;
  var topLogros = <String>[].obs;
  var estadisticasSemanal = EstadisticasSemanal(
    estadoAnimoPromedio: TTexts.sinRegistros,
    mensajeEstadoAnimo: TTexts.sinRegistros,
    progresoLogros: [0, 0, 0, 0, 0, 0, 0],
    progresoPlanes: [0, 0, 0, 0, 0, 0, 0],
    logros: [],
  ).obs;

  //***************Métodos***************/

  @override
  void onInit() {
    super.onInit();

    openAI = OpenAI.instance.build(
        token: openAiKey,
        baseOption: HttpSetup(receiveTimeout: const Duration(seconds: 5)),
        enableLog: true);
  }

  @override
  void onClose() {
    stopListening();
    super.onClose();
  }

  Future<void> obtenerEstadisticasDiarias() async {
    try {
      List<EstadisticasDiaria> semanaEstadisticas = [];
      DateTime hoy = DateTime.now();

      int diaSemana = hoy.weekday;
      DateTime lunes = hoy.subtract(Duration(days: diaSemana - 1));
      List<DateTime> semana =
          List.generate(7, (index) => lunes.add(Duration(days: index)));

      //List<DateTime> semana = TTexts.obtenerUltimos7Dias();

      for (var dia in semana) {
        //DateTime fecha = hoy.subtract(Duration(days: i));
        String fechaFormato = DateFormat('yyyy-MM-dd').format(dia);

        EstadisticasDiaria? obj =
            await statsRepository.getEstadisticaDiariaPorFecha(fechaFormato);
        if (obj != null) {
          semanaEstadisticas.add(obj);
        } else {
          var estadisticaDiaria = EstadisticasDiaria(
            fecha: fechaFormato,
            estadoAnimo: TTexts.sinRegistros,
            descripcionAnimo: TTexts.sinRegistros,
            cantPlanTotal: 0,
            cantPlanCumplido: 0,
            logros: [],
            fechaRegistro: DateTime.parse(fechaFormato),
          );
          await statsRepository.saveEstadisticaDiaria(
              estadisticaDiaria,
              fechaFormato,
              AuthenticationRepository.instance.authUser?.uid ?? '0');
          semanaEstadisticas.add(estadisticaDiaria);
        }
      }
      estadisticasDiarias7.assignAll(semanaEstadisticas);
      semanaEstadisticas = [];

      List<DateTime> mes = TTexts.obtenerUltimos30Dias();
      int cantidadDias =
          await statsRepository.getCantidadEstadisticasDiariasPorUsuario();
      if (cantidadDias > 28) {
        for (var dia in mes) {
          //DateTime fecha = hoy.subtract(Duration(days: i));
          String fechaFormato = DateFormat('yyyy-MM-dd').format(dia);

          EstadisticasDiaria? obj =
              await statsRepository.getEstadisticaDiariaPorFecha(fechaFormato);
          if (obj != null) {
            semanaEstadisticas.add(obj);
          } else {
            var estadisticaDiaria = EstadisticasDiaria(
              fecha: fechaFormato,
              estadoAnimo: TTexts.sinRegistros,
              descripcionAnimo: TTexts.sinRegistros,
              cantPlanTotal: 0,
              cantPlanCumplido: 0,
              logros: [],
              fechaRegistro: DateTime.parse(fechaFormato),
            );
            await statsRepository.saveEstadisticaDiaria(
                estadisticaDiaria,
                fechaFormato,
                AuthenticationRepository.instance.authUser?.uid ?? '0');
            semanaEstadisticas.add(estadisticaDiaria);
          }
        }
        estadisticasDiarias30.assignAll(semanaEstadisticas);
      } else {
        estadisticasDiarias30.value = [];
      }
    } catch (e) {
      estadisticasDiarias7.value = [];
      estadisticasDiarias30.value = [];
      log.e("Error: obtenerEstadisticasDiarias:  ${e.toString()}");
      Loaders.errorSnackBar(
          title: 'Oh, sucedió un error', message: e.toString());
      throw Exception(e);
    }
  }

  Future<void> calcularEstadisticaSemanal() async {
    if (estadisticasDiarias7.isEmpty) return;
    try {
      isLoading.value = true;
      log.i("calcularEstadisticaSemanal: Comienza calcularEstadisticaSemanal");
      await analizarEstadisticaSemanalOpenAI(estadisticasDiarias7);
    } catch (e) {
      log.e("Ocurrio un Error: ${e.toString()}");
    } finally {
      isLoading.value = false;
      log.i("calcularEstadisticaSemanal: Finaliza calcularEstadisticaSemanal");
    }
  }

  Future<void> calcularEstadisticaMensual() async {
    if (estadisticasDiarias30.isEmpty) return;
    try {
      isLoading.value = true;
      log.i("calcularEstadisticaMensual: Comienza calcularEstadisticaMensual");
      await analizarEstadisticaMensualOpenAI(estadisticasDiarias30);
    } catch (e) {
      log.e("Ocurrio un Error: ${e.toString()}");
    } finally {
      isLoading.value = false;
      log.i("calcularEstadisticaMensual: Finaliza calcularEstadisticaMensual");
    }
  }

  Future<void> analizarEstadisticaSemanalOpenAI(
      List<EstadisticasDiaria> listEstadistica) async {
    try {
      List<String> estadosAnimo = [];
      List<String> descripcionesAnimo = [];
      List<int> cantidadPlanTotal = [];
      List<int> cantidadPlanCumplido = [];
      // List<String> logros = [];
      List<int> logrosPlan = [];

      bool ningunCampoLleno = listEstadistica.every((detail) =>
          detail.estadoAnimo.trim().isEmpty &&
          detail.descripcionAnimo.trim().isEmpty);

      for (var elemento in listEstadistica) {
        estadosAnimo.add(elemento.estadoAnimo);
        descripcionesAnimo.add(elemento.descripcionAnimo);
        cantidadPlanTotal.add(elemento.cantPlanTotal);
        cantidadPlanCumplido.add(elemento.cantPlanCumplido);

        for (var logro in elemento.logros) {
          logrosPlan.add(logro);
        }
        /*  for (var logro in elemento.logros) {
          logros.add(TTexts.obtenerNombreLogro(logro));
        } */
      }
      List<String> listaFullResponse = ["",""];
      if (!ningunCampoLleno) {
        final promptEstadistica = """
        Actúa como un psicólogo con altos conocimientos de Terapia Cognitivo Conductual (CBT). Te muestro la siguiente información de un paciente:
        1. Estados de ánimos durante la semana: ${estadosAnimo.join(', ')} .
        2. Descripciones de los estados de ánimos durante la semana : ${descripcionesAnimo.join(', ')} .

        Analiza esa información y dame como respuesta lo siguiente:
        - En 2 palabras como máximo dime el estado de ánimo promedio del Paciente. Al final agrega "|" .
        - Un mensaje motivador para el paciente respecto a las descripciones de estados de ánimos analizados. Máximo en 30 palabrass y luego al final agrega "|".
    
        Te muestro ejemplos de como debes darme tus respuestas:
        Ejemplo 1: Ligeramente Estresado | Persististe a pesar de los desafíos. Ahora, prioriza tu bienestar. Recarga energías y sigue adelante. 
        Tu salud mental es crucial para tu éxito.¡A Esforzarse!
        Ejemplo 2: Muy Enojado | Fueron días difíciles pero no te desanimes. Eres un gran guerrero que siempre lucha por sus objetivos. 
        Busquemos la paz y meditación constante para apaciguar nuestros pensamientos y seguir adelante.
        Ejemplo 3: Muy Feliz | Fueron días maravillosos, cumpliste varias metas y formaste nuevas amistades, estableciendo un lazo único con ellos. Sigue
        así, la vida es para disfrutarla y no hay que desaprovecharla. ¡Con Fuerza!
        """;

        List<Map<String, dynamic>> messagesHistory = [];
        messagesHistory.insert(0,
            Messages(role: Role.system, content: promptEstadistica).toJson());
        final request = ChatCompleteText(
            messages: messagesHistory,
            maxToken: 500,
            temperature: 0.7,
            model: GptTurbo0125ChatModel());
        log.i("Antes de ejecutar  OPENAI API");
        final response = await openAI.onChatCompletion(request: request);
        log.i("Despues de ejecutar OPENAI API");
        var fullResponse = '';
        if (response != null && response.choices.isNotEmpty) {
          log.i("Se encuentra respuesta OPENAI");
          fullResponse = response.choices.first.message?.content ?? '';
          log.i("Respuesta: $fullResponse");
        } else {
          log.e("No se pudo obtener respuesta del modelo GPT-3.5");
          throw Exception('No se pudo obtener respuesta del modelo GPT-3.5');
        }

        listaFullResponse = fullResponse.split('|');
      } else {
        listaFullResponse[0] = "";
        listaFullResponse[1] = "";
      }

      // Contar la frecuencia de cada logro
      var freqMap = <int, int>{};
      for (var logro in logrosPlan) {
        freqMap[logro] = (freqMap[logro] ?? 0) + 1;
      }
      // Ordenar por frecuencia y tomar los tres más frecuentes
      var sortedLogros = freqMap.entries.toList()
        ..sort((a, b) => b.value.compareTo(a.value));
      // Tomar los tres logros más frecuentes
      var top3Logros = sortedLogros.take(3).map((entry) => entry.key).toList();

      final estadisticaSemanal = EstadisticasSemanal(
          estadoAnimoPromedio: listaFullResponse[0].trim(),
          mensajeEstadoAnimo: listaFullResponse[1].trim(),
          progresoLogros: cantidadPlanCumplido,
          progresoPlanes: cantidadPlanTotal,
          logros: top3Logros);

      //Grabar Estadistica Semanal
      await statsRepository.saveEstadisticaSemanal(estadisticaSemanal);
    } catch (e) {
      log.e("Ocurrió un error: ${e.toString()}");
    }
  }

  Future<void> analizarEstadisticaMensualOpenAI(
      List<EstadisticasDiaria> listEstadistica) async {
    try {
      List<String> estadosAnimo = [];
      List<String> descripcionesAnimo = [];
      List<int> cantidadPlanTotal = [];
      List<int> cantidadPlanCumplido = [];
      // List<String> logros = [];
      List<int> logrosPlan = [];

      // Inicializa la lista que contendrá las sumas de cada 7 días
      List<int> cantidadPlanTotalPorSemana = List.filled(4, 0);
      List<int> cantidadPlanCumplidoPorSemana = List.filled(4, 0);

      for (int i = 0; i < listEstadistica.length; i++) {
        // Agrega la información de cada día
        estadosAnimo.add(listEstadistica[i].estadoAnimo);
        descripcionesAnimo.add(listEstadistica[i].descripcionAnimo);
        cantidadPlanTotal.add(listEstadistica[i].cantPlanTotal);
        cantidadPlanCumplido.add(listEstadistica[i].cantPlanCumplido);
        logrosPlan = listEstadistica[i].logros;

        // Sumar los valores de cada 7 días
        int semanaIndex = i ~/
            7; // Dividimos por 7 para obtener el índice de la semana (0 a 3)
        cantidadPlanTotalPorSemana[semanaIndex] +=
            listEstadistica[i].cantPlanTotal;
        cantidadPlanCumplidoPorSemana[semanaIndex] +=
            listEstadistica[i].cantPlanCumplido;
      }

/*       for (var elemento in listEstadistica) {
        estadosAnimo.add(elemento.estadoAnimo);
        descripcionesAnimo.add(elemento.descripcionAnimo);
        cantidadPlanTotal.add(elemento.cantPlanTotal);
        cantidadPlanCumplido.add(elemento.cantPlanCumplido);

        logrosPlan = elemento.logros;
        /*  for (var logro in elemento.logros) {
          logros.add(TTexts.obtenerNombreLogro(logro));
        } */
      } */

      final promptEstadistica = """
      Actúa como un psicólogo con altos conocimientos de Terapia Cognitivo Conductual (CBT). Te muestro la siguiente información de un paciente:
      1. Estados de ánimos durante el mes: ${estadosAnimo.join(', ')} .
      2. Descripciones de los estados de ánimos durante el mes : ${descripcionesAnimo.join(', ')} .

      Analiza esa información y dame como respuesta lo siguiente:
      1. En 2 palabras como máximo dime el estado de ánimo promedio del Paciente. Al final agrega "|" .
      2. Un mensaje motivador para el paciente respecto a las descripciones de estados de ánimos analizados. Máximo en 30 palabrass y luego al final agrega "|".
  
      Te muestro ejemplos de como debes darme tus respuestas:
      Ejemplo 1: Ligeramente Estresado | Persististe a pesar de los desafíos. Ahora, prioriza tu bienestar. Recarga energías y sigue adelante. 
      Tu salud mental es crucial para tu éxito.¡A Esforzarse!
      Ejemplo 2: Muy Enojado | Fueron días difíciles pero no te desanimes. Eres un gran guerrero que siempre lucha por sus objetivos. 
      Busquemos la paz y meditación constante para apaciguar nuestros pensamientos y seguir adelante.
      Ejemplo 3: Muy Feliz | Fueron días maravillosos, cumpliste varias metas y formaste nuevas amistades, estableciendo un lazo único con ellos. Sigue
      así, la vida es para disfrutarla y no hay que desaprovecharla. ¡Con Fuerza!
      """;

      List<Map<String, dynamic>> messagesHistory = [];
      messagesHistory.insert(
          0, Messages(role: Role.system, content: promptEstadistica).toJson());
      final request = ChatCompleteText(
          messages: messagesHistory,
          maxToken: 500,
          temperature: 0.7,
          model: GptTurbo0125ChatModel());
      log.i("Antes de ejecutar  OPENAI API");
      final response = await openAI.onChatCompletion(request: request);
      log.i("Despues de ejecutar OPENAI API");
      var fullResponse = '';
      if (response != null && response.choices.isNotEmpty) {
        log.i("Se encuentra respuesta OPENAI");
        fullResponse = response.choices.first.message?.content ?? '';
        log.i("Respuesta: $fullResponse");
      } else {
        log.e("No se pudo obtener respuesta del modelo GPT-3.5");
        throw Exception('No se pudo obtener respuesta del modelo GPT-3.5');
      }

      List<String> listaFullResponse = fullResponse.split('|');
      //List<String> listaLogrosTop3 = listaFullResponse[2].trim().split(',');

      // Contar la frecuencia de cada logro
      var freqMap = <int, int>{};
      for (var logro in logrosPlan) {
        freqMap[logro] = (freqMap[logro] ?? 0) + 1;
      }
      // Ordenar por frecuencia y tomar los tres más frecuentes
      var sortedLogros = freqMap.entries.toList()
        ..sort((a, b) => b.value.compareTo(a.value));
      // Tomar los tres logros más frecuentes
      var top3Logros = sortedLogros.take(3).map((entry) => entry.key).toList();

      final estadisticaSemanal = EstadisticasSemanal(
          estadoAnimoPromedio: listaFullResponse[0].trim(),
          mensajeEstadoAnimo: listaFullResponse[1].trim(),
          progresoLogros: cantidadPlanTotalPorSemana,
          progresoPlanes: cantidadPlanCumplidoPorSemana,
          logros: top3Logros);

      //Grabar Estadistica Mensual
      await statsRepository.saveEstadisticaMensual(estadisticaSemanal);
    } catch (e) {
      log.e("Ocurrió un error: ${e.toString()}");
    }
  }

  bool isSubscriptionActive() {
    return _subscription != null && !_subscription!.isPaused;
  }

  void stopListening() {
    log.i("Se canceló stopWeeklyListening");
    _subscription?.cancel();
  }

  Future<void> startListeningWeeklyStatistics() async {
    log.i(
        "startListeningWeeklyStatistics: Comienza startListeningWeeklyStatistics");
    isLoading.value = true;
    if (!cargaEstadisticaCompleto) {
      await cargaEstadisticas();
      cargaEstadisticaCompleto = true;
    }

    _subscription =
        statsRepository.listenToWeeklyStatistics().listen((snapshot) {
      if (snapshot.exists) {
        var estadisticaLocal = EstadisticasSemanal.fromSnapshot(snapshot);
        estadisticasSemanal.value = estadisticaLocal;
        log.i(estadisticasSemanal.value.toString());
        List<Logro> lista = [];
        for (int i = 0; i < estadisticaLocal.logros.length; i++) {
          var logro = Logro(
              titulo: TTexts.obtenerNombreLogro(estadisticaLocal.logros[i]),
              icono: TTexts.obtenerIconoLogro(estadisticaLocal.logros[i]));

          lista.add(logro);
        }

        if (lista.length < 3) {
          switch (lista.length) {
            case 0:
              lista.add(Logro(
                  titulo: TTexts.obtenerNombreLogro(TTexts.sinLogro),
                  icono: TTexts.obtenerIconoLogro(TTexts.sinLogro)));
              lista.add(Logro(
                  titulo: TTexts.obtenerNombreLogro(TTexts.sinLogro),
                  icono: TTexts.obtenerIconoLogro(TTexts.sinLogro)));
              lista.add(Logro(
                  titulo: TTexts.obtenerNombreLogro(TTexts.sinLogro),
                  icono: TTexts.obtenerIconoLogro(TTexts.sinLogro)));
              break;
            case 1:
              lista.add(Logro(
                  titulo: TTexts.obtenerNombreLogro(TTexts.sinLogro),
                  icono: TTexts.obtenerIconoLogro(TTexts.sinLogro)));
              lista.add(Logro(
                  titulo: TTexts.obtenerNombreLogro(TTexts.sinLogro),
                  icono: TTexts.obtenerIconoLogro(TTexts.sinLogro)));
              break;
            case 2:
              lista.add(Logro(
                  titulo: TTexts.obtenerNombreLogro(TTexts.sinLogro),
                  icono: TTexts.obtenerIconoLogro(TTexts.sinLogro)));
              break;
            default:
          }
        }
        logroConIcono.assignAll(lista);
      } else {
        estadisticasSemanal.value = EstadisticasSemanal(
          estadoAnimoPromedio: TTexts.sinRegistros,
          mensajeEstadoAnimo: TTexts.sinRegistros,
          progresoLogros: [0, 0, 0, 0, 0, 0, 0],
          progresoPlanes: [0, 0, 0, 0, 0, 0, 0],
          logros: [],
        );
      }
      isLoading.value = false;
    });
    log.i(
        "startListeningWeeklyStatistics: Termina startListeningWeeklyStatistics");
  }

  Future<void> startListeningMonthlylStatistics() async {
    log.i(
        "startListeningMonthlylStatistics: Comienza startListeningMonthlylStatistics");
    isLoading.value = true;

    _subscription =
        statsRepository.listenToMonthlyStatistics().listen((snapshot) {
      if (snapshot.exists) {
        var estadisticaLocal = EstadisticasSemanal.fromSnapshot(snapshot);
        estadisticasSemanal.value = estadisticaLocal;
        log.i(estadisticasSemanal.value.toString());
        List<Logro> lista = [];
        for (int i = 0; i < estadisticaLocal.logros.length; i++) {
          var logro = Logro(
              titulo: TTexts.obtenerNombreLogro(estadisticaLocal.logros[i]),
              icono: TTexts.obtenerIconoLogro(estadisticaLocal.logros[i]));

          lista.add(logro);
        }

        if (lista.length < 3) {
          switch (lista.length) {
            case 0:
              lista.add(Logro(
                  titulo: TTexts.obtenerNombreLogro(TTexts.sinLogro),
                  icono: TTexts.obtenerIconoLogro(TTexts.sinLogro)));
              lista.add(Logro(
                  titulo: TTexts.obtenerNombreLogro(TTexts.sinLogro),
                  icono: TTexts.obtenerIconoLogro(TTexts.sinLogro)));
              lista.add(Logro(
                  titulo: TTexts.obtenerNombreLogro(TTexts.sinLogro),
                  icono: TTexts.obtenerIconoLogro(TTexts.sinLogro)));
              break;
            case 1:
              lista.add(Logro(
                  titulo: TTexts.obtenerNombreLogro(TTexts.sinLogro),
                  icono: TTexts.obtenerIconoLogro(TTexts.sinLogro)));
              lista.add(Logro(
                  titulo: TTexts.obtenerNombreLogro(TTexts.sinLogro),
                  icono: TTexts.obtenerIconoLogro(TTexts.sinLogro)));
              break;
            case 2:
              lista.add(Logro(
                  titulo: TTexts.obtenerNombreLogro(TTexts.sinLogro),
                  icono: TTexts.obtenerIconoLogro(TTexts.sinLogro)));
              break;
            default:
          }
        }
        logroConIcono.assignAll(lista);
      } else {
        estadisticasSemanal.value = EstadisticasSemanal(
          estadoAnimoPromedio: TTexts.sinRegistros,
          mensajeEstadoAnimo: TTexts.sinRegistros,
          progresoLogros: [0, 0, 0, 0],
          progresoPlanes: [0, 0, 0, 0],
          logros: [],
        );
        logroConIcono.value = [];
      }
      isLoading.value = false;
    });
    log.i(
        "startListeningMonthlylStatistics: Termina startListeningMonthlylStatistics");
  }

  Future<void> obtenerEstadisticas() async {
    try {
      isLoading.value = true;

      if (selectedDate.value == TTexts.semanal) {
        if (isSubscriptionActive()) {
          stopListening();
        }
        startListeningWeeklyStatistics();
      } else {
        if (isSubscriptionActive()) {
          stopListening();
        }
        startListeningMonthlylStatistics();
      }
    } catch (e) {
      log.e("Ocurrió un error: ${e.toString()}");
    } finally {
      isLoading.value = false;
    }
  }

  //Crea un método que llame primero a la función de obtenerEstadisticasDiarias para obtener su información. Luego que ejecute el calculo de estadísticas semanales.
  Future<void> cargaEstadisticas() async {
    try {
      await obtenerEstadisticasDiarias();
      await calcularEstadisticaSemanal();
      await calcularEstadisticaMensual();
      /*  obtenerEstadisticasDiarias().then((_) {
        calcularEstadisticaSemanal();
        calcularEstadisticaMensual();
      }); */
    } catch (e) {
      log.e("cargaEstadisticas: Ocurrió un error: ${e.toString()}");
    }
  }
}
