import 'package:app_health_connect/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class TFullScreenLoader {
  static void openLoadingDialog2(String text, String animation) {
    showDialog(
        context: Get.overlayContext!,
        barrierDismissible: false,
        builder: (_) => PopScope(
            canPop: false,
            child: Container(
              color: TColors.primary,
              width: double.infinity,
              height: double.infinity,
              child: const Column(
                children: [SizedBox(height: 250), CircularProgressIndicator()],
              ),
            )));
  }

  static void openLoadingDialog(String text, String imagePath) {
    showDialog(
        context: Get.overlayContext!,
        barrierDismissible: false,
        builder: (_) => PopScope(
            canPop: false,
            child: Container(
              color: TColors.primary,
              width: double.infinity,
              height: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //Lottie.asset(imagePath,width:150,height: 150),
                   Image.asset(
                    imagePath,
                    width: 60,
                    height: 60,
                  ), 
                  const SizedBox(height: 10),
                  Text(
                    text,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      decoration: TextDecoration.none
                      
                    ),
                  ),
                ],
              ),
            )
          )
    );
  }

   static void openLoadingDialogContext(BuildContext context, text, String imagePath) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => PopScope(
            canPop: false,
            child: Container(
              color: TColors.primary,
              width: double.infinity,
              height: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //Lottie.asset(imagePath,width:150,height: 150),
                   Image.asset(
                    imagePath,
                    width: 60,
                    height: 60,
                  ), 
                  const SizedBox(height: 10),
                  Text(
                    text,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      decoration: TextDecoration.none
                      
                    ),
                  ),
                ],
              ),
            )
          )
    );
  }

  static stopLoading() {
    Navigator.of(Get.overlayContext!).pop();
  }

  static stopLoadingContext(BuildContext context) {
    Navigator.of(context).pop();
  }
}
