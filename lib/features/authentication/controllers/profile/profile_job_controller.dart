import 'package:app_health_connect/config/helper/logging.dart';
import 'package:app_health_connect/data/repositories/authentication/authentication_repository.dart';
import 'package:app_health_connect/data/repositories/user/user_repository.dart';
import 'package:app_health_connect/features/authentication/controllers/dashboard/dashboard_controller.dart';
import 'package:app_health_connect/features/authentication/models/user_detail.dart';
import 'package:app_health_connect/utils/constants/image_strings.dart';
import 'package:app_health_connect/utils/helpers/network_manager.dart';
import 'package:app_health_connect/utils/popups/custom_success_dialog.dart';
import 'package:app_health_connect/utils/popups/full_screen_loader.dart';
import 'package:app_health_connect/utils/popups/loaders.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileJobController extends GetxController {
  static ProfileJobController get instance => Get.find();

  final log = logger(ProfileJobController);

  final profileJobFormKey = GlobalKey<FormState>();

  final TextEditingController ocupacionController = TextEditingController();
  final TextEditingController horasTrabajoController = TextEditingController();
  var selectedDropdownModalidadTrabajoValue = 'Trabajo Remoto'.obs;
  var selectedDropdownTipoContratoValue = 'Tiempo Completo'.obs;
  var selectedDropdownTurnoTrabajoValue = 'Horario Diurno(Mañana y Tarde)'.obs;
  var selectedDropdownTipHorTrabajoValue = 'hrs/día'.obs;

  var itemsModTrabajo = ['Trabajo Remoto', 'Trabajo Híbrido'];
  var itemsHorasTrabajo = ['hrs/día', 'hrs/semana'];
  var itemsTipoContrato = ['Tiempo Completo', 'Part Time', 'Practicante'];
  var itemsTurnoTrabajo = [
    'Horario Diurno(Mañana y Tarde)',
    'Horario Rotativo'
  ];

  UserDetail? detalleUser = DashboardController.instance.detailuser;

  @override
  void onInit() {
    if (detalleUser != null) {
      ocupacionController.text = detalleUser!.ocupacion;
      horasTrabajoController.text = detalleUser!.horasTrabajo;
      selectedDropdownModalidadTrabajoValue.value =
          detalleUser!.modalidadTrabajo;
      selectedDropdownTipoContratoValue.value = detalleUser!.tipoContrato;
      selectedDropdownTurnoTrabajoValue.value = detalleUser!.turnoTrabajo;
      selectedDropdownTipHorTrabajoValue.value = detalleUser!.tipoHorasTrabajo;
    } else {
      DashboardController.instance.cerrarSesion();
    }

    super.onInit();
  }

  void guardarCambiosDatosLaborales() async {
    try {
      TFullScreenLoader.openLoadingDialog(
          "Procesando Información..", TImages.loadingAnimation);

      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        TFullScreenLoader.stopLoading();
        return;
      }

      if (!profileJobFormKey.currentState!.validate()) {
        TFullScreenLoader.stopLoading();
        return;
      }

      final userDetail = UserDetail(
        idUsuario: AuthenticationRepository.instance.authUser!.uid,
        ocupacion: ocupacionController.text,
        horasTrabajo: horasTrabajoController.text,
        modalidadTrabajo: selectedDropdownModalidadTrabajoValue.value,
        tipoContrato: selectedDropdownTipoContratoValue.value,
        turnoTrabajo: selectedDropdownTurnoTrabajoValue.value,
        tipoHorasTrabajo: selectedDropdownTipHorTrabajoValue.value,
        genero: '',
        fechaNacimiento: '',
        altura: '',
        peso: '',
      );

      final userRepository = Get.isRegistered<UserRepository>()
          ? Get.find<UserRepository>()
          : Get.put(UserRepository());
      await userRepository.updateDatosLaborales(userDetail);

      DashboardController.instance.updateDetalleUsuarioTrabajo(
          ocupacionController.text,
          selectedDropdownModalidadTrabajoValue.value,
          selectedDropdownTipoContratoValue.value,
          selectedDropdownTurnoTrabajoValue.value,
          horasTrabajoController.text,
          selectedDropdownTipHorTrabajoValue.value);

      TFullScreenLoader.stopLoading();
      showSuccessDialog();
    } catch (e) {
      TFullScreenLoader.stopLoading();
      log.e("Error: ${e.toString()}");
      Loaders.errorSnackBar(
          title: 'Oh, sucedió un error', message: e.toString());
    }
  }

  void showSuccessDialog() {
    Get.dialog(CustomSuccessWidget(
      titulo: 'Exito',
      mensaje: 'Datos Laborales Actualizados con éxito',
      onPressed: () {
        log.i("Datos Laborales Actualizados con éxito");
        Get.back();
        // Get.off(() => DashboardScreen());
        // Get.back();
      },
    ));
  }
}
