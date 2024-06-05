import 'package:app_health_connect/features/authentication/controllers/onboarding/onboarding_controller.dart';
import 'package:app_health_connect/features/authentication/screens/onboarding/widgets/onboarding_widgets.dart';
import 'package:app_health_connect/utils/constants/general.dart';
import 'package:app_health_connect/utils/constants/image_strings.dart';
import 'package:app_health_connect/utils/constants/text_strings.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OnBoardingController());

    return Scaffold(
      body: Stack(
        children: [
         
          const CircleWidget(
            locationCircle: General.circleTopRight,
            widthCircle: 150,
            heightCircle: 150,
            distance1: -50,
            distance2: -50
          ),
          const CircleWidget(
            locationCircle: General.circleBottomLeft,
            widthCircle: 150,
            heightCircle: 150,
            distance1: -50,
            distance2: -50,
          ),
           //Horizontal Scrollable Pages
          PageView(
            controller: controller.pageController,
            onPageChanged: controller.updatePageIndicator,
            children: const [
              OnBoardingPage(
                image: TImages.onBoardingImage1,
                title: TTexts.onBoardingTitle1,
                subTitle: TTexts.onBoardingSubTitle1,
              ),
              OnBoardingPage(
                image: TImages.onBoardingImage2,
                title: TTexts.onBoardingTitle2,
                subTitle: TTexts.onBoardingSubTitle2,
              ),
              OnBoardingPage(
                image: TImages.onBoardingImage3,
                title: TTexts.onBoardingTitle3,
                subTitle: TTexts.onBoardingSubTitle3,
              )
            ],
          ),
          //Skip Button
         // const OnBoardingSkip(),
          //Dot Navigation
          const OnBoardingDotNavigation(),
          //Button
          const OnBoardingNextButton(),
        ],
      ),
    );
  }
}



