import 'package:app_health_connect/features/authentication/controllers/plan/plan_controller.dart';
import 'package:app_health_connect/features/authentication/screens/plan/plan_actividad_detalle.dart';
import 'package:app_health_connect/utils/constants/colors.dart';
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
            Expanded(
              child: Obx(() => ListView.builder(
                itemCount: controller.tareas.length,
                itemBuilder: (context, index) {
                  final tarea = controller.tareas[index];
                  return InkWell(
                    onTap: () => showPlanDetailDragDetail(context, tarea),
                    child: TareaCard(
                      titulo: tarea.nombre,
                      hora: tarea.hora,
                      icono: tarea.icono,
                      logro: tarea.logro,
                      completada: tarea.completada,
                      onToggle: () => controller.toggleActividad(index),
                    ),
                  );
                 /*  return ListTile(
                    leading: Icon(tarea.icono, color: Colors.blue),
                    title: Text(tarea.nombre),
                    subtitle: Text(tarea.hora),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.add_circle_outline, color: Colors.blue),
                          onPressed: () {
                            // Implementar lógica para añadir
                          },
                        ),
                        Checkbox(
                          value: tarea.completada,
                          onChanged: (_) => controller.toggleActividad(index),
                          activeColor: Colors.blue,
                        ),
                      ],
                    ), 
                  );*/
                },
              )),
            ),
          ],
        ),
      ),
    );
  }
}

class TareaCard extends StatelessWidget {
  final String titulo;
  final String hora;
  final IconData icono;
  final IconData logro;
  final bool completada;
  final Function() onToggle;

  const TareaCard({
    super.key,
    required this.titulo,
    required this.hora,
    required this.icono,
    required this.logro,
    required this.completada,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      surfaceTintColor: const Color.fromARGB(255, 230, 229, 229),
      elevation: 4,
      borderOnForeground: false,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 25.0),
        child: Row(
          children: [
            Icon(icono, color: TColors.primary, size: 24),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    titulo,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Hora: $hora',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
           
            CircleAvatar(
              backgroundColor: completada ? TColors.primary : const Color.fromARGB(71, 158, 158, 158),  
              radius: 25,
              child: Icon(logro, color: TColors.white, size: 24),
            ),
            const SizedBox(width: 15),
            InkWell(
              onTap: onToggle,
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  border: Border.all(color: Colors.blue, width: 2),
                  color: completada ? Colors.blue : Colors.white,
                ),
                child: completada
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