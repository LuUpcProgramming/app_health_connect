import 'dart:convert';
import 'dart:math';

import 'package:app_health_connect/config/constants/environment.dart';
import 'package:app_health_connect/config/helper/logging.dart';
import 'package:app_health_connect/data/repositories/chat/chat_repository.dart';
import 'package:app_health_connect/data/repositories/history/history_repository.dart';
import 'package:app_health_connect/data/repositories/plan/plan_repository.dart';
import 'package:app_health_connect/data/repositories/statistics/statistics_repository.dart';
import 'package:app_health_connect/data/repositories/user/user_repository.dart';
import 'package:app_health_connect/features/authentication/models/chat_message.dart';
import 'package:app_health_connect/features/authentication/models/history_advice.dart';
import 'package:app_health_connect/features/authentication/models/plan_diario.dart';
import 'package:app_health_connect/features/authentication/models/recomendacion.dart';
import 'package:app_health_connect/navigation_menu.dart';
import 'package:app_health_connect/utils/constants/image_strings.dart';
import 'package:app_health_connect/utils/constants/text_strings.dart';
import 'package:app_health_connect/utils/popups/full_screen_loader.dart';
import 'package:app_health_connect/utils/popups/loaders.dart';
import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ChatController extends GetxController {
  static ChatController get instance => Get.find();

  //***************Variables***************/

  // final _user = UserModel(id: '',);
  var nombreUsuario = "";
  var idUsuario = "";
  var countMessageHistory = 0;
  //List<Map<String, dynamic>> messagesHistory = [];
  //var messagesHistory = <ChatMessageModel>[].obs;
  var messagesHistory = <Map<String, dynamic>>[].obs;
  var isLoading = true.obs;
  final log = logger(ChatController);
  final openAiKey = Environment.openAiKey;
  late final OpenAI openAI;
  final currentUser = FirebaseAuth.instance.currentUser;

  //***************Métodos***************/
  @override
  void onInit() {
    super.onInit();
    openAI = OpenAI.instance.build(
        token: openAiKey,
        baseOption: HttpSetup(
            sendTimeout: const Duration(seconds: 10),
            receiveTimeout: const Duration(seconds: 10),
            connectTimeout: const Duration(seconds: 10)),
        enableLog: true);
    log.i("onInit: Se instancia OPENAI");
    WidgetsBinding.instance.addPostFrameCallback((_) {
      cargaDatosChat();
    });
  }

  Future<void> cargaDatosChat() async {
    try {
      TFullScreenLoader.openLoadingDialog(
          "Cargando Chat..", TImages.loadingAnimation);
      isLoading.value = true;
      log.i("cargaDatosChat: Comienza cargaDatosChat");

      // Carga de datos de Usuario
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        final userRepository = Get.put(UserRepository());
        final user = await userRepository.fethUserRecord();
        nombreUsuario = user.firstName;
        idUsuario = user.id;
      }
      log.i(
          "cargaDatosChat: nombreUsuario $nombreUsuario , idUsuario $idUsuario");
      // Carga de Historial de Mensajes desde la base de datos
      final chatRepository = Get.put(ChatRepository());
      var dataHistorial =
          await chatRepository.cargarHistorialMensajesPorUsuario(
              currentUser?.uid.trim() ?? idUsuario);

      final historial = <Map<String, dynamic>>[];
      for (var element in dataHistorial.listaMensajes) {
        historial.add({'role': element.role, 'content': element.content});
      }
      messagesHistory.assignAll(historial);
      countMessageHistory = messagesHistory.length;
      log.i("cargaDatosChat: Se carga Historial de Chat si lo hubiera");

      isLoading.value = false;
      TFullScreenLoader.stopLoading();
      log.i("cargaDatosChat: Finaliza cargaDatosChat");
    } catch (e) {
      TFullScreenLoader.stopLoading();
      log.e('Error en cargaDatosChat');
      log.e("Error: ${e.toString()}");
      //Show some generic error to user
      Loaders.errorSnackBar(
          title: 'Oh, sucedió un error', message: e.toString());
      throw Exception(e);
    }
  }

  Future<void> procesarConversacion(int indicador) async {
    try {
      log.i("procesarConversacion: Comienza procesarConversacion");
      TFullScreenLoader.openLoadingDialog(
          "Procesando Información...", TImages.loadingAnimation);
      if (messagesHistory.isNotEmpty) {
        if (countMessageHistory != messagesHistory.length) {
          // Aquí va la lógica para procesar la conversación
          log.i(
              "procesarConversacion: Entra a ejecutar saveHistoryToFirestore,saveHistoryRecomendacion,generarTipsRecomendacion");
          await saveHistoryToFirestore();
          await saveHistoryRecomendacion();
          await generarTipsRecomendacion(indicador);
          /* if (indicador == TTexts.indicadorGenerarPlan) {
            await generarPlandiario();
          } */
        }
      }

      Get.delete<ChatController>();
      Get.delete<ChatRepository>();
      //final dashboard = Get.put(DashboardController());
      //TFullScreenLoader.stopLoading();
      //await dashboard.loadData();
      Get.off(() => const NavigationMenu());
      //Get.to(()=> const HistorialAdviceScreen());
    } catch (e) {
      log.e('Error en procesarConversacion');
      log.e("Error: ${e.toString()}");
      TFullScreenLoader.stopLoading();
      //Show some generic error to user
      Loaders.errorSnackBar(
          title: 'Oh, sucedió un error', message: e.toString());
    } finally {
      log.i("procesarConversacion : Finaliza procesarConversacion");
    }
  }

  Future<void> saveHistoryToFirestore() async {
    try {
      log.i("saveHistoryToFirestore: Comienza saveHistoryToFirestore");
      var historialMensajes = <ChatMessageDetail>[];
      for (var message in messagesHistory) {
        var chatMessageDetail = ChatMessageDetail(
          role: message['role'],
          content: message['content'],
          //createdAt: DateTime.now()
        );
        historialMensajes.add(chatMessageDetail);
      }
      var objMensaje = ChatMessageModel(
          idUsuario: currentUser!.uid.trim(), listaMensajes: historialMensajes);

      final chatController = Get.put(ChatRepository());
      await chatController.saveMessageToFirestore(objMensaje);
      log.i(
          "saveHistoryToFirestore: Se guarda Historial de Mensajes del Chat en Firestore");
      log.i("saveHistoryToFirestore: Finaliza saveHistoryToFirestore");
    } catch (e) {
      log.e('Error en saveHistoryToFirestore');
      log.e("Error: ${e.toString()}");
      //Show some generic error to user
      Loaders.errorSnackBar(
          title: 'Oh, sucedió un error', message: e.toString());
      throw Exception(e);
    }
  }

  Future<void> saveHistoryRecomendacion() async {
    try {
      log.i("saveHistoryRecomendacion: Comienza saveHistoryRecomendacion");
      final promptSave = """
      De todo lo que hemos conversado, sintetiza toda la información en una recomendación resumida,  
      generando 4 datos:
      - Primero genera un título corto y llamativo que resuma la recomendación. Solo digita el título y sepáralo por el operador "|".
      - Luego una descripcion detallada explicando la recomendación. Solo digita la descripción y sepáralo por el operador "|".
      - Luego, une descripción resumida de la situación o problema. Solo digita la descripción y sepáralo por el operador "|".
      - Luegoo, solo 1 estado de ánimo de acuerdo a esta lista: ${TTexts.obtenerEstadosDeAnimo().join(', ')}.
      - Finalmente, solo 1 estado de trabajo de acuerdo a esta lista: ${TTexts.emocionesTrabajo.join(', ')}.

      Te muestro ejemplos de como debes darme tus respuestas:
      Ejemplo 1: Recupera tu equilibrio emocional|Encuentra momentos para expresar tus emociones, ya sea a través de la música, 
      actividades que disfrutes o conversaciones honestas.Practica la comunicación asertiva para abordar conflictos y cuida de ti mismo en situaciones estresantes.|Conflictos y situaciones estresantes en el trabajo.|Deprimido|Confundido
      Ejemplo 2: Recuperando el ánimo|Tómate un tiempo para ti, habla sobre tus sentimientos con alguien de confianza, 
      dedica tiempo a actividades que disfrutes como tocar la guitarra y practica la autocompasión.|Enojo por conflicto con el jefe del trabajo.|Triste|Presionado
      Ejemplo 3: Practica la respiración profunda|Cuando sientas el peso del estrés recuerda el poder la respiración profunda. 
      Puedes hacerlo en cualquier momento del día, incluso en el trabajo cuando te sientas abrumado. Inhala profundamente por tu nariz, retén el aire por un momento
      y luego exhala lentamente por la boca.|Exceso de actividades en el trabajo y horas extras sin pago.|Estresado|Frustrado
      """;
      messagesHistory
          .add(Messages(role: Role.user, content: promptSave).toJson());
      log.i("saveHistoryRecomendacion: Antes de llamar a OPENAI");
      final request = ChatCompleteText(
          messages: messagesHistory,
          maxToken: 500,
          temperature: 0.6,
          model: GptTurbo0125ChatModel());
      final response = await openAI.onChatCompletion(request: request);
      log.i(
          "saveHistoryRecomendacion: Despues de llamar a OPENAI para procesar Historial de Mensajes");

      String fullResponse = '';
      if (response != null && response.choices.isNotEmpty) {
        log.i("saveHistoryRecomendacion: Se muestra respuesta OPENAI");
        fullResponse = response.choices.first.message?.content ?? '';
      } else {
        throw Exception('No se pudo obtener respuesta del modelo GPT-3.5');
      }

      List<String> listaFullResponse = fullResponse.split('|');
      DateTime now = DateTime.now();
      if (listaFullResponse.length == 5) {
        var historyAdvice = HistoryAdvice(idUsuario: currentUser!.uid.trim());

        var historyadvicedt = HistoryAdviceDetail(
            title: listaFullResponse[0].trim(),
            description: listaFullResponse[1].trim(),
            problema: listaFullResponse[2].trim(),
            estadoAnimo: listaFullResponse[3].trim(),
            fechaRegistro: now);

        final historyRepository = Get.put(HistoryRepository());
        log.i("saveHistoryRecomendacion: Se instancia HistoryRepository");
        HistoryAdvice? dHistory = await historyRepository
            .getHistoryRecommendationByUser(currentUser!.uid.trim());
        log.i(
            "saveHistoryRecomendacion: Se obtiene lista de recomendaciones guardadas en Firestore");
        if (dHistory == null) {
          historyAdvice.listaHistorialDetalle = [];
          historyAdvice.listaHistorialDetalle.add(historyadvicedt);
        } else {
          historyAdvice.listaHistorialDetalle = dHistory.listaHistorialDetalle;
          historyAdvice.listaHistorialDetalle.add(historyadvicedt);
        }

        final chatController = Get.put(ChatRepository());
        await chatController.saveHistorialRecomendacion(historyAdvice);
        log.i(
            "saveHistoryRecomendacion: Se guarda nueva Historial de Recomendación en Firestore");
        final statisticsRepository = Get.put(StatisticsRepository());
        await statisticsRepository.procesarRecomendacionEstadisticaDiaria(now);
        Get.delete<StatisticsRepository>();
        log.i(
            "saveHistoryRecomendacion: Se procesa Estadistica de Recomendación Diaria");
        final userRepository = Get.put(UserRepository());
        await userRepository.updateEmocionUsuario(
            currentUser!.uid.trim(), listaFullResponse[3].trim(), listaFullResponse[4].trim());
        log.i(
            "saveHistoryRecomendacion: Se Actualizó emociones del Usuario");
      }

      log.i("saveHistoryRecomendacion: Finaliza saveHistoryRecomendacion");
    } catch (e) {
      log.e('Error en saveHistoryRecomendacion');
      log.e("Error: ${e.toString()}");
      //Show some generic error to user
      Loaders.errorSnackBar(
          title: 'Oh, sucedió un error', message: e.toString());
      throw Exception(e);
    } finally {}
  }

  final List<String> daysCompleto = TTexts.dias;

  Future<void> generarPlandiario() async {
    try {
      TFullScreenLoader.openLoadingDialog(
          "Generando Plan...", TImages.loadingAnimation);
      DateTime now = DateTime.now();
      String fechaRegistro = DateFormat('yyyy-MM-dd').format(now);
      String horaRegistro = DateFormat('HH:mm:ss').format(now);
      Random random = Random();
      String dias = getDiasRestantesDeLaSemana();
      String identificadorPlan =
          '${DateFormat('yyyyMMdd').format(now)}_${random.nextInt(100000)}';
      log.i("generarPlandiario: Comienza generarPlandiario");
      final promptPlanDiario = """
      A continuación, debes generar planes diarios que permitan al paciente desarrollar hábitos saludables para mejorar su salud física y mental. Los planes deben seguir el siguiente formato de respuesta, utilizando "||" como separador entre los diferentes puntos. 

      1) Meta: Genera la meta que el paciente desea alcanzar en un máximo de 20 palabras. Ejemplo: "Ir al gimnasio","Comer saludable".
      2) Tipo de Actividad: Selecciona una opción entre las siguientes: ${TTexts.activMeditacion}, ${TTexts.actividadAlimentacion}, ${TTexts.actividadFisico}.
      3) Día: Selecciona uno de estos días $dias.
      4) Hora: Indica la hora ideal en formato 24 horas (ejemplo: 13:00).
      5) Periodo: "AM" o "PM" dependiendo de la hora seleccionada.
      6) Mensaje: Escribe un mensaje motivacional para que el paciente cumpla su plan.
      7) Recomendaciones: Proporciona tres recomendaciones inspiradoras separadas por "\n" para que el paciente logre su meta.

      El formato de respuesta debe ser exactamente así, utilizando "||" para separar los campos y "\n" para separar cada recomendación. No incluyas ningún texto adicional ni explicaciones.

      Ejemplo:
      Comer Ensalada en el Almuerzo||Alimentación||Lunes||13:00||PM||Preparar una ensalada fresca para el almuerzo no solo es una elección saludable, ¡es un acto de amor propio! Cuida tu cuerpo, nutre tu mente y siembra la energía positiva que necesitas para brillar durante todo el día ¡Tú puedes hacerlo, y te mereces lo mejor!||- Mantén tus ensaladas interesantes probando diferentes combinaciones de vegetales, proteínas y aderezos.\n- Piensa en cómo te sientes después de comer algo fresco y saludable, y cómo esto contribuye a tu bienestar general.\n- Dedica un tiempo a preparar tus ingredientes con antelación para que sea fácil y rápido armar tu ensalada cada día.
      """;

      messagesHistory
          .add(Messages(role: Role.user, content: promptPlanDiario).toJson());
      log.i("generarPlandiario: Antes de llamar a OPENAI");
      final request = ChatCompleteText(
          messages: messagesHistory,
          maxToken: 1000,
          temperature: 0.3,
          model: GptTurbo0125ChatModel());
      final response = await openAI.onChatCompletion(request: request);
      log.i(
          "generarPlandiario: Despues de llamar a OPENAI para generar Plan Diario");

      String fullResponse = '';
      if (response != null && response.choices.isNotEmpty) {
        log.i("generarPlandiario: Se muestra respuesta OPENAI");
        fullResponse = response.choices.first.message?.content ?? '';
      } else {
        throw Exception('No se pudo obtener respuesta del modelo GPT-3.5');
      }
      log.i(fullResponse);
      List<String> listaFullResponse = fullResponse.split('||');

      if (listaFullResponse.length == 7) {
        List<String> selectedDays = listaFullResponse[2].trim().split(',');

        final planRepository = Get.put(PlanRepository());

        for (var dia in selectedDays) {
          final planDiario = PlanDiario(
              idUsuario: currentUser!.uid,
              meta: listaFullResponse[0].trim(),
              tipoActividad: listaFullResponse[1].trim(),
              diaPlan: dia.trim(),
              fechaPlan: TTexts.obtenerFechaDeDia(
                  dia.trim()), // Se obtiene la fecha del día seleccionado
              estadoPlan: TTexts.estadoPendiente,
              hora: listaFullResponse[3].trim(),
              periodo: listaFullResponse[4].trim(),
              mensaje: listaFullResponse[5].trim(),
              recomendacion: listaFullResponse[6].trim(),
              tipoLogro: TTexts.obtenerTipoLogro(listaFullResponse[1].trim()),
              fechaRegistro: fechaRegistro,
              horaRegistro: horaRegistro,
              identificadorPlan: identificadorPlan);
          await planRepository.savePlanDiario(planDiario);
          log.i("Se registra para dia: $dia");
        }
        messagesHistory.clear();
        log.i("generarPlandiario: Se generó Plan Diario");
      }
    } catch (e) {
      log.e('Error en generarPlandiario');
      log.e("Error: ${e.toString()}");
      //Show some generic error to user
      Loaders.errorSnackBar(
          title: 'Oh, sucedió un error', message: e.toString());
    } finally {
      log.i("generarPlandiario: Termina generarPlandiario");
    }
  }

  Future<void> generarTipsRecomendacion(int indicador) async {
    try {
      DateTime now = DateTime.now();
      String fechaRegistro = DateFormat('yyyy-MM-dd').format(now);
      String horaRegistro = DateFormat('HH:mm:ss').format(now);
      log.i("generarTipsRecomendacion: Comienza generarTipsRecomendacion");
      const promptRecomendaciones = """
Genera una lista de recomendaciones que ayuden al paciente a mejorar su salud física y mental (cada uno debe tener titulo,descripcion y beneficios). Devuelve el resultado en formato JSON siguiendo esta estructura:

[
  {
    "titulo": "string",
    "descripcion": [
      "string",
      "string",
      "string"
    ],
    "beneficios": [
      "string",
      "string",
      "string"
    ]
  },
  {
    "titulo": "string",
    "descripcion": [
      "string",
      "string",
      "string"
    ],
    "beneficios": [
      "string",
      "string",
      "string"
    ]
  }
]

Cada recomendación debe contener un "título", una "descripción" con al menos 3 pasos detallados y prácticos, y "beneficios" con al menos 3 puntos. No incluyas ningún texto adicional ni explicaciones. Solo devuelve el JSON.

Ejemplo:
  {
    "titulo": "Leer un libro",
    "descripcion": [
      "Escoge tu libro favorito, lo puedes descargar o comprar en una librería.",
      "Elige un espacio ideal y sin ruido para que leas tu libro de forma tranquila y sin interrupciones.",
      "Disfruta leyendo cada capítulo haciendo pausas y, si es posible, leyéndolo en voz alta."
    ],
    "beneficios": [
      "Te dará una sensación de paz y tranquilidad.",
      "Mejorará tu capacidad de concentración y productividad en el trabajo.",
      "Aumentará tu habilidad de análisis y comprensión lectora."
    ]
  }
Genera 3 objetos diferentes del formato del ejemplo que te he mostrado.

""";

      messagesHistory.add(
          Messages(role: Role.user, content: promptRecomendaciones).toJson());
      log.i("generarTipsRecomendacion: Antes de llamar a OPENAI");
      final request = ChatCompleteText(
          messages: messagesHistory,
          maxToken: 500,
          temperature: 0.5,
          responseFormat: ResponseFormat.jsonObject,
          model: GptTurbo0125ChatModel());
      final response = await openAI.onChatCompletion(request: request);
      log.i(
          "generarTipsRecomendacion: Despues de llamar a OPENAI para generar Plan Diario");

      String fullResponse = '';
      if (response != null && response.choices.isNotEmpty) {
        log.i("generarTipsRecomendacion: Se muestra respuesta OPENAI");
        fullResponse = response.choices.first.message?.content ?? '';
      } else {
        throw Exception('No se pudo obtener respuesta del modelo GPT-3.5');
      }
      log.i(fullResponse);
      //List<String> listaFullResponse = fullResponse.trim().split('||');
      // Convertir el String a un objeto JSON
      final planRepository = Get.put(PlanRepository());
      if (TTexts.validarRepeticionesRecomendaciones(fullResponse)) {
        List<dynamic> jsonList = jsonDecode(fullResponse);
        List<Recomendacion> listaRecomendaciones =
            jsonList.map((json) => Recomendacion.fromJson(json)).toList();
        if (listaRecomendaciones.isNotEmpty) {
          for (var recomendacion in listaRecomendaciones) {
            final objeto = Recomendacion(
                idUsuario: currentUser!.uid,
                titulo: recomendacion.titulo,
                descripcion: recomendacion.descripcion,
                beneficios: recomendacion.beneficios,
                fechaRegistro: fechaRegistro,
                horaRegistro: horaRegistro);
            await planRepository.saveRecomendacion(objeto);
          }
        }
      } else {
        Map<String, dynamic> jsonMap = jsonDecode(fullResponse);
        Recomendacion recomendacion = Recomendacion.fromJson(jsonMap);
        recomendacion.idUsuario = currentUser!.uid;
        recomendacion.fechaRegistro = fechaRegistro;
        recomendacion.horaRegistro = horaRegistro;

        await planRepository.saveRecomendacion(recomendacion);
      }

      if (indicador == TTexts.indicadorTerminarChat) {
        messagesHistory.clear();
      }
      log.i("generarTipsRecomendacion: Se generó Recomendaciones");
    } on OpenAIAuthError catch (err) {
      log.i('OpenAIAuthError ->${err.data?.error.toMap()}');
      Loaders.errorSnackBar(
          title: 'Ocurrió un problema...',
          message: 'El asistente virtual no está disponible en este momento.');
    } on OpenAIRateLimitError catch (err) {
      log.i('OpenAIRateLimitError ->${err.data?.error.toMap()}');
      Loaders.errorSnackBar(
          title: 'Ocurrió un problema...',
          message: 'El asistente virtual no está disponible en este momento.');
    } on OpenAIServerError catch (err) {
      log.i('OpenAIServerError ->${err.data?.error.toMap()}');
      Loaders.errorSnackBar(
          title: 'Ocurrió un problema...',
          message: 'El asistente virtual no está disponible en este momento.');
    } catch (e) {
      log.e('Error en generarTipsRecomendacion');
      log.e("Error: ${e.toString()}");
      //Show some generic error to user
      Loaders.errorSnackBar(
          title: 'Oh, sucedió un error', message: e.toString());
    } finally {
      log.i("generarTipsRecomendacion: Termina generarTipsRecomendacion");
    }
  }

  void eliminarConversacion() async {
    try {
      TFullScreenLoader.openLoadingDialog(
          "Eliminando Chat...", TImages.loadingAnimation);
      log.i("eliminarConversacion: Comienza eliminarConversacion");
      final chatRepository = Get.put(ChatRepository());

      await chatRepository.removeConversacion(currentUser!.uid.trim());
      log.i("eliminarConversacion: Se eliminó Conversacion del Chat");
      messagesHistory.clear();

      Get.delete<ChatController>();
      Get.delete<ChatRepository>();
      Get.off(() => const NavigationMenu());
    } catch (e) {
      log.e('Error en eliminarConversacion');
      log.e("Error: ${e.toString()}");
      //Show some generic error to user
      TFullScreenLoader.stopLoading();
      Loaders.errorSnackBar(
          title: 'Oh, sucedió un error', message: e.toString());
    } finally {
      log.i("eliminarConversacion: Termina eliminarConversacion");
    }
  }

  String getDiasRestantesDeLaSemana() {
    final diaActualIndex = DateTime.now().weekday -
        1; // weekday devuelve 1 para Lunes y 7 para Domingo
    List<String> diasRestantes = TTexts.dias.sublist(diaActualIndex);
    String diasRestantesString = diasRestantes.join(',');
    log.i("Dias Restantes: $diasRestantes");
    log.i("Dias Restantes: $diasRestantesString");
    return diasRestantesString.trim();
  }
}
