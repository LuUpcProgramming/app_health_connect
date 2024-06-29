import 'package:app_health_connect/config/helper/logging.dart';
import 'package:app_health_connect/data/repositories/user/user_repository.dart';
import 'package:app_health_connect/features/authentication/models/user_detail.dart';
import 'package:app_health_connect/features/authentication/models/user_model.dart';
import 'package:app_health_connect/utils/constants/colors.dart';
import 'package:app_health_connect/utils/constants/image_strings.dart';
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

  //***************Métodos***************/

  @override
  void onInit() {
    super.onInit();
    //cargaDatosDashboard();
    log.i("Inicio onINIT");
    WidgetsBinding.instance.addPostFrameCallback((_) {
      log.i("Ingresa a cargaDatosUsuario");
      cargaDatosUsuario();
    });
  }


  //Cargas Data
 /*  Future<void> cargaDatosDashboard() async {
    try {
      TFullScreenLoader.openLoadingDialog("Cargando Datos", TImages.loadingAnimation);
      log.i("Comienza cargaDatosDashboard");
      await cargaDatosUsuario();
      await cargaDatosDetalleUsuario();
      TFullScreenLoader.stopLoading();
      log.i("Finaliza cargaDatosDashboard");
    } catch (e) {
      //Show some generic error to user
      log.e("Error en cargaDatosDashboard");
      log.e("Error: ${e.toString()}");
      TFullScreenLoader.stopLoading();
      Loaders.errorSnackBar(
          title: 'Oh, sucedió un error', message: e.toString());
      throw Exception(e);
    }
  } */

  Future<void> cargaDatosUsuario() async {
    try {
      //Show Dialog
      log.i("Comienza cargaDatosUsuario");
      profileLoading.value = true;
      TFullScreenLoader.openLoadingDialog("Espere por favor...", TImages.loadingAnimation);
      final currentUser = FirebaseAuth.instance.currentUser;
      log.i('currentUser: $currentUser');
      if (currentUser != null) {
        final userRepository = Get.put(UserRepository());
        final duserdetail =
            await userRepository.getUserDetails(currentUser.uid.trim());
        _detalleUsuario.value = duserdetail;
        //inal user = await userRepository.getUserRecord(currentUser.uid.trim());
        final user = await userRepository.fethUserRecord();
        usuario(user);
        //usuario.value = user;
        log.i("Se cargaron datos de usuario");
       // Get.delete<UserRepository>();
      } else {
        /* log.e("Usuario no está autenticado");
        FirebaseAuth.instance.signOut();
        Loaders.errorSnackBar(
            title: 'No Logueado', message: "Usuario no está autenticado.");
        Get.offAll(() => const LoginScreen()); */
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
      log.i("Finaliza cargaDatosUsuario");
      TFullScreenLoader.stopLoading();
      _showDialog(Get.context!);
      //_showDialog(Get.context!);
    }
  }

  Future<void> cargaDatosDetalleUsuario() async {
    try {
      //Show Dialog
      final currentUser = FirebaseAuth.instance.currentUser;
      log.i('currentUser: $currentUser');
      if (currentUser != null) {
        final userRepository = Get.put(UserRepository());
        UserDetail duser =
            await userRepository.getUserDetails(currentUser.uid.trim());
        _detalleUsuario.value = duser;
        log.i('Detalles del usuario cargados: ${duser.toString()}');
        Get.delete<UserRepository>();
      } else {
        throw Exception('Usuario no está logueado');
      }
    } catch (e) {
      log.e('Error en cargaDatosDetalleUsuario');
      log.e("Error: ${e.toString()}");
      //Show some generic error to user
      Loaders.errorSnackBar(
          title: 'Oh, sucedió un error', message: e.toString());
      throw Exception(e);
    }
  }

  void setAnalysisResponse(String response) {
    analysisResponse.value = response;
  }

  Future<void> actualizarEstadoDialog() async {
    /* final currentUser = FirebaseAuth.instance.currentUser;
     final usuario = UserDetail(
          idUsuario: currentUser?.uid ?? "0",
          genero: detailuser!.genero,
          fechaNacimiento: detailuser!.fechaNacimiento,
          altura: detailuser!.altura,
          peso: detailuser!.peso,
          ocupacion: detailuser!.ocupacion,
          modalidadTrabajo: detailuser!.modalidadTrabajo,
          horasTrabajo: detailuser!.horasTrabajo,
          tipoHorasTrabajo: detailuser!.tipoHorasTrabajo,
          tipoContrato: detailuser!.tipoContrato,
          turnoTrabajo: detailuser!.turnoTrabajo,
          opcionesSalud: detailuser!.opcionesSalud,
          analisisIA:detailuser!.analisisIA,
          estadoDialogAnalisisIA: false); */
    log.i("Comienza actualizarEstadoDialog");
    detailuser!.estadoDialogAnalisisIA = false;
    final userRepository = Get.put(UserRepository());
    await userRepository.saveUserDetails(detailuser!);
    Get.delete<UserRepository>();
    log.i("Termina actualizarEstadoDialog");
  }

  Future<void> _showDialog(BuildContext context) async {
    // Mostrar el diálogo si hay una respuesta analítica
    //WidgetsBinding.instance.addPostFrameCallback((_) {
    log.i("Comienza _showDialog");
    if (detailuser != null) {
      if (detailuser!.estadoDialogAnalisisIA) {
        if (dialogState.value) {
          log.i("Ingresa a showDialogEvaluacionPreliminar");
          showDialogEvaluacionPreliminar(context, detailuser!);
          dialogState.value = false;
          actualizarEstadoDialog();
        }

        //Actualizar estado de visualización
      }
    }
    log.i("Termina _showDialog");
    //});
  }

  Future<dynamic> showDialogEvaluacionPreliminar(
      BuildContext context, UserDetail dt) {
    List<String> lista = dt.analisisIA.split('|');
    log.i("showDialogEvaluacionPreliminar: ${lista.toString()}");
    log.i("showDialogEvaluacionPreliminar: Construye Widget dialog");
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            height: 500, // Puedes ajustar la altura según tus necesidades
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
                          lista[0].trim(),
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


}
