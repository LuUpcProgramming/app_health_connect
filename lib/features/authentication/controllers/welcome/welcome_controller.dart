import 'package:app_health_connect/config/helper/logging.dart';
import 'package:app_health_connect/data/repositories/user/user_repository.dart';
import 'package:app_health_connect/features/authentication/models/user_detail.dart';
import 'package:app_health_connect/features/authentication/models/user_model.dart';
import 'package:app_health_connect/features/authentication/screens/welcome/work_info.dart';
import 'package:app_health_connect/features/authentication/screens/welcome/health_info.dart';
import 'package:app_health_connect/navigation_menu.dart';
import 'package:app_health_connect/utils/popups/loaders.dart';
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

  @override
  void onInit() {
    super.onInit();
    getUser();
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
        throw Exception('Usuario no está logueado');
      }
    } catch (e) {
      //Show some generic error to user
      Loaders.errorSnackBar(
          title: 'Oh, sucedió un error', message: e.toString());
      throw Exception(e);
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
          idUsuario: _user.value!.id,
          genero: selectedDropdownGeneroValue!,
          fechaNacimiento: dateController.text,
          altura: alturaController.text,
          peso: pesoController.text);
      log.i('Personal Info: ${userPersonalInfo.toJson()}');
      Get.to(
        () => const WorkInfoScreen(),
        transition: Transition.rightToLeft, // Transición de deslizar
        duration: const Duration(milliseconds: 700), // Duración de la transición
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
          idUsuario: _user.value!.id,
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
        duration: const Duration(milliseconds: 700), // Duración de la transición
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

      final userHealthInfo = UserDetail(
          idUsuario: _user.value!.id,
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

      final userRepository = Get.put(UserRepository());
      await userRepository.saveUserDetails(userHealthInfo);

      //Funcionalidad para que el api de OPENAI reconozca esa informacion grabada

      // Show Success Hessage
      Loaders.successSnackBar(
          title: 'Procesando... Gracias!',
          message:
              '¡Empecemos tu viaje hacia un mejor Bienestar físico y mental con Health Connect');

      Get.offAll(
        () => const NavigationMenu(),
        transition: Transition.fadeIn, // Transición de deslizar
        duration: const Duration(milliseconds: 700), // Duración de la transición
      );
    } catch (e) {
      Loaders.errorSnackBar(
          title: 'Oh, sucedió un error', message: e.toString());
    }
  }
}
