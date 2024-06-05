import 'package:app_health_connect/features/authentication/controllers/welcome/welcome_controller.dart';
import 'package:app_health_connect/utils/constants/sizes.dart';
import 'package:app_health_connect/utils/validators/validation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WorkInfoScreen extends StatelessWidget {
  static const name = 'work-info-screen';
  const WorkInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: _WorkInfoView()
        // bottomNavigationBar: CustomBottomNavigation(),
        );
  }
}

class _WorkInfoView extends StatefulWidget {
  const _WorkInfoView();

  @override
  _WorkInfoState createState() => _WorkInfoState();
}

class _WorkInfoState extends State<_WorkInfoView> {
  final controller = Get.put(WelcomeController());
  @override
  void initState() {
    super.initState();
    // Inicializar el valor seleccionado con el primer ítem de la lista
    controller.selectedDropdownModalidadTrabajoValue = 'Trabajo Remoto';
    controller.selectedDropdownTipHorTrabajoValue = 'hrs/día';
    controller.selectedDropdownTipoContratoValue = 'Tiempo Completo';
    controller.selectedDropdownTurnoTrabajoValue =
        'Horario Diurno(Mañana y Tarde)';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Cuéntame sobre ti',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF4157FF),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: Form(
        key: controller.formWorkInfoKey,
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text(
                  'Ocupación',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: TSizes.spaceBtwInputFields),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.16),
                        offset: const Offset(0, 2),
                        blurRadius: 8,
                      ),
                    ],
                    color: Colors.white,
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  child: TextFormField(
                    controller: controller.ocupacionController,
                    validator: (value) =>
                        TValidator.validateEmptyText('Ocupación', value),
                    decoration: const InputDecoration(
                      hintText: 'Escribe tu ocupación',
                      border: InputBorder.none,
                    ),
                    style: const TextStyle(
                      fontSize: 16,
                      fontFamily: 'Source Sans Pro',
                      color: Colors.black,
                    ),
                    keyboardType: TextInputType.text,
                  ),
                ),
                const SizedBox(height: TSizes.spaceBtwInputFields),
                const Text(
                  'Modalidad de Trabajo',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: TSizes.spaceBtwInputFields),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.16),
                        offset: const Offset(0, 2),
                        blurRadius: 8,
                      ),
                    ],
                    color: Colors.white,
                  ),
                  child: DropdownButtonFormField<String>(
                    value: controller.selectedDropdownModalidadTrabajoValue,
                    validator: (value) =>
                        TValidator.validateEmptyText('Mod. de Trabajo', value),
                    onChanged: (newValue) {
                      setState(() {
                        controller.selectedDropdownModalidadTrabajoValue =
                            newValue!;
                      });
                    },
                    items: controller.itemsModTrabajo.map((String item) {
                      return DropdownMenuItem<String>(
                        value: item,
                        child: Text(item),
                      );
                    }).toList(),
                    style: const TextStyle(
                      fontSize: 16,
                      fontFamily: 'Source Sans Pro',
                      color: Colors.black,
                    ),
                    dropdownColor: Colors.white,
                    decoration: const InputDecoration(
                      border: InputBorder.none, // Eliminar la línea inferior
                    ),
                  ),
                ),
                const SizedBox(height: TSizes.spaceBtwInputFields),
                const Text(
                  'Horas de Trabajo',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: TSizes.spaceBtwInputFields),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.16),
                                  offset: const Offset(0, 2),
                                  blurRadius: 8,
                                ),
                              ],
                              color: Colors.white,
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 6),
                            child: TextFormField(
                              controller: controller.horasTrabajoController,
                              validator: (value) =>
                                  TValidator.validateEmptyText(
                                      'Horas Trabajo', value),
                              decoration: const InputDecoration(
                                hintText: 'Número de horas',
                                border: InputBorder.none,
                              ),
                              keyboardType: TextInputType.number,
                              style: const TextStyle(
                                fontSize: 16,
                                fontFamily: 'Source Sans Pro',
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          //width: double.infinity,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 6),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.16),
                                  offset: const Offset(0, 2),
                                  blurRadius: 8,
                                ),
                              ],
                              color: Colors.white,
                            ),
                            child: DropdownButtonFormField<String>(
                              value:
                                  controller.selectedDropdownTipHorTrabajoValue,
                              validator: (value) =>
                                  TValidator.validateEmptyText(
                                      'Tipo Horas', value),
                              onChanged: (newValue) {
                                setState(() {
                                  controller
                                          .selectedDropdownTipHorTrabajoValue =
                                      newValue!;
                                });
                              },
                              items: controller.itemsHorasTrabajo
                                  .map((String item) {
                                return DropdownMenuItem<String>(
                                  value: item,
                                  child: Text(item),
                                );
                              }).toList(),
                              style: const TextStyle(
                                fontSize: 16,
                                fontFamily: 'Source Sans Pro',
                                color: Colors.black,
                              ),
                              dropdownColor: Colors.white,
                              decoration: const InputDecoration(
                                border: InputBorder
                                    .none, // Eliminar la línea inferior
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: TSizes.spaceBtwInputFields),
                const Text(
                  'Tipo de Contrato',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: TSizes.spaceBtwInputFields),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.16),
                        offset: const Offset(0, 2),
                        blurRadius: 8,
                      ),
                    ],
                    color: Colors.white,
                  ),
                  child: DropdownButtonFormField<String>(
                    value: controller.selectedDropdownTipoContratoValue,
                    validator: (value) =>
                        TValidator.validateEmptyText('Tipo de Contrato', value),
                    onChanged: (newValue) {
                      setState(() {
                        controller.selectedDropdownTipoContratoValue =
                            newValue!;
                      });
                    },
                    items: controller.itemsTipoContrato.map((String item) {
                      return DropdownMenuItem<String>(
                        value: item,
                        child: Text(item),
                      );
                    }).toList(),
                    style: const TextStyle(
                      fontSize: 16,
                      fontFamily: 'Source Sans Pro',
                      color: Colors.black,
                    ),
                    dropdownColor: Colors.white,
                    decoration: const InputDecoration(
                      border: InputBorder.none, // Eliminar la línea inferior
                    ),
                  ),
                ),
                const SizedBox(height: TSizes.spaceBtwInputFields),
                const Text(
                  'Turno de Trabajo',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: TSizes.spaceBtwInputFields),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.16),
                        offset: const Offset(0, 2),
                        blurRadius: 8,
                      ),
                    ],
                    color: Colors.white,
                  ),
                  child: DropdownButtonFormField<String>(
                    value: controller.selectedDropdownTurnoTrabajoValue,
                    validator: (value) =>
                        TValidator.validateEmptyText('Turno Trabajo', value),
                    onChanged: (newValue) {
                      setState(() {
                        controller.selectedDropdownTurnoTrabajoValue =
                            newValue!;
                      });
                    },
                    items: controller.itemsTurnoTrabajo.map((String item) {
                      return DropdownMenuItem<String>(
                        value: item,
                        child: Text(item),
                      );
                    }).toList(),
                    style: const TextStyle(
                      fontSize: 16,
                      fontFamily: 'Source Sans Pro',
                      color: Colors.black,
                    ),
                    decoration: const InputDecoration(
                      border: InputBorder.none, // Eliminar la línea inferior
                    ),
                  ),
                ),
                const SizedBox(height: 50),
                Center(
                  child: ElevatedButton(
                    onPressed: () => controller.validarWorkInfo(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4157FF),
                      minimumSize: const Size(104, 48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      elevation: 8,
                      padding: EdgeInsets.zero,
                    ),
                    child: Container(
                      width: 104,
                      height: 48,
                      decoration: BoxDecoration(
                        color: const Color(0xFF4157FF),
                        borderRadius: BorderRadius.circular(6),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.12),
                            offset: const Offset(0, 2),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(2),
                      child: const Icon(
                        Icons.arrow_forward,
                        color: Colors.white,
                        size: 22,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: TSizes.spaceBtwAditional),
                /*
                Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 0, bottom: 0),
                    child: Image.asset('assets/images/logo.png'),
                  ),
                )
                */
              ],
            ),
          ),
        ),
      ),
    );
  }
}
