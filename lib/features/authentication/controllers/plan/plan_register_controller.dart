import 'dart:math';

import 'package:app_health_connect/config/constants/environment.dart';
import 'package:app_health_connect/config/helper/logging.dart';
import 'package:app_health_connect/data/repositories/plan/plan_repository.dart';
import 'package:app_health_connect/features/authentication/models/plan_diario.dart';
import 'package:app_health_connect/features/authentication/screens/dashboard/dashboard_screen.dart';
import 'package:app_health_connect/features/authentication/screens/plan/plan_detalle.dart';
import 'package:app_health_connect/utils/constants/image_strings.dart';
import 'package:app_health_connect/utils/constants/text_strings.dart';
import 'package:app_health_connect/utils/helpers/network_manager.dart';
import 'package:app_health_connect/utils/notification/config_notification.dart';
import 'package:app_health_connect/utils/popups/custom_success_dialog.dart';
import 'package:app_health_connect/utils/popups/full_screen_loader.dart';
import 'package:app_health_connect/utils/popups/loaders.dart';
import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class PlanRegisterController extends GetxController {
  static PlanRegisterController get instance => Get.find();

  final log = logger(PlanRegisterController);
  final TextEditingController metaController = TextEditingController();
  final TextEditingController horaController = TextEditingController();

  GlobalKey<FormState> planDiarioFormKey = GlobalKey<FormState>();
  final selectedActividad = 'Meditación'.obs;
  TimeOfDay selectedTime = TimeOfDay.now();
  String selectedHora = '00:00';
  String selectedPeriodo = 'AM';
  final currentUser = FirebaseAuth.instance.currentUser;
  final RxList<int> selectedDays = <int>[].obs;

  final List<String> days = ['L', 'M', 'M', 'J', 'V', 'S', 'D'];
  final List<String> daysCompleto = TTexts.dias;

  // Lista reactiva para controlar si un día está habilitado
  var enabledDays = <bool>[].obs;
  final List<String> tipoActividad = [
    TTexts.activMeditacion,
    TTexts.actividadAlimentacion,
    TTexts.actividadFisico
  ];

  late final OpenAI openAI;
  final openAiKey = Environment.openAiKey;

  @override
  void onInit() {
    super.onInit();
    openAI = OpenAI.instance.build(
        token: openAiKey,
        baseOption: HttpSetup(receiveTimeout: const Duration(seconds: 5)),
        enableLog: true);
    _initializeDays();
  }

  void _initializeDays() {
    final currentDayIndex =
        DateTime.now().weekday - 1; // 0 = Lunes, 6 = Domingo

    // Crear una lista donde los días anteriores al día actual están deshabilitados
    enabledDays.assignAll(List.generate(days.length, (index) {
      return index >= currentDayIndex;
    }));

    // Inicializar los días seleccionados como no seleccionados
    //selectedDays2.assignAll(List.filled(days.length, false));
  }

  bool isDaySelected(int index) {
    return selectedDays.contains(index);
  }

  void toggleDay(int index) {
    // Solo permite la selección si el día está habilitado
    if (enabledDays[index]) {
      if (selectedDays.contains(index)) {
        selectedDays.remove(index);
      } else {
        selectedDays.add(index);
      }
      selectedDays.sort();
    }
  }

  String addLeadingZero(int number) {
    if (number < 10) {
      return '0$number';
    } else {
      return number.toString();
    }
  }

  void grabar() {
    log.i('Grabando plan diario');
    log.i('Meta: ${metaController.text}');
    log.i('Hora: ${horaController.text}');
    log.i('Tipo de actividad: ${selectedActividad.value}');
    log.i('Periodo: $selectedPeriodo');
    log.i('Días seleccionados: $selectedDays');
    log.i('Hora seleccionada: $selectedHora');
  }

  void grabarPlanDiario() async {
    try {
      DateTime now = DateTime.now();
      String fechaRegistro = DateFormat('yyyy-MM-dd').format(now);
      String horaRegistro = DateFormat('HH:mm:ss').format(now);
      Random random = Random();
      String identificadorPlan =
          '${DateFormat('yyyyMMdd').format(now)}_${random.nextInt(100000)}';
      log.i('Grabando plan diario');
      log.i('Meta: ${metaController.text}');
      log.i('Hora: ${horaController.text}');
      log.i('Tipo de actividad: ${selectedActividad.value}');
      log.i('Periodo: $selectedPeriodo');
      log.i('Días seleccionados: $selectedDays');
      TFullScreenLoader.openLoadingDialog(
          'Procesando Información...', TImages.loadingAnimation);

      //check internet connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        TFullScreenLoader.stopLoading();
        return;
      }

      // Form Validation
      if (!planDiarioFormKey.currentState!.validate()) {
        TFullScreenLoader.stopLoading();
        return;
      }

      if (selectedActividad.isEmpty) {
        TFullScreenLoader.stopLoading();
        Loaders.warningSnackBar(
            title: 'Campo requerido',
            message: 'Por favor seleccione un tipo de actividad');
        return;
      }

      if (selectedDays.isEmpty) {
        TFullScreenLoader.stopLoading();
        Loaders.warningSnackBar(
            title: 'Campo requerido',
            message: 'Por favor seleccione al menos un día');
        return;
      }

      // Llamar a Asistente Para Generar mensaje y recomendación
      final promptPlanDiario = """
      Actúa como un psicólogo con conocimientos profundos de Terapia Cognitivo Conductual (CBT). El paciente quiere crear un plan diario para mejorar su salud física y mental.
      Este paciente te envía la siguiente información:
      -Meta u Objetivo: ${metaController.text}
      -Tipo de Actividad: ${selectedActividad.value}
      -Días de la Semana: ${selectedDays.map((e) => daysCompleto[e]).toList()}
      -Hora: $selectedHora $selectedPeriodo
      Para ello necesita tu ayuda para generar un:
      1) Mensaje motivacional para cumplir su plan.
      2) Tres Recomendaciones que lo inspire a cumplir su plan.
      Tu respuesta solo debe tener el contenido del mensaje y las recomendaciones separado por el operador "|".

      Ejemplo de formato de respuesta:
      Preparar una ensalada fresca para el almuerzo no solo es una elección saludable, ¡es un acto de amor propio! Cuida tu cuerpo, nutre tu mente y siembra la energía positiva que necesitas para brillar durante todo el día ¡Tu puedes hacerlo, y te mereces lo mejor!|- Mantén tus ensaladas interesantes probando diferentes combinaciones de vegetales, proteínas y aderezos.\n- Piensa en cómo te sientes después de comer algo fresco y saludable, y cómo esto contribuye a tu bienestar general.\n- Dedica un tiempo a preparar tus ingredientes con antelación para que sea fácil y rápido armar tu ensalada cada día.
      """;

      List<Map<String, dynamic>> messagesHistory = [];
      messagesHistory.insert(
          0, Messages(role: Role.system, content: promptPlanDiario).toJson());
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
        //log.i("Respuesta: $fullResponse");
      } else {
        log.e("No se pudo obtener respuesta del modelo GPT-3.5");
        throw Exception('No se pudo obtener respuesta del modelo GPT-3.5');
      }

      List<String> listaFullResponse = fullResponse.split('|');
      var listaDeDias = selectedDays.map((e) => daysCompleto[e]).toList();
      final FirebaseApiMessaging firebaseApiMessaging = FirebaseApiMessaging();
      final planRepository = Get.put(PlanRepository());
      for (var dia in listaDeDias) {
        final planDiario = PlanDiario(
            idUsuario: currentUser!.uid,
            meta: metaController.text,
            tipoActividad: selectedActividad.value,
            diaPlan: dia.trim(),
            fechaPlan: obtenerFechaDelDia(dia.trim()),
            estadoPlan: TTexts.estadoPendiente,
            hora: selectedHora,
            periodo: selectedPeriodo,
            mensaje: listaFullResponse[0].trim(),
            recomendacion: listaFullResponse[1].trim(),
            tipoLogro: TTexts.obtenerTipoLogro(selectedActividad.value),
            fechaRegistro: fechaRegistro,
            horaRegistro: horaRegistro,
            identificadorPlan: identificadorPlan);

        await planRepository.savePlanDiario(planDiario);

        await firebaseApiMessaging.scheduleNotificationForPlanDiario(
            planDiario.fechaPlan, planDiario.hora, planDiario.meta, "Es hora de cumplir con tu meta diaria. ¡Vamos a por ello!");
        log.i("Se registra para dia: $dia");
      }
      limpiar();

      TFullScreenLoader.stopLoading();
      Get.delete<PlanRepository>();
      showSuccessDialog();

      // Show Success Hessage
      /*  Loaders.successSnackBar(
          title: 'Felicidades', message: '¡Tu Plan ha sido registrado!'); */

      //Move to Verify Email Screen
      // Get.off(() => DashboardScreen());
      //TFullScreenLoader.stopLoading();
    } catch (e) {
      TFullScreenLoader.stopLoading();
      Loaders.errorSnackBar(
          title: 'Oh, sucedió un error', message: e.toString());
      return;
    }
  }

  void showSuccessDialog() {
    Get.dialog(CustomSuccessWidget(
      onPressed: () {
        log.i("Plan registrado con éxito");
        Get.delete<PlanRegisterController>();
        Get.off(() => const PlanDiarioDetalle());
        // Get.off(() => DashboardScreen());
        // Get.back();
      },
    ));
  }

  String obtenerFechaDelDia(String diaElegido) {
    // Obtener el día de la semana actual
    DateTime now = DateTime.now();
    int diaActualIndex =
        now.weekday - 1; // weekday devuelve de 1 (lunes) a 7 (domingo)

    // Buscar el índice del día elegido
    int diaElegidoIndex = TTexts.dias.indexOf(diaElegido);

    // Calcular la diferencia entre el día actual y el día elegido
    int diferenciaDias = diaElegidoIndex - diaActualIndex;

    // Obtener la fecha correspondiente sumando la diferencia de días
    DateTime fechaElegida = now.add(Duration(days: diferenciaDias));

    String fechaFormateada = DateFormat('yyyy-MM-dd').format(fechaElegida);

    return fechaFormateada;
  }

  void limpiar() {
    metaController.clear();
    horaController.clear();
    selectedActividad.value = TTexts.activMeditacion;
    selectedTime = TimeOfDay.now();
    selectedHora = '00:00';
    selectedPeriodo = 'AM';
    selectedDays.clear();
  }
}
