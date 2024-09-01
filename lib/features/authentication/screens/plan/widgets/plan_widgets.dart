import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerPlanCard extends StatelessWidget {
  const ShimmerPlanCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      surfaceTintColor: const Color.fromARGB(255, 230, 229, 229),
      elevation: 5,
      borderOnForeground: false,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Container(
                width: double.infinity,
                height: 10.0,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8.0),
            Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Container(
                width: double.infinity,
                height: 20.0,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8.0),
            Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
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
}
