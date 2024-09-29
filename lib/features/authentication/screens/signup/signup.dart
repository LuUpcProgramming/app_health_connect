import 'package:app_health_connect/features/authentication/controllers/signup/signup_controller.dart';
import 'package:app_health_connect/features/authentication/screens/login/widgets/custom_scaffold.dart';
import 'package:app_health_connect/utils/constants/colors.dart';
import 'package:app_health_connect/utils/constants/image_strings.dart';
import 'package:app_health_connect/utils/constants/sizes.dart';
import 'package:app_health_connect/utils/constants/text_strings.dart';
import 'package:app_health_connect/utils/validators/validation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SignupController());
    return CustomScaffold(
      child: Column(
        children: [
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
                // get started form
                child: Form(
                  key: controller.signupFormKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                       const Image(
                        height: 130,
                        image: AssetImage(TImages.officialLogo),
                      ),
                      const SizedBox(
                        height: 35.0,
                      ),
                      Row(
                        children: [
                          //Nombres
                          Expanded(
                            child: TextFormField(
                              controller: controller.firstName,
                              validator: (value) => TValidator.validateEmptyText('Nombres', value),
                              expands: false,
                              decoration: InputDecoration(
                                label: const Text('Nombres'),
                                hintText: 'Ingresa tu Nombre',
                                hintStyle: const TextStyle(
                                  color: Colors.black26,
                                ),
                                prefixIcon: const Icon(Icons.person, color: TColors.primary),
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
                          const SizedBox(width: TSizes.spaceBtwInputFields),
                          //Apellidos
                          Expanded(
                            child: TextFormField(
                              controller: controller.lastName,
                              validator: (value) => TValidator.validateEmptyText('Apellidos', value),
                              expands: false,
                              decoration: InputDecoration(
                                label: const Text('Apellidos'),
                                hintText: 'Ingresa tu Apellido',
                                hintStyle: const TextStyle(
                                  color: Colors.black26,
                                ),
                                prefixIcon: const Icon(Icons.person, color: TColors.primary),
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
                        ],
                      ),
                     const SizedBox(height: TSizes.spaceBtwInputFields),
                      // email
                      TextFormField(
                        controller: controller.email,
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
                      const SizedBox(height: TSizes.spaceBtwInputFields),
                      // password
                      Obx(
                        () => TextFormField(
                          controller: controller.password,
                          obscureText: controller.hidePassword.value,
                          obscuringCharacter: '*',
                          validator: (value) => TValidator.validatePassword(value),
                          decoration: InputDecoration(
                            labelText: TTexts.password,
                            hintText: 'Ingresa tu contraseña',
                            hintStyle: const TextStyle(
                              color: Colors.black26,
                            ),
                            prefixIcon: const Icon(Icons.lock, color: TColors.primary),
                            suffixIcon: IconButton(
                              onPressed: () => controller.hidePassword.value = !controller.hidePassword.value,
                                icon: Icon(controller.hidePassword.value ? Icons.visibility_off : Icons.visibility,
                                color: TColors.primary)
                            ),
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
                       const SizedBox(height: TSizes.spaceBtwInputFields),
                      Obx(
                        () => TextFormField(
                          controller: controller.confirmarPassword,
                          obscureText: controller.hideConfirmarPassword.value,
                          obscuringCharacter: '*',
                          validator: (value) => TValidator.validatePassword(value),
                          decoration: InputDecoration(
                            labelText: TTexts.confirmarPassword,
                            hintText: 'Confirme Contraseña',
                            hintStyle: const TextStyle(
                              color: Colors.black26,
                            ),
                            prefixIcon: const Icon(Icons.lock, color: TColors.primary),
                            suffixIcon: IconButton(
                              onPressed: () => controller.hideConfirmarPassword.value = !controller.hideConfirmarPassword.value,
                                icon: Icon(controller.hideConfirmarPassword.value ? Icons.visibility_off : Icons.visibility,
                                color: TColors.primary)
                            ),
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
                      // i agree to the processing
                     /*  const Row(
                        children: [
                          TTermsAndConditionCheckbox(),
                        ],
                      ), */
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
                          onPressed: () => controller.signup(),
                          child: const Text(TTexts.registerAccount,style: TextStyle(color: TColors.white,fontSize: 16)),
                        ),
                      ),
                      const SizedBox(
                        height: 30.0,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: TColors.primary, width: 1.4), // Borde azul con mayor grosor
                          backgroundColor: TColors.white,
                          elevation: 10, // Elevación del botón
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 18), // Color del texto
                          ),
                          onPressed: () => Get.back(),
                          child: const Text("Regresar", 
                            style: TextStyle(color: TColors.primary,fontSize: 16)),
                        ),
                      ),
                      const SizedBox(height: TSizes.spaceBtwSections),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/*
return Scaffold(
      appBar: AppBar(
        backgroundColor: TColors.primary,
        title: const Text('CREA TU CUENTA',
            style: TextStyle(
              color: TColors.white,
              fontWeight: FontWeight.w500,
              //fontStyle: FontStyle.italic,
              fontSize: 18,
            )),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: TColors.white),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: const SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
             // TLoginHeader(),
              SizedBox(height: TSizes.spaceBtwItems),
              TSignupForm(),
              SizedBox(height: TSizes.spaceBtwSections)
            ],
          ),
        ),
      ),
    );

 */
