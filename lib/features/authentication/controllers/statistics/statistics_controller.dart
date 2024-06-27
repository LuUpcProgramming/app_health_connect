import 'package:app_health_connect/config/constants/environment.dart';
import 'package:app_health_connect/config/helper/logging.dart';
import 'package:app_health_connect/data/repositories/statistics/statistics_repository.dart';
import 'package:app_health_connect/features/authentication/models/statistics.dart';
import 'package:app_health_connect/utils/constants/text_strings.dart';
import 'package:app_health_connect/utils/popups/loaders.dart';
import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:flutter/material.dart';
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
/*   var estadisticas = Estadisticas(
    estadoAnimoPromedio: 'Ligeramente Estresado',
    mensajeEstadoAnimo:
        '“Persististe a pesar de los desafíos esta semana. Ahora, prioriza tu bienestar. Recarga energías y sigue adelante. Tu salud mental es crucial para tu éxito. ¡Sigue adelante!”',
    progreso: [5, 10, 7, 12, 14, 8, 6],
    logros: [
      Logro(titulo: 'Gourmet Saludable', icono: Icons.restaurant),
      Logro(titulo: 'Equilibrio Espiritual', icono: Icons.spa),
      Logro(titulo: 'Resiliencia Fitness', icono: Icons.fitness_center),
    ],
  ).obs; */
  var estadisticasSemanal = EstadisticasSemanal(
    estadoAnimoPromedio: TTexts.sinRegistros,
    mensajeEstadoAnimo: TTexts.sinRegistros,
    progresoLogros: [0, 0, 0, 0, 0, 0, 0],
    progresoPlanes: [0, 0, 0, 0, 0, 0, 0],
    logros: [],
  ).obs;

  //***************Métodos***************/
  /* void updateEstadisticas(Estadisticas nuevasEstadisticas) {
    estadisticas.value = nuevasEstadisticas;
  } */

/*   Future<void> cargaEstadisticas() async {
    isLoading.value = true;
    if (selectedDate.value == TTexts.semanal) {
      updateEstadisticas(
        Estadisticas(
          estadoAnimoPromedio: 'Muy Feliz',
          mensajeEstadoAnimo:
              '“Recarga energías, tómate un tiempo para ti mismo y haz aquello que te haga sentir bien. Recuerda que tu salud mental es fundamental para alcanzar tus metas.¡Sigue adelante!”',
          progresoLogros: [5, 10, 12, 10, 2, 8, 9],
          progresoPlanes: [10, 12, 12, 10, 8, 9, 9],
          logros: [
            Logro(titulo: 'Sueño Reparador', icono: Icons.bed),
            Logro(titulo: 'Mente en Calma', icono: Icons.self_improvement),
            Logro(titulo: 'Círculos de apoyo', icono: Icons.group),
          ],
        ),
      );
    } else if (selectedDate.value == TTexts.mensual) {
      updateEstadisticas(
        Estadisticas(
          estadoAnimoPromedio: 'Ligeramente triste',
          mensajeEstadoAnimo:
              '“Persististe a pesar de los desafíos. Ahora, prioriza tu bienestar. Recarga energías y sigue adelante. Tu salud mental es crucial para tu éxito. ¡Sigue adelante!”',
          progresoLogros: [15, 20, 20, 40, 15, 30],
          progresoPlanes: [25, 40, 40, 40, 15, 30],
          logros: [
            Logro(titulo: 'Gourmet Saludable', icono: Icons.restaurant),
            Logro(titulo: 'Equilibrio Espiritual', icono: Icons.spa),
            Logro(titulo: 'Resiliencia Fitness', icono: Icons.fitness_center),
          ],
        ),
      );
    }
    isLoading.value = false;
  } */

  //var estadisticasDiarias = EstadisticasDiarias().obs;
