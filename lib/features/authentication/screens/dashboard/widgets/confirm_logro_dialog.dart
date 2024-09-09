import 'package:app_health_connect/features/authentication/controllers/dashboard/dashboard_controller.dart';
import 'package:app_health_connect/features/authentication/screens/plan/widgets/plan_widgets.dart';
import 'package:app_health_connect/utils/constants/colors.dart';
import 'package:app_health_connect/utils/constants/image_strings.dart';
import 'package:app_health_connect/utils/constants/text_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ConfirmLogroDialog extends StatelessWidget {
  final VoidCallback? onPressed;
  final DashboardController controller;

  const ConfirmLogroDialog(
      {super.key, this.onPressed, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: Colors.white,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(top: 50.0, bottom: 20.0),
                  decoration: const BoxDecoration(
                    color: TColors.primary,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(25.0),
                    ),
                  ),
                ),
                const Positioned(
                  top: 5,
                  left: 0,
                  right: 0,
                  child: Column(
                    children: [
                      Text(
                        'Logros Pendientes de Confirmar',
                        style: TextStyle(
                          color: TColors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Elige solo las metas que pudiste cumplir',
                        style: TextStyle(
                            color: TColors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            PlanLogros(controller: controller),
            const SizedBox(height: 32),
            Center(
              child: ElevatedButton(
                onPressed: onPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: TColors.primary,
                  padding: const EdgeInsets.symmetric(
                      vertical: 12.0, horizontal: 70.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                ),
                child: Obx(() => controller.isLoadingPlanes.value
                  ? const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    )
                  : const Text(
                      'Actualizar',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class PlanLogros extends StatelessWidget {
  final DashboardController controller;
  const PlanLogros({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(right: 16, left: 16, top: 0, bottom: 8),
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
          if (controller.planesConfirmar.isEmpty) {
            return Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Image.asset(
                    TImages.noData,
                    width: 140,
                    height: 140,
                  ),
                  Text('No tienes Logros Pendientes \n Felicidades!',
                      softWrap: true,
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 16,
                          fontStyle: FontStyle.italic,
                          color: Colors.grey[600]))
                ],
              ),
            );
          } else {
            return SizedBox(
              height: 250,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: controller.planesConfirmar.length,
                itemBuilder: (context, index) {
                  final plan = controller.planesConfirmar[index];
                  return PlanLogrosItem(
                    meta: plan.meta,
                    hora: plan.hora,
                    periodo: plan.periodo,
                    tipoLogro: plan.tipoLogro,
                    fechaPlan: plan.fechaPlan,
                    iconoPlan: TTexts.obtenerIconoPlan(plan.tipoLogro),
                    estadoPlan: plan.estadoPlan,
                    onToggle: () => controller.togglePlanesConfirmar(index),
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

class PlanLogrosItem extends StatelessWidget {
  final String meta;
  final String hora;
  final String periodo;
  final int tipoLogro;
  final String fechaPlan;
  final IconData iconoPlan;
  // final IconData logroPlan;
  final int estadoPlan;
  final Function() onToggle;

  const PlanLogrosItem(
      {super.key,
      required this.meta,
      required this.hora,
      required this.periodo,
      required this.tipoLogro,
      required this.fechaPlan,
      required this.iconoPlan,
      required this.onToggle,
      required this.estadoPlan});

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
                    'Fecha: ${TTexts.convertirFecha(fechaPlan)}\nHora: $hora ${periodo.toLowerCase()}',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            //const Icon(Icons.arrow_forward, size: 25, color: Colors.black),
            InkWell(
                onTap: onToggle,
                child: Container(
                  width: 21,
                  height: 21,
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
        const Divider(
            color: Colors.grey, thickness: 0.3, indent: 5, endIndent: 0),
      ],
    );
  }
}
