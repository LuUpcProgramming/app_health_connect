import 'package:app_health_connect/features/authentication/controllers/dashboard/dashboard_controller.dart';
import 'package:app_health_connect/features/authentication/screens/chat/chat_screen.dart';
import 'package:app_health_connect/features/authentication/screens/dashboard/widgets/detalle_recomendacion.dart';
import 'package:app_health_connect/features/authentication/screens/plan/widgets/plan_widgets.dart';
import 'package:app_health_connect/utils/constants/colors.dart';
import 'package:app_health_connect/utils/constants/image_strings.dart';
import 'package:app_health_connect/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class WeeklyCalendar extends StatelessWidget {
  final List<String> days = ["Lun", "Mar", "Mié", "Jue", "Vie", "Sáb", "Dom"];
  final DateTime now = DateTime.now();

  WeeklyCalendar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: List.generate(7, (index) {
        DateTime day = now.add(Duration(days: index - now.weekday + 1));
        bool isToday = now.day == day.day;
        return Column(
          children: [
            Text(
              '${day.day}',
              style: TextStyle(
                color: isToday ? TColors.primary : Colors.black,
                fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            Text(
              days[day.weekday - 1],
              style: TextStyle(
                color: isToday ? TColors.primary : Colors.black,
                fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        );
      }),
    );
  }
}

class StatusBox extends StatelessWidget {
  final String title;
  final String content;
  final String subContent;

  const StatusBox(
      {super.key,
      required this.title,
      required this.content,
      required this.subContent});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFefeffe)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.4), // Color de la sombra
                spreadRadius: 2, // Cuanto se extiende la sombra
                blurRadius: 5, // Cuanto se difumina la sombra
                offset: const Offset(
                    0, 2.5), // Posición de la sombra (horizontal, vertical)
              ),
            ]),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
            const SizedBox(
              height: 8,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  content,
                  style: const TextStyle(
                      fontSize: 40, fontWeight: FontWeight.w800),
                ),
                Text(
                  subContent,
                  style: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                      fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

Widget assistantBox(DashboardController controller) {
  return GestureDetector(
      onTap: () {
        Get.offAll(
          () => const ChatScreen(),
          transition: Transition.rightToLeft, // Transición de deslizar
          duration:
              const Duration(milliseconds: 600), // Duración de la transición
        );
      },
      child: Container(
          //padding: const EdgeInsets.all(16),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFefeffe)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.4), // Color de la sombra
                  spreadRadius: 2, // Cuanto se extiende la sombra
                  blurRadius: 5, // Cuanto se difumina la sombra
                  offset: const Offset(
                      0, 2.5), // Posición de la sombra (horizontal, vertical)
                ),
              ]),
          child: const Row(children: [
            CircleAvatar(
              backgroundImage: AssetImage(TImages.robotLogo),
              backgroundColor:
                  TColors.accent, // Usamos AssetImage para la imagen local
              radius: 30,
            ),
            SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Conversemos!',
                  style: TextStyle(fontSize: 18),
                ),
                Text(
                  'Coni quiere saber como te sientes!',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
            Spacer(),
            Icon(Icons.arrow_forward, size: 32),
          ])));
}

class RecommendationBox extends StatelessWidget {
  final IconData icon;
  final String text;

  const RecommendationBox({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: THelperFunctions.screenWidth() / 2.4,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFefeffe)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.4), // Color de la sombra
            spreadRadius: 2, // Cuanto se extiende la sombra
            blurRadius: 5, // Cuanto se difumina la sombra
            offset: const Offset(0, 2.5), // Posición de la sombra
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Sección superior del 20% con el ícono centrado
          Container(
            height: 50, // 20% del alto
            decoration: const BoxDecoration(
              color: TColors.primary, // Fondo azul
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Center(
              child: Icon(
                icon,
                size: 40,
                color: Colors.white, // Ícono blanco
              ),
            ),
          ),
          // Sección inferior del 80% con la descripción
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  text,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PlanBox extends StatelessWidget {
  final DashboardController controller;
  const PlanBox({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(right: 16,left: 16, top: 0, bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(0),
        border: Border.all(color: const Color(0xFFefeffe)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.4), // Color de la sombra
            spreadRadius: 2, // Cuanto se extiende la sombra
            blurRadius: 5, // Cuanto se difumina la sombra
            offset: const Offset(
                0, 2.5), // Posición de la sombra (horizontal, vertical)
          ),
        ]
      ),
      child: Obx(() {
        if (controller.isLoading.value) {
          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(), 
            itemCount: 2, 
            itemBuilder: (_, index) {
              return const ShimmerPlanDashboard();
            },
          );
        } else {
          if (controller.planes.isEmpty) {
            return Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Image.asset(
                    TImages.noData,
                    width: 150,
                    height: 150,
                  ),
                  Text('Estás al día con tus planes diarios',
                      style: TextStyle(
                          fontSize: 16, fontStyle: FontStyle.italic,color: Colors.grey[600]))
                ],
              ),
            );
          } else {
            return SizedBox(
              height: 200,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: controller.planes.length,
                itemBuilder: (context, index) {
                  final plan = controller.planes[index];
                  return InkWell(
                    onTap: () => controller.showPlanDetalle(plan),
                    child: PlanItem(
                      meta: plan.meta,
                      hora: plan.hora,
                      periodo: plan.periodo,
                      tipoLogro: plan.tipoLogro,
                      iconoPlan: plan.iconoPlan,
                    ),
                  );
                },
              ),
            );
          }
        }
      }),
    );
  }
}

class PlanItem extends StatelessWidget {
  final String meta;
  final String hora;
  final String periodo;
  final int tipoLogro;
  final IconData iconoPlan;
  // final IconData logroPlan;
  // final int completada;
  // final Function() onToggle;

  const PlanItem(
      {super.key,
      required this.meta,
      required this.hora,
      required this.periodo,
      required this.tipoLogro,
      required this.iconoPlan});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(iconoPlan, color: TColors.primary, size: 30),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    meta,
                    softWrap: true,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Hora: $hora ${periodo.toLowerCase()}',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            const Icon(Icons.arrow_forward, size: 25, color: Colors.black), 
          ],
        ),
         const Divider(color: Colors.grey, thickness: 0.3, indent: 5, endIndent: 0),
      ],
    );
  }
}

class CustomIconButton extends StatelessWidget {
  final IconData icon;
  final void Function()? onPressed;

  const CustomIconButton({super.key, required this.icon, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(100),
        ),
        child: Center(
          child: Icon(
            icon,
            color: Colors.black,
            size: 14,
          ),
        ),
      ),
    );
  }
}

class RecomendacionesList extends StatelessWidget {
  final DashboardController controller;

  const RecomendacionesList({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoadingRecomendaciones.value) {
        return const Center(child: CircularProgressIndicator());
      } else if (controller.tipsRecomendaciones.isEmpty) {
        return const Center(child: Text("No hay recomendaciones disponibles."));
      } else {
        return SizedBox(
          height: 150,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: controller.tipsRecomendaciones.length,
            itemBuilder: (context, index) {
              final recomendacion = controller.tipsRecomendaciones[index];
              return GestureDetector(
                onTap: () => showRecomendacionDetail(context,recomendacion),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 8),
                  child: RecommendationBox(
                    icon: Icons.tips_and_updates,
                    text: recomendacion.titulo,
                  ),
                ),
              );
            },
          ),
        );
      }
    });
  }
}
