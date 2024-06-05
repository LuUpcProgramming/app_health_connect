import 'package:app_health_connect/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Loaders {
  static successSnackBar({required title, message = ''}) {
    Get.snackbar(
      title, 
      message,
      isDismissible: true,
      shouldIconPulse: true,
      colorText: TColors.white,
      backgroundColor: Colors.green.shade300,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration (seconds: 3),
      margin: const EdgeInsets.all(20),
      icon: const Icon(Icons.read_more,color: TColors.white)
    );
  }
  static warningSnackBar({required title, message = ''}) {
    Get.snackbar(
      title, 
      message,
      isDismissible: true,
      shouldIconPulse: true,
      colorText: TColors.white,
      backgroundColor: Colors.orange,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration (seconds: 4),
      margin: const EdgeInsets.all(20),
      icon: const Icon(Icons.warning,color: TColors.white)
    );
  }
  static errorSnackBar({required title, message = ''}) {
    Get.snackbar(
      title, 
      message,
      isDismissible: true,
      shouldIconPulse: true,
      colorText: TColors.white,
      backgroundColor: Colors.red.shade600,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration (seconds: 3),
      margin: const EdgeInsets.all(20),
      icon: const Icon(Icons.error,color: TColors.white)
    );
  }
}
