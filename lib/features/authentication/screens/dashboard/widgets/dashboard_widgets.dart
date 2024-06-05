import 'package:app_health_connect/features/authentication/screens/chat/chat_screen.dart';
import 'package:app_health_connect/utils/constants/colors.dart';
import 'package:app_health_connect/utils/constants/image_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class WeeklyCalendar extends StatelessWidget {
  final List<String> days = ["Lun", "Mar", "Mié", "Jue", "Vie", "Sáb", "Dom"];
  final DateTime now = DateTime.now();

  WeeklyCalendar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: List.generate(7, (index) {
        DateTime day = now.add(Duration(days: index - now.weekday + 1));
        bool isToday = now.day == day.day;
        return Column(
          children: [
            Text(
              '${day.day}',
              style: TextStyle(
                color: isToday ? TColors.primary : Colors.black,
                fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            Text(
              days[day.weekday - 1],
              style: TextStyle(
                color: isToday ? TColors.primary : Colors.black,
                fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        );
      }),
    );
  }
}

class StatusBox extends StatelessWidget {
  final String title;
  final String content;
  final String subContent;

  const StatusBox(
      {super.key,
      required this.title,
      required this.content,
      required this.subContent});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFefeffe)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.4), // Color de la sombra
              spreadRadius: 2, // Cuanto se extiende la sombra
              blurRadius: 5, // Cuanto se difumina la sombra
              offset: const Offset(0, 2.5), // Posición de la sombra (horizontal, vertical)
            ),
          ]
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 4,),
            Center(
              child: Text(
                content,
                style: const TextStyle(fontSize:25,fontWeight: FontWeight.w800),
              ),
            ),
            
            Center(
              child: Text(
                subContent,
                style: const TextStyle(fontSize: 16, color: Colors.grey,fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AssistantBox extends StatelessWidget {
  const AssistantBox({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Get.to(
            () => const ChatScreen(),
            transition: Transition.rightToLeft, // Transición de deslizar
            duration: const Duration(milliseconds: 600), // Duración de la transición
          );
        },
        child: Container(
            //padding: const EdgeInsets.all(16),
            padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 25),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFefeffe)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.4), // Color de la sombra
                  spreadRadius: 2, // Cuanto se extiende la sombra
                  blurRadius: 5, // Cuanto se difumina la sombra
                  offset: const Offset(0, 2.5), // Posición de la sombra (horizontal, vertical)
                ),
              ]
                
            ),
            child: const Row(children: [
              CircleAvatar(
                backgroundImage: AssetImage(TImages.robotLogo),
                backgroundColor: TColors.accent, // Usamos AssetImage para la imagen local
                radius: 30,
              ),
              SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Conversemos!',
                    style: TextStyle(fontSize: 18),
                  ),
                  Text(
                    'Coni quiere saber como te sientes!',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
              Spacer(),
              Icon(Icons.arrow_forward, size: 32),
            ])));
  }
}

class RecommendationBox extends StatelessWidget {
  final IconData icon;
  final String text;

  const RecommendationBox({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 30,horizontal: 8),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFefeffe)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.4), // Color de la sombra
              spreadRadius: 2, // Cuanto se extiende la sombra
              blurRadius: 5, // Cuanto se difumina la sombra
              offset: const Offset(0, 2.5), // Posición de la sombra (horizontal, vertical)
            ),
          ]
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32, color: Colors.green),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                text,
                style: const TextStyle(fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PlanBox extends StatelessWidget {
  const PlanBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFefeffe)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.4), // Color de la sombra
            spreadRadius: 2, // Cuanto se extiende la sombra
            blurRadius: 5, // Cuanto se difumina la sombra
            offset: const Offset(0, 2.5), // Posición de la sombra (horizontal, vertical)
          ),
        ]
      ),
      child:  Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const PlanItem(
            icon: Icons.pause,
            text: 'Hora: 5 minutos/ hora',
            title: 'Pausa Activa',
          ),
          Divider(
            color: Colors.grey.shade300, // Color de la línea divisoria
            thickness: 1, // Grosor de la línea divisoria
            indent: 5, // Espaciado desde la izquierda
            endIndent: 5, // Espaciado desde la derecha
          ),
          const PlanItem(
            icon: Icons.restaurant,
            text: 'Hora: 1:00 pm',
            title: 'Almuerzo Saludable',
          ),
          Divider(
            color: Colors.grey.shade300, // Color de la línea divisoria
            thickness: 1, // Grosor de la línea divisoria
            indent: 5, // Espaciado desde la izquierda
            endIndent: 5, // Espaciado desde la derecha
          ),
          const PlanItem(
            icon: Icons.self_improvement,
            text: 'Hora: 6:00 pm',
            title: 'Meditación y Relajación',
          ),
        ],
      ),
    );
  }
}

class PlanItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String text;

  const PlanItem(
      {super.key, required this.icon, required this.title, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF4157ff)),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style:
                const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                
              ),
              Text(
                text,
                style:
                const TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
              ),
            ],
          ),
          const Spacer(),
          const Icon(Icons.arrow_forward),
        ],
      ),
    );
  }
}

class CustomIconButton extends StatelessWidget {
  final IconData icon;
  final void Function()? onPressed;

  const CustomIconButton({super.key, required this.icon, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(100),
        ),
        child: Center(
          child: Icon(
            icon,
            color: Colors.black,
            size: 14,
          ),
        ),
      ),
    );
  }
}
