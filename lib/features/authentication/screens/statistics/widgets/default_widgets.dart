
import 'package:app_health_connect/utils/constants/colors.dart';
import 'package:app_health_connect/utils/constants/image_strings.dart';
import 'package:flutter/material.dart';

Widget buildDefaultMoodCard() {
    return Card(
      color: TColors.primary,
      elevation: 15,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Estado de ánimo promedio',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 23,
                  fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(TImages.noData,width: 130, height: 130,),
                const Text('Sin Registros',
                style: TextStyle(fontSize: 25,fontStyle: FontStyle.italic,color: TColors.white)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildDefaultTopAchievements() {
  return Card(
    color: TColors.primary,
    elevation: 15,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15.0),
    ),
    child:  Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Top 3 logros',
            style: TextStyle(
                color: Colors.white,
                fontSize: 23,
                fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
                Image.asset(TImages.noData,width: 130, height: 130,),
              const Text('Sin Logros',
              style: TextStyle(fontSize: 25,fontStyle: FontStyle.italic,color: TColors.white)),
            ],
          ),
        ],
      ),
    ),
  );
}