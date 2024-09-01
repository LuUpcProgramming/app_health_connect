import 'dart:async';

import 'package:app_health_connect/config/helper/logging.dart';
import 'package:app_health_connect/data/repositories/plan/plan_repository.dart';
import 'package:app_health_connect/features/authentication/models/actividad.dart';
import 'package:app_health_connect/features/authentication/models/plan_diario.dart';
import 'package:app_health_connect/utils/constants/text_strings.dart';
import 'package:app_health_connect/utils/popups/custom_question_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PlanController extends GetxController {
  static PlanController get instance => Get.find();
  //***************Variables***************/
  final log = logger(PlanController);
  //Detalle Plan Diario
  final RxList<Tarea> tareas = <Tarea>[].obs;
  final RxList<PlanDiario> planes = <PlanDiario>[].obs;
  var isLoading = true.obs;
  StreamSubscription? _subscriptionPlan;

  @override
  void onInit() {
    super.onInit();
    listarPlanesUsuario("1");
  }

  void listarPlanesUsuario(String userId) async {
    isLoading.value = true;

    final planDiarioRepository = Get.put(PlanRepository());
    // Escuchar el stream de Firestore y actualizar la lista reactiva
    _subscriptionPlan = planDiarioRepository
        .getStreamPlanesDiariosByUserId(userId)
        .listen((listaPlanes) {
      List<PlanDiario> planesLocal = [];
      for (var plan in listaPlanes) {
        final planDiario = PlanDiario(
            idDocumento: plan.idDocumento,
            idUsuario: plan.idUsuario,
            meta: plan.meta,
            tipoActividad: plan.tipoActividad,
            dia: plan.dia,
            completada: plan.completada,
            hora: plan.hora,
            periodo: plan.periodo,
            mensaje: plan.mensaje,
            recomendacion: plan.recomendacion,
            tipoLogro: plan.tipoLogro,
            iconoLogro: obtenerIconoLogro(plan.tipoLogro),
            iconoPlan: obtenerIconoPlan(plan.tipoLogro),
            fechaRegistro: plan.fechaRegistro,
            horaRegistro: plan.horaRegistro,
            identificadorPlan: plan.identificadorPlan);
        planesLocal.add(planDiario);
      }
      planes.assignAll(planesLocal);
    }, onError: (error) {
      log.i("Error al obtener planes diarios: $error");
    });

    //List<PlanDiario> listaPlanes =
    //    await planDiarioRepository.getPlanesDiariosByUserId(userId);

/*     for (var plan in planes) {
      final planDiario = PlanDiario(
          idDocumento: plan.idDocumento,
          idUsuario: plan.idUsuario,
          meta: plan.meta,
          tipoActividad: plan.tipoActividad,
          dias: plan.dias,
          hora: plan.hora,
          periodo: plan.periodo,
          mensaje: plan.mensaje,
          recomendacion: plan.recomendacion,
          tipoLogro: plan.tipoLogro,
          completada: plan.completada,
          iconoLogro: obtenerIconoLogro(plan.tipoLogro),
          iconoPlan: obtenerIconoPlan(plan.tipoLogro));
      planes.add(planDiario);
    } */
    log.i(planes.toString());
    isLoading.value = false;
  }

  IconData obtenerIconoLogro(int tipoLogro) {
    if (tipoLogro == TTexts.logroGourmetSaludable) {
      return Icons.soup_kitchen;
    } else if (tipoLogro == TTexts.logroEquilibrioInterior) {
      return Icons.self_improvement;
    } else if (tipoLogro == TTexts.logroResilienciaFitness) {
      return Icons.directions_run;
    } else {
      return Icons.report_off;
    }
  }

  IconData obtenerIconoPlan(int tipoLogro) {
    if (tipoLogro == TTexts.logroGourmetSaludable) {
      return Icons.local_dining;
    } else if (tipoLogro == TTexts.logroEquilibrioInterior) {
      return Icons.volunteer_activism;
    } else if (tipoLogro == TTexts.logroResilienciaFitness) {
      return Icons.fitness_center;
    } else {
      return Icons.report_off;
    }
  }

  void togglePlan(int index) {
    int valor = planes[index].completada;
    if (valor == TTexts.logroIncompleto) {
      showQuestionDialog(planes[index]);
    } else {
      planes[index].completada =
          (planes[index].completada == TTexts.logroIncompleto)
              ? TTexts.logroCompletado
              : TTexts.logroIncompleto;
      planes.refresh();
    }
  }

  void showQuestionDialog(PlanDiario plan) {
    Get.dialog(CustomQuestionWidget(
      onPressedConfirm: () {
        log.i("Logro Actualizado");
        final planRepository = Get.find<PlanRepository>();
        planRepository.updateLogro(plan.idDocumento, TTexts.logroCompletado);
        Get.back();
      },
      onPressedCancel: () => Get.back(),
      titulo: '¿Actividad Completada?',
      descripcion:
          'Solo acepta si has completado la actividad correspondiente. De ti depende tu bienestar.',
    ));
  }

  @override
  void onClose() {
    // Cancelar la suscripción cuando el Controller se cierre
    _subscriptionPlan?.cancel();
    super.onClose();
  }
}
