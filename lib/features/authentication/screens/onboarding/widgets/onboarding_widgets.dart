import 'package:app_health_connect/features/authentication/controllers/onboarding/onboarding_controller.dart';
import 'package:app_health_connect/utils/constants/colors.dart';
import 'package:app_health_connect/utils/constants/general.dart';
import 'package:app_health_connect/utils/device/device_utility.dart';
import 'package:app_health_connect/utils/helpers/helper_functions.dart';
import 'package:app_health_connect/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../../../utils/constants/sizes.dart';

class OnBoardingSkip extends StatelessWidget {
  const OnBoardingSkip({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
        top: TDeviceUtils.getAppBarHeight(),
        right: TSizes.defaultSpace,
        child: TextButton(
          onPressed: () => OnBoardingController.instance.skipPage(),
          child: const Text('Saltar'),
        ));
  }
}

class OnBoardingPage extends StatelessWidget {
  const OnBoardingPage(
      {super.key,
      required this.image,
      required this.title,
      required this.subTitle});

  final String image, title, subTitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Column(
        children: [
          Image(
              width: THelperFunctions.screenWidth() * 0.8,
              height: THelperFunctions.screenHeight() * 0.3,
              image: AssetImage(image)),
          Text(
            title,
            style:TAppTheme.textThemeTitle,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: TSizes.spaceBtwItems),
          Text(
            subTitle,
            style: TAppTheme.textThemeSubTitleDark,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

 
}

class OnBoardingDotNavigation extends StatelessWidget {
  const OnBoardingDotNavigation({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = OnBoardingController.instance;
    //final dark = THelperFunctions.isDarkMode(context);
    return Positioned(
        bottom:  (THelperFunctions.screenHeight() * 0.15),
        left: THelperFunctions.screenWidth() * 0.10,
        child: SmoothPageIndicator(
            controller: controller.pageController,
            onDotClicked: controller.dotNavigationClick,
            count: 3,
            effect: const ExpandingDotsEffect(
                activeDotColor: Color.fromRGBO(65, 87, 255, 1), dotHeight: 6)));
  }
}

class OnBoardingNextButton extends StatelessWidget {
  const OnBoardingNextButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    //final dark = THelperFunctions.isDarkMode(context);
    return Positioned(
        right: THelperFunctions.screenWidth() * 0.05,
        bottom: THelperFunctions.screenHeight() * 0.13,
        child: ElevatedButton(
          onPressed: () {
            OnBoardingController.instance.nextPage(); 
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: TColors.primary,

            elevation: 5, // Elevación del botón
            padding: const EdgeInsets.symmetric(
                horizontal: 40, vertical: 18), // Color del texto
          ),
          child: const Text("Siguiente",
                          style: TextStyle(color: TColors.white, fontSize: 14)),
        ));
  }
}

class CircleWidget extends StatelessWidget {
  const CircleWidget(
      {super.key,
      required this.locationCircle,
      required this.widthCircle,
      required this.heightCircle,
      required this.distance1,
      required this.distance2});

  final int locationCircle;
  final double widthCircle, heightCircle, distance1, distance2;

  @override
  Widget build(BuildContext context) {
    if (locationCircle == General.circleTopLeft) {
      return Positioned(
        top: distance1,
        left: distance2,
        child: Container(
          width: widthCircle,
          height: heightCircle,
          decoration: const BoxDecoration(
            color: Color.fromRGBO(65, 87, 255, 1),
            shape: BoxShape.circle,
          ),
        ),
      );
    } else if (locationCircle == General.circleTopRight) {
      return Positioned(
        top: distance1,
        right: distance2,
        child: Container(
          width: widthCircle,
          height: heightCircle,
          decoration: const BoxDecoration(
            color: Color.fromRGBO(65, 87, 255, 1),
            shape: BoxShape.circle,
          ),
        ),
      );
    } else if (locationCircle == General.circleBottomLeft) {
      return Positioned(
        bottom: distance1,
        left: distance2,
        child: Container(
          width: widthCircle,
          height: heightCircle,
          decoration: const BoxDecoration(
            color: Color.fromRGBO(65, 87, 255, 1),
            shape: BoxShape.circle,
          ),
        ),
      );
    } else if (locationCircle == General.circleBottomRight) {
      return Positioned(
        bottom: distance1,
        right: distance2,
        child: Container(
          width: widthCircle,
          height: heightCircle,
          decoration: const BoxDecoration(
            color: Color.fromRGBO(65, 87, 255, 1),
            shape: BoxShape.circle,
          ),
        ),
      );
    }else{
      return Container();
    }

  }
}
