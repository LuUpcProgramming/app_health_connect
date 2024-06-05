import 'package:app_health_connect/features/authentication/controllers/welcome/welcome_controller.dart';
import 'package:app_health_connect/features/authentication/screens/welcome/personal_info.dart';
import 'package:app_health_connect/utils/constants/colors.dart';
import 'package:app_health_connect/utils/constants/image_strings.dart';
import 'package:app_health_connect/utils/constants/sizes.dart';
import 'package:app_health_connect/utils/constants/text_strings.dart';
import 'package:app_health_connect/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(WelcomeController());
    return Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(TImages.defaultFondo),
              fit: BoxFit.cover, // Esto hace que la imagen cubra toda la pantalla
            ),
          ),
          child: Padding(
            //TODO Verificar Padding. Probar en varios dispositivos como se  visualiza, sino corregir con el Scroll
            padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 220.0),
            child: Column(
              children: [
                ///Images
                Image(
                    image: const AssetImage(TImages.robotLogo),
                    width: THelperFunctions.screenWidth() * 0.5),
                const SizedBox(height: TSizes.spaceBtwSections),
                      
                ///Titulo y subtitulo
                Obx((){
                  if (controller.user == null) {
                    return const CircularProgressIndicator();
                  }else{
                    final user= controller.user!;
                    return Text(
                        '${TTexts.ipPresentationIATitle}'
                        '${user.firstName}!',
                        style: const TextStyle(
                          fontSize: 28.0,
                          fontWeight: FontWeight.bold,
                          color: TColors.primary,
                        ),
                        textAlign: TextAlign.center);
                  }
                    
                  }
                ), 
               /*  const Text(
                  '${TTexts.ipPresentationIATitle} Jesus',
                  style:  TextStyle(
                    fontSize: 28.0,
                    fontWeight: FontWeight.bold,
                    color: TColors.primary,
                  ),
                  textAlign: TextAlign.center
                  ), */
                      
                const SizedBox(height: TSizes.spaceBtwItems),
                const Text(TTexts.ipPresentationIASubtitle,
                    style: TextStyle(
                        fontSize: 16.0,
                        color: TColors.primary,
                        fontStyle: FontStyle.italic),
                    textAlign: TextAlign.center),
                const SizedBox(height: TSizes.spaceBtwSections),
                      
                ///Buttons
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(TColors.primary),
                        foregroundColor:
                            MaterialStateProperty.all<Color>(TColors.white),
                        padding: const MaterialStatePropertyAll(EdgeInsets.all(20))),
                    onPressed: () => Get.to(
                      const PersonalInfoScreen(),
                      transition: Transition.rightToLeft, // Transición de deslizar
                      duration: const Duration(milliseconds: 700), // Duración de la transición
                    ),
                    child: const Text(TTexts.tContinue,style: TextStyle(fontSize: 18)),
                  ),
                ),
              ],
                      ),
          ),
        )
    );
  }
}
