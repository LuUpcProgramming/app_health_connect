import 'package:app_health_connect/features/authentication/screens/advice/historial_advice.dart';
import 'package:app_health_connect/features/authentication/screens/dashboard/dashboard_screen.dart';
import 'package:app_health_connect/features/authentication/screens/statistics/statistics.dart';
import 'package:app_health_connect/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NavigationMenu extends StatelessWidget {
  const NavigationMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NavigationController());
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        navigationBarTheme: NavigationBarThemeData(
          labelTextStyle: MaterialStateProperty.all(
            const TextStyle(color: Colors.white), // Cambia el color del label aquí
          ),
        ),
      ),
      home: Scaffold(
        bottomNavigationBar: Obx(
          () => NavigationBar(
            height: 80,
            elevation: 0,
            selectedIndex: controller.selectedIndex.value,
            onDestinationSelected: (index) =>
                controller.selectedIndex.value = index,
            backgroundColor: TColors.primary,
            indicatorColor: TColors.white,
            destinations:  [
              NavigationDestination(
                icon: Icon(
                  Icons.home,color: controller.selectedIndex.value==0?TColors.black:TColors.white,
                ), 
                label: 'Inicio'
              ),
              NavigationDestination(
                icon: Icon(
                  Icons.history,
                    color: controller.selectedIndex.value==1?TColors.black:TColors.white,
                  ),
                label: 'Historial'
              ),
              NavigationDestination(                  
                icon: Icon(
                  Icons.shopping_bag,
                    color: controller.selectedIndex.value==2?TColors.black:TColors.white,
                  ),
                label: 'Plan Diario',
              ),
              NavigationDestination(
                icon: Icon(
                  Icons.bar_chart,
                  color: controller.selectedIndex.value==3?TColors.black:TColors.white,
                ), 
                label: 'Métrica'
              ),
              NavigationDestination(
                
                icon: Icon(
                  Icons.person,
                  color: controller.selectedIndex.value==4?TColors.black:TColors.white,
                ), 
                label: 'Perfil'
              ),
            ],
          ),
        ),
        body: Obx(() => controller.screens[controller.selectedIndex.value]),
      ),
    );
  }
}

class NavigationController extends GetxController {
  final Rx<int> selectedIndex = 0.obs;
  final screens = [
    const DashboardScreen(),
    const HistorialAdviceScreen(),
    Container(color: Colors.blue),
    const EstadisticasScreen(),
     Container(color: Colors.grey)
  ];
}
