import 'package:app_health_connect/features/authentication/screens/password_configuration/forget_password.dart';
import 'package:app_health_connect/features/authentication/screens/signup/signup.dart';
import 'package:app_health_connect/utils/constants/colors.dart';
import 'package:app_health_connect/utils/constants/sizes.dart';
import 'package:app_health_connect/utils/constants/text_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TLoginForm extends StatelessWidget {
  const TLoginForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
        child: Padding(
      padding: const EdgeInsets.symmetric(
          vertical: TSizes.spaceBtwSections),
      child: Column(
        children: [
          //Email
          TextFormField(
            decoration: const InputDecoration(
                prefixIcon: Icon(Icons.email,color:TColors.primary),
                labelText: TTexts.email),
          ),
          const SizedBox(height: TSizes.spaceBtwInputFields * 1.5),
          //Password
          TextFormField(
            decoration: const InputDecoration(
                prefixIcon: Icon(Icons.password,color: TColors.primary,),
                labelText: TTexts.password,
                suffixIcon: Icon(Icons.remove_red_eye_outlined,color: TColors.primary,)),
          ),
          const SizedBox(height: TSizes.spaceBtwInputFields / 2),
          //Remember me &  Forget Password
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              //Remember me
              Row(
                children: [
                  Checkbox(value: true, onChanged: (value) {}),
                  const Text(TTexts.rememberMe),
                ],
              ),
              TextButton(
                  onPressed: () => Get.to(()=> const ForgetPassword()),
                  child: const Text(
                      TTexts.forgetPassword)) //Forget Password
            ],
          ),
          const SizedBox(height: TSizes.spaceBtwSections),
          SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(TColors.primary),
                  foregroundColor: MaterialStateProperty.all<Color>(TColors.white),
                  padding: const MaterialStatePropertyAll(EdgeInsets.all(20))
                ),
                onPressed: () {},
                child: const Text(TTexts.signIn,style: TextStyle(fontSize: 16),)
              )
          ),
          const SizedBox(height: TSizes.spaceBtwItems),
          SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                style: const ButtonStyle(
                  padding:  MaterialStatePropertyAll(EdgeInsets.all(20))
                ),
                onPressed: () => Get.to(() => const SignUpScreen()),
                child: const Text(TTexts.createAccount)
              )
          ),
          const SizedBox(height: TSizes.spaceBtwSections),
        ],
      ),
    ));
  }
}