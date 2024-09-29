import 'package:app_health_connect/config/helper/logging.dart';
import 'package:app_health_connect/features/authentication/controllers/advice/advice_controller.dart';
import 'package:app_health_connect/features/authentication/controllers/statistics/statistics_controller.dart';
import 'package:app_health_connect/features/authentication/screens/advice/historial_advice.dart';
import 'package:app_health_connect/features/authentication/screens/dashboard/dashboard_screen.dart';
import 'package:app_health_connect/features/authentication/screens/login/login.dart';
import 'package:app_health_connect/features/authentication/screens/plan/plan.dart';
import 'package:app_health_connect/features/authentication/screens/statistics/statistics_screen.dart';
import 'package:app_health_connect/utils/constants/colors.dart';
import 'package:app_health_connect/utils/constants/text_strings.dart';
import 'package:app_health_connect/utils/popups/loaders.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
            const TextStyle(
                color: Colors.white), // Cambia el color del label aquí
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
            destinations: [
              NavigationDestination(
                  icon: Icon(
                    Icons.home,
                    color: controller.selectedIndex.value == 0
                        ? TColors.black
                        : TColors.white,
                  ),
                  label: 'Inicio'),
              NavigationDestination(
                  icon: Icon(
                    Icons.history,
                    color: controller.selectedIndex.value == 1
                        ? TColors.black
                        : TColors.white,
                  ),
                  label: 'Historial'),
              NavigationDestination(
                icon: Icon(
                  Icons.shopping_bag,
                  color: controller.selectedIndex.value == 2
                      ? TColors.black
                      : TColors.white,
                ),
                label: 'Plan Diario',
              ),
              NavigationDestination(
                  icon: Icon(
                    Icons.bar_chart,
                    color: controller.selectedIndex.value == 3
                        ? TColors.black
                        : TColors.white,
                  ),
                  label: 'Métrica'),
              NavigationDestination(
                  icon: Icon(
                    Icons.person,
                    color: controller.selectedIndex.value == 4
                        ? TColors.black
                        : TColors.white,
                  ),
                  label: 'Perfil'),
            ],
          ),
        ),
        body: Obx(() => controller.screens[controller.selectedIndex.value]),
      ),
    );
  }
}

class NavigationController extends GetxController {
  static NavigationController get instance => Get.find();
  final log = logger(NavigationController);
  final Rx<int> selectedIndex = 0.obs;
  final screens = [
    DashboardScreen(),
    const HistorialAdviceScreen(),
    const DailyPlanScreen(),
    const EstadisticasScreen(),
    const Perfil(),
  ];

  @override
  void onInit() {
    super.onInit();
    // Escucha los cambios en selectedIndex
    ever(selectedIndex, handleScreenChange);
  }

  void handleScreenChange(int index) async{
    try {
      if (index == 1) {
        log.i("handleScreenChange: Entro a index 1 Historial Recomendaciones");
        DateTime now = DateTime.now();
        final adviceController = Get.put(AdviceController());
        if (!adviceController.isSubscriptionActive()) {
          adviceController.startListeningAdviceRecommendation(now, now);
        }
      } else if (index == 2) {
        // Navegación directa a la pantalla "Plan Diario"
        log.i("handleScreenChange: Entro a Plan Diario");
/*         Get.off(() => const DailyPlanScreen(),
            transition: Transition.rightToLeft,
            duration:const Duration(milliseconds: 500)
        );  */
      } else if (index == 3) {
        log.i("handleScreenChange: Entro a index 3");
        final estadisticaController = Get.put(EstadisticaController());
        //await estadisticaController.cargaEstadisticas();
        if (estadisticaController.isSubscriptionActive()) {
          estadisticaController.stopListening();
        }
        estadisticaController.selectedDate.value = TTexts.semanal;
        await estadisticaController.startListeningWeeklyStatistics();
      } else if (index == 4) {
        log.i("handleScreenChange: Entro a index 4");
      }
    } catch (e) {
      log.e("Error: ${e.toString()}");
      Loaders.errorSnackBar(
          title: 'Oh, sucedió un error', message: e.toString());
    }
  }
}

class Perfil extends StatelessWidget {
  const Perfil({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
              Get.offAll(() => const LoginScreen());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: TColors.primary,
              elevation: 10, // Elevación del botón
              padding: const EdgeInsets.symmetric(
                  horizontal: 24, vertical: 12), // Color del texto
            ),
            child: const Text("Cerrar Sesión",
                style: TextStyle(color: Colors.white)),
          )
        ],
      ),
    );
  }
}
