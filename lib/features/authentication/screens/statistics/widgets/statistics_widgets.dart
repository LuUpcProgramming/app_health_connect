import 'package:app_health_connect/features/authentication/controllers/statistics/statistics_controller.dart';
import 'package:app_health_connect/features/authentication/models/statistics.dart';
import 'package:app_health_connect/utils/constants/colors.dart';
import 'package:app_health_connect/utils/constants/text_strings.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget buildMoodCard(String estadoAnimoPromedio, String mensajeEstadoAnimo) {
  return Card(
    color: TColors.primary,
    elevation: 15,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15.0),
    ),
    child: Padding(
      padding: const EdgeInsets.all(18.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Estado de ánimo promedio',
            style: TextStyle(
                color: Colors.white, fontSize: 23, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.sentiment_dissatisfied,
                  color: Colors.yellow, size: 40),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  // 'Ligeramente Estresado',
                  estadoAnimoPromedio,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            mensajeEstadoAnimo,
            style: const TextStyle(color: Colors.white),
            textAlign: TextAlign.justify,
          ),
        ],
      ),
    ),
  );
}

Widget buildWeeklyProgressChart(EstadisticaController stat) {
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
            () => Text(
              stat.selectedDate.value == TTexts.semanal
                  ? 'Progreso Semanal'
                  : 'Progreso Mensual',

              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 23,
                  fontWeight: FontWeight.w800),
            ),
          ),
          const SizedBox(height: 15),
          SizedBox(
            height: 200,
            child: BarChart(
              BarChartData(
                maxY: 20,
                barGroups: _buildBarGroups(
                    stat.selectedDate.value, stat.estadisticasSemanal.value),
                borderData: FlBorderData(show: false),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            value.toInt().toString(),
                            style: const TextStyle(color: Colors.white),
                          );
                        }),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            value.toInt().toString(),
                            style: const TextStyle(color: Colors.white),
                          );
                        }),
                  ),
                  topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
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

Widget buildMonthlyProgressChart(EstadisticaController stat) {
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
            () => Text(
              stat.selectedDate.value == TTexts.semanal
                  ? 'Progreso Semanal'
                  : 'Progreso Mensual',
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 23,
                  fontWeight: FontWeight.w800),
            ),
          ),
          const SizedBox(height: 15),
          SizedBox(
            height: 200,
            child: BarChart(
              BarChartData(
                maxY: 50,
                barGroups: _buildBarGroups(
                    stat.selectedDate.value, stat.estadisticasSemanal.value),
                borderData: FlBorderData(show: false),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            value.toInt().toString(),
                            style: const TextStyle(color: Colors.white),
                          );
                        }),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            value.toInt().toString(),
                            style: const TextStyle(color: Colors.white),
                          );
                        }),
                  ),
                  topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (double value, TitleMeta meta) {
                        const style = TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        );
                        // Obtener el mes actual
                        final currentMonth = DateTime.now().month;
                        // Lista de nombres de los meses
                        final List<String> months = [
                          'E',
                          'F',
                          'M',
                          'A',
                          'M',
                          'J',
                          'J',
                          'A',
                          'S',
                          'O',
                          'N',
                          'D'
                        ];
                        // Crear una lista de los últimos 6 meses
                        final List<String> lastSixMonths =
                            List.generate(6, (index) {
                          int monthIndex = (currentMonth - 6 + index + 12) % 12;
                          return months[monthIndex];
                        });
                        Widget text;
                        if (value.toInt() >= 0 && value.toInt() < 6) {
                          text =
                              Text(lastSixMonths[value.toInt()], style: style);
                        } else {
                          text = const Text('', style: style);
                        }
                        /*                       switch (value.toInt()) {
                          case 0:
                            text = const Text('E', style: style);
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
                        } */
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

List<BarChartGroupData> _buildBarGroups( String selectedDate, EstadisticasSemanal estadisticas) {
  List<int> datalogros = estadisticas.progresoLogros;
  List<int> dataplanes = estadisticas.progresoPlanes;

  assert(datalogros.length == dataplanes.length);

  return List.generate(datalogros.length, (index) {
    return _buildBarGroup(index, datalogros[index], dataplanes[index]);
  });

  /* return [
    _buildBarGroup(0, 5, 3),
    _buildBarGroup(1, 10, 4),
    _buildBarGroup(2, 7, 5),
    _buildBarGroup(3, 12, 8),
    _buildBarGroup(4, 14, 7),
    _buildBarGroup(5, 8, 4),
    _buildBarGroup(6, 6, 3),
  ]; */
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

Widget _buildLegend() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      _buildLegendItem(
          color: const Color.fromRGBO(1, 251, 287, 1), text: 'Cumplidos'),
      const SizedBox(width: 10),
      _buildLegendItem(
          color: const Color.fromRGBO(240, 50, 116, 1), text: 'Planes Total'),
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

Widget buildTopAchievements(List<Logro> logros) {
  return Card(
    color: TColors.primary,
    elevation: 15,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15.0),
    ),
    child:  Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Top 3 logros',
            style: TextStyle(
                color: Colors.white, fontSize: 23, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: logros.map((logro) {
              return Column(
                children: [
                   Icon(logro.icono, color: Colors.white, size: 40),
                  const SizedBox(height: 10),
                  Text(
                    logro.titulo,
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w600),
                    softWrap: true,
                    textAlign: TextAlign.center,
                  ),
                ],
              );
            }).toList(),
  /*           children: [
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
            ], */
          ),
        ],
      ),
    ),
  );
}
