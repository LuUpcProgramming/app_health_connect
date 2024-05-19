import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DashboardScreen extends StatelessWidget {
  static const name = 'dashboard-screen';

  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: _DashboardView()
        // bottomNavigationBar: CustomBottomNavigation(),
        );
  }
}

class _DashboardView extends StatelessWidget {
  const _DashboardView();
  final String userName = "Juan";
  final String userImage =
      'assets/images/user_image.png'; // Ruta a la imagen en assets

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top section with image and greeting
              Row(
                children: [
                  CircleAvatar(
                    backgroundImage: AssetImage(
                        userImage), // Usamos AssetImage para la imagen local
                    radius: 20,
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Bienvenido',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        userName,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                '¿Cómo te sientes?',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),

              // Weekly calendar
              WeeklyCalendar(),
              const SizedBox(height: 16),

              // Trabajo and Estado de Ánimo boxes
              const Row(
                children: [
                  StatusBox(
                    title: 'Trabajo',
                    content: 'Saturado',
                    subContent: 'horas extras',
                  ),
                  SizedBox(width: 16),
                  StatusBox(
                    title: 'Estado de ánimo',
                    content: '😩',
                    subContent: 'Estresado',
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Asistente Virtual section
              const Text(
                'Asistente Virtual',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              AssistantBox(),
              const SizedBox(height: 16),

              // Tu Plan del Día section
              const Text(
                'Tu Plan del Día',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              PlanBox(),
              const SizedBox(height: 16),

              // Recomendado para ti section
              const Text(
                'Recomendado para ti',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  RecommendationBox(
                    icon: Icons.local_florist,
                    text: 'Tips para aliviar estrés en el trabajo remoto',
                  ),
                  const SizedBox(width: 16),
                  RecommendationBox(
                    icon: Icons.restaurant,
                    text: 'Tips para mejorar la alimentación',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const BottomMenu(),
    );
  }
}

// Widgets for different sections

class WeeklyCalendar extends StatelessWidget {
  final List<String> days = ["Lun", "Mar", "Mié", "Jue", "Vie", "Sáb", "Dom"];
  final DateTime now = DateTime.now();

  WeeklyCalendar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(7, (index) {
        DateTime day = now.add(Duration(days: index - now.weekday + 1));
        bool isToday = now.day == day.day;
        return Column(
          children: [
            Text(
              '${day.day}',
              style: TextStyle(
                color: isToday ? Colors.blue : Colors.black,
                fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            Text(
              days[day.weekday - 1],
              style: TextStyle(
                color: isToday ? Colors.blue : Colors.black,
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
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              content,
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 4),
            Text(
              subContent,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
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
        context.push('/chat');
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFefeffe))) ,
        child: const Row(
          children: [
            CircleAvatar(
              backgroundImage: AssetImage('assets/images/logo.png'), // Usamos AssetImage para la imagen local
              radius: 20,
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
          ]
        )
      )
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
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Pausa Activa',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          PlanItem(
            icon: Icons.pause,
            text: 'Hora: 5 minutos/ hora',
            title: 'Pausa Activa',
          ),
          PlanItem(
            icon: Icons.restaurant,
            text: 'Hora: 1:00 pm',
            title: 'Almuerzo Saludable',
          ),
          PlanItem(
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
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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

class RecommendationBox extends StatelessWidget {
  final IconData icon;
  final String text;

  const RecommendationBox({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFefeffe)),
        ),
        child: Row(
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

// Custom Icon Button

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

// Bottom navigation bar

class BottomMenu extends StatelessWidget {
  const BottomMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: const Color(0xFF4157ff),
      shape: const CircularNotchedRectangle(),
      notchMargin: 6.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            icon: const Icon(Icons.home, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.android,
                color: Colors.white), // Reemplazamos el ícono por uno válido
            onPressed: () {},
          ),
          const SizedBox(width: 40), // Space for the floating button
          IconButton(
            icon: const Icon(Icons.bar_chart, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.person, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
