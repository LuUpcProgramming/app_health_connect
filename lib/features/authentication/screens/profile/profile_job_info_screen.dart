import 'package:app_health_connect/features/authentication/controllers/profile/profile_job_controller.dart';
import 'package:app_health_connect/features/authentication/screens/login/widgets/custom_scaffold.dart';
import 'package:app_health_connect/utils/constants/colors.dart';
import 'package:app_health_connect/utils/validators/validation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileJobScreen extends StatelessWidget {
  const ProfileJobScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfileJobController());

    return CustomScaffold(
      child: Column(
        children: [
          const Expanded(
            flex: 1,
            child: SizedBox(
              height: 10,
            ),
          ),
          Expanded(
            flex: 15,
            child: Container(
              padding: const EdgeInsets.fromLTRB(25.0, 25.0, 25.0, 20.0),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40.0),
                  topRight: Radius.circular(40.0),
                ),
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 0, left: 16, right: 16, bottom: 16),
                  child: Form(
                    key: controller.profileJobFormKey,
                    child: Column(
                      children: [
                        const Text(
                          "Mis Datos Laborales",
                          maxLines: 2,
                          style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: TColors.primary),
                        ),
                        const SizedBox(height: 32.0),
                        // Nombres
                        TextFormField(
                          controller: controller.ocupacionController,
                          decoration: const InputDecoration(
                            labelText: "Ocupación",
                            prefixIcon:
                                Icon(Icons.person, color: TColors.primary),
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) =>
                              TValidator.validateEmptyText("Ocupación", value),
                        ),
                        const SizedBox(height: 25.0),
                        Obx(
                          () => DropdownButtonFormField<String>(
                            validator: (value) => TValidator.validateEmptyText('Mod. de Trabajo', value),
                            decoration: const InputDecoration(
                              labelText: "Modalidad de Trabajo",
                              prefixIcon:
                                  Icon(Icons.wc, color: TColors.primary),
                              border: OutlineInputBorder(),
                            ),
                            value: controller
                                    .selectedDropdownModalidadTrabajoValue.value.isEmpty
                                ? null
                                : controller.selectedDropdownModalidadTrabajoValue.value,
                            items:
                                controller.itemsModTrabajo.map((String gender) {
                              return DropdownMenuItem<String>(
                                value: gender,
                                child: Text(gender),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              controller.selectedDropdownModalidadTrabajoValue.value =
                                  newValue!;
                            },
                          ),
                        ),
                        const SizedBox(height: 25.0),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: controller.horasTrabajoController,
                                    decoration: const InputDecoration(
                                      labelText:"Horas",
                                      prefixIcon:
                                          Icon(Icons.person, color: TColors.primary),
                                      border: OutlineInputBorder(),
                                    ),
                                    validator: (value) => TValidator.validateEmptyText("Horas Trabajo", value),
                                  ),
                                ),
                                const SizedBox(width: 8), 
                                Expanded(child:  Obx(
                                  () => DropdownButtonFormField<String>(
                                    validator: (value) => TValidator.validateEmptyText('Tipo Horas', value),
                                    decoration: const InputDecoration(
                                      labelText: "Tipo Horas",
                                      prefixIcon:
                                          Icon(Icons.wc, color: TColors.primary),
                                      border: OutlineInputBorder(),
                                    ),
                                    value: controller
                                            .selectedDropdownTipHorTrabajoValue.value.isEmpty
                                        ? null
                                        : controller.selectedDropdownTipHorTrabajoValue.value,
                                    items:
                                        controller.itemsHorasTrabajo.map((String gender) {
                                      return DropdownMenuItem<String>(
                                        value: gender,
                                        child: Text(gender),
                                      );
                                    }).toList(),
                                    onChanged: (String? newValue) {
                                      controller.selectedDropdownTipHorTrabajoValue.value =
                                          newValue!;
                                    },
                                  ),
                                ),),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 25.0),
                        Obx(
                          () => DropdownButtonFormField<String>(
                            validator: (value) => TValidator.validateEmptyText('Tipo de Contrato', value),
                            decoration: const InputDecoration(
                              labelText: "Tipo de Contrato",
                              prefixIcon:
                                  Icon(Icons.wc, color: TColors.primary),
                              border: OutlineInputBorder(),
                            ),
                            value: controller
                                    .selectedDropdownTipoContratoValue.value.isEmpty
                                ? null
                                : controller.selectedDropdownTipoContratoValue.value,
                            items:
                                controller.itemsTipoContrato.map((String gender) {
                              return DropdownMenuItem<String>(
                                value: gender,
                                child: Text(gender),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              controller.selectedDropdownTipoContratoValue.value =
                                  newValue!;
                            },
                          ),
                        ),
                        const SizedBox(height: 25.0),
                        Obx(
                          () => DropdownButtonFormField<String>(
                            validator: (value) => TValidator.validateEmptyText('Turno Trabajo', value),
                            decoration: const InputDecoration(
                              labelText: "Turno de Trabajo",
                              prefixIcon:
                                  Icon(Icons.wc, color: TColors.primary),
                              border: OutlineInputBorder(),
                            ),
                            value: controller
                                    .selectedDropdownTurnoTrabajoValue.value.isEmpty
                                ? null
                                : controller.selectedDropdownTurnoTrabajoValue.value,
                            items:
                                controller.itemsTurnoTrabajo.map((String gender) {
                              return DropdownMenuItem<String>(
                                value: gender,
                                child: Text(gender),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              controller.selectedDropdownTurnoTrabajoValue.value =
                                  newValue!;
                            },
                          ),
                        ),
                        const SizedBox(height: 32.0),
                        // Botón de guardar
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: TColors.primary,
                              elevation: 10, // Elevación del botón
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 18), // Color del texto
                            ),
                            onPressed: () =>
                                controller.guardarCambiosDatosLaborales(),
                            child: const Text("Guardar Cambios",
                                style: TextStyle(
                                    color: TColors.white, fontSize: 16)),
                          ),
                        ),
                      ],
                    ),
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
