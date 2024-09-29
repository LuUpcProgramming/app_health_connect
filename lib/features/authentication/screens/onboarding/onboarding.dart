import 'package:app_health_connect/features/authentication/controllers/onboarding/onboarding_controller.dart';
import 'package:app_health_connect/features/authentication/screens/login/widgets/custom_scaffold.dart';
import 'package:app_health_connect/features/authentication/screens/onboarding/widgets/onboarding_widgets.dart';
import 'package:app_health_connect/utils/constants/general.dart';
import 'package:app_health_connect/utils/constants/image_strings.dart';
import 'package:app_health_connect/utils/constants/text_strings.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OnBoardingController());

    return CustomScaffold(
      child: Column(
        children: [
         
/*           const CircleWidget(
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
          ), */
          const Expanded(
            flex: 1,
            child: SizedBox(
              height: 10,
            ),
          ),
          Expanded(
            flex: 8,
            child: Container(
              padding: const EdgeInsets.fromLTRB(25.0, 20.0, 25.0, 20.0),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40.0),
                  topRight: Radius.circular(40.0),
                ),
              ),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: PageView(
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
                  ),
                  const OnBoardingDotNavigation(),
                  const OnBoardingNextButton(),
                ],
              ),
            ),
          ),
          //Skip Button
         // const OnBoardingSkip(),
         
        ],
      ),
    );
  }
}



