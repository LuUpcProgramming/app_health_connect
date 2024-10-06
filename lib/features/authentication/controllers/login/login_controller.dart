import 'package:app_health_connect/data/repositories/authentication/authentication_repository.dart';
import 'package:app_health_connect/utils/constants/image_strings.dart';
import 'package:app_health_connect/utils/helpers/network_manager.dart';
import 'package:app_health_connect/utils/popups/full_screen_loader.dart';
import 'package:app_health_connect/utils/popups/loaders.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class LoginController extends GetxController {
  static LoginController get instance => Get.find();
  //** Variables */
  final rememberMe = false.obs;
  final hidePassword = true.obs;
  final localStorage = GetStorage();
  final email= TextEditingController();
  final password = TextEditingController();
  GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();

  var rememberPassword = true.obs;


  @override
  void onInit() {

    email.text = localStorage.read('REMEMBER_ME_EMAIL')??"";
    password.text = localStorage.read('REMEMBER_ME_PASSWORD')??""; 
    
   // email.text = localStorage.read('REMEMBER_ME_EMAIL')??"luisnatividad97@hotmail.com";
    email.text = localStorage.read('REMEMBER_ME_EMAIL')??"luis_1997_na@hotmail.com";
    password.text = localStorage.read('REMEMBER_ME_PASSWORD')??"L123456%%"; 

    super.onInit();
  }

  Future<void> emailAndPasswordSignIn() async {
    try {
      TFullScreenLoader.openLoadingDialog(
          'Iniciando Sesión', TImages.loadingAnimation);

      // Check Internet Connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        TFullScreenLoader.stopLoading();
        Loaders.warningSnackBar(title: "Sin Conexión a Internet", message: "Por favor, verifica tu conexión a internet");
        return;
      }

      // Form Validation
      if (!loginFormKey.currentState!.validate()) {
        TFullScreenLoader.stopLoading();
        return;
      }

      if (rememberMe.value) {
        localStorage.write('REMEMBER_ME_EMAIL', email.text.trim());
        localStorage.write('REMEMBER_ME_PASSWORD', password.text.trim());
      }else{
        localStorage.remove('REMEMBER_ME_EMAIL');
        localStorage.remove('REMEMBER_ME_PASSWORD');
      }

      final userCredentials = await AuthenticationRepository.instance
          .loginWithEmailAndPassword(email.text.trim(), password.text.trim());

      

      AuthenticationRepository.instance.screenRedirect();
      TFullScreenLoader.stopLoading();
    } catch (e) {
      TFullScreenLoader.stopLoading();
      Loaders.errorSnackBar(title: 'Oh! Algo Salió Mal', message: e.toString());
    }
  }
}
