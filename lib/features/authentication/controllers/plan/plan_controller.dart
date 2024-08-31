import 'package:app_health_connect/config/helper/logging.dart';
import 'package:app_health_connect/features/authentication/models/actividad.dart';
import 'package:app_health_connect/features/authentication/models/plan_diario.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class PlanController extends GetxController {
  static PlanController get instance => Get.find();
  //***************Variables***************/
  final log = logger(PlanController);
  //Detalle Plan Diario
  final RxList<Tarea> tareas = <Tarea>[].obs;

   void toggleActividad(int index) {
    tareas[index].completada = !tareas[index].completada;
    tareas.refresh();
  }

  @override
  void onInit() {
    super.onInit();
    PlanDiario(idUsuario: '123', meta: 'Pausa Activa', tipoActividad: 'Meditación', dias: List.empty(), hora: '10', periodo: 'AM',
    mensaje: 'Preparar una ensalada fresca para el almuerzo no solo es una elección saludable, ¡es un acto de amor propio! Cuida tu cuerpo, nutre tu mente y siembra la energía positiva que necesitas para brillar durante todo el día ¡Tu puedes hacerlo, y te mereces lo mejor!',
    recomendacion: """- Mantén tus ensaladas interesantes probando diferentes combinaciones de vegetales, proteínas y aderezos.\n- Piensa en cómo te sientes después de comer algo fresco y saludable, y cómo esto contribuye a tu bienestar general.\n- Dedica un tiempo a preparar tus ingredientes con antelación para que sea fácil y rápido armar tu ensalada cada día.""",
    tipoLogro: 1);

    tareas.addAll([
      Tarea('Pausa Activa', '10:00am', Icons.pause,Icons.self_improvement,
      '''Preparar una ensalada fresca para el almuerzo no solo es una elección saludable, ¡es un acto de amor propio! Cuida tu cuerpo, nutre tu mente y siembra la energía positiva que necesitas para brillar durante todo el día ¡Tu puedes hacerlo, y te mereces lo mejor!''', false),
      Tarea(
          'Ensalada fresca en el almuerzo', '1:00 pm', Icons.restaurant,Icons.soup_kitchen,
          '''Preparar una ensalada fresca para el almuerzo no solo es una elección saludable, ¡es un acto de amor propio! Cuida tu cuerpo, nutre tu mente y siembra la energía positiva que necesitas para brillar durante todo el día ¡Tu puedes hacerlo, y te mereces lo mejor!''', false),
      Tarea('Ejercicios de Cardio', '6:30 am', Icons.directions_run,Icons.nordic_walking,
      '''Preparar una ensalada fresca para el almuerzo no solo es una elección saludable, ¡es un acto de amor propio! Cuida tu cuerpo, nutre tu mente y siembra
      la energía positiva que necesitas para brillar durante todo el día ¡Tu puedes hacerlo, y te mereces lo mejor!''', false),
      Tarea('Consumir 5 porciones de fruta', '10:00 am', Icons.apple,Icons.soup_kitchen,
      '''Preparar una ensalada fresca para el almuerzo no solo es una elección saludable, ¡es un acto de amor propio! Cuida tu cuerpo, nutre tu mente y siembra
      la energía positiva que necesitas para brillar durante todo el día ¡Tu puedes hacerlo, y te mereces lo mejor!''', true),
      Tarea(
          'Mantenerse hidratado', 'Durante el día', Icons.water_drop,Icons.soup_kitchen,
          '''Preparar una ensalada fresca para el almuerzo no solo es una elección saludable, ¡es un acto de amor propio! Cuida tu cuerpo, nutre tu mente y siembra
      la energía positiva que necesitas para brillar durante todo el día ¡Tu puedes hacerlo, y te mereces lo mejor!''', true),
      Tarea('Leer un libro', '8:00 pm', Icons.book,Icons.self_improvement,
      '''Preparar una ensalada fresca para el almuerzo no solo es una elección saludable, ¡es un acto de amor propio! Cuida tu cuerpo, nutre tu mente y siembra
      la energía positiva que necesitas para brillar durante todo el día ¡Tu puedes hacerlo, y te mereces lo mejor!''',
       false),
      Tarea('Consumir 5 porciones de fruta', '10:00 am', Icons.apple,Icons.soup_kitchen,
      '''Preparar una ensalada fresca para el almuerzo no solo es una elección saludable, ¡es un acto de amor propio! Cuida tu cuerpo, nutre tu mente y siembra
      la energía positiva que necesitas para brillar durante todo el día ¡Tu puedes hacerlo, y te mereces lo mejor!''', true),
     Tarea('Pausa Activa', '10:00am', Icons.pause,Icons.self_improvement,
     '''Preparar una ensalada fresca para el almuerzo no solo es una elección saludable, ¡es un acto de amor propio! Cuida tu cuerpo, nutre tu mente y siembra
      la energía positiva que necesitas para brillar durante todo el día ¡Tu puedes hacerlo, y te mereces lo mejor!''', false),
      Tarea(
          'Ensalada fresca en el almuerzo', '1:00 pm', Icons.restaurant,Icons.soup_kitchen,
          '''Preparar una ensalada fresca para el almuerzo no solo es una elección saludable, ¡es un acto de amor propio! Cuida tu cuerpo, nutre tu mente y siembra
      la energía positiva que necesitas para brillar durante todo el día ¡Tu puedes hacerlo, y te mereces lo mejor!''', false),
      Tarea('Ejercicios de Cardio', '6:30 am', Icons.directions_run,Icons.nordic_walking,
      '''Preparar una ensalada fresca para el almuerzo no solo es una elección saludable, ¡es un acto de amor propio! Cuida tu cuerpo, nutre tu mente y siembra
      la energía positiva que necesitas para brillar durante todo el día ¡Tu puedes hacerlo, y te mereces lo mejor!''', false),
      Tarea('Consumir 5 porciones de fruta', '10:00 am', Icons.apple,Icons.soup_kitchen,
      '''Preparar una ensalada fresca para el almuerzo no solo es una elección saludable, ¡es un acto de amor propio! Cuida tu cuerpo, nutre tu mente y siembra
      la energía positiva que necesitas para brillar durante todo el día ¡Tu puedes hacerlo, y te mereces lo mejor!''', true),
      Tarea(
          'Mantenerse hidratado', 'Durante el día', Icons.water_drop,Icons.soup_kitchen,
          '''Preparar una ensalada fresca para el almuerzo no solo es una elección saludable, ¡es un acto de amor propio! Cuida tu cuerpo, nutre tu mente y siembra
      la energía positiva que necesitas para brillar durante todo el día ¡Tu puedes hacerlo, y te mereces lo mejor!''', true),
      Tarea('Leer un libro', '8:00 pm', Icons.book,Icons.self_improvement,
      '''Preparar una ensalada fresca para el almuerzo no solo es una elección saludable, ¡es un acto de amor propio! Cuida tu cuerpo, nutre tu mente y siembra
      la energía positiva que necesitas para brillar durante todo el día ¡Tu puedes hacerlo, y te mereces lo mejor!''', false),
      Tarea('Consumir 5 porciones de fruta', '10:00 am', Icons.apple,Icons.soup_kitchen,
      '''Preparar una ensalada fresca para el almuerzo no solo es una elección saludable, ¡es un acto de amor propio! Cuida tu cuerpo, nutre tu mente y siembra
      la energía positiva que necesitas para brillar durante todo el día ¡Tu puedes hacerlo, y te mereces lo mejor!''', true),
    ]);
  }
}
