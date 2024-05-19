import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class WelcomeScreen extends StatelessWidget {
  static const name = 'welcome-screen';
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: _WelcomeView(nombre: "Luis")
        // bottomNavigationBar: CustomBottomNavigation(),
        );
  }
}

class _WelcomeView extends StatelessWidget {
  final String nombre;
  const _WelcomeView({required this.nombre});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(children: [
        //Círculo superior derecho
        Positioned(
          top: -50,
          right: -50,
          child: Container(
            width: 150,
            height: 150,
            decoration: const BoxDecoration(
              color: Color.fromRGBO(65, 87, 255, 1),
              shape: BoxShape.circle,
            ),
          ),
        ),
        // Círculo inferior izquierdo
        Positioned(
          bottom: -50,
          left: -50,
          child: Container(
            width: 150,
            height: 150,
            decoration: const BoxDecoration(
              color: Color.fromRGBO(65, 87, 255, 1),
              shape: BoxShape.circle,
            ),
          ),
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                Image.asset(
                  'assets/images/logo.png',
                  height: 200.0,
                ),
                const SizedBox(height: 20.0),
                const Text(
                  'Hola, José',
                  style: TextStyles.titleTextStyle,
                ),
                const SizedBox(height: 10.0),
                const Text(
                  'Me llamo Coni y seré tu asistente virtual.\nPrimero Conozcámonos!',
                  style: TextStyles.subtitleTextStyle,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: () {
                    context.push('/personal');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4157FF),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 60.0, vertical: 15.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  child: const Text('Continuar',
                      style: TextStyles.buttonTextStyle),
                ),
                const Spacer(),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}

class TextStyles {
  static const TextStyle titleTextStyle = TextStyle(
    fontSize: 28.0,
    fontWeight: FontWeight.bold,
    color: Color(0xFF4157FF),
  );

  static const TextStyle subtitleTextStyle = TextStyle(
    fontSize: 16.0,
    color: Color(0xFF4157FF),
  );

  static const TextStyle buttonTextStyle = TextStyle(
    fontSize: 18.0,
    color: Colors.white,
  );
}
