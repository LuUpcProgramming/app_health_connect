
import 'package:app_health_connect/features/authentication/controllers/dashboard/dashboard_controller.dart';
import 'package:app_health_connect/features/authentication/screens/dashboard/widgets/dashboard_widgets.dart';
import 'package:app_health_connect/utils/constants/image_strings.dart';
import 'package:app_health_connect/utils/constants/sizes.dart';
import 'package:app_health_connect/utils/constants/text_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class DashboardScreen extends StatelessWidget {
  DashboardScreen({super.key});
  final controller = Get.put(DashboardController());

  @override
  Widget build(BuildContext context) {
    // _showDialog(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          // padding: const EdgeInsets.all(32.0),
          padding: const EdgeInsets.only(top: 40, left: 16, right: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Top section with image and greeting
              Row(
                children: [
                  const CircleAvatar(
                    backgroundImage: AssetImage(TImages
                        .avatarLogo), // Usamos AssetImage para la imagen local
                    radius: 30,
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /* Para Pruebas 
                    const Text(
                      '${TTexts.avatarTitle} $userName',
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w500),
                    ), */
                      Obx(() {
                        if (controller.profileLoading.value) {
                          return const CircularProgressIndicator();
                        } else {
                          final nombreUsuario = controller.usuario.value?.firstName ?? "";
                          return Text(
                            '${TTexts.avatarTitle} $nombreUsuario',
                            style: const TextStyle(fontSize: 16),
                          );
                        }
                      }),
                      const Text(
                        '¿Cómo te sientes?',
                        style: TextStyle(fontSize: 16),
                      )
                    ],
                  ),
                ],
              ),
              const SizedBox(height: TSizes.spaceBtwItems),

              // Weekly calendar
              WeeklyCalendar(),
              const SizedBox(height: TSizes.spaceBtwItems),

              // Trabajo and Estado de Ánimo boxes
              Row(
                children: [
                  Obx(() {
                    if (controller.detailuser == null) {
                      return const StatusBox(
                        title: 'Trabajo',
                        content: 'Estresado',
                        subContent: '',
                      );
                    } else {
                      List<String> lista =
                          controller.detailuser!.analisisIA.split('|');
                      if(lista.length==3){
                        return StatusBox(
                          title: 'Trabajo',
                          content: '👨‍💼',
                          subContent: lista[1].trim(),
                        );
                      }else{
                        return const StatusBox(
                          title: 'Trabajo',
                          content: '👨‍💼',
                          subContent: 'Intensivo',
                        );
                      }
                      
                    }
                  }),
                  const SizedBox(width: 16),
                  Obx(() {
                    if (controller.detailuser == null) {
                      return const StatusBox(
                        title: 'Estado de ánimo',
                        content: '😩',
                        subContent: 'Estresado',
                      );
                    } else {
                      List<String> lista = controller.detailuser!.analisisIA.split('|');
                      if(lista.length==3){
                        return StatusBox(
                          title: 'Estado de ánimo',
                          content: '😩',
                          subContent: lista[2].trim()
                        );
                      }else{
                        return const StatusBox(
                          title: 'Estado de ánimo',
                          content: '😩',
                          subContent: 'Estresado',
                        );
                      }                   
                    }
                  }),
                ],
              ),
              const SizedBox(height: TSizes.spaceBtwItems),

              // Asistente Virtual section
              const Text(
                'Asistente Virtual',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              assistantBox(controller),
              const SizedBox(height: TSizes.spaceBtwItems),

              // Tu Plan del Día section
              const Text(
                'Tu Plan del Día',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              const PlanBox(),
              const SizedBox(height: 16),

              // Recomendado para ti section
              const Text(
                'Recomendado para ti',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              const Row(
                children: [
                  RecommendationBox(
                    icon: Icons.local_florist,
                    text: 'Tips para aliviar estrés en el trabajo remoto',
                  ),
                  SizedBox(width: 16),
                  RecommendationBox(
                    icon: Icons.restaurant,
                    text: 'Tips para mejorar la alimentación',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );

    //const String userName = "Juan";
  }

 
}
