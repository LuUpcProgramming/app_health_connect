import 'package:app_health_connect/features/authentication/controllers/login/forget_pass_controller.dart';
import 'package:app_health_connect/features/authentication/screens/login/login.dart';
import 'package:app_health_connect/features/authentication/screens/login/widgets/custom_scaffold.dart';
import 'package:app_health_connect/utils/constants/colors.dart';
import 'package:app_health_connect/utils/constants/image_strings.dart';
import 'package:app_health_connect/utils/constants/sizes.dart';
import 'package:app_health_connect/utils/constants/text_strings.dart';
import 'package:app_health_connect/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ResetPassword extends StatelessWidget {
  const ResetPassword({super.key,required this.email});

  final String email;

 
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      child:  Column(
        children: [
          const Expanded(
            flex: 1,
            child: SizedBox(
              height: 10,
            ),
          ),
          Expanded(
            flex:7,
            child:Container(
              padding: const EdgeInsets.fromLTRB(25.0, 50.0, 25.0, 20.0),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40.0),
                  topRight: Radius.circular(40.0),
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  
                  children: [
                    ///Images
                    Image(
                        image: const AssetImage(TImages.deliveredEmailIllustration),
                        width: THelperFunctions.screenHeight() * 0.2),
                    const SizedBox(height: TSizes.spaceBtwSections),
                              
                    ///Titulo y subtitulo
                    const Text(
                      TTexts.changeYourPasswordTitle,
                      style: TextStyle(
                        color: TColors.primary,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center),
                    const SizedBox(height: TSizes.spaceBtwItems),
                    const Text(
                      TTexts.changeYourPasswordSubTitle,
                      style: TextStyle(
                          color: TColors.black,
                          fontSize: 16.0,
                          fontWeight: FontWeight.normal),
                      textAlign: TextAlign.center),
                    const SizedBox(height: TSizes.spaceBtwSections),
                              
                    ///Buttons
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: TColors.primary,
                          elevation: 10, // Elevación del botón
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 18), // Color del texto
                        ),
                        onPressed: () => Get.offAll(() => const LoginScreen(),
                          transition: Transition.rightToLeft,
                          duration: const Duration(milliseconds: 600)),
                        child: const Text(TTexts.done,
                            style: TextStyle(color: TColors.white, fontSize: 16)),
                      ),
                    ),
                    const SizedBox(
                      height: 30.0,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(
                              color: TColors.primary,
                              width: 1.4), // Borde azul con mayor grosor
                          backgroundColor: TColors.white,
                          elevation: 10, // Elevación del botón
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 18), // Color del texto
                        ),
                        onPressed: () => ForgetPasswordController.instance.resendPasswordResetEmail(email),
                        child: const Text(TTexts.resendEmail,
                            style: TextStyle(color: TColors.primary, fontSize: 16)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ]
      ),
    );
  }
}