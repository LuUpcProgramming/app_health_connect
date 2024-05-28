import 'package:app_health_connect/config/helper/logging.dart';
import 'package:app_health_connect/data/repositories/user/user_repository.dart';
import 'package:app_health_connect/features/authentication/models/user_detail.dart';
import 'package:app_health_connect/features/authentication/models/user_model.dart';
import 'package:app_health_connect/features/authentication/screens/welcome/work_info.dart';
import 'package:app_health_connect/features/authentication/screens/dashboard/dashboard_screen.dart';
import 'package:app_health_connect/features/authentication/screens/welcome/health_info.dart';
import 'package:app_health_connect/utils/popups/loaders.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  final TextEditingController ocupacionController = TextEditingController();
  final TextEditingController modalidadTrabajoController =
      TextEditingController();
  final TextEditingController horasTrabajoController = TextEditingController();
  final TextEditingController tipoContratoController = TextEditingController();
  String? selectedDropdownModalidadTrabajoValue;
  String? selectedDropdownTipoContratoValue;
  String? selectedDropdownTurnoTrabajoValue;

  //*Health Information*/
  // final TextEditingController opcionesSaludController = TextEditingController();
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
      Get.to(() => const WorkInfoScreen());
    } catch (e) {
      Loaders.errorSnackBar(
          title: 'Oh, sucedió un error', message: e.toString());
    }
  }

  //Validar Datos de Trabajo y pasar a siguiente Screen
  void validarWorkInfo() async {
    try {
      //log.i('Work Info: ${formWorkInfoKey.currentState!.validate()}');
      //if (!formWorkInfoKey.currentState!.validate()) {return;}

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
      log.i('Personal Info: ${userWorkInfo.toJson()}');
      Get.to(() => const HealthInfoScreen());
    } catch (e) {
      Loaders.errorSnackBar(
          title: 'Oh, sucedió un error', message: e.toString());
    }
  }

  //Validar Datos de Salud y pasar a siguiente Screen (Dashboard)
  void validarHealthInfo() async {
    try {
      final userHealthInfo = UserDetail(
          idUsuario: _user.value!.id,
          genero: selectedDropdownGeneroValue!,
          fechaNacimiento: dateController.text,
          altura: alturaController.text,
          peso: pesoController.text,
          ocupacion: ocupacionController.text,
          modalidadTrabajo: selectedDropdownModalidadTrabajoValue!,
          horasTrabajo: horasTrabajoController.text,
          tipoContrato: selectedDropdownTipoContratoValue!,
          turnoTrabajo: selectedDropdownTurnoTrabajoValue!,
          opcionesSalud: selectedOptions);
      log.i('Personal Info: ${userHealthInfo.toJson()}');

      final userRepository = Get.put(UserRepository());
      await userRepository.saveUserDetails(userHealthInfo);

      // Show Success Hessage
      Loaders.successSnackBar(
          title: 'Procesando... Gracias!',
          message:
              '¡Empecemos tu viaje hacia un mejor Bienestar físico y mental con Health Connect');
      /*
      CollectionReference collectionReference =FirebaseFirestore.instance.collection('UserDetails');
      collectionReference.add(userHealthInfo.toJson());
      Get.to(const DashboardScreen());
      Get.to(() => const DashboardScreen());
      */
      Get.offAll(() => const DashboardScreen());
    } catch (e) {
      Loaders.errorSnackBar(
          title: 'Oh, sucedió un error', message: e.toString());
    }
  }
}
