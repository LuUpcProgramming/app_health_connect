import 'dart:async';

import 'package:app_health_connect/config/helper/logging.dart';
import 'package:app_health_connect/data/repositories/history/history_repository.dart';
import 'package:app_health_connect/features/authentication/models/history_advice.dart';
import 'package:app_health_connect/utils/constants/text_strings.dart';
import 'package:app_health_connect/utils/popups/loaders.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';

class AdviceController extends GetxController {
  static AdviceController get instance => Get.find();

  //***************Variables***************/
  final log = logger(AdviceController);
  final selectedYear = '2024'.obs;
  final selectedMonth = TTexts.listaMeses[DateTime.now().month - 1].obs;
  // final _history = Rx<HistoryAdvice?>(null);
  var countHistorialMessages = 0.obs;
  // HistoryAdvice? get historial => _history.value;
  var isLoading = false.obs;
  final currentUser = FirebaseAuth.instance.currentUser;
  //List<HistoryAdviceDetail> listaHistorial = [];
  RxList<HistoryAdviceDetail> listaHistorial = <HistoryAdviceDetail>[].obs;
  //bool _historialCargado = false;
  //Caché
  // DateTime? lastUpdateTime;
  // final cacheDuration = const Duration(minutes: 1); // Duración del caché
  StreamSubscription<DocumentSnapshot>? _subscriptionAdvice;
  final historyRepository = Get.put(HistoryRepository());
  final List<String> years = TTexts.years;
  final List<String> months = TTexts.listaMeses;

  @override
  onInit() {
    super.onInit();
    initializeDateFormatting();
  }

  @override
  void onClose() {
    stopListening();
    super.onClose();
  }

  //***************Métodos***************/

/*   Future<void> cargaHistorialRecomendaciones() async {
    try {
      //Show Dialog
      /* if (listaHistorial.isNotEmpty) {
        if (listaHistorial.length == countHistorialMessages.value) {
          return;
        }
      } */
      isLoading.value = true;
      if (currentUser == null) {
        FirebaseAuth.instance.signOut();
        Loaders.errorSnackBar(
            title: 'No Logueado', message: "Usuario no está autenticado.");
        Get.offAll(() => const LoginScreen());
      }
      log.i("Comienza cargaHistorialRecomendaciones");
      //TFullScreenLoader.openLoadingDialog("Cargando Historial", TImages.avatarLogo);
      final historyRepository = Get.put(HistoryRepository());

      HistoryAdvice dHistory = await historyRepository
          .getHistoryRecommendationByUser(currentUser!.uid.trim());
      //historial?.value = dHistory;
      listaHistorial.value = dHistory.listaHistorialDetalle;
      countHistorialMessages.value = dHistory.listaHistorialDetalle.length;
      log.i("Se cargaron las recomendaciones");
      isLoading.value = false;
    } catch (e) {
      //Show some generic error to user
      log.e("Error: ${e.toString()}");
      Loaders.errorSnackBar(
          title: 'Oh, sucedió un error', message: e.toString());
      throw Exception(e);
    } finally {
      log.i("Finaliza cargaHistorialRecomendaciones");
      //TFullScreenLoader.stopLoading();
    }
  } */

  /* List<HistoryAdviceDetail> get filteredHistorial {
    initializeDateFormatting();
    return listaHistorial.where((advice) {
      final adviceDate = DateFormat("dd/MM/yyyy").parse(advice.date.trim());
      final adviceYear = adviceDate.year.toString();
      final adviceMonth = DateFormat('MMMM', 'es_ES').format(adviceDate);
      return adviceYear == selectedYear.value &&
          adviceMonth == selectedMonth.value;
    }).toList();
  } */

  bool isSubscriptionActive() {
    return _subscriptionAdvice != null && !_subscriptionAdvice!.isPaused;
  }

  void stopListening() {
    log.i("Se canceló stopWeeklyListening");
    _subscriptionAdvice?.cancel();
  }

  void startListeningAdviceRecommendation(DateTime fecInicioMes,DateTime fecFinMes) async {
    log.i(
        "startListeningAdviceRecommendation: Comienza startListeningAdviceRecommendation");
    try {
      isLoading.value = true;
      _subscriptionAdvice =
          historyRepository.listenToAdviceRecommendations().listen((snapshot) {
        if (snapshot.exists) {
          HistoryAdvice dHistory = HistoryAdvice.fromSnapshot(snapshot);
          // historial?.value = dHistory;
          // Filtrar por el mes actual
          DateTime inicioMes = DateTime(fecInicioMes.year, fecInicioMes.month, 1);
          DateTime finMes = DateTime(fecFinMes.year, fecFinMes.month + 1, 1)
              .subtract(const Duration(seconds: 1));

          // Filtrar las recomendaciones del mes actual
          List<HistoryAdviceDetail> listaHistorialFiltrada =
              dHistory.listaHistorialDetalle.where((item) {
            return item.fechaRegistro.isAfter(inicioMes) &&
                item.fechaRegistro.isBefore(finMes);
          }).toList();

          listaHistorialFiltrada.sort((a, b) => b.fechaRegistro.compareTo(a.fechaRegistro));

          listaHistorial.assignAll(listaHistorialFiltrada);
          //countHistorialMessages.value = dHistory.listaHistorialDetalle.length;
          log.i(
              "startListeningAdviceRecommendation: Se cargaron las recomendaciones");
        } else {
          // historial?.value = HistoryAdvice(idUsuario: '0', listaHistorialDetalle: []);
          listaHistorial.value = [];
        }
      });
    } catch (e) {
      log.e("Error: ${e.toString()}");
      Loaders.errorSnackBar(
          title: 'Oh, sucedió un error', message: e.toString());
    } finally {
      isLoading.value = false;
      log.i(
          "startListeningAdviceRecommendation: Termina startListeningAdviceRecommendation");
    }
  }

  // Este método genera el rango de fechas (inicio y fin) según el mes y año seleccionado
  DateTimeRange getSelectedDateRange() {
    int year = int.parse(selectedYear.value); // Obtiene el año seleccionado
    int month = TTexts.obtenerNumeroMes(
        selectedMonth.value); // Convierte el mes seleccionado a número

    // Fecha de inicio del mes
    DateTime startOfMonth = DateTime(year, month, 1);

    // Fecha de fin del mes (el último día del mes)
    DateTime endOfMonth =
        DateTime(year, month + 1, 1).subtract(const Duration(days: 1));

    return DateTimeRange(start: startOfMonth, end: endOfMonth);
  }

  // Método para filtrar las recomendaciones según el rango de fechas seleccionado
  void filterRecommendationsBySelectedDate() {
    DateTimeRange dateRange = getSelectedDateRange();

    // Llama a tu método de filtrado de recomendaciones pasándole el rango de fechas
    /*List<HistoryAdviceDetail> filtro = listaHistorial.where((item) {
      return item.fechaRegistro.isAfter(dateRange.start) &&
          item.fechaRegistro.isBefore(dateRange.end);
    }).toList();
*/
    startListeningAdviceRecommendation(dateRange.start,dateRange.end);

  }
}
