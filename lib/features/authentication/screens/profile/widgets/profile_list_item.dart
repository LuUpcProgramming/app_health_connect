import 'package:app_health_connect/utils/constants/colors.dart';
import 'package:flutter/material.dart';

class ProfileListItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final bool hasNavigation;

  const ProfileListItem({
    super.key,
    required this.icon,
    required this.text,
    this.hasNavigation = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60.0, // Altura ajustada manualmente
      margin: const EdgeInsets.symmetric(
        horizontal: 16.0, // Espaciado horizontal
      ).copyWith(
        bottom: 12.0, // Espaciado inferior
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 16.0, // Padding horizontal
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0), // Radio ajustado manualmente
        color: TColors.primary,
        
      ),
      child: Row(
        children: <Widget>[
          Icon(
            icon,
            size: 30.0, // Tamaño del icono ajustado manualmente
            color: TColors.white,
          ),
          const SizedBox(width: 12.0), // Separador entre el icono y el texto
          Text(
            text,
            style: const TextStyle(
              fontSize: 16.0, // Tamaño de fuente ajustado manualmente
              fontWeight: FontWeight.w500,
              color: TColors.white,
            ),
          ),
          const Spacer(),
          if (hasNavigation)
            const Icon(
              Icons.arrow_forward_ios, // Icono por defecto de Flutter
              size: 20.0, // Tamaño ajustado manualmente
              color: TColors.white,
            ),
        ],
      ),
    );
  }
}
