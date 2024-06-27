import 'package:app_health_connect/features/authentication/controllers/statistics/statistics_controller.dart';
import 'package:app_health_connect/features/authentication/screens/statistics/widgets/default_widgets.dart';
import 'package:app_health_connect/features/authentication/screens/statistics/widgets/statistics_widgets.dart';
import 'package:app_health_connect/utils/constants/colors.dart';
import 'package:app_health_connect/utils/constants/text_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EstadisticasScreen extends StatelessWidget {
  const EstadisticasScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(EstadisticaController());
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(
            top: 32,
            left: 16,
            right: 16,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.trending_up, color: TColors.primary, size: 80),
                  SizedBox(width: 8.0),
                  Expanded(
                    child: Text(
                      'Estadísticas',
                      softWrap: true,
                      style: TextStyle(
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.only(left: 15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.16),
                            offset: const Offset(0, 2),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: Obx(
                        () => DropdownButton<String>(
                          value: controller.selectedDate.value,
                          isExpanded: true,
                          underline: const SizedBox(),
                          onChanged: (newvalue) {
                            controller.selectedDate.value = newvalue!;
                            //controller.cargaEstadisticas();
                            controller.cargaDataEstadisticas();
                          },
                          items: controller.listaTipoFecha
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Obx(() {
                if(controller.isLoading.value){
                  return const Center(child: CircularProgressIndicator());
                }else{
                 /*  var estadoAnimo =
                      controller.estadisticas.value.estadoAnimoPromedio;
                  var estadoMensaje =
                      controller.estadisticas.value.mensajeEstadoAnimo; */
                  var estadoAnimo =controller.estadisticasSemanal.value.estadoAnimoPromedio;
                  var estadoMensaje =controller.estadisticasSemanal.value.mensajeEstadoAnimo;

                  if (estadoAnimo.trim().isEmpty && estadoMensaje.trim().isEmpty) {
                    return buildDefaultMoodCard();
                  } else {
                    return buildMoodCard(estadoAnimo, estadoMensaje);
                  }
                }
               
              }),
              const SizedBox(height: 20),
              Obx(() {
                if(controller.isLoading.value){
                  return const Center(child: CircularProgressIndicator());
                }else{
                  if (controller.selectedDate.value == TTexts.semanal) {
                    return buildWeeklyProgressChart(controller);
                  } else if (controller.selectedDate.value == TTexts.mensual) {
                    return buildMonthlyProgressChart(controller);
                  } else {
                    return buildWeeklyProgressChart(controller);
                  }
                } 
               
              }),
              const SizedBox(height: 20),
              Obx(() {
                if(controller.isLoading.value){
                  return const Center(child: CircularProgressIndicator());
                }else{
                  var logros = controller.estadisticasSemanal.value.logros;
                  if (logros.isEmpty) {
                    return buildDefaultTopAchievements();
                  } else {
                    return buildTopAchievements(controller.logroConIcono);
                  }
                }
                
              }),
            ],
          ),
        ),
      ),
    );
  }
}
