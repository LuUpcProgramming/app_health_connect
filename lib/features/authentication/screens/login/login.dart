import 'package:app_health_connect/common/widgets/login_signup/form_divider.dart';
import 'package:app_health_connect/common/widgets/login_signup/social_buttons.dart';
import 'package:app_health_connect/features/authentication/screens/login/widgets/login_form.dart';
import 'package:app_health_connect/features/authentication/screens/login/widgets/login_header.dart';
import 'package:app_health_connect/features/authentication/screens/onboarding/widgets/onboarding_widgets.dart';
import 'package:app_health_connect/utils/constants/general.dart';
import 'package:app_health_connect/utils/constants/sizes.dart';
import 'package:app_health_connect/utils/constants/text_strings.dart';
import 'package:app_health_connect/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const CircleWidget(
            locationCircle: General.circleTopLeft,
            widthCircle: 150,
            heightCircle: 150,
            distance1: -50,
            distance2: -50,
          ),
          const CircleWidget(
            locationCircle: General.circleTopRight,
            widthCircle: 150,
            heightCircle: 150,
            distance1: -50,
            distance2: -50,
          ),
          SingleChildScrollView(
            child: Padding(
              //padding: TSpacingStyle.paddingWithAppBarHeight,
              //padding: const EdgeInsets.only(top: 100, left: 24, right: 24),
              padding:  EdgeInsets.only(
                top: THelperFunctions.screenHeight() * 0.08,
                left: TSizes.defaultSpace,
                right: TSizes.defaultSpace,
                bottom: THelperFunctions.screenHeight() * 0.08
              ),
              child: Column(
                children: [
                  const SizedBox(height: TSizes.spaceBtwSections),
                  // Logo, Titulo y Subtitulo
                  const TLoginHeader(),
                  //Formulario
                  const TLoginForm(),

                  //Divider
                  TFormDivider(dividerText: TTexts.orSignInWith.capitalize!),
                  const SizedBox(height: TSizes.spaceBtwSections),

                  ///Footer
                  const TSocialButtons()
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}


