import 'package:app_health_connect/data/repositories/authentication/authentication_repository.dart';
import 'package:app_health_connect/features/authentication/controllers/dashboard/dashboard_controller.dart';
import 'package:app_health_connect/features/authentication/screens/profile/profile_job_info_screen.dart';
import 'package:app_health_connect/features/authentication/screens/profile/profile_personal_info_screen.dart';
import 'package:app_health_connect/features/authentication/screens/profile/widgets/profile_list_item.dart';
import 'package:app_health_connect/utils/constants/colors.dart';
import 'package:app_health_connect/utils/constants/image_strings.dart';
import 'package:flutter/material.dart';
import 'package:app_health_connect/features/authentication/screens/login/widgets/custom_scaffold.dart';
import 'package:get/get.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var profileInfo = Expanded(
      child: Column(
        children: <Widget>[
          Container(
            height: 120.0, // Altura ajustada manualmente
            width: 120.0, // Anchura ajustada manualmente
            margin: const EdgeInsets.only(top: 24.0), // Espaciado superior
            child: const Stack(
              children: <Widget>[
                CircleAvatar(
                  radius: 60.0, // Radio ajustado manualmente
                  backgroundImage: AssetImage(TImages.avatarLogo),
                  //backgroundColor: TColors.primary,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16.0), // Espaciado entre avatar y texto
          Text(
            //'Nicolas Adams',
            '${DashboardController.instance.usuario.value?.firstName ?? ''} ${DashboardController.instance.usuario.value?.lastName ?? ''}',
            style: const TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: TColors.white),
          ),
          const SizedBox(height: 8.0), // Espaciado entre los textos
          Text(
            AuthenticationRepository.instance.authUser?.email ?? '',
            style: const TextStyle(
              fontSize: 14.0,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 36.0), // Espaciado entre el correo y el botón
        ],
      ),
    );

    var header = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const SizedBox(width: 16.0), // Espaciado lateral
        profileInfo,
        const SizedBox(width: 16.0), // Espaciado lateral
      ],
    );

    return CustomScaffold(
      child: Column(
        children: <Widget>[
          //const SizedBox(height: 60.0), // Espaciado superior
          header,
          const SizedBox(
            width: double.infinity,
            child: Padding(
              padding: EdgeInsets.only(left: 20.0, bottom: 24.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Mi Perfil',
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              children: <Widget>[
                InkWell(
                  onTap: () => Get.to( () => const ProfilePersonalInfoScreen(),
                      transition: Transition.rightToLeft,
                      duration: const Duration(milliseconds: 600)),
                  child: const ProfileListItem(
                    icon: Icons.privacy_tip, // Reemplazo por icono estándar
                    text: 'Datos Personales',
                  ),
                ),
                InkWell(
                  onTap: () => Get.to( () => const ProfileJobScreen(),
                      transition: Transition.rightToLeft,
                      duration: const Duration(milliseconds: 600)),
                  child: const ProfileListItem(
                    icon: Icons.work, // Reemplazo por icono estándar
                    text: 'Datos Laborales',
                  ),
                ),
                InkWell(
                  onTap: () {
                    //Navigator.pushNamed(context, '/profile');
                  },
                  child: const ProfileListItem(
                    icon:
                        Icons.health_and_safety, // Reemplazo por icono estándar
                    text: 'Datos de Salud',
                  ),
                ),
                InkWell(
                  onTap: () => DashboardController.instance.cerrarSesion(),
                  child: const ProfileListItem(
                    icon: Icons.exit_to_app, // Reemplazo por icono estándar
                    text: 'Cerrar Sesión',
                    hasNavigation: false,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
