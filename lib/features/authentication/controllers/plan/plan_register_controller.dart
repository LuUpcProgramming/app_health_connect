import 'package:app_health_connect/config/helper/logging.dart';
import 'package:app_health_connect/data/repositories/plan/plan_repository.dart';
import 'package:app_health_connect/features/authentication/models/plan_diario.dart';
import 'package:app_health_connect/features/authentication/screens/dashboard/dashboard_screen.dart';
import 'package:app_health_connect/utils/constants/image_strings.dart';
import 'package:app_health_connect/utils/constants/text_strings.dart';
import 'package:app_health_connect/utils/helpers/network_manager.dart';
import 'package:app_health_connect/utils/popups/full_screen_loader.dart';
import 'package:app_health_connect/utils/popups/loaders.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PlanRegisterController extends GetxController {
  static PlanRegisterController get instance => Get.find();

  final log = logger(PlanRegisterController);
  final TextEditingController metaController = TextEditingController();
  final TextEditingController horaController = TextEditingController();
 
  GlobalKey<FormState> planDiarioFormKey = GlobalKey<FormState>();
   final selectedActividad = 'Meditación'.obs;
  TimeOfDay selectedTime = TimeOfDay.now();
   String selectedHora = '00:00';
  String selectedPeriodo = 'AM';
  //final currentUser = FirebaseAuth.instance.currentUser;
  final RxInt selectedDay =2.obs; // Inicialmente, 'M' (miércoles) está seleccionado
  final RxList<int> selectedDays = <int>[].obs;
  final List<String> days = ['L', 'M', 'M', 'J', 'V', 'S', 'D'];
  final List<String> tipoActividad = [
    TTexts.activMeditacion,
    TTexts.actividadAlimentacion,
    TTexts.actividadFisico
  ];

  void toggleDay(int index) {
    if (selectedDays.contains(index)) {
      selectedDays.remove(index);
    } else {
      selectedDays.add(index);
    }
    selectedDays.sort(); // Mantener el orden
  }

  bool isDaySelected(int index) => selectedDays.contains(index);

  void selectDay(int index) {
    selectedDay.value = index;
  }

  String addLeadingZero(int number) {
    if (number < 10) {
      return '0$number';
    } else {
      return number.toString();
    }
  }

  int obtenerTipoLogro(String tipoActividad){ 
    if(tipoActividad == 'Meditación'){
      return TTexts.logroEquilibrioInterior;
    }else if(tipoActividad == 'Alimentación'){
      return TTexts.logroGourmetSaludable;
    }else if(tipoActividad == 'Actividad Física'){
      return TTexts.logroResilienciaFitness;
    }else{
      return 0;
    }

  }

  void grabar(){
      log.i('Grabando plan diario');
      log.i('Meta: ${metaController.text}');
      log.i('Hora: ${horaController.text}');
      log.i('Tipo de actividad: ${selectedActividad.value}');
      log.i('Periodo: $selectedPeriodo');
      log.i('Días seleccionados: $selectedDays');
      log.i('Día seleccionado: ${days[selectedDay.value]}');
      log.i('Hora seleccionada: $selectedHora');
  }

  void grabarPlanDiario() async{
    
    try {
      log.i('Grabando plan diario');
      log.i('Meta: ${metaController.text}');
      log.i('Hora: ${horaController.text}');
      log.i('Tipo de actividad: ${selectedActividad.value}');
      log.i('Periodo: $selectedPeriodo');
      log.i('Días seleccionados: $selectedDays');
      log.i('Día seleccionado: ${days[selectedDay.value]}');
      TFullScreenLoader.openLoadingDialog(
          'Procesando Información...', TImages.loadingAnimation);

      //check internet connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        TFullScreenLoader.stopLoading();
        return;
      }

      // Form Validation
      if (!planDiarioFormKey.currentState!.validate()) {
        TFullScreenLoader.stopLoading();
        return;
      }

      if(selectedActividad.isEmpty){
        TFullScreenLoader.stopLoading();
        Loaders.warningSnackBar(title: 'Campo requerido', message: 'Por favor seleccione un tipo de actividad');
        return;
      }

      if(selectedDays.isEmpty){
        TFullScreenLoader.stopLoading();
        Loaders.warningSnackBar(title: 'Campo requerido', message: 'Por favor seleccione al menos un día');
        return;
      }

      final planDiario = PlanDiario(
        idUsuario: '1', 
        meta: metaController.text, 
        tipoActividad: selectedActividad.value, 
        dias: selectedDays.map((e) => days[e]).toList(), 
        hora: selectedHora, 
        periodo: selectedPeriodo,
        mensaje: 'Preparar una ensalada fresca para el almuerzo no solo es una elección saludable, ¡es un acto de amor propio! Cuida tu cuerpo, nutre tu mente y siembra la energía positiva que necesitas para brillar durante todo el día ¡Tu puedes hacerlo, y te mereces lo mejor!',
        recomendacion: '- Mantén tus ensaladas interesantes probando diferentes combinaciones de vegetales, proteínas y aderezos.\n- Piensa en cómo te sientes después de comer algo fresco y saludable, y cómo esto contribuye a tu bienestar general.\n- Dedica un tiempo a preparar tus ingredientes con antelación para que sea fácil y rápido armar tu ensalada cada día.',
        tipoLogro: obtenerTipoLogro(selectedActividad.value)
      );

      final planRepository = Get.put(PlanRepository());
      await planRepository.savePlanDiario(planDiario);

      // Show Success Hessage
      Loaders.successSnackBar(
          title: 'Felicidades',
          message:'¡Tu Plan ha sido registrado!');

      //Move to Verify Email Screen
      //Get.off(() => DashboardScreen());
      TFullScreenLoader.stopLoading();
    } catch (e) {
      TFullScreenLoader.stopLoading();
      Loaders.errorSnackBar(
          title: 'Oh, sucedió un error', message: e.toString());
    }
    
    
  }
}
