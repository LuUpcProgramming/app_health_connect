import 'dart:async';

import 'package:app_health_connect/config/helper/logging.dart';
import 'package:app_health_connect/data/repositories/plan/plan_repository.dart';
import 'package:app_health_connect/data/repositories/user/user_repository.dart';
import 'package:app_health_connect/features/authentication/models/plan_diario.dart';
import 'package:app_health_connect/features/authentication/models/recomendacion.dart';
import 'package:app_health_connect/features/authentication/models/user_detail.dart';
import 'package:app_health_connect/features/authentication/models/user_model.dart';
import 'package:app_health_connect/features/authentication/screens/dashboard/widgets/confirm_logro_dialog.dart';
import 'package:app_health_connect/features/authentication/screens/login/login.dart';
import 'package:app_health_connect/features/authentication/screens/plan/plan_detalle.dart';
import 'package:app_health_connect/utils/constants/colors.dart';
import 'package:app_health_connect/utils/constants/image_strings.dart';
import 'package:app_health_connect/utils/constants/text_strings.dart';
import 'package:app_health_connect/utils/popups/full_screen_loader.dart';
import 'package:app_health_connect/utils/popups/loaders.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DashboardController extends GetxController {
  static DashboardController get instance => Get.find();

  //***************Variables***************/
  final log = logger(DashboardController);
  Rx<UserModel?> usuario = UserModel.empty().obs;
  //UserModel? get user => usuario.value;
  final _detalleUsuario = Rx<UserDetail?>(null);
  UserDetail? get detailuser => _detalleUsuario.value;

  final analysisResponse = Rx<String?>(null);
  final analisiIA = ''.obs;
  var dialogState = true.obs;
  var profileLoading = false.obs;

  final RxList<PlanDiario> planes = <PlanDiario>[].obs;
  RxList<PlanDiario> planesConfirmar = <PlanDiario>[].obs;
  RxList<Recomendacion> tipsRecomendaciones = <Recomendacion>[].obs;
  StreamSubscription? _subscriptionPlaDiario;
  RxList<Recomendacion> recomendaciones = <Recomendacion>[].obs;
  var isLoading = true.obs;
  var isLoadingPlanes = false.obs;
  var isLoadingRecomendaciones = false.obs;

  //***************Métodos***************/

  @override
  void onInit() {
    super.onInit();
    //cargaDatosDashboard();
    log.i("Inicio onINIT");
    WidgetsBinding.instance.addPostFrameCallback((_) {
      log.i("Ingresa a loadData");
      loadData();
    });
  }

  Future<void> loadData() async {
    try {
      //Show Dialog
      log.i("loadData: Comienza loadData");
      profileLoading.value = true;
      isLoadingRecomendaciones.value = true;
      TFullScreenLoader.openLoadingDialog(
          "Espere por favor...", TImages.loadingAnimation);
      final currentUser = FirebaseAuth.instance.currentUser;
      log.i('loadData: currentUser: $currentUser');
      if (currentUser != null) {
        final userRepository = Get.put(UserRepository());
        final duserdetail = await userRepository.getUserDetails(currentUser.uid.trim());
        _detalleUsuario.value = duserdetail;
        //inal user = await userRepository.getUserRecord(currentUser.uid.trim());
        final user = await userRepository.fethUserRecord();
        usuario(user);
        //usuario.value = user;
        log.i("loadData: Se cargaron datos de usuario");
        final planRepository = Get.put(PlanRepository());
        List<PlanDiario> planes = await planRepository
            .getPlanesDiariosParaConfirmacion(currentUser.uid.trim());
        planesConfirmar.assignAll(planes);
        List<Recomendacion> recomendaciones = await planRepository.getRecomendaciones(currentUser.uid.trim());     
        tipsRecomendaciones.assignAll(recomendaciones);
        isLoadingRecomendaciones.value = false;
        listarPlanes(currentUser.uid.trim());
      } else {
        FirebaseAuth.instance.signOut();
        Get.offAll(() => const LoginScreen());
        throw Exception('Usuario no está logueado');
      }
      //TFullScreenLoader.stopLoading();
    } catch (e) {
      //Show some generic error to user
      log.e("Error: ${e.toString()}");
      usuario(UserModel.empty());
      Loaders.errorSnackBar(
          title: 'Oh, sucedió un error', message: e.toString());
      throw Exception(e);
    } finally {
      profileLoading.value = false;
      log.i("loadData: Finaliza loadData");
      TFullScreenLoader.stopLoading();
      checkDialogIA(Get.context!);
      log.i('loadData: planesConfirmar: $planesConfirmar');
      if (planesConfirmar.isNotEmpty) {
        showLogrosPorConfirmarDialog();
      }
    }
  }

  void setAnalysisResponse(String response) {
    analysisResponse.value = response;
  }

  Future<void> actualizardataUserDetail() async {
    log.i("Comienza actualizarEstadoDialog");
    detailuser!.estadoDialogAnalisisIA = false;
    final userRepository = Get.put(UserRepository());
    await userRepository.saveUserDetails(detailuser!);
    Get.delete<UserRepository>();
    log.i("Termina actualizarEstadoDialog");
  }

  Future<void> checkDialogIA(BuildContext context) async {
    // Mostrar el diálogo si hay una respuesta analítica
    //WidgetsBinding.instance.addPostFrameCallback((_) {
    log.i("Comienza _showDialog");
    if (detailuser != null) {
      if (detailuser!.estadoDialogAnalisisIA) {
        if (dialogState.value) {
          log.i("Ingresa a showDialogEvaluacionPreliminar");
          showDialogEvaluacionPreliminar(context, detailuser!);
          dialogState.value = false;
          actualizardataUserDetail();
        }

        //Actualizar estado de visualización
      }
    }
    log.i("Termina _showDialog");
    //});
  }

  Future<dynamic> showDialogEvaluacionPreliminar(
      BuildContext context, UserDetail dt) {
    log.i("showDialogEvaluacionPreliminar: Construye Widget dialog");
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            height: 550, // Puedes ajustar la altura según tus necesidades
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            //padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: const BoxDecoration(
                      color: TColors.primary,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Evaluación Preliminar",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            IconButton(
                              icon:
                                  const Icon(Icons.close, color: Colors.white),
                              onPressed: () => Navigator.pop(context),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  //Text("Personal: ${analisis.personal}"),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          //"Eres una Persona joven Llena de Vitalidad",
                          dt.analisisIA,
                          textAlign: TextAlign.justify,
                          style: const TextStyle(
                              fontSize: 18, fontStyle: FontStyle.italic),
                          softWrap: true,
                        ),
                        const SizedBox(height: 10),
                        const Center(
                          child: Text(
                            "¡Comencemos el viaje a tu bienestar y tranquilidad mental!",
                            // lista[4].trim(),
                            style: TextStyle(
                                fontSize: 18,
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.w700),
                            softWrap: true,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  //Metodos sobre Planes Diarios
  void showPlanDetalle(PlanDiario plan) {
    //_subscriptionPlaDiario?.cancel();

    Get.to(
      () => const PlanDiarioDetalle(),
      transition: Transition.rightToLeft, // Transición de deslizar
      duration: const Duration(milliseconds: 500), // Duración de la transición
    );
  }

  void listarPlanes(String userId) async {
    isLoading.value = true;

    final planDiarioRepository = Get.put(PlanRepository());
    // Escuchar el stream de Firestore y actualizar la lista reactiva
    _subscriptionPlaDiario = planDiarioRepository
        .getStreamPlanesDiariosByUserIdDiaLogro(userId)
        .listen((listaPlanes) {
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
        return a.hora.compareTo(b.hora);
      });

      planes.assignAll(planesLocal);
    }, onError: (error) {
      log.i("Error al obtener planes diarios: $error");
    });
    log.i(planes.toString());
    isLoading.value = false;
  }

  void showLogrosPorConfirmarDialog() {
    Get.dialog(
        ConfirmLogroDialog(
          controller: Get.find<DashboardController>(),
          onPressed: () => procesarPlanesConfirmar(),
        ),
        barrierDismissible: false);
  }

  void togglePlanesConfirmar(int index) {
    planesConfirmar[index].estadoPlan =
        planesConfirmar[index].estadoPlan == TTexts.estadoPendiente
            ? TTexts.estadoCompletado
            : TTexts.estadoPendiente;
    planesConfirmar.refresh();
  }

  void procesarPlanesConfirmar() async {
    bool todosIncompletos = planesConfirmar
        .every((plan) => plan.estadoPlan == TTexts.estadoPendiente);
    final planRepository = Get.put(PlanRepository());
    isLoadingPlanes.value = true;

    for (var plan in planesConfirmar) {
      if (plan.estadoPlan == TTexts.estadoPendiente) {
        plan.estadoPlan = TTexts.estadoIncompleto;
      }
      planRepository.updateEstadoCompletado(plan.idDocumento, plan.estadoPlan);
    }
    log.i("Planes Confirmados Exitosamente");
    isLoadingPlanes.value = false;
    Get.back();

    if (todosIncompletos) {
      Loaders.customSnackBar(
          title: 'No cumpliste ninguna Meta 😢',
          message: 'No te desanimes y sigue adelante. Confía en ti. Tu puedes!',
          color: const Color.fromARGB(242, 33, 148, 158));
      return;
    } else {
      Loaders.successSnackBar(
          title: 'Planes Confirmados Exitosamente 😀',
          message:
              'No olvides de seguir cumpliendo tus metas. ¡Sigue adelante!');
    }
  }

