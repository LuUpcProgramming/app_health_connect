import 'package:app_health_connect/config/helper/logging.dart';
import 'package:app_health_connect/data/repositories/authentication/authentication_repository.dart';
import 'package:app_health_connect/data/repositories/user/user_repository.dart';
import 'package:app_health_connect/features/authentication/controllers/dashboard/dashboard_controller.dart';
import 'package:app_health_connect/features/authentication/models/user_detail.dart';
import 'package:app_health_connect/features/authentication/models/user_model.dart';
import 'package:app_health_connect/utils/constants/image_strings.dart';
import 'package:app_health_connect/utils/helpers/network_manager.dart';
import 'package:app_health_connect/utils/popups/custom_success_dialog.dart';
import 'package:app_health_connect/utils/popups/full_screen_loader.dart';
import 'package:app_health_connect/utils/popups/loaders.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfilePersonalInfoController extends GetxController {
  static ProfilePersonalInfoController get instance => Get.find();

  final log = logger(ProfilePersonalInfoController);
  var hidePassword = true.obs;
  var hideConfirmPassword = true.obs;
  var hideNewPassword = true.obs;
  var showNewPasswordFields = false.obs;
  final profilePersonalFormKey = GlobalKey<FormState>();

  // Controladores para los campos
  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final email = TextEditingController();
  //final gender = TextEditingController();
  final birthDate = TextEditingController();
  final height = TextEditingController();
  final weight = TextEditingController();
  final actualPassword = TextEditingController();
  final newPassowrd = TextEditingController();
  final confirmPassword = TextEditingController();
  var isPasswordEditable = false.obs;
  var isPasswordCorrect = true.obs;
  var mensajeError = ''.obs;

  var selectedDropdownGeneroValue = 'Masculino'.obs;

  UserDetail? detalleUser = DashboardController.instance.detailuser;
  Rx<UserModel?> user = DashboardController.instance.usuario;

  @override
  void onInit() {
    //Asignar valores random a los controladores
    if (user.value != null) {
      firstName.text = user.value!.firstName;
      lastName.text = user.value!.lastName;
      email.text = user.value!.email;
      birthDate.text = detalleUser!.fechaNacimiento;
      height.text = detalleUser!.altura;
      weight.text = detalleUser!.peso;
      selectedDropdownGeneroValue.value = detalleUser!.genero;
    } else {
      DashboardController.instance.cerrarSesion();
    }

    super.onInit();
  }

  guardarCambiosDatosPersonales() async {
    try {
      TFullScreenLoader.openLoadingDialog(
          "Procesando Información..", TImages.loadingAnimation);

      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        TFullScreenLoader.stopLoading();
        // Navigator.of(Get.overlayContext!).pop();
        return;
      }

      if (isPasswordEditable.value) {
        isPasswordCorrect.value = true;
        if (actualPassword.text.isEmpty) {
          isPasswordCorrect.value = false;
          mensajeError.value = 'Contraseña es Obligatoria';
          TFullScreenLoader.stopLoading();
          return;
        }

        // Check for minimum password length
        if (actualPassword.text.length < 6) {
          isPasswordCorrect.value = false;
          mensajeError.value = 'Contraseña debe tener al menos 6 caracteres';
          TFullScreenLoader.stopLoading();
          return;
        }

        // Check for uppercase letters
        if (!actualPassword.text.contains(RegExp(r'[A-Z]'))) {
          isPasswordCorrect.value = false;
          mensajeError.value =
              'Contraseña debe tener al menos una letra mayúscula';
          TFullScreenLoader.stopLoading();
          return;
        }

        // Check for numbers
        if (!actualPassword.text.contains(RegExp(r'[0-9]'))) {
          isPasswordCorrect.value = false;
          mensajeError.value = 'Contraseña debe tener al menos un número';
          TFullScreenLoader.stopLoading();
          return;
        }

        // Check for special characters
        if (!actualPassword.text.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
          isPasswordCorrect.value = false;
          mensajeError.value =
              'Contraseña debe tener al menos un carácter especial';
          TFullScreenLoader.stopLoading();
          return;
        }
      }

      if (!profilePersonalFormKey.currentState!.validate()) {
        TFullScreenLoader.stopLoading();
        return;
      }

      if (isPasswordEditable.value) {
        if (newPassowrd.text != confirmPassword.text) {
          TFullScreenLoader.stopLoading();
          Loaders.warningSnackBar(
              title: 'Verificar Nueva Contraseña',
              message: 'Las contraseñas deben coincidir. Intenta nuevamente.');
          return;
        }
      }

      final usuario = UserModel(
          id: AuthenticationRepository.instance.authUser!.uid,
          firstName: firstName.text,
          lastName: lastName.text,
          email: user.value!.email,
          phoneNumber: '',
          profilePicture: '');

      final userDetail = UserDetail(
          idUsuario: AuthenticationRepository.instance.authUser!.uid,
          genero: selectedDropdownGeneroValue.value,
          fechaNacimiento: birthDate.text,
          altura: height.text,
          peso: weight.text);

      final userRepository = Get.isRegistered<UserRepository>()
          ? Get.find<UserRepository>()
          : Get.put(UserRepository());

      await userRepository.updateDatosPersonales(userDetail);
      await userRepository.updateNamesUser(usuario);

      if (isPasswordEditable.value) {
        await AuthenticationRepository.instance.reauthenticateAndChangePassword(
            actualPassword.text, newPassowrd.text);
        actualPassword.clear();
        newPassowrd.clear();
        confirmPassword.clear();
      }

      DashboardController.instance.usuario.value?.firstName = firstName.text;

      DashboardController.instance
          .updateGenericoUsuario(firstName.text, lastName.text);
      DashboardController.instance.updateDetalleUsuarioPersonal(
          selectedDropdownGeneroValue.value,
          birthDate.text,
          height.text,
          weight.text
      );


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
      titulo: 'Éxito',
      mensaje: 'Datos Personales Actualizados con éxito',
      onPressed: () {
        log.i("Datos Personales Actualizados con éxito");
        Get.back();
        // Get.off(() => DashboardScreen());
        // Get.back();
      },
    ));
  }
}
