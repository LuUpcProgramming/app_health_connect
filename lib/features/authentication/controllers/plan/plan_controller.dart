import 'dart:async';

import 'package:app_health_connect/config/helper/logging.dart';
import 'package:app_health_connect/data/repositories/plan/plan_repository.dart';
import 'package:app_health_connect/features/authentication/models/actividad.dart';
import 'package:app_health_connect/features/authentication/models/plan_diario.dart';
import 'package:app_health_connect/features/authentication/screens/plan/widgets/custom_logro_dialog.dart';
import 'package:app_health_connect/utils/constants/text_strings.dart';
import 'package:app_health_connect/utils/popups/custom_question_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  final currentUser = FirebaseAuth.instance.currentUser;

  @override
  void onInit() {
    super.onInit();
    listarPlanesUsuario(currentUser!.uid);
  }

  void listarPlanesUsuario(String userId) async {
    isLoading.value = true;

    final planDiarioRepository = Get.put(PlanRepository());
    // Escuchar el stream de Firestore y actualizar la lista reactiva
    _subscriptionPlan = planDiarioRepository.getStreamPlanesDiariosByUserId(userId).listen((listaPlanes) {
      List<PlanDiario> planesLocal = [];
      for (var plan in listaPlanes) {
        final planDiario = PlanDiario(
            idDocumento: plan.idDocumento,
            idUsuario: plan.idUsuario,
            meta: plan.meta,
            tipoActividad: plan.tipoActividad,
            diaPlan: plan.diaPlan,
            fechaPlan: plan.fechaPlan,
            estadoPlan: plan.estadoPlan,
            hora: plan.hora,
            periodo: plan.periodo,
            mensaje: plan.mensaje,
            recomendacion: plan.recomendacion,
            tipoLogro: plan.tipoLogro,
            iconoLogro: TTexts.obtenerIconoLogro(plan.tipoLogro),
            iconoPlan: TTexts.obtenerIconoPlan(plan.tipoLogro),
            fechaRegistro: plan.fechaRegistro,
            horaRegistro: plan.horaRegistro,
            identificadorPlan: plan.identificadorPlan);
        planesLocal.add(planDiario);
      }

      // Ordenar por 'completada' ascendente y luego por 'hora' ascendente
      planesLocal.sort((a, b) {
        int compareCompletada = a.estadoPlan.compareTo(b.estadoPlan);
        if (compareCompletada != 0) {
          return compareCompletada;
        } else {
          // Comparar por hora como String. Si es necesario, puedes convertir a DateTime para una comparación más precisa.
          return a.hora.compareTo(b.hora);
        }
      });

      planes.assignAll(planesLocal);
    }, onError: (error) {
      log.i("Error al obtener planes diarios: $error");
    });
    log.i(planes.toString());
    isLoading.value = false;
  }

 
  void togglePlan(int index) {
    int valor = planes[index].estadoPlan;
    if (valor == TTexts.estadoPendiente) {
      showQuestionDialog(planes[index]);
    } else {
      planes[index].estadoPlan =
          (planes[index].estadoPlan == TTexts.estadoPendiente)
              ? TTexts.estadoCompletado
              : TTexts.estadoPendiente;
      planes.refresh();
    }
  }

  void showQuestionDialog(PlanDiario plan) {
    Get.dialog(CustomQuestionWidget(
      onPressedConfirm: () {
        log.i("Logro Actualizado");
        final planRepository = Get.find<PlanRepository>();
        planRepository.updateEstadoCompletado(plan.idDocumento, TTexts.estadoCompletado);
        Get.back();
        showLogroDialog(plan.tipoLogro);
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

  void showLogroDialog(int tipoLogro) {
    Get.dialog(CustomLogroDialog(
      tipoLogro: tipoLogro,
      titulo: "¡Felicidades!",
      descripcion: "Obtuviste el logro de ${TTexts.obtenerNombreLogro(tipoLogro)}. ¡Sigue así! Prioriza tu bienestar.",
      onPressed: () {
        log.i("Ganaste un logro felicidades");
        Get.back();
      },
    ));
  }
}