/*   void showRecomendacionDialog(Recomendacion recomendacion) {
    Get.dialog(
      AlertDialog(
        title: Text(recomendacion.titulo),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(recomendacion.descripcion),
            const SizedBox(height: 10),
            Text(recomendacion.descripcion2, style: const TextStyle(fontStyle: FontStyle.italic)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }
 */

  List<Recomendacion> recomendacionesPrueba = [
    Recomendacion(
      idDocumento: '12345',
      idUsuario: 'u123',
      titulo: 'Hacer ejercicio',
      descripcion: [
        'Establecer rutina',
        'Hacer 30 minutos de cardio',
        'Realizar estiramientos'
      ],
      beneficios: [
        'Mejora el estado físico',
        'Reduce el estrés',
        'Aumenta la energía'
      ],
      fechaRegistro: '2024-09-10',
      horaRegistro: '08:00',
    ),
    Recomendacion(
      idDocumento: '12345',
      idUsuario: 'u123',
      titulo: 'Hacer ejercicio',
      descripcion: [
        'Establecer rutina',
        'Hacer 30 minutos de cardio',
        'Realizar estiramientos'
      ],
      beneficios: [
        'Mejora el estado físico',
        'Reduce el estrés',
        'Aumenta la energía'
      ],
      fechaRegistro: '2024-09-10',
      horaRegistro: '08:00',
    ),
    Recomendacion(
      idDocumento: '12345',
      idUsuario: 'u123',
      titulo: 'Hacer ejercicio',
      descripcion: [
        'Establecer rutina',
        'Hacer 30 minutos de cardio',
        'Realizar estiramientos'
      ],
      beneficios: [
        'Mejora el estado físico',
        'Reduce el estrés',
        'Aumenta la energía'
      ],
      fechaRegistro: '2024-09-10',
      horaRegistro: '08:00',
    ),
  ];

 
}
