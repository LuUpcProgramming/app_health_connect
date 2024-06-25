import 'package:app_health_connect/data/repositories/authentication/authentication_repository.dart';
import 'package:app_health_connect/data/repositories/user/user_repository.dart';
import 'package:app_health_connect/features/authentication/screens/signup/verify_email.dart';
import 'package:app_health_connect/utils/helpers/network_manager.dart';
import 'package:app_health_connect/features/authentication/models/user_model.dart';
import 'package:app_health_connect/utils/popups/loaders.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignupController extends GetxController {
  static SignupController get instance => Get.find();

  //Variables
  final hidePassword = true.obs;
  final privacyPolicy = true.obs;
  final email = TextEditingController();
  final firstName = TextEditingController();
  final lastName = TextEditingController();
  //final username = TextEditingController();
  final password = TextEditingController();
  //final confirmPassword = TextEditingController();
  final phoneNumber = TextEditingController();
  GlobalKey<FormState> signupFormKey = GlobalKey<FormState>();

  @override
  void onInit() {
    firstName.text = "Luis";
    lastName.text = "Natividad";
    phoneNumber.text = "934543452";
    email.text = "luisnatividad97@hotmail.com";
    password.text = "L123456%%";

    super.onInit();
  }

  //Signup

  void signup() async {
    try {
      // Start Loading
      showDialog(
          context: Get.overlayContext!,
          builder: (context) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          });
      // Check Internet Connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        Navigator.of(Get.overlayContext!).pop();
        return;
      }
      // Form Validation
      if (!signupFormKey.currentState!.validate()) {
        Navigator.of(Get.overlayContext!).pop();
        return;
      }

      // Privacy Policy Check
      if (!privacyPolicy.value) {
        Loaders.warningSnackBar(
            title: 'Aceptar la política de privacidad',
            message:
                'En orden para crear la cuenta, usted debe leer y aceptar la política de privacidad y términos de uso');
        Navigator.of(Get.overlayContext!).pop();
        return;
      }

      // Register user in the Firebase Authentication S Save user data in the Firebase
      final userCredential = await AuthenticationRepository.instance
          .registerWithEmailAndPassword(
              email.text.trim(), password.text.trim());

      // Save Authenticated user data in the Firebase Firestore

      final newUser = UserModel(
          id: userCredential.user!.uid,
          firstName: firstName.text.trim(),
          lastName: lastName.text.trim(),
          email: email.text.trim(),
          phoneNumber: phoneNumber.text.trim(),
          profilePicture: '');

      final userRepository = Get.put(UserRepository());
      await userRepository.saveUserRecord(newUser);

      // Show Success Hessage
      Loaders.successSnackBar(
          title: 'Felicidades',
          message:
              '¡Tu cuenta ha sido creada! Verifica tu email para continuar.');

      //Move to Verify Email Screen
      Get.to(() => VerifyEmailScreen(email: email.text.trim()));
    } catch (e) {
      Navigator.of(Get.overlayContext!).pop();
      //Show some generic error to user
      Loaders.errorSnackBar(
          title: 'Oh, sucedió un error', message: e.toString());
    }
  }
}