/*   Future<void> obtenerEstadisticasDiarias() async {
    var fechaActual = DateTime.now();
    try {
      isLoading.value = true;
      String fechaFormato = DateFormat('dd-MM-yyyy').format(fechaActual);

      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('estadisticas')
          //.doc(AuthenticationRepository.instance.authUser!.uid)
          .doc('61gBjNkAMk5LfBf5zRty')
          .collection('diario')
          .doc(fechaFormato)
          .get();

      if (doc.exists) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        estadisticasDiarias.value = EstadisticasDiarias(
          estadoAnimo: data['estado_animo'],
          descripcionEstadoAnimo: data['descripcion_animo'],
          cantidadPlanesTotales: data['c_planes_totales'],
          cantidadPlanesCumplidos: data['c_planes_cumplidos'],
          logros: List<String>.from(data['logros']),
        );
      } else {
        estadisticasDiarias.value =
            EstadisticasDiarias(); // Datos vacíos si no existe el documento
      }
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      print("Error obteniendo estadísticas diarias: $e");
    }
  } */

  @override
  void onInit() {
    super.onInit();
    openAI = OpenAI.instance.build(
        token: openAiKey,
        baseOption: HttpSetup(receiveTimeout: const Duration(seconds: 5)),
        enableLog: true);
    obtenerEstadisticasDiarias().then((_) {
      calcularEstadisticaSemanal();
    });
  }

  var estadisticasDiarias = <EstadisticasDiaria>[].obs;

  void cargaDataEstadisticas() {
    obtenerEstadisticasDiarias().then((_) {
      calcularEstadisticaSemanal();
    });
  }

  Future<void> obtenerEstadisticasDiarias() async {
    try {
      List<EstadisticasDiaria> semanaEstadisticas = [];
      DateTime hoy = DateTime.now();

      // Obtener el día de la semana (1 es Lunes, 7 es Domingo)
      int diaSemana = hoy.weekday;

      // Calcular la diferencia desde el lunes de esa semana
      DateTime lunes = hoy.subtract(Duration(days: diaSemana - 1));

      // Crear una lista de fechas desde lunes hasta domingo
      List<DateTime> semana =
          List.generate(7, (index) => lunes.add(Duration(days: index)));

      for (var dia in semana) {
        //DateTime fecha = hoy.subtract(Duration(days: i));
        String fechaFormato = DateFormat('yyyy-MM-dd').format(dia);

        EstadisticasDiaria obj =
            await statsRepository.getEstadisticaDiariaPorFecha(fechaFormato);
        semanaEstadisticas.add(obj);
      }

      estadisticasDiarias.value = semanaEstadisticas;
    } catch (e) {
      estadisticasDiarias.value = [];
      log.e("Error: obtenerEstadisticasDiarias:  ${e.toString()}");
      Loaders.errorSnackBar(
          title: 'Oh, sucedió un error', message: e.toString());
      throw Exception(e);
    }
  }

  // Existing variables...
  var estadoAnimoPromedio = ''.obs;
  var descripcionEstadoAnimoPromedio = ''.obs;
  var progresoSemanal = <int>[].obs;
  var topLogros = <String>[].obs;

  Future<void> calcularEstadisticaSemanal() async {
    if (estadisticasDiarias.isEmpty) return;
    try {
      isLoading.value = true;
      log.i("calcularEstadisticaSemanal: Comienza calcularEstadisticaSemanal");
      await analizarEstadisticaOpenAI(estadisticasDiarias);
    } catch (e) {
      log.e("Ocurrio un Error: ${e.toString()}");
    } finally {
      isLoading.value = false;
      log.i("calcularEstadisticaSemanal: Finaliza calcularEstadisticaSemanal");
    }
  }

  Future<void> analizarEstadisticaOpenAI(
      List<EstadisticasDiaria> listEstadistica) async {
    try {
      List<String> estadosAnimo = [];
      List<String> descripcionesAnimo = [];
      List<int> cantidadPlanTotal = [];
      List<int> cantidadPlanCumplido = [];
      List<String> logros = [];

      for (var elemento in listEstadistica) {
        estadosAnimo.add(elemento.estadoAnimo);
        descripcionesAnimo.add(elemento.descripcionAnimo);
        cantidadPlanTotal.add(elemento.cantPlanTotal);
        cantidadPlanCumplido.add(elemento.cantPlanCumplido);

        for (var logro in elemento.logros) {
          logros.add(logro);
        }
      }

      final promptEstadistica = """
      Actúa como un psicólogo con altos conocimientos de Terapia Cognitivo Conductual (CBT). Te muestro la siguiente información de un paciente:
      1. Estados de ánimos durante la semana: ${estadosAnimo.join(', ')} .
      2. Descripciones de los estados de ánimos durante la semana : ${descripcionesAnimo.join(', ')} .
      3. Logros obtenidos tras cumplir actividades positivas de salud mental para el paciente durante la semana: ${logros.join(', ')} .

      Analiza esa información y dame como respuesta lo siguiente:
      1. En 2 palabras como máximo dime el estado de ánimo promedio del Paciente. Al final agrega "|" .
      2. Un mensaje motivador para el paciente respecto a las descripciones de estados de ánimos analizados. Máximo en 30 palabrass y luego al final agrega "|".
      3. Top 3 logros que el paciente haya obtenido durante la semana. Cada logro sepáralo con una coma.

      Te muestro ejemplos de como debes darme tus respuestas:
      Ejemplo 1: Ligeramente Estresado | Persististe a pesar de los desafíos. Ahora, prioriza tu bienestar. Recarga energías y sigue adelante. 
      Tu salud mental es crucial para tu éxito.¡A Esforzarse! | Gourmet Saludable,Equilibrio Espiritual,Resiliencia Fitness
      Ejemplo 2: Muy Enojado | Fueron días difíciles pero no te desanimes. Eres un gran guerrero que siempre lucha por sus objetivos. 
      Busquemos la paz y meditación constante para apaciguar nuestros pensamientos y seguir adelante.| Dieta Balanceada,Desconexión Digital,Hidratación Deportiva
      Ejemplo 3: Muy Feliz | Fueron días maravillosos, cumpliste varias metas y formaste nuevas amistades, estableciendo un lazo único con ellos. Sigue
      así, la vida es para disfrutarla y no hay que desaprovecharla. ¡Con Fuerza! | Desayuno Energético,Respiración Profunda,Descanso Activo
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
      List<String> listaLogrosTop3 = listaFullResponse[2].trim().split(',');
      
      final estadisticaSemanal = EstadisticasSemanal(
        estadoAnimoPromedio: listaFullResponse[0].trim(),
        mensajeEstadoAnimo: listaFullResponse[1].trim(),
        progresoLogros: cantidadPlanCumplido,
        progresoPlanes: cantidadPlanTotal,
        logros: listaLogrosTop3
      );

      //Grabar Estadistica Semanal
      await statsRepository.saveEstadisticaSemanal(estadisticaSemanal);

      EstadisticasSemanal obtenerEstadistica =await statsRepository.getEstadisticaSemanal();
      estadisticasSemanal.value = obtenerEstadistica;

      if(obtenerEstadistica.logros.length == 3){
        logroConIcono.value = [
          Logro(titulo: obtenerEstadistica.logros[0].trim(), icono: Icons.restaurant),
          Logro(titulo: obtenerEstadistica.logros[1].trim(), icono: Icons.fitness_center),
          Logro(titulo: obtenerEstadistica.logros[2].trim(), icono: Icons.spa)
        ];
      }else{
        logroConIcono.value = [
          Logro(titulo: 'Gourmet Saludable', icono: Icons.restaurant),
          Logro(titulo: 'Dieta Balanceada', icono: Icons.spa),
          Logro(titulo: 'Resiliencia Fitness', icono: Icons.fitness_center)
        ];
      }

    } catch (e) {
      log.e("Ocurrió un error: $e");
    }
  }
}
