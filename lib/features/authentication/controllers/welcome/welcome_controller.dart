
import 'package:app_health_connect/config/constants/environment.dart';
import 'package:app_health_connect/config/helper/logging.dart';
import 'package:app_health_connect/data/repositories/user/user_repository.dart';
import 'package:app_health_connect/features/authentication/models/user_detail.dart';
import 'package:app_health_connect/features/authentication/models/user_model.dart';
import 'package:app_health_connect/features/authentication/screens/login/login.dart';
import 'package:app_health_connect/features/authentication/screens/welcome/work_info.dart';
import 'package:app_health_connect/features/authentication/screens/welcome/health_info.dart';
import 'package:app_health_connect/navigation_menu.dart';
import 'package:app_health_connect/utils/constants/image_strings.dart';
import 'package:app_health_connect/utils/popups/full_screen_loader.dart';
import 'package:app_health_connect/utils/popups/loaders.dart';
import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WelcomeController extends GetxController {
  static WelcomeController get instance => Get.find();

  //***************Variables***************/
  final log = logger(WelcomeController);
  final _user = Rx<UserModel?>(null);
  UserModel? get user => _user.value;
  GlobalKey<FormState> formPersonaInfoKey = GlobalKey<FormState>();
  GlobalKey<FormState> formWorkInfoKey = GlobalKey<FormState>();
  GlobalKey<FormState> formHealthInfoKey = GlobalKey<FormState>();
  //*Personal Information*/
  // final TextEditingController generoController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController alturaController = TextEditingController();
  final TextEditingController pesoController = TextEditingController();
  String? selectedDropdownGeneroValue;
  //DateTime? selectedDate;
  //*Work Information*/
  var itemsModTrabajo = ['Trabajo Remoto', 'Trabajo Híbrido'];
  var itemsHorasTrabajo = ['hrs/día', 'hrs/semana'];
  var itemsTipoContrato = ['Tiempo Completo', 'Part Time', 'Practicante'];
  var itemsTurnoTrabajo = [
    'Horario Diurno(Mañana y Tarde)',
    'Horario Rotativo'
  ];
  final TextEditingController ocupacionController = TextEditingController();
  final TextEditingController modalidadTrabajoController =
      TextEditingController();
  final TextEditingController horasTrabajoController = TextEditingController();
  final TextEditingController tipoContratoController = TextEditingController();
  String? selectedDropdownModalidadTrabajoValue;
  String? selectedDropdownTipoContratoValue;
  String? selectedDropdownTurnoTrabajoValue;
  String? selectedDropdownTipHorTrabajoValue;

  //*Health Information*/
  List<String> selectedOptions = [];

  //** OPENAI */
  final openAiKey = Environment.openAiKey;
  late final OpenAI openAI;

  @override
  void onInit() {
    super.onInit();
    getUser();
    openAI = OpenAI.instance.build(
        token: openAiKey,
        baseOption: HttpSetup(receiveTimeout: const Duration(seconds: 5)),
        enableLog: true);
  }

  //***************Métodos***************/
  //Obtener Usuario Registrado
  Future<void> getUser() async {
    try {
      //Show Dialog
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        final userRepository = Get.put(UserRepository());
        UserModel user =
            await userRepository.getUserRecord(currentUser.uid.trim());
        _user.value = user;
        log.i('Welcome Screen: ${_user.value}');
      } else {
        log.e('Welcome Screen: Usuario No Logueado');
        throw Exception('Usuario no está logueado');
      }
    } catch (e) {
      //Show some generic error to user
      Loaders.errorSnackBar(
          title: 'Oh, sucedió un error', message: e.toString());
      Get.offAll(() => const LoginScreen());
    }
  }

  //Validar Datos Personales y pasar a siguiente Screen
  void validarPersonalInfo() async {
    try {
      log.i('Personal Info: ${formPersonaInfoKey.currentState!.validate()}');
      if (!formPersonaInfoKey.currentState!.validate()) {
        return;
      }

      final userPersonalInfo = UserDetail(
          idUsuario: _user.value?.id ?? "0",
          genero: selectedDropdownGeneroValue!,
          fechaNacimiento: dateController.text,
          altura: alturaController.text,
          peso: pesoController.text);
      log.i('Personal Info: ${userPersonalInfo.toJson()}');
      Get.to(
        () => const WorkInfoScreen(),
        transition: Transition.rightToLeft, // Transición de deslizar
        duration:
            const Duration(milliseconds: 700), // Duración de la transición
      );
    } catch (e) {
      Loaders.errorSnackBar(
          title: 'Oh, sucedió un error', message: e.toString());
    }
  }

  //Validar Datos de Trabajo y pasar a siguiente Screen
  void validarWorkInfo() async {
    try {
      // Form Validation
      if (!formWorkInfoKey.currentState!.validate()) {
        return;
      }

      final userWorkInfo = UserDetail(
          idUsuario: _user.value?.id ?? "0",
          genero: selectedDropdownGeneroValue!,
          fechaNacimiento: dateController.text,
          altura: alturaController.text,
          peso: pesoController.text,
          ocupacion: ocupacionController.text,
          modalidadTrabajo: selectedDropdownModalidadTrabajoValue!,
          horasTrabajo: horasTrabajoController.text,
          tipoContrato: selectedDropdownTipoContratoValue!,
          turnoTrabajo: selectedDropdownTurnoTrabajoValue!);

/*       final userWorkInfo = UserDetail(
          idUsuario: '0',
          genero: 'M',
          fechaNacimiento: '032',
          altura: '23',
          peso: '23',
          ocupacion: ocupacionController.text,
          modalidadTrabajo: selectedDropdownModalidadTrabajoValue!,
          horasTrabajo: horasTrabajoController.text,
          tipoHorasTrabajo: selectedDropdownTipHorTrabajoValue!,
          tipoContrato: selectedDropdownTipoContratoValue!,
          turnoTrabajo: selectedDropdownTurnoTrabajoValue!); */
      log.i('Work Info: ${userWorkInfo.toJson()}');
      Get.to(
        () => const HealthInfoScreen(),
        transition: Transition.rightToLeft, // Transición de deslizar
        duration:
            const Duration(milliseconds: 700), // Duración de la transición
      );
    } catch (e) {
      Loaders.errorSnackBar(
          title: 'Oh, sucedió un error', message: e.toString());
    }
  }

  //Validar Datos de Salud y pasar a siguiente Screen (Dashboard)
  void validarHealthInfo() async {
    log.i('Health Info: $selectedOptions');
    try {
      if (selectedOptions.length < 3) {
        Loaders.warningSnackBar(
            title: 'Espere!', message: 'Seleccione mínimo tres opciones');
        return;
      }
      TFullScreenLoader.openLoadingDialog(
          'Procesando Información', TImages.loadingAnimation);

      final userHealthInfo = UserDetail(
          idUsuario: _user.value?.id ?? "0",
          genero: selectedDropdownGeneroValue!,
          fechaNacimiento: dateController.text,
          altura: alturaController.text,
          peso: pesoController.text,
          ocupacion: ocupacionController.text,
          modalidadTrabajo: selectedDropdownModalidadTrabajoValue!,
          horasTrabajo: horasTrabajoController.text,
          tipoHorasTrabajo: selectedDropdownTipHorTrabajoValue!,
          tipoContrato: selectedDropdownTipoContratoValue!,
          turnoTrabajo: selectedDropdownTurnoTrabajoValue!,
          opcionesSalud: selectedOptions);
      log.i('Health Info: ${userHealthInfo.toJson()}');

      log.i('validarHealthInfo: Antes de analyzeUserInfoWithOpenAI');
      final analysisResponse = await analyzeUserInfoWithOpenAI(userHealthInfo);
      log.i('validarHealthInfo: Despues de  analyzeUserInfoWithOpenAI');
      userHealthInfo.analisisIA = analysisResponse;
      userHealthInfo.estadoDialogAnalisisIA = true;

      final userRepository = Get.put(UserRepository());
      await userRepository.saveUserDetails(userHealthInfo);
      log.i('validarHealthInfo: Se Guarda detalles del usuario en Firestore');
      TFullScreenLoader.stopLoading();

      Get.delete<WelcomeController>();

      Get.offAll(
        () => const NavigationMenu(),
        transition: Transition.fadeIn, // Transición de deslizar
        duration:
            const Duration(milliseconds: 700), // Duración de la transición
      );
    } catch (e) {
      log.e('validarHealthInfo: Sucedió un error: $e');
      Loaders.errorSnackBar(
          title: 'Oh, sucedió un error', message: e.toString());
    }
  }

  Future<String> analyzeUserInfoWithOpenAI(UserDetail userHealthInfo) async {
    final prompt = """
    Actúa como un psicólogo con conocimientos de Terapia Cognitivo Conductual (CBT). 
    Analiza la siguiente información del usuario:

    Género: ${userHealthInfo.genero}
    Fecha de Nacimiento: ${userHealthInfo.fechaNacimiento}
    Altura: ${userHealthInfo.altura}
    Peso: ${userHealthInfo.peso}
    Ocupación: ${userHealthInfo.ocupacion}
    Modalidad de Trabajo: ${userHealthInfo.modalidadTrabajo}
    Horas de Trabajo: ${userHealthInfo.horasTrabajo}
    Tipo de Contrato: ${userHealthInfo.tipoContrato}
    Turno de Trabajo: ${userHealthInfo.turnoTrabajo}
    Problemas de Salud: ${userHealthInfo.opcionesSalud.join(', ')}

    Proporciona un análisis en base a la información proporcionada.La información de tu respuesta debe contener lo siguiente:
    -personal: Análisis breve sobre el género y edad de la persona. Debe ser respuesta breve con 30 palabras como máximo.
      Ejemplo: Persona joven llena de vitalidad.
    -imc: Análisis del Índice de masa corporal en base a su altura y peso. Debe ser respuesta breve e informativa con 20 palabras como máximo.
      Ejemplo: 23: Rango normal.
    -trabajo: Análisis breve del entorno laboral. Debe ser respuesta corta con 20 palabras como máximo.
      Ejemplo: Trabajo intensivo con largas horas laborales.
    -salud: Análisis breve de los problemas de salud. Debe ser respuesta corta, positiva y motivadora con 30 palabras como máximo.
      Ejemplo: Es necesario recibir atención temprana en salud mental. Mejoremos juntos.
    -ind_trabajo: En base al análisis brinda el estado laboral de la persona en una sola palabra.
      Ejemplo: Intensivo.
    -ind_salud: En base al análisis brinda el estado de salud mental de la persona en una sola palabra.
     Ejemplo: Estresado.

     El formato de tu respuesta debe ser lo siguiente: 
     'personal||imc||trabajo||salud||ind_trabajo||ind_salud'


    """;
    final promptv2 = """
    Actúa como un psicólogo con altos conocimientos de Terapia Cognitivo Conductual (CBT). 
    Analiza la siguiente información del usuario:

    Género: ${userHealthInfo.genero}
    Fecha de Nacimiento: ${userHealthInfo.fechaNacimiento}
    Altura: ${userHealthInfo.altura}
    Peso: ${userHealthInfo.peso}
    Ocupación: ${userHealthInfo.ocupacion}
    Modalidad de Trabajo: ${userHealthInfo.modalidadTrabajo}
    Horas de Trabajo: ${userHealthInfo.horasTrabajo}
    Tipo de Contrato: ${userHealthInfo.tipoContrato}
    Turno de Trabajo: ${userHealthInfo.turnoTrabajo}
    Problemas de Salud: ${userHealthInfo.opcionesSalud.join(', ')}

    Para tu análisis y diagnóstico preliminar ten en cuenta la información proporcionada y los siguientes criterios (No me des las respuestas de cada punto aún):
    1. Análisis personal: Análisis breve y positiva sobre el género y edad de la persona.
    2. Análisis del IMC: Análisis breve e informativo del Índice de Masa Corporal en base a su altura y peso.
    3. Análisis del entorno laboral: Análisis breve del entorno laboral del usuario.
    4. Análisis de la salud mental: Análisis breve, positivo y motivador sobre los problemas de salud mencionados.

    Ahora, sintetiza toda aquella información (Del 1 al 4)  en un párrafo coherente dirigido al paciente en un máximo de 60 palabras.

    Luego, separado por el operador "|" agrega lo siguiente:
    - En una sola palabra indica como se encuentra el paciente respecto a su entorno laboral  en base a tu análisis y diagnóstico. (Solo digita la palabra).
    - En una sola palabra indica como se encuentra el paciente respecto a su salud mental en base a tu análisis y diagnóstico. (Solo digita la palabra).

    Te muestro una lista de ejemplos de como debes responderme:
    Ejemplo 1: Tu edad de 27 años es ideal para el crecimiento personal y profesional. Tu IMC es saludable, lo cual es positivo. 
    Sin embargo, tu entorno laboral es exigente, con largas horas de trabajo. A pesar de enfrentar ansiedad, depresión, cansancio y estrés, 
    tu conciencia sobre estos problemas es el primer paso hacia la mejora.|Sobrecargado|Estresado
    Ejemplo 2: Tienes 27 años y, como administrador, has logrado mucho. Tu IMC indica un peso bajo, lo que puede necesitar atención. 
    Trabajas de forma remota y aunque trabajas muchas horas, esto puede ser ajustable. La ansiedad, depresión, cansancio y estrés 
    que sientes son tratables, y hay muchas estrategias que podemos usar para ayudarte a mejorar.|Laborioso|Ansioso
    Ejemplo 3: A tus 34 años, has alcanzado una posición sólida como ingeniero de soporte. Tu IMC es saludable. 
    Aunque trabajas muchas horas de forma remota, podemos encontrar un equilibrio. Los problemas de ansiedad, depresión, cansancio y estrés 
    que enfrentas son manejables y juntos podemos desarrollar estrategias efectivas para tu bienestar.|Intensivo|Decaído 


    """;
    try {
      log.i('OpenAIKey: $openAiKey');
      log.i("prompt: $prompt");

      List<Map<String, dynamic>> messagesHistory = [];

      messagesHistory.insert(
          0, Messages(role: Role.system, content: promptv2).toJson());
      final request = ChatCompleteText(
          messages: messagesHistory,
          maxToken: 500,
          temperature: 0.7,
          model: GptTurbo0125ChatModel());

      log.i("Antes de ejecutar  OPENAI API");
      final response = await openAI.onChatCompletion(request: request);
      log.i("Despues de ejecutar OPENAI API");
      String fullResponse = '';
      if (response != null && response.choices.isNotEmpty) {
        log.i("Se encuentra respuesta OPENAI");
        fullResponse = response.choices.first.message?.content ?? '';
        // log.i("Respuesta OpenAI: $fullResponse");
        return fullResponse;
      } else {
        log.e("No se pudo obtener respuesta del modelo GPT-3.5");
        throw Exception('No se pudo obtener respuesta del modelo GPT-3.5');
      }
    } catch (e) {
      log.e("Ocurrió un error: $e");
      return "Ocurrió un error: $e";
    }
  }
}
