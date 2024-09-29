import 'package:app_health_connect/features/authentication/controllers/login/login_controller.dart';
import 'package:app_health_connect/features/authentication/screens/password_configuration/forget_password.dart';
import 'package:app_health_connect/utils/constants/sizes.dart';
import 'package:app_health_connect/utils/constants/text_strings.dart';
import 'package:app_health_connect/utils/validators/validation.dart';
import 'package:app_health_connect/features/authentication/screens/login/widgets/custom_scaffold.dart';
import 'package:app_health_connect/features/authentication/screens/signup/signup.dart';
import 'package:app_health_connect/utils/constants/colors.dart';
import 'package:app_health_connect/utils/constants/image_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.isRegistered<LoginController>()
        ? Get.find<LoginController>()
        : Get.put(LoginController());
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
                child: Form(
                  key: controller.loginFormKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Image(
                        height: 150,
                        image: AssetImage(TImages.officialLogo),
                      ),
                      const SizedBox(
                        height: 40.0,
                      ),
                        TextFormField(
                        controller: controller.email,  
                        validator: (value) => TValidator.validateEmail(value),
                        decoration: InputDecoration(
                          label: const Text('Correo Electrónico'),
                          hintText: 'Ingresa tu correo',
                          hintStyle: const TextStyle(
                            color: Colors.black26,
                          ),
                          prefixIcon: const Icon(Icons.email,color: TColors.primary,),
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
                      const SizedBox(
                        height: 25.0,
                      ),
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
                      const SizedBox(
                        height: 25.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Obx(() => Checkbox(
                                value: controller.rememberMe.value, onChanged: (value)=> controller.rememberMe.value = !controller.rememberMe.value,
                                activeColor: TColors.primary,),
                                ),
                                const Text(TTexts.rememberMe, style: TextStyle(
                                    color: Colors.black45,
                                )),
                            ],
                          ),
                          TextButton(
                          onPressed: () => Get.to(() => const ForgetPassword(), 
                          transition: Transition.rightToLeft,
                          duration:const Duration(milliseconds: 600)),
                          child: const Text(TTexts.forgetPassword)) 
                        ],
                      ),
                      const SizedBox(
                        height: 25.0,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: TColors.primary,
                            elevation: 10, // Elevación del botón
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 18), // Color del texto
                          ),
                          onPressed: () => controller.emailAndPasswordSignIn(),
                          child: const Text('Inicia Sesión',style: TextStyle(color: TColors.white,fontSize: 16)),
                        ),
                      ),
                      const SizedBox(
                        height: 25.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Divider(
                              thickness: 0.7,
                              color: Colors.grey.withOpacity(0.5),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: 0,
                              horizontal: 10,
                            ),
                            child: Text(
                              '¿No Tienes una Cuenta?',
                              style: TextStyle(
                                color: Colors.black45,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Divider(
                              thickness: 0.7,
                              color: Colors.grey.withOpacity(0.5),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 25.0,
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
                          onPressed: () => Get.to(() => const SignUpScreen(),
                          transition: Transition.rightToLeft,
                          duration:const Duration(milliseconds: 600)),
                          child: const Text(TTexts.createAccount, 
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
