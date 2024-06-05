import 'package:app_health_connect/data/repositories/authentication/authentication_repository.dart';
import 'package:app_health_connect/features/authentication/controllers/signup/verify_email_controller.dart';
import 'package:app_health_connect/utils/constants/colors.dart';
import 'package:app_health_connect/utils/constants/image_strings.dart';
import 'package:app_health_connect/utils/constants/sizes.dart';
import 'package:app_health_connect/utils/constants/text_strings.dart';
import 'package:app_health_connect/utils/helpers/helper_functions.dart';
import 'package:app_health_connect/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VerifyEmailScreen extends StatelessWidget {
  const VerifyEmailScreen({super.key, this.email});

  final String? email;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(VerifyEmailController());
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () => AuthenticationRepository.instance.logout(),
            icon: const Icon(Icons.close),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding:  EdgeInsets.only(
            top: THelperFunctions.screenHeight()*0.05,
            left: TSizes.defaultSpace,
            right: TSizes.defaultSpace,
            //bottom: THelperFunctions.screenHeight()*0.08
          ),
          child: Column(
            children: [
              ///Images
              Image(
                  image: const AssetImage(TImages.deliveredEmailIllustration),
                  width: THelperFunctions.screenWidth() * 0.8,
                  height: THelperFunctions.screenHeight() * 0.30),
              const SizedBox(height: TSizes.sm),

              ///Titulo y subtitulo
              Text(TTexts.confirmEmail,
                  style: TAppTheme.textThemeTitle,
                  textAlign: TextAlign.center),
              const SizedBox(height: TSizes.sm),
              Text(email ?? '',
                  style: TAppTheme.textThemeSubTitleDark,
                  textAlign: TextAlign.center),
              const SizedBox(height: TSizes.spaceBtwItems),
              Text(TTexts.confirmEmailSubTitle,
                  style: TAppTheme.textThemeCustom(14, 'Poppins', FontStyle.normal, TColors.dark, FontWeight.w500),
                  textAlign: TextAlign.center),
              const SizedBox(height: TSizes.spaceBtwAditional),

              ///Buttons
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
                  onPressed: () => controller.checkEmailVerificationStatus(),
                  child: const Text(TTexts.tContinue),
                ),
              ),
              const SizedBox(height: TSizes.spaceBtwItems),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  style: const ButtonStyle(
                      padding: MaterialStatePropertyAll(EdgeInsets.all(20))),
                  onPressed: () => controller.sendEmailVerification(),
                  child: const Text(TTexts.resendEmail),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
