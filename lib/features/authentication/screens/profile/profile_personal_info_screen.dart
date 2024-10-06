import 'package:app_health_connect/features/authentication/controllers/profile/profile_personal_info_controller.dart';
import 'package:app_health_connect/features/authentication/screens/login/widgets/custom_scaffold.dart';
import 'package:app_health_connect/utils/constants/colors.dart';
import 'package:app_health_connect/utils/validators/validation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfilePersonalInfoScreen extends StatelessWidget {
  const ProfilePersonalInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfilePersonalInfoController());

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
                    key: controller.profilePersonalFormKey,
                    child: Column(
                      children: [
                        const Text(
                          "Mis Datos Personales",
                          maxLines: 2,
                          style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: TColors.primary),
                        ),
                        const SizedBox(height: 32.0),
                        // Nombres
                        TextFormField(
                          controller: controller.firstName,
                          decoration: const InputDecoration(
                            labelText: "Nombres",
                            prefixIcon:
                                Icon(Icons.person, color: TColors.primary),
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) =>
                              TValidator.validateEmptyText("Nombres", value),
                        ),
                        const SizedBox(height: 16.0),

                        // Apellidos
                        TextFormField(
                          controller: controller.lastName,
                          decoration: const InputDecoration(
                            labelText: "Apellidos",
                            prefixIcon:
                                Icon(Icons.person, color: TColors.primary),
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) =>
                              TValidator.validateEmptyText("Apellidos", value),
                        ),
                        const SizedBox(height: 16.0),
                        Obx(
                          () => DropdownButtonFormField<String>(
                            decoration: const InputDecoration(
                              labelText: "Género",
                              prefixIcon:
                                  Icon(Icons.wc, color: TColors.primary),
                              border: OutlineInputBorder(),
                            ),
                            value: controller
                                    .selectedDropdownGeneroValue.value.isEmpty
                                ? null
                                : controller.selectedDropdownGeneroValue.value,
                            items:
                                ['Masculino', 'Femenino'].map((String gender) {
                              return DropdownMenuItem<String>(
                                value: gender,
                                child: Text(gender),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              controller.selectedDropdownGeneroValue.value =
                                  newValue!;
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Por favor, selecciona tu género.";
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        // Fecha de nacimiento
                        TextFormField(
                          controller: controller.birthDate,
                          validator: (value) {
                            // Validación básica de formato de fecha (dd/MM/yyyy)
                            if (value == null || value.isEmpty) {
                              return 'Ingresa tu fecha de nacimiento';
                            }
                            final regex = RegExp(
                                r"^(0[1-9]|1[0-9]|2[0-9]|3[01])/(0[1-9]|1[0-2])/\d{4}$");
                            if (!regex.hasMatch(value)) {
                              return 'Formato de fecha inválido. Usa DD/MM/YYYY';
                            }
                            return null;
                          },
                          keyboardType: TextInputType
                              .datetime, // Cambia el tipo de teclado
                          decoration: InputDecoration(
                            labelText: 'Fecha de Nacimiento',
                            hintText:
                                'DD/MM/YYYY', // Sugiere el formato esperado
                            prefixIcon: const Icon(Icons.calendar_today,
                                color: TColors.primary),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                color: Colors.black12, // Default border color
                              ),
                            ),
                            enabledBorder: const OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        // Altura
                        TextFormField(
                          controller: controller.height,
                          decoration: const InputDecoration(
                            labelText: "Altura (cm)",
                            prefixIcon:
                                Icon(Icons.height, color: TColors.primary),
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) =>
                              TValidator.validateEmptyText("Altura", value),
                        ),
                        const SizedBox(height: 16.0),

                        // Peso
                        TextFormField(
                          controller: controller.weight,
                          decoration: const InputDecoration(
                            labelText: "Peso (kg)",
                            prefixIcon: Icon(Icons.fitness_center,
                                color: TColors.primary),
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) =>
                              TValidator.validateEmptyText("Peso", value),
                        ),
                        const SizedBox(height: 16.0),
                        // Correo
                        TextFormField(
                          controller: controller.email,
                          readOnly: true,
                          decoration: InputDecoration(
                            labelText: "Correo Electrónico",
                            prefixIcon:
                                const Icon(Icons.email, color: TColors.primary),
                            border: const OutlineInputBorder(),
                            filled: true, // Activa el fondo relleno
                            fillColor: Colors.grey[200], // Color de fondo opaco
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        // Contraseña
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Obx(
                                    () => SizedBox(
                                      height:
                                          60, // Fijar altura del TextFormField
                                      child: TextFormField(
                                        controller: controller.actualPassword,
                                        obscureText:
                                            controller.hidePassword.value,
                                        obscuringCharacter: '*',
                                        enabled: controller.isPasswordEditable
                                            .value, // Campo bloqueado inicialmente
                                        decoration: InputDecoration(
                                          labelText: 'Contraseña Actual',
                                          prefixIcon: const Icon(Icons.lock,
                                              color: TColors.primary),
                                          suffixIcon: IconButton(
                                            icon: Icon(
                                              controller.hidePassword.value
                                                  ? Icons.visibility_off
                                                  : Icons.visibility,
                                              color: TColors.primary,
                                            ),
                                            onPressed: () {
                                              controller.hidePassword.value =
                                                  !controller
                                                      .hidePassword.value;
                                            },
                                          ),
                                          border: const OutlineInputBorder(),
                                          filled: !controller.isPasswordEditable
                                              .value, // Fondo opaco cuando está bloqueado
                                          fillColor: controller
                                                  .isPasswordEditable.value
                                              ? Colors.transparent
                                              : Colors.black12
                                                  .withOpacity(0.05),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                    width:
                                        8), // Espaciado entre el TextFormField y el botón
                                SizedBox(
                                  height:
                                      60, // Fijar la altura del botón igual al TextFormField
                                  child: ElevatedButton(
                                    onPressed: () {
                                      controller.isPasswordEditable.value =
                                          !controller.isPasswordEditable.value;
                                      controller.showNewPasswordFields.value =
                                          !controller.showNewPasswordFields
                                              .value; // Mostrar nuevos campos
                                      controller.actualPassword.clear();
                                      controller.newPassowrd.clear();
                                      controller.confirmPassword.clear();
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: TColors
                                          .primary, // Color de fondo azul
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            2), // Bordes redondeados
                                      ),
                                      padding: EdgeInsets
                                          .zero, // Quitar padding interno
                                    ),
                                    child: const Icon(
                                      Icons.edit, // Icono de edición
                                      color: Colors.white, // Color del icono
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Obx(
                              () => controller.isPasswordEditable.value &&
                                      !controller.isPasswordCorrect
                                          .value // Condición para mostrar el error
                                  ? Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Text(
                                        controller.mensajeError
                                            .value, // Mensaje de error
                                        style: const TextStyle(
                                          color: Colors
                                              .red, // Color del mensaje de error
                                          fontSize: 12,
                                        ),
                                      ),
                                    )
                                  : const SizedBox
                                      .shrink(), // Espacio vacío si no hay error
                            ),
                            const SizedBox(height: 16.0),
                            // Mostrar los campos de Nueva Contraseña y Confirmar Contraseña solo si showNewPasswordFields es true
                            Obx(() => controller.showNewPasswordFields.value
                                ? Column(
                                    children: [
                                      TextFormField(
                                        controller: controller.newPassowrd,
                                        obscureText:
                                            controller.hideNewPassword.value,
                                        obscuringCharacter: '*',
                                        enabled:
                                            controller.isPasswordEditable.value,
                                        validator: (value) {
                                          if (controller
                                              .isPasswordEditable.value) {
                                            return TValidator.validatePassword(
                                                value);
                                          }
                                          return null;
                                        },
                                        decoration: InputDecoration(
                                          labelText: "Nueva Contraseña",
                                          prefixIcon: const Icon(Icons.lock,
                                              color: TColors.primary),
                                          suffixIcon: IconButton(
                                            icon: Icon(
                                              controller.hideNewPassword.value
                                                  ? Icons.visibility_off
                                                  : Icons.visibility,
                                              color: TColors.primary,
                                            ),
                                            onPressed: () {
                                              controller.hideNewPassword.value =
                                                  !controller
                                                      .hideNewPassword.value;
                                            },
                                          ),
                                          border: const OutlineInputBorder(),
                                          filled: !controller.isPasswordEditable
                                              .value, // Fondo opaco cuando está bloqueado
                                          fillColor: controller
                                                  .isPasswordEditable.value
                                              ? Colors.transparent
                                              : Colors.black12
                                                  .withOpacity(0.05),
                                        ),
                                      ),
                                      const SizedBox(height: 16.0),
                                      // Confirmar contraseña
                                      TextFormField(
                                        controller: controller.confirmPassword,
                                        obscureText: controller
                                            .hideConfirmPassword.value,
                                        obscuringCharacter: '*',
                                        enabled:
                                            controller.isPasswordEditable.value,
                                        validator: (value) {
                                          if (controller
                                              .isPasswordEditable.value) {
                                            return TValidator.validatePassword(
                                                value);
                                          }
                                          return null;
                                        },
                                        decoration: InputDecoration(
                                          labelText: "Confirmar Contraseña",
                                          prefixIcon: const Icon(Icons.lock,
                                              color: TColors.primary),
                                          suffixIcon: IconButton(
                                            icon: Icon(
                                              controller
                                                      .hideConfirmPassword.value
                                                  ? Icons.visibility_off
                                                  : Icons.visibility,
                                              color: TColors.primary,
                                            ),
                                            onPressed: () {
                                              controller.hideConfirmPassword
                                                      .value =
                                                  !controller
                                                      .hideConfirmPassword
                                                      .value;
                                            },
                                          ),
                                          border: const OutlineInputBorder(),
                                          filled: !controller.isPasswordEditable
                                              .value, // Fondo opaco cuando está bloqueado
                                          fillColor: controller
                                                  .isPasswordEditable.value
                                              ? Colors.transparent
                                              : Colors.black12
                                                  .withOpacity(0.05),
                                        ),
                                      ),
                                    ],
                                  )
                                : SizedBox.shrink()),
                          ],
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
                                controller.guardarCambiosDatosPersonales(),
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
