import 'package:app_health_connect/features/authentication/screens/signup/widgets/signup_form.dart';
import 'package:app_health_connect/utils/constants/colors.dart';
import 'package:app_health_connect/utils/constants/sizes.dart';
import 'package:app_health_connect/features/authentication/screens/login/widgets/login_header.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
              TLoginHeader(),
              SizedBox(height: TSizes.spaceBtwItems),
              TSignupForm(),
              /*
              ///Divider
              TFormDivider(dividerText: TTexts.orSignUpWith.capitalize!),
              const SizedBox(height: TSizes.spaceBtwSections),

              ///Social Login Buttons
              const TSocialButtons(),
              */
              SizedBox(height: TSizes.spaceBtwSections)
            ],
          ),
        ),
      ),
    );
  }
}
