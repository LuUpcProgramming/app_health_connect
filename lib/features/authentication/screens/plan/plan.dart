import 'package:app_health_connect/features/authentication/controllers/plan/plan_register_controller.dart';
import 'package:app_health_connect/utils/constants/colors.dart';
import 'package:app_health_connect/utils/constants/image_strings.dart';
import 'package:app_health_connect/utils/validators/validation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DailyPlanScreen extends StatelessWidget {
  const DailyPlanScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PlanRegisterController());
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF4157FF),
       /*  leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Get.to(()=> const NavigationMenu());
          },
        ), */
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(
            top: 32,
            left: 16,
            right: 16,
          ),
          child: Form(
            key: controller.planDiarioFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.event, color: TColors.primary, size: 60),
                    SizedBox(width: 8.0),
                    Expanded(
                      child: Text(
                        'Registro de Plan Diario',
                        softWrap: true,
                        style: TextStyle(
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Descripción de meta/objetivo',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      TextFormField(
                        controller: controller.metaController,
                        validator: (value) =>
                            TValidator.validateEmptyText('Meta', value),
                        decoration: const InputDecoration(
                          hintText: 'Escriba su Meta',
                          hintStyle: TextStyle(
                            fontSize: 18,
                          ),
                          border: UnderlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 30),
                      const Text(
                        'Tipo de actividad',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12.0),
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
                                  value: controller.selectedActividad.value,
                                  isExpanded: true,
                                  underline: const SizedBox(),
                                  onChanged: (newvalue) {
                                    controller.selectedActividad.value =
                                        newvalue!;
                                  },
                                  items: controller.tipoActividad
                                      .map<DropdownMenuItem<String>>(
                                          (String value) {
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
                      const SizedBox(height: 30),
                      const Text(
                        'Período',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            height: 60,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: controller.days.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 6.0),
                                  child: Obx(() => GestureDetector(
                                        onTap: () => controller.enabledDays[index] ? controller.toggleDay(index) : null,
                                        child: CircleAvatar(
                                          radius: 25,
                                          backgroundColor:
                                              controller.isDaySelected(index)
                                                  ? TColors.primary
                                                  : Colors.transparent,
                                          child: Text(
                                            controller.days[index],
                                            style: TextStyle(
                                              color: controller.enabledDays[index] ?  (controller.isDaySelected(index)
                                                  ? Colors.white
                                                  : TColors.primary) : Colors.grey,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      )),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      const Text(
                        'Hora',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Expanded(
                            flex: 2,
                            child: TextFormField(
                              readOnly: true,
                              validator: (value) =>
                                  TValidator.validateEmptyText('Hora', value),
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 18),
                              controller: controller.horaController,
                              decoration: const InputDecoration(
                                hintText: '00:00',
                                hintStyle: TextStyle(
                                  fontSize: 16,
                                ),
                                border: UnderlineInputBorder(),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8.0),
                          Expanded(
                            flex: 2,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: TColors.primary,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10.0, horizontal: 25.0),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25.0),
                                  ),
                                ),
                                child: const Text(
                                  'Hora',
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.white),
                                ),
                                onPressed: () async {
                                  final TimeOfDay? picked =
                                      await showTimePicker(
                                    context: context,
                                    initialTime: controller.selectedTime,
                                    initialEntryMode:
                                        TimePickerEntryMode.inputOnly,
                                  );

                                  if (picked != null) {
                                    controller.selectedPeriodo =
                                        picked.period == DayPeriod.am
                                            ? 'AM'
                                            : 'PM';
                                    controller.selectedTime = picked;
                                    controller.horaController.text =
                                        '${picked.hour}:${controller.addLeadingZero(picked.minute)} ${controller.selectedPeriodo}';
                                    controller.selectedHora =
                                        '${picked.hour}:${controller.addLeadingZero(picked.minute)}';
                                  }
                                }),
                          ),
                        ],
                      ),
                      const SizedBox(height: 50),
                      Center(
                        child: ElevatedButton(
                          onPressed: ()=>{controller.grabarPlanDiario()},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: TColors.primary,
                            padding: const EdgeInsets.symmetric(
                                vertical: 12.0, horizontal: 70.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                          ),
                          child: const Text(
                            'Registrar Plan',
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(height: 50),
                      const Center(
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Cumple tus objetivos con compromiso y convicción, porque cada logro es un paso hacia una mente más sana y feliz. ¡Sigue adelante con valentía y constancia, el cambio está en tus manos!',
                                textAlign: TextAlign.justify,
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                    fontStyle: FontStyle.italic),
                              ),
                            ),
                            SizedBox(width: 16),
                            Image(
                              image: AssetImage(TImages.robotLogo),
                              width: 100.0,
                              height: 100.0,
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
