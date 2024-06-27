import 'package:app_health_connect/config/helper/logging.dart';
import 'package:app_health_connect/data/repositories/history/history_repository.dart';
import 'package:app_health_connect/features/authentication/models/history_advice.dart';
import 'package:app_health_connect/features/authentication/screens/login/login.dart';
import 'package:app_health_connect/utils/popups/loaders.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class AdviceController extends GetxController {
  static AdviceController get instance => Get.find();

  //***************Variables***************/
  final log = logger(AdviceController);
  final selectedYear = '2024'.obs;
  final selectedMonth = 'junio'.obs;
  final _history = Rx<HistoryAdvice?>(null);
  var countHistorialMessages = 0.obs;
  HistoryAdvice? get historial => _history.value;
  var isLoading = true.obs;
  final currentUser = FirebaseAuth.instance.currentUser;
  //List<HistoryAdviceDetail> listaHistorial = [];
  RxList<HistoryAdviceDetail> listaHistorial = <HistoryAdviceDetail>[].obs;
  //bool _historialCargado = false;
  //Caché
  // DateTime? lastUpdateTime;
  // final cacheDuration = const Duration(minutes: 1); // Duración del caché

  final List<String> years = ['2024', '2025', '2026', '2027'];
  final List<String> months = [
    'enero',
    'febrero',
    'marzo',
    'abril',
    'mayo',
    'junio',
    'julio',
    'agosto',
    'septiembre',
    'octubre',
    'noviembre',
    'diciembre'
  ];

/*   @override
  void onInit() {
    super.onInit();
    /* WidgetsBinding.instance.addPostFrameCallback((_) {
      cargaHistorialRecomendaciones();
    }); */
    //TODO: Descomentar si se necesita optimizar llamado de data
    /* ever(selectedYear, (value) => refreshIfNeeded());
    ever(selectedMonth, (value) => refreshIfNeeded()); */
  }
 */
  //TODO: Descomentar si se necesita optimizar llamado de data
  /*   void refreshIfNeeded() {
    if (lastUpdateTime == null || DateTime.now().difference(lastUpdateTime!) > cacheDuration) {
      cargaHistorialRecomendaciones();
    }
  } */

/*   final List<HistoryAdviceDetail> lista = [
    HistoryAdviceDetail(
        title: 'Practica la Respiración Profunda',
        description:
            'Cuando sientas el peso del estrés, recuerda el poder de la respiración profunda. En cada inhalación, encuentras calma; en cada exhalación, liberas tensión.',
        date: '29 Mie'),
    HistoryAdviceDetail(
        title: 'Meditación por las mañanas',
        description:
            'Comienza cada mañana con la tranquilidad que solo la meditación puede brindarte. Al dedicar unos minutos a calmar tu mente, estableces un poderoso precedente para el día.',
        date: '28 Mar'),
    HistoryAdviceDetail(
        title: 'No descuides tu alimentación',
        description:
            'Incluso en los momentos mas estresantes, recuerda que tu cuerpo es aliado mas importante. Alimentarte adecuadamente te brinda la energía y la claridad mental que necesitas para superar cualquier obstáculo.',
        date: '27 Lun'),
    HistoryAdviceDetail(
        title: 'Practica la Respiración Profunda',
        description:
            'Cuando sientas el peso del estrés, recuerda el poder de la respiración profunda. En cada inhalación, encuentras calma; en cada exhalación, liberas tensión.',
        date: '26 Dom'),
    HistoryAdviceDetail(
        title: 'Meditación por las mañanas',
        description:
            'Comienza cada mañana con la tranquilidad que solo la meditación puede brindarte. Al dedicar unos minutos a calmar tu mente, estableces un poderoso precedente para el día.',
        date: '25 Sab'),
    HistoryAdviceDetail(
        title: 'No descuides tu alimentación',
        description:
            'Incluso en los momentos mas estresantes, recuerda que tu cuerpo es aliado mas importante. Alimentarte adecuadamente te brinda la energía y la claridad mental que necesitas para superar cualquier obstáculo.',
        date: '24 Vie'),
  ]; */
  @override
  onInit() {
    super.onInit();
    initializeDateFormatting();
  }

  //***************Métodos***************/

  Future<void> cargaHistorialRecomendaciones() async {
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
      historial?.value = dHistory;
      listaHistorial.value = dHistory.listaHistorialDetalle;
      countHistorialMessages.value = dHistory.listaHistorialDetalle.length;
      //TODO: Descomentar si se necesita optimizar llamado de data
      //lastUpdateTime = DateTime.now();
      log.i("Se cargaron las recomendaciones");
      isLoading.value = false;
      //TFullScreenLoader.stopLoading();
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
  }

  List<HistoryAdviceDetail> get filteredHistorial {
    initializeDateFormatting();
    return listaHistorial.where((advice) {
      final adviceDate = DateFormat("dd/MM/yyyy").parse(advice.date.trim());
      final adviceYear = adviceDate.year.toString();
      final adviceMonth = DateFormat('MMMM', 'es_ES').format(adviceDate);
      return adviceYear == selectedYear.value &&
          adviceMonth == selectedMonth.value;
    }).toList();
  }

  /*  void getHistoryStream(String userId) {
    FirebaseFirestore.instance
        .collection('History')
        .where('idUsuario', isEqualTo: userId)
        .snapshots()
        .listen((QuerySnapshot snapshot) {
      listaHistorial.clear();
      for (var document in snapshot.docs) {
        listaHistorial.add(HistoryAdviceDetail.fromJson(document.data() as Map<String, dynamic>));
      }
    });
  } */
}
