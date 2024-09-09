import 'package:app_health_connect/features/authentication/controllers/plan/plan_controller.dart';
import 'package:app_health_connect/features/authentication/screens/plan/plan_actividad_detalle.dart';
import 'package:app_health_connect/features/authentication/screens/plan/widgets/plan_widgets.dart';
import 'package:app_health_connect/utils/constants/colors.dart';
import 'package:app_health_connect/utils/constants/image_strings.dart';
import 'package:app_health_connect/utils/constants/text_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class PlanDiarioDetalle extends StatelessWidget {
  const PlanDiarioDetalle({super.key});

  @override
  Widget build(BuildContext context) {
    final PlanController controller = Get.put(PlanController());
    final DateTime now = DateTime.now();
    final DateFormat formatoDia = DateFormat('E', 'es');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Volver',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: TColors.primary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(
          top: 32,
          left: 16,
          right: 16,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.only(right: 1),
                      child: const Icon(
                        Icons.receipt_long,
                        color: TColors.primary,
                        size: 60,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Plan Diario',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '${now.day}',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: TColors.primary,
                        ),
                      ),
                      Text(
                        formatoDia.format(now).substring(0, 3),
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20.0),
            Expanded(child: Obx(() {
              if (controller.isLoading.value) {
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: 4, // Número de tarjetas shimmer a mostrar
                  itemBuilder: (_, index) {
                    return const ShimmerPlanCard();
                  },
                );
              } else {
                if (controller.planes.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Image.asset(
                          TImages.noData,
                          width: 300,
                          height: 300,
                        ),
                        const Text('Sin Registros',
                            style: TextStyle(
                                fontSize: 20, 
                                fontStyle: FontStyle.italic))
                      ],
                    ),
                  );
                } else {
                  return ListView.builder(
                    itemCount: controller.planes.length,
                    itemBuilder: (context, index) {
                      final plan = controller.planes[index];
                      return InkWell(
                        onTap: () => showPlanDetailDragDetail(context, plan),
                        child: PlanCard(
                          meta: plan.meta,
                          hora: plan.hora,
                          periodo: plan.periodo,
                          tipoLogro: plan.tipoLogro,
                          iconoPlan: plan.iconoPlan,
                          logroPlan: plan.iconoLogro,
                          estadoPlan: plan.estadoPlan,
                          onToggle: () => controller.togglePlan(index),
                        ),
                      );
                    },
                  );
                }
              }
            })),
          ],
        ),
      ),
    );
  }
}

class PlanCard extends StatelessWidget {
  final String meta;
  final String hora;
  final String periodo;
  final int tipoLogro;
  final IconData iconoPlan;
  final IconData logroPlan;
  final int estadoPlan;
  final Function() onToggle;

  const PlanCard({
    super.key,
    required this.meta,
    required this.hora,
    required this.periodo,
    required this.tipoLogro,
    required this.iconoPlan,
    required this.logroPlan,
    required this.estadoPlan,
    required this.onToggle,
  });

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
        child: Row(
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
            CircleAvatar(
              backgroundColor: estadoPlan == TTexts.estadoCompletado
                  ? TTexts.obtenerColorLogro(tipoLogro)
                  : const Color.fromARGB(71, 158, 158, 158),
              radius: 25,
              child: Icon(logroPlan, color: TColors.white, size: 24),
            ),
            const SizedBox(width: 15),
            InkWell(
              onTap: onToggle,
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  border: Border.all(color: TColors.primary, width: 2),
                  color: estadoPlan == TTexts.estadoCompletado
                      ? TColors.primary
                      : Colors.white,
                ),
                child: estadoPlan == TTexts.estadoCompletado
                    ? const Icon(Icons.check, size: 16, color: Colors.white)
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
