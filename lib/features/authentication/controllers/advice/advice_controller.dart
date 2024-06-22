import 'package:app_health_connect/features/authentication/models/history_advice.dart';
import 'package:get/get.dart';

class AdviceController extends GetxController {
  static AdviceController get instance => Get.find();

  //***************Variables***************/
  final selectedYear = '2024'.obs;
  final selectedMonth = 'Mayo'.obs;

  final List<String> years = ['2021', '2022', '2023', '2024'];
  final List<String> months = [
    'Enero',
    'Febrero',
    'Marzo',
    'Abril',
    'Mayo',
    'Junio',
    'Julio',
    'Agosto',
    'Septiembre',
    'Octubre',
    'Noviembre',
    'Diciembre'
  ];

  final List<HistoryAdvice> lista = [
    HistoryAdvice(
      title: 'Practica la Respiración Profunda',
      description: 'Cuando sientas el peso del estrés, recuerda el poder de la respiración profunda. En cada inhalación, encuentras calma; en cada exhalación, liberas tensión.',
      date: '29 Mie'
    ),
    HistoryAdvice(
      title: 'Meditación por las mañanas',
      description: 'Comienza cada mañana con la tranquilidad que solo la meditación puede brindarte. Al dedicar unos minutos a calmar tu mente, estableces un poderoso precedente para el día.',
      date: '28 Mar'
    ),
    HistoryAdvice(
      title: 'No descuides tu alimentación',
      description: 'Incluso en los momentos mas estresantes, recuerda que tu cuerpo es aliado mas importante. Alimentarte adecuadamente te brinda la energía y la claridad mental que necesitas para superar cualquier obstáculo.',
      date: '27 Lun'
    ),
     HistoryAdvice(
      title: 'Practica la Respiración Profunda',
      description: 'Cuando sientas el peso del estrés, recuerda el poder de la respiración profunda. En cada inhalación, encuentras calma; en cada exhalación, liberas tensión.',
      date: '26 Dom'
    ),
    HistoryAdvice(
      title: 'Meditación por las mañanas',
      description: 'Comienza cada mañana con la tranquilidad que solo la meditación puede brindarte. Al dedicar unos minutos a calmar tu mente, estableces un poderoso precedente para el día.',
      date: '25 Sab'
    ),
    HistoryAdvice(
      title: 'No descuides tu alimentación',
      description: 'Incluso en los momentos mas estresantes, recuerda que tu cuerpo es aliado mas importante. Alimentarte adecuadamente te brinda la energía y la claridad mental que necesitas para superar cualquier obstáculo.',
      date: '24 Vie'
    ),
  ];

  //***************Métodos***************/
}
