import 'package:app_health_connect/data/repositories/authentication/authentication_repository.dart';
import 'package:app_health_connect/features/authentication/controllers/login/login_controller.dart';
import 'package:app_health_connect/features/authentication/screens/password_configuration/reset_password.dart';
import 'package:app_health_connect/utils/constants/image_strings.dart';
import 'package:app_health_connect/utils/helpers/network_manager.dart';
import 'package:app_health_connect/utils/popups/full_screen_loader.dart';
import 'package:app_health_connect/utils/popups/loaders.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgetPasswordController extends GetxController {
  static ForgetPasswordController get instance => Get.find();

  GlobalKey<FormState> forgetPassFormKey = GlobalKey<FormState>();
  final emailFP = TextEditingController();

  @override
  void onInit() {
    emailFP.text = "luisnatividad97@hotmail.com";
    super.onInit();
  }

  void sendPasswordResetEmail() async {
    try {
      TFullScreenLoader.openLoadingDialog(
          'Procesando tu Solicitud...', TImages.loadingAnimation);

       // Check Internet Connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        TFullScreenLoader.stopLoading();
        return;
      }

      if (!forgetPassFormKey.currentState!.validate()) {
        TFullScreenLoader.stopLoading();
        return;
      }

      await AuthenticationRepository.instance.sendPasswordResetEmail(emailFP.text.trim());

      TFullScreenLoader.stopLoading();

      Loaders.successSnackBar(title: "Correo Enviado",message:"Revisa tu correo para restablecer tu contraseña");
      Get.delete<LoginController>();
      Get.to(() =>  ResetPassword(email: emailFP.text.trim()),
          transition: Transition.rightToLeft,
          duration: const Duration(milliseconds: 600));
      //Get.delete<ForgetPasswordController>();    
    } catch (e) {
      TFullScreenLoader.stopLoading();
      Loaders.errorSnackBar(title: "Ocurrio un error",message: "No se pudo enviar el correo de restablecimiento de contraseña");
    }
  }

  resendPasswordResetEmail(String email) async{
     try {
      TFullScreenLoader.openLoadingDialog(
          'Procesando tu Solicitud...', TImages.loadingAnimation);

       // Check Internet Connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        TFullScreenLoader.stopLoading();
        return;
      }


      await AuthenticationRepository.instance.sendPasswordResetEmail(email);

      TFullScreenLoader.stopLoading();

      Loaders.successSnackBar(title: "Correo Enviado",message:"Revisa tu correo para restablecer tu contraseña");
  
    } catch (e) {
      TFullScreenLoader.stopLoading();
      Loaders.errorSnackBar(title: "Ocurrio un error",message: "No se pudo enviar el correo de restablecimiento de contraseña");
    }
  }
}
