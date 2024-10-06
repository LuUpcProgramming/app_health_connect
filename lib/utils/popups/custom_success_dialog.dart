import 'package:app_health_connect/utils/constants/colors.dart';
import 'package:flutter/material.dart';

class CustomSuccessWidget extends StatelessWidget {
  final VoidCallback? onPressed;
  final String titulo;
  final String mensaje;

  const CustomSuccessWidget({super.key, this.onPressed,  this.titulo='Éxito',  this.mensaje='Registro Exitoso'});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(top: 90.0, bottom: 20.0),
                  decoration: const BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(10.0),
                    ),
                  ),
                ),
                const Positioned(
                  top: 5,
                  left: 0,
                  right: 0,
                  child: Column(
                    children: [
                      Icon(Icons.task_alt, size: 85, color: Colors.white),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
             Text(
              titulo,
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
             Text(
              mensaje,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w400,
              ),
              maxLines: 3,
              softWrap: true,
            ),
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
                child: const Text(
                  'Aceptar',
                  style: TextStyle(fontSize: 18, color: Colors.white),
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
