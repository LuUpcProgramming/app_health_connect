import 'package:app_health_connect/features/authentication/controllers/statistics/statistics_controller.dart';
import 'package:app_health_connect/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:get/get.dart';

class EstadisticasScreen extends StatelessWidget {
  const EstadisticasScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(EstadisticaController());
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(
            top: 32,
            left: 16,
            right: 16,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.trending_up,color: TColors.primary ,size: 80),
                  SizedBox(width: 8.0),
                  Expanded(
                    child:  Text(
                      'Estadísticas',
                      softWrap: true,
                      style: TextStyle(
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.only(left: 15),
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
                          value: controller.selectedDate.value,
                          isExpanded: true,
                          underline: const SizedBox(),
                          onChanged: (newvalue) =>
                              controller.selectedDate.value = newvalue!,
                          items: controller.listaTipoFecha
                              .map<DropdownMenuItem<String>>((String value) {
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
              const SizedBox(height: 20),
              _buildMoodCard(),
              const SizedBox(height: 20),
              _buildWeeklyProgressChart(controller),
              const SizedBox(height: 20),
              _buildTopAchievements(),
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildMoodCard() {
    return Card(
      color: TColors.primary,
      elevation: 15,     
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: const Padding(
        padding: EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Estado de ánimo promedio',
              style: TextStyle(color: Colors.white, fontSize: 23,fontWeight: FontWeight.w800),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.sentiment_dissatisfied,
                    color: Colors.yellow, size: 40),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Ligeramente Estresado',
                    style: TextStyle(color: Colors.white, fontSize: 18,fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Text(
              '“Persististe a pesar de los desafíos esta semana. Ahora, prioriza tu bienestar. '
              'Recarga energías y sigue adelante. Tu salud mental es crucial para tu éxito. ¡Sigue adelante!”',
              style: TextStyle(color: Colors.white),
              textAlign: TextAlign.justify,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeeklyProgressChart(
    EstadisticaController stat
  ) {
    return Card(
      color: TColors.primary,
      elevation: 15,   
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(
              ()=> Text(
                stat.selectedDate.value=='Semanal'?'Progreso Semanal':'Progreso Mensual',
                style: const TextStyle(color: Colors.white, fontSize: 23,fontWeight: FontWeight.w800),
              ),
            ),
            const SizedBox(height: 15),
            SizedBox(
              height: 200,
              child: BarChart(
                BarChartData(
                  maxY: 20,
                  barGroups: _buildBarGroups(),
                  borderData: FlBorderData(show: false),
                  titlesData: FlTitlesData(
                    leftTitles:  AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value,meta){
                          return Text(
                            value.toInt().toString(),
                            style: const TextStyle(color: Colors.white),
                          );
                        }
                      ),
                    ),
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value,meta){
                          return Text(
                            value.toInt().toString(),
                            style: const TextStyle(color: Colors.white),
                          );
                        }
                      ),
                    ),
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (double value, TitleMeta meta) {
                          const style = TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          );
                          Widget text;
                          switch (value.toInt()) {
                            case 0:
                              text = const Text('L', style: style);
                              break;
                            case 1:
                              text = const Text('M', style: style);
                              break;
                            case 2:
                              text = const Text('M', style: style);
                              break;
                            case 3:
                              text = const Text('J', style: style);
                              break;
                            case 4:
                              text = const Text('V', style: style);
                              break;
                            case 5:
                              text = const Text('S', style: style);
                              break;
                            case 6:
                              text = const Text('D', style: style);
                              break;
                            default:
                              text = const Text('', style: style);
                              break;
                          }
                          return SideTitleWidget(
                            axisSide: meta.axisSide,
                            child: text,
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            _buildLegend()
          ],
        ),
      ),
    );
  }

  Widget _buildLegend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildLegendItem(color: const Color.fromRGBO(1, 251, 287, 1), text: 'Logros'),
        const SizedBox(width: 10),
        _buildLegendItem(color: const Color.fromRGBO(240, 50, 116, 1), text: 'Planes'),
      ],
    );
  }

  Widget _buildLegendItem({required Color color, required String text}) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          color: color,
        ),
        const SizedBox(width: 4),
        Text(
          text,
          style: const TextStyle(color: Colors.white),
        ),
      ],
    );
  }

  List<BarChartGroupData> _buildBarGroups() {
    return [
      _buildBarGroup(0, 5, 3),
      _buildBarGroup(1, 10, 4),
      _buildBarGroup(2, 7, 5),
      _buildBarGroup(3, 12, 8),
      _buildBarGroup(4, 14, 7),
      _buildBarGroup(5, 8, 4),
      _buildBarGroup(6, 6, 3),
    ];
  }

  BarChartGroupData _buildBarGroup(int x, int y1, int y2) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y1.toDouble(),
          color: const Color.fromRGBO(1, 251, 287, 1),
          width: 8,
        ),
        BarChartRodData(
          toY: y2.toDouble(),
          color: const Color.fromRGBO(240, 50, 116, 1),
          width: 8,
        ),
      ],
      barsSpace: 4,
    );
  }

  Widget _buildTopAchievements() {
    return Card(
      color: TColors.primary,
      elevation: 15,   
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Top 3 logros',
              style: TextStyle(color: Colors.white, fontSize: 23,fontWeight: FontWeight.w800),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Icon(Icons.restaurant, color: Colors.white, size: 40),
                    SizedBox(height: 10),
                    Text(
                      'Gourmet Saludable',
                      style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600),
                      softWrap: true,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                Column(
                  children: [
                    Icon(Icons.spa, color: Colors.white, size: 40),
                    SizedBox(height: 10),
                    Text(
                      'Equilibrio Espiritual',
                      style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600),
                      softWrap: true,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                Column(
                  children: [
                    Icon(Icons.fitness_center, color: Colors.white, size: 40),
                    SizedBox(height: 10),
                    Text(
                      'Resiliencia Fitness',
                       style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600),
                      softWrap: true,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
