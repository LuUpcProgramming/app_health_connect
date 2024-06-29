import 'package:app_health_connect/config/constants/environment.dart';
import 'package:app_health_connect/data/repositories/chat/chat_repository.dart';
import 'package:app_health_connect/data/repositories/history/history_repository.dart';
import 'package:app_health_connect/data/repositories/user/user_repository.dart';
import 'package:app_health_connect/features/authentication/controllers/dashboard/dashboard_controller.dart';
import 'package:app_health_connect/features/authentication/models/chat_message.dart';
import 'package:app_health_connect/features/authentication/models/history_advice.dart';
import 'package:app_health_connect/navigation_menu.dart';
import 'package:app_health_connect/utils/constants/image_strings.dart';
import 'package:app_health_connect/utils/popups/full_screen_loader.dart';
import 'package:app_health_connect/utils/popups/loaders.dart';
import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../config/helper/logging.dart';

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
        baseOption: HttpSetup(receiveTimeout: const Duration(seconds: 5)),
        enableLog: true);
    log.i("onInit: Se instancia OPENAI");
     WidgetsBinding.instance.addPostFrameCallback((_) {
      cargaDatosChat();
    });
  }

  Future<void> cargaDatosChat() async {
    try {
      TFullScreenLoader.openLoadingDialog("Cargando Chat..", TImages.loadingAnimation);
      isLoading.value = true;
      log.i("cargaDatosChat: Comienza cargaDatosChat");

      // Simular carga de datos con un retraso
      // await Future.delayed(const Duration(seconds: 1));

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
      Get.delete<ChatRepository>();
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
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('dd/MM/yyyy').format(now);
    try {
      log.i("saveHistoryRecomendacion: Comienza saveHistoryRecomendacion");
      final promptSave = """
      De todo lo que hemos conversado, sintetiza toda la información en una recomendación resumida,  
      generando 3 datos:
      - Primero genera un título corto y llamativo que resuma la recomendación. Solo digita el título y sepáralo por el operador "|".
      - Luego una descripcion detallada explicando la recomendación. Solo digita la descripción y sepáralo por el operador "|".
      - Luego, La fecha $formattedDate (Solo digita la fecha). Solo digita la fecha y sepáralo por el operador "|".
      - Luego, une descripción resumida de la situación o problema. Solo digita la descripción y sepáralo por el operador "|".
      - Finalmente, el estado de ánimo sintetizado en 1 palabra. Solo digite la palabra.

      Te muestro ejemplos de como debes darme tus respuestas:
      Ejemplo 1: Recupera tu equilibrio emocional|Encuentra momentos para expresar tus emociones, ya sea a través de la música, 
      actividades que disfrutes o conversaciones honestas.Practica la comunicación asertiva para abordar conflictos y cuida de ti mismo en situaciones estresantes.|
      24/06/2024|Conflictos y situaciones estresantes en el trabajo.|Resiliencia.
      Ejemplo 2: Recuperando el ánimo|Tómate un tiempo para ti, habla sobre tus sentimientos con alguien de confianza, 
      dedica tiempo a actividades que disfrutes como tocar la guitarra y practica la autocompasión.|23/06/2024|Enojo por conflicto con el jefe del trabajo.|Triste.
      Ejemplo 2: Practica la respiración profunda|Cuando sientas el peso del estrés recuerda el poder la respiración profunda. 
      Puedes hacerlo en cualquier momento del día, incluso en el trabajo cuando te sientas abrumado. Inhala profundamente por tu nariz, retén el aire por un momento
      y luego exhala lentamente por la boca.|22/06/2024|Exceso de actividades en el trabajo y horas extras sin pago.|Estresado.
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
      messagesHistory.clear();

      String fullResponse = '';
      if (response != null && response.choices.isNotEmpty) {
        log.i("saveHistoryRecomendacion: Se muestra respuesta OPENAI");
        fullResponse = response.choices.first.message?.content ?? '';
      } else {
        throw Exception('No se pudo obtener respuesta del modelo GPT-3.5');
      }

      List<String> listaFullResponse = fullResponse.split('|');

      var historyAdvice = HistoryAdvice(idUsuario: currentUser!.uid.trim());

      var historyadvicedt = HistoryAdviceDetail(
          title: listaFullResponse[0].trim(),
          description: listaFullResponse[1].trim(),
          date: listaFullResponse[2],
          problema: listaFullResponse[3].trim(),
          estadoAnimo: listaFullResponse[4].trim());

      final historyRepository = Get.put(HistoryRepository());
      log.i("saveHistoryRecomendacion: Se instancia HistoryRepository");
      HistoryAdvice dHistory = await historyRepository
          .getHistoryRecommendationByUser(currentUser!.uid.trim());
      log.i(
          "saveHistoryRecomendacion: Se obtiene lista de recomendaciones guardadas en Firestore");
      if (dHistory.idUsuario == "0") {
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

  void procesarConversacion() {
    try {
      log.i("procesarConversacion: Comienza procesarConversacion");
      TFullScreenLoader.openLoadingDialog("Procesando Información...", TImages.loadingAnimation);
      if (messagesHistory.isNotEmpty) {
        if (countMessageHistory != messagesHistory.length) {
          // Aquí va la lógica para procesar la conversación
          log.i(
              "procesarConversacion: Entra a ejecutar saveHistoryToFirestore y saveHistoryRecomendacion ");
          saveHistoryToFirestore();
          saveHistoryRecomendacion();
        }
      }
      TFullScreenLoader.stopLoading();
      Get.delete<ChatController>();
      Get.off(() => const NavigationMenu());
      //Get.to(()=> const HistorialAdviceScreen());
    } catch (e) {
      log.e('Error en procesarConversacion');
      log.e("Error: ${e.toString()}");
      //Show some generic error to user
      Loaders.errorSnackBar(
          title: 'Oh, sucedió un error', message: e.toString());
    } finally {
      log.i("procesarConversacion : Finaliza procesarConversacion");
    }
  }

  void eliminarConversacion() async {
    try {
      isLoading.value = true;
      log.i("eliminarConversacion: Comienza eliminarConversacion");
      final chatRepository = Get.put(ChatRepository());

      await chatRepository.removeConversacion(currentUser!.uid.trim());
      log.i("eliminarConversacion: Se eliminó Conversacion del Chat");
      messagesHistory.clear();
    } catch (e) {
      log.e('Error en eliminarConversacion');
      log.e("Error: ${e.toString()}");
      //Show some generic error to user
      Loaders.errorSnackBar(
          title: 'Oh, sucedió un error', message: e.toString());
    } finally {
      log.i("eliminarConversacion: Termina eliminarConversacion");
      isLoading.value = false;
    }
  }
}
