import 'package:app_health_connect/features/authentication/controllers/signup/signup_controller.dart';
import 'package:app_health_connect/features/authentication/screens/signup/widgets/terms_conditions_checkbox.dart';
import 'package:app_health_connect/utils/constants/colors.dart';
import 'package:app_health_connect/utils/constants/sizes.dart';
import 'package:app_health_connect/utils/constants/text_strings.dart';
import 'package:app_health_connect/utils/validators/validation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TSignupForm extends StatelessWidget {
  const TSignupForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SignupController());
    return Form(
      key: controller.signupFormKey,
      child: Column(
        children: [
          const SizedBox(height: TSizes.spaceBtwSections),
          Row(
            children: [
              //Nombres
              Expanded(
                child: TextFormField(
                  controller: controller.firstName,
                  validator: (value) => TValidator.validateEmptyText('Nombres', value),
                  expands: false,
                  decoration: const InputDecoration(
                      labelText: TTexts.firstName,
                      prefixIcon: Icon(Icons.person, color: TColors.primary)),
                ),
              ),
              const SizedBox(width: TSizes.spaceBtwInputFields),
              //Apellidos
              Expanded(
                child: TextFormField(
                  controller: controller.lastName,
                  validator: (value) => TValidator.validateEmptyText('Apellidos', value),
                  expands: false,
                  decoration: const InputDecoration(
                      labelText: TTexts.lastName,
                      prefixIcon: Icon(Icons.person, color: TColors.primary)),
                ),
              )
            ],
          ),
          const SizedBox(height: TSizes.spaceBtwInputFields),

          /*
          //Username
          TextFormField(
            expands: false,
            decoration: const InputDecoration(
                labelText: TTexts.username,
                prefixIcon: Icon(Icons.person_2_rounded,
                    color: TColors.primary)),
          ),
          
          const SizedBox(height: TSizes.spaceBtwInputFields),
          */
          //Email
          TextFormField(
            controller: controller.email,
            validator: (value) => TValidator.validateEmail(value),
            decoration: const InputDecoration(
                labelText: TTexts.email,
                prefixIcon: Icon(Icons.email, color: TColors.primary)),
          ),
          const SizedBox(height: TSizes.spaceBtwInputFields),
          //Telefono
          TextFormField(
            controller: controller.phoneNumber,
            validator: (value) => TValidator.validatePhoneNumber(value),
            decoration: const InputDecoration(
                labelText: TTexts.phoneNo,
                prefixIcon: Icon(Icons.phone, color: TColors.primary)),
          ),
          const SizedBox(height: TSizes.spaceBtwInputFields),
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
          const SizedBox(height: TSizes.spaceBtwSections),

          //Terms & Conditions Checkbox
          const TTermsAndConditionCheckbox(),
          const SizedBox(height: TSizes.spaceBtwSections),
          //Signup Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(TColors.primary),
                  foregroundColor:
                      MaterialStateProperty.all<Color>(TColors.white),
                  padding: const MaterialStatePropertyAll(EdgeInsets.all(20))),
              onPressed: () => controller.signup(),
              child: const Text(TTexts.registerAccount,
                  style: TextStyle(fontSize: 16)),
            ),
          )
        ],
      ),
    );
  }
}
