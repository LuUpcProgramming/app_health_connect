import 'package:app_health_connect/features/authentication/controllers/advice/advice_controller.dart';
import 'package:app_health_connect/features/authentication/models/history_advice.dart';
import 'package:app_health_connect/features/authentication/screens/advice/historial_advice_dt.dart';
import 'package:app_health_connect/utils/constants/colors.dart';
import 'package:app_health_connect/utils/constants/image_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

class HistorialAdviceScreen extends StatelessWidget {
  const HistorialAdviceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AdviceController());
    return Scaffold(
      /* appBar: AppBar(
        title: const Text('Historial',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
        backgroundColor: TColors.primary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Get.back();
          },
        ),
      ), */
      body: Padding(
          padding: const EdgeInsets.only(
            top: 32,
            left: 16,
            right: 16,
          ),
          child: Column(
            children: [
              const Row(
                children: [
                  Icon(Icons.manage_search, color: TColors.primary, size: 80),
                  SizedBox(width: 8.0),
                  Expanded(
                    child: Text(
                      'Historial de Recomendaciones',
                      softWrap: true,
                      style: TextStyle(
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8.0),
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
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
                          value: controller.selectedYear.value,
                          isExpanded: true,
                          underline: const SizedBox(),
                          onChanged: (newvalue) {
                             controller.selectedYear.value = newvalue!;
                             controller.cargaHistorialRecomendaciones();
                          },  
                          items: controller.years
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
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8.0),
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
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
                          value: controller.selectedMonth.value,
                          isExpanded: true,
                          underline: const SizedBox(),
                          onChanged: (newvalue) {
                             controller.selectedMonth.value = newvalue!;
                          controller.cargaHistorialRecomendaciones();
                          },
                          items: controller.months
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
              const SizedBox(height: 10),
              const Divider(
                  color: Colors.grey, thickness: 0.3, indent: 1, endIndent: 1),
              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: 4, // Número de tarjetas shimmer a mostrar
                      itemBuilder: (_, index) {
                        return const ShimmerRecomendacionCard();
                      },
                    );
                  } else {
                     var filteredList = controller.filteredHistorial;
                  //  if (controller.listaHistorial.isEmpty) {
                    if (filteredList.isEmpty) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Image.asset(TImages.noData,width: 350, height: 350,),
                          const Text('Sin Registros',
                          style: TextStyle(fontSize: 20,fontStyle: FontStyle.italic))
                        ],
                      );
                    } else {
                      return ListView.builder(
                          shrinkWrap: true,
                          itemCount: filteredList.length,
                          itemBuilder: (_, index) {
                            final advice = controller.listaHistorial[index];
                            return RecomendacionCard(advice: advice);
                          });
                    }
                  }
                }),
              ),
            ],
          )),
      //bottomNavigationBar: const NavigationMenu(),
    );
  }
}

class RecomendacionCard extends StatelessWidget {
  final HistoryAdviceDetail advice;

  const RecomendacionCard({super.key, required this.advice});

  @override
  Widget build(BuildContext context) {
    return Card(
      surfaceTintColor: const Color.fromARGB(255, 230, 229, 229),
      elevation: 10,
      borderOnForeground: false,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: InkWell(
        onTap: () => showRecommendationDragDetail(context, advice),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                advice.title,
                softWrap: true,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                advice.description,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                softWrap: true,
              ),
              const SizedBox(height: 8.0),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  advice.date,
                  style: const TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ShimmerRecomendacionCard extends StatelessWidget {
  const ShimmerRecomendacionCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      surfaceTintColor: const Color.fromARGB(255, 230, 229, 229),
      elevation: 10,
      borderOnForeground: false,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                height: 50.0,
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
          ],
        ),
      ),
    );
  }
}
