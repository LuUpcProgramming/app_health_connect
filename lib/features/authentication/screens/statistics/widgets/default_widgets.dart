
import 'package:app_health_connect/utils/constants/colors.dart';
import 'package:app_health_connect/utils/constants/image_strings.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

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

Widget buildShimmerMoodCard() {
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
          /* const Text(
            'Estado de ánimo promedio',
            style: TextStyle(
                color: Colors.white,
                fontSize: 23,
                fontWeight: FontWeight.w800),
          ), */
          Shimmer.fromColors(
           /*  baseColor: Colors.blue[200]!,
            highlightColor: Colors.blue[50]!, */
            baseColor: const Color(0xFF6b88ff), // Tono más claro de azul
            highlightColor: const Color(0xFFa3baff), // Tono aún más claro o blanco azulado
            child: Container(
              width: double.infinity,
              height: 28.0,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          Shimmer.fromColors(
            baseColor: const Color(0xFF6b88ff), // Tono más claro de azul
            highlightColor: const Color(0xFFa3baff), // Tono aún más claro o blanco azulado
            child: Container(
              width: double.infinity,
              height: 40.0,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          Shimmer.fromColors(
            baseColor: const Color(0xFF6b88ff), // Tono más claro de azul
            highlightColor: const Color(0xFFa3baff), // Tono aún más claro o blanco azulado
            child: Container(
              width: double.infinity,
              height: 30.0,
              color: Colors.white,
            ),
          ),
        ],
      ),
    ),
  );
}

Widget buildShimmerProgressChart() {
  return Card(
    color: TColors.primary,
    elevation: 15,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15.0),
    ),
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Shimmer.fromColors(
           /*  baseColor: Colors.blue[200]!,
            highlightColor: Colors.blue[50]!, */
            baseColor: const Color(0xFF6b88ff), // Tono más claro de azul
            highlightColor: const Color(0xFFa3baff), // Tono aún más claro o blanco azulado
            child: Container(
              width: double.infinity,
              height: 28.0,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 15),
          Shimmer.fromColors(
           /*  baseColor: Colors.blue[200]!,
            highlightColor: Colors.blue[50]!, */
            baseColor: const Color(0xFF6b88ff), // Tono más claro de azul
            highlightColor: const Color(0xFFa3baff), // Tono aún más claro o blanco azulado
            child: Container(
              width: double.infinity,
              height: 200.0,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 20),
          Shimmer.fromColors(
           /*  baseColor: Colors.blue[200]!,
            highlightColor: Colors.blue[50]!, */
            baseColor: const Color(0xFF6b88ff), // Tono más claro de azul
            highlightColor: const Color(0xFFa3baff), // Tono aún más claro o blanco azulado
            child: Container(
              width: double.infinity,
              height: 10.0,
              color: Colors.white,
            ),
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

Widget buildShimmerTopAchievements() {
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
          Shimmer.fromColors(
            baseColor: const Color(0xFF6b88ff), // Tono más claro de azul
            highlightColor: const Color(0xFFa3baff), // Tono aún más claro o blanco azulado
            child: Container(
              width: double.infinity,
              height: 28.0,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          Shimmer.fromColors(
            baseColor: const Color(0xFF6b88ff), // Tono más claro de azul
            highlightColor: const Color(0xFFa3baff), // Tono aún más claro o blanco azulado
            child: Container(
              width: double.infinity,
              height: 80.0,
              color: Colors.white,
            ),
          ),

        ],
      ),
    ),
  );
}