import 'package:app_health_connect/features/authentication/controllers/login/forget_pass_controller.dart';
import 'package:app_health_connect/features/authentication/screens/login/widgets/custom_scaffold.dart';
import 'package:app_health_connect/utils/constants/colors.dart';
import 'package:app_health_connect/utils/constants/sizes.dart';
import 'package:app_health_connect/utils/constants/text_strings.dart';
import 'package:app_health_connect/utils/validators/validation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgetPassword extends StatelessWidget {
  const ForgetPassword({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ForgetPasswordController());
    return CustomScaffold(
      child: Column(children: [
        const Expanded(
          flex: 1,
          child: SizedBox(
            height: 10,
          ),
        ),
        Expanded(
          flex: 7,
          child: Container(
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
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ///Headings
                  const Text(TTexts.forgetPasswordTitle,
                      style: TextStyle(
                          color: TColors.primary,
                          fontSize: 32.0,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.start),
                  const SizedBox(height: 32),
                  const Text(TTexts.forgetPasswordSubTitle,
                      style: TextStyle(
                          color: TColors.black,
                          fontSize: 16.0,
                          fontWeight: FontWeight.normal),
                      textAlign: TextAlign.start),
                  const SizedBox(height: TSizes.spaceBtwSections * 2),
                  ///Text Field
                  Form(
                    key: controller.forgetPassFormKey,
                    child: TextFormField(
                      controller: controller.emailFP,
                      validator: (value) => TValidator.validateEmail(value),
                      decoration: InputDecoration(
                        label: const Text('Coreo Electrónico'),
                        hintText: 'Ingresa tu Correo',
                        hintStyle: const TextStyle(
                          color: Colors.black26,
                        ),
                        prefixIcon: const Icon(Icons.email, color: TColors.primary),
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Colors.black12, // Default border color
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Colors.black12, // Default border color
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: TSizes.spaceBtwSections),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: TColors.primary,
                        elevation: 10, // Elevación del botón
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 18), // Color del texto
                      ),
                      onPressed: () => controller.sendPasswordResetEmail(),
                      child: const Text("Enviar",
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
                      onPressed: () => Get.back(),
                      child: const Text("Regresar",
                          style: TextStyle(color: TColors.primary, fontSize: 16)),
                    ),
                  ),
                  const SizedBox(height: TSizes.spaceBtwSections),
                ],
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
