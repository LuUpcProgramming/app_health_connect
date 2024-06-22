import 'package:get/get.dart';

class EstadisticaController extends GetxController {
  static EstadisticaController get instance => Get.find();

  //***************Variables***************/
  final selectedDate = 'Semanal'.obs;
  final List<String> listaTipoFecha = [
    'Semanal',
    'Mensual'
  ];

  //***************Métodos***************/
  
}