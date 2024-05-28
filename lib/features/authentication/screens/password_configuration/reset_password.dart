import 'package:app_health_connect/utils/constants/colors.dart';
import 'package:app_health_connect/utils/constants/image_strings.dart';
import 'package:app_health_connect/utils/constants/sizes.dart';
import 'package:app_health_connect/utils/constants/text_strings.dart';
import 'package:app_health_connect/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ResetPassword extends StatelessWidget {
  const ResetPassword({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () => Get.back(), 
            icon: const Icon(Icons.close, color: TColors.primary)
          )
        ],
      ),
      body:  SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            children: [
              ///Images
              Image(
                  image: const AssetImage(TImages.deliveredEmailIllustration),
                  width: THelperFunctions.screenHeight() * 0.6),
              const SizedBox(height: TSizes.spaceBtwSections),

              ///Titulo y subtitulo
              Text(TTexts.changeYourPasswordTitle,
                  style: Theme.of(context).textTheme.headlineMedium,
                  textAlign: TextAlign.center),
              const SizedBox(height: TSizes.spaceBtwItems),
              Text(TTexts.changeYourPasswordSubTitle,
                  style: Theme.of(context).textTheme.labelMedium,
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
                      padding: const MaterialStatePropertyAll(EdgeInsets.all(20))
                  ),
                  onPressed: () {},
                  child: const Text(TTexts.done),
                ),
              ),
               ///Buttons
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(TColors.primary),
                      foregroundColor:
                          MaterialStateProperty.all<Color>(TColors.white),
                      padding: const MaterialStatePropertyAll(EdgeInsets.all(20))
                  ),
                  onPressed: () {},
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