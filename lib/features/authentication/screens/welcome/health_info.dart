import 'package:app_health_connect/features/authentication/controllers/welcome/welcome_controller.dart';
import 'package:app_health_connect/features/authentication/models/user_detail.dart';
import 'package:app_health_connect/features/authentication/screens/dashboard/dashboard_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class HealthInfoScreen extends StatelessWidget {
  static const name = 'health-info-screen';
  const HealthInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: __HealthInfoView()
        // bottomNavigationBar: CustomBottomNavigation(),
        );
  }
}

class __HealthInfoView extends StatefulWidget {
  const __HealthInfoView();

  @override
  __HealthInfoState createState() => __HealthInfoState();
}

class __HealthInfoState extends State<__HealthInfoView> {

  final controller = Get.put(WelcomeController());
  
  void toggleOption(String option) {
    setState(() {
      if (controller.selectedOptions.contains(option)) {
        controller.selectedOptions.remove(option);
      } else {
        controller.selectedOptions.add(option);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Cuéntame sobre tu salud',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF4157FF),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Elige las opciones que sientes que están afectando tu salud provocado por tu trabajo',
              style: TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontFamily: 'Open Sans',
                fontStyle: FontStyle.italic,
                height: 1.3, // lineHeight adjusted for Flutter
              ),
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 15,
              runSpacing: 20,
              children: [
                HealthButton(
                  label: 'Ansiedad',
                  isSelected: controller.selectedOptions.contains('Ansiedad'),
                  onTap: () => toggleOption('Ansiedad'),
                  width: 150,
                  height: 50,
                  fontSize: 18,
                ),
                HealthButton(
                  label: 'Estrés',
                  isSelected: controller.selectedOptions.contains('Estrés'),
                  onTap: () => toggleOption('Estrés'),
                  width: 100,
                  height: 50,
                  fontSize: 20,
                ),
                HealthButton(
                  label: 'Cansancio',
                  isSelected: controller.selectedOptions.contains('Cansancio'),
                  onTap: () => toggleOption('Cansancio'),
                  width: 140,
                  height: 50,
                  fontSize: 18,
                ),
                HealthButton(
                  label: 'TDAH',
                  isSelected: controller.selectedOptions.contains('TDAH'),
                  onTap: () => toggleOption('TDAH'),
                  width: 100,
                  height: 50,
                  fontSize: 16,
                ),
                HealthButton(
                  label: 'Depresión',
                  isSelected: controller.selectedOptions.contains('Depresión'),
                  onTap: () => toggleOption('Depresión'),
                  width: 160,
                  height: 50,
                  fontSize: 18,
                ),
                HealthButton(
                  label: 'Insomnio',
                  isSelected: controller.selectedOptions.contains('Insomnio'),
                  onTap: () => toggleOption('Insomnio'),
                  width: 130,
                  height: 50,
                  fontSize: 18,
                ),
                HealthButton(
                  label: 'Dolores de cabeza',
                  isSelected: controller.selectedOptions.contains('Dolores de cabeza'),
                  onTap: () => toggleOption('Dolores de cabeza'),
                  width: 240,
                  height: 60,
                  fontSize: 20,
                ),
                HealthButton(
                  label: 'Mala Postura',
                  isSelected: controller.selectedOptions.contains('Mala Postura'),
                  onTap: () => toggleOption('Mala Postura'),
                  width: 165,
                  height: 60,
                  fontSize: 18,
                ),
                HealthButton(
                  label: 'Mala Alimentación',
                  isSelected: controller.selectedOptions.contains('Mala Alimentación'),
                  onTap: () => toggleOption('Mala Alimentación'),
                  width: 420,
                  height: 60,
                  fontSize: 20,
                ),
                HealthButton(
                  label: 'Sedentarismo',
                  isSelected: controller.selectedOptions.contains('Sedentarismo'),
                  onTap: () => toggleOption('Sedentarismo'),
                  width: 170,
                  height: 50,
                  fontSize: 18,
                ),
                HealthButton(
                  label: 'Falta de Ejercicio',
                  isSelected: controller.selectedOptions.contains('Falta de Ejercicio'),
                  onTap: () => toggleOption('Falta de Ejercicio'),
                  width: 230,
                  height: 50,
                  fontSize: 20,
                ),
              ],
            ),
            const SizedBox(height: 50),
            Center(
              child: ElevatedButton(
                onPressed: () => controller.validarHealthInfo(),
                style: ButtonStyle(
                  // ignore: deprecated_member_use
                  backgroundColor:
                      MaterialStateProperty.all<Color>(const Color(0xFF4157FF)),
                  // ignore: deprecated_member_use
                  padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                    const EdgeInsets.symmetric(horizontal: 8),
                  ),
                  // ignore: deprecated_member_use
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  // ignore: deprecated_member_use
                  minimumSize: MaterialStateProperty.all<Size>(
                    const Size(239, 56),
                  ),
                ),
                child: const Text(
                  'Continuar',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontFamily: 'Source Sans Pro',
                    fontWeight: FontWeight.w700,
                    height: 1.3, // height adjusted for 20px font size
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HealthButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final double width;
  final double height;
  final double fontSize;

  const HealthButton({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.width = 150,
    this.height = 50,
    this.fontSize = 18,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF4157FF) : Colors.white,
          borderRadius: BorderRadius.circular(6),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.16),
              offset: const Offset(0, 2),
              blurRadius: 8,
            ),
          ],
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black,
              fontSize: fontSize,
              fontFamily: 'Source Sans Pro',
              fontWeight: FontWeight.w400,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ),
    );
  }
}
