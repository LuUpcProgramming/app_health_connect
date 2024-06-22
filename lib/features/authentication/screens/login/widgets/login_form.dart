import 'package:app_health_connect/features/authentication/controllers/login/login_controller.dart';
import 'package:app_health_connect/features/authentication/screens/password_configuration/forget_password.dart';
import 'package:app_health_connect/features/authentication/screens/signup/signup.dart';
import 'package:app_health_connect/utils/constants/colors.dart';
import 'package:app_health_connect/utils/constants/sizes.dart';
import 'package:app_health_connect/utils/constants/text_strings.dart';
import 'package:app_health_connect/utils/validators/validation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TLoginForm extends StatelessWidget {
  const TLoginForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());
    return Form(
      key: controller.loginFormKey,
      child: Padding(
      padding: const EdgeInsets.symmetric(vertical: TSizes.spaceBtwSections),
      child: Column(
        children: [
          //Email
          TextFormField(
            controller: controller.email,
            validator: (value) => TValidator.validateEmail(value),
            decoration: const InputDecoration(
                prefixIcon: Icon(Icons.email, color: TColors.primary),
                labelText: TTexts.email,
                labelStyle: TextStyle(color: TColors.primary)),
          ),
          const SizedBox(height: TSizes.spaceBtwInputFields * 1.5),
          //Password
          Obx(
            () => TextFormField(
              controller: controller.password,
              validator: (value) => TValidator.validatePassword(value),
              obscureText: controller.hidePassword.value,
              decoration:  InputDecoration(
                  prefixIcon: const Icon(Icons.password, color: TColors.primary),
                  labelText: TTexts.password,
                  suffixIcon: IconButton(
                    onPressed: () => controller.hidePassword.value = !controller.hidePassword.value,
                    icon: Icon(controller.hidePassword.value ? Icons.remove_red_eye_outlined: Icons.panorama_fish_eye,
                      color: TColors.primary)
                  )
              ),
            ),
          ),
          const SizedBox(height: TSizes.spaceBtwInputFields / 2),
          //Remember me &  Forget Password
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              //Remember me
              Row(
                children: [
                  Obx(() => Checkbox(value: controller.rememberMe.value, onChanged: (value)=> controller.rememberMe.value = !controller.rememberMe.value)),
                  const Text(TTexts.rememberMe),
                ],
              ),
              TextButton(
                  onPressed: () => Get.to(() => const ForgetPassword()),
                  child: const Text(TTexts.forgetPassword)) //Forget Password
            ],
          ),
          const SizedBox(height: TSizes.spaceBtwSections),
          SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(TColors.primary),
                      foregroundColor:
                          MaterialStateProperty.all<Color>(TColors.white),
                      padding:
                          const MaterialStatePropertyAll(EdgeInsets.all(20))),
                  onPressed: () => controller.emailAndPasswordSignIn(),
                  child: const Text(
                    TTexts.signIn,
                    style: TextStyle(fontSize: 16),
                  ))),
          const SizedBox(height: TSizes.spaceBtwItems),
          SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                  style: const ButtonStyle(
                      padding: MaterialStatePropertyAll(EdgeInsets.all(20))),
                  onPressed: () => Get.to(() => const SignUpScreen()),
                  child: const Text(TTexts.createAccount))),
          const SizedBox(height: TSizes.spaceBtwSections),
        ],
      ),
    ));
  }
}
