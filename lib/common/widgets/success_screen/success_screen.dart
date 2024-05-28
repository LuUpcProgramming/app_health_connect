import 'package:app_health_connect/common/styles/spacing_styles.dart';
import 'package:app_health_connect/utils/constants/colors.dart';
import 'package:app_health_connect/utils/constants/sizes.dart';
import 'package:app_health_connect/utils/constants/text_strings.dart';
import 'package:app_health_connect/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';


class SuccessScreen extends StatelessWidget {
  const SuccessScreen({super.key, required this.image, required this.title, required this.subtitle, required this.onPressed});

  final String image, title, subtitle;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      padding: TSpacingStyle.paddingWithAppBarHeight * 2,
      child: Column(
        children: [
          ///Images
          Lottie.asset(image,width: MediaQuery.of(context).size.width * 0.6),
          /* Image(
              image: AssetImage(image),
              width: THelperFunctions.screenHeight() * 0.6), */
          const SizedBox(height: TSizes.spaceBtwSections),

          ///Titulo y subtitulo
          Text(title,
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center),
          const SizedBox(height: TSizes.spaceBtwItems),
          Text(subtitle,
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
                  padding: const MaterialStatePropertyAll(EdgeInsets.all(20))),
              onPressed: onPressed,
              child: const Text(TTexts.tContinue),
            ),
          ),
        ],
      ),
    ));
  }
}
