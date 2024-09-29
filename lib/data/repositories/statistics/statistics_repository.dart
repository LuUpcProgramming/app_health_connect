import 'package:app_health_connect/config/helper/logging.dart';
import 'package:app_health_connect/data/repositories/authentication/authentication_repository.dart';
import 'package:app_health_connect/data/repositories/history/history_repository.dart';
import 'package:app_health_connect/data/repositories/plan/plan_repository.dart';
import 'package:app_health_connect/features/authentication/models/history_advice.dart';
import 'package:app_health_connect/features/authentication/models/plan_diario.dart';
import 'package:app_health_connect/features/authentication/models/statistics.dart';
import 'package:app_health_connect/utils/constants/text_strings.dart';
import 'package:app_health_connect/utils/exceptions/firebase_exceptions.dart';
import 'package:app_health_connect/utils/exceptions/format_exceptions.dart';
import 'package:app_health_connect/utils/exceptions/platform_exceptions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class StatisticsRepository extends GetxController {
  static StatisticsRepository get instance => Get.find();

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final log = logger(StatisticsRepository);
  final currentUser = AuthenticationRepository.instance.authUser?.uid;
  // final RxBool hasDataChanged = false.obs;

  Future<EstadisticasDiaria?> getEstadisticaDiariaPorFecha(String fecha) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> doc = await _db
          .collection('Estadistica')
          // .doc('61gBjNkAMk5LfBf5zRty')
          .doc(currentUser ?? '0')
          .collection('diario')
          .doc(fecha)
          .get();
      if (doc.exists) {
        //log.i('getEstadisticaDiariaPorFecha: ${doc.data().toString()}');
        return EstadisticasDiaria.fromSnapshot(doc);
      } else {
        return null;
      }
    } on TFirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'getEstadisticaDiariaPorFecha: Algo salió mal, intente de nuevo';
    }
  }

  Future<EstadisticasSemanal> getEstadisticaSemanal() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> doc = await _db
          .collection('Estadistica')
          .doc(currentUser ?? '0')
          //.doc('61gBjNkAMk5LfBf5zRty')
          .collection('semanal')
          .doc(currentUser ?? '0')
          //.doc('61gBjNkAMk5LfBf5zRty')
          .get();
      if (doc.exists) {
        log.i('getEstadisticaDiariaPorFecha: ${doc.data().toString()}');
        return EstadisticasSemanal.fromSnapshot(doc);
      } else {
        return EstadisticasSemanal.fromSnapshot(doc);
      }
    } on TFirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'getEstadisticaSemanal: Algo salió mal, intente de nuevo';
    }
  }

  Future<bool> checkExistsEstadisticaSemanal() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> doc = await _db
          .collection('Estadistica')
          .doc(currentUser ?? '0')
          //.doc('61gBjNkAMk5LfBf5zRty')
          .collection('semanal')
          //.doc('61gBjNkAMk5LfBf5zRty')
          .doc(currentUser ?? '0')
          .get();
      if (doc.exists) {
        log.i('checkExistsEstadisticaSemanal: ${doc.data().toString()}');
        return true;
      } else {
        return false;
      }
    } on TFirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'checkExistsEstadisticaSemanal: Algo salió mal, intente de nuevo';
    }
  }

  Future<void> saveEstadisticaDiaria(EstadisticasDiaria estadisticaDiaria,
      String fecha, String idUsuario) async {
    try {
      await _db
          .collection("Estadistica")
          //.doc('61gBjNkAMk5LfBf5zRty')
          .doc(idUsuario)
          .collection('diario')
          .doc(fecha)
          .set(estadisticaDiaria.toJson());
      // .set(estadisticaSemanal.toJson(), SetOptions(merge: true));
    } on TFirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'saveEstadisticaDiaria: Algo salió mal, intente de nuevo';
    }
  }

  Future<void> saveEstadisticaSemanal(
      EstadisticasSemanal estadisticaSemanal) async {
    try {
      await _db
          .collection("Estadistica")
          //.doc('61gBjNkAMk5LfBf5zRty')
          .doc(currentUser ?? '0')
          .collection('semanal')
          //.doc('61gBjNkAMk5LfBf5zRty')
          .doc(currentUser ?? '0')
          .set(estadisticaSemanal.toJson());
      // .set(estadisticaSemanal.toJson(), SetOptions(merge: true));
    } on TFirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Algo salió mal, intente de nuevo';
    }
  }

  Future<void> saveEstadisticaMensual(
      EstadisticasSemanal estadisticaMensual) async {
    try {
      await _db
          .collection("Estadistica")
          //.doc('61gBjNkAMk5LfBf5zRty')
          .doc(currentUser ?? '0')
          .collection('mensual')
          //.doc('61gBjNkAMk5LfBf5zRty')
          .doc(currentUser ?? '0')
          .set(estadisticaMensual.toJson());
      // .set(estadisticaSemanal.toJson(), SetOptions(merge: true));
    } on TFirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Algo salió mal, intente de nuevo';
    }
  }

  Future<void> updatePlanesEstadisticaDiaria(
      String idUsuario, String fecha, EstadisticasDiaria stat) async {
    try {
      await _db
          .collection("Estadistica")
          .doc(idUsuario)
          .collection("diario")
          .doc(fecha)
          .update({
        'cantPlanCumplido': stat.cantPlanCumplido,
        'cantPlanTotal': stat.cantPlanTotal,
        'logros': stat.logros,
      });
    } on TFirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Algo salió mal, intente de nuevo';
    }
  }

  Future<void> updateRecomendacionEstadisticaDiaria(
      String idUsuario, String fecha, EstadisticasDiaria stat) async {
    try {
      await _db
          .collection("Estadistica")
          .doc(idUsuario)
          .collection("diario")
          .doc(fecha)
          .update({
        'estadoAnimo': stat.estadoAnimo,
        'descripcionAnimo': stat.descripcionAnimo
      });
    } on TFirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Algo salió mal, intente de nuevo';
    }
  }


  Stream<DocumentSnapshot<Map<String, dynamic>>> listenToWeeklyStatistics() {
    try {
      return _db
          .collection('Estadistica')
          //.doc('61gBjNkAMk5LfBf5zRty')
          .doc(AuthenticationRepository.instance.authUser?.uid ?? '0')
          .collection('semanal')
          .doc(AuthenticationRepository.instance.authUser?.uid ?? '0')
          .snapshots();
    } on TFirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      log.e("Error al escuchar cambios: ${e.toString()}");
      return const Stream.empty();
    }
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> listenToMonthlyStatistics() {
    try {
      return _db
          .collection('Estadistica')
          //.doc('61gBjNkAMk5LfBf5zRty')
          .doc(currentUser ?? '0')
          .collection('mensual')
          .doc(currentUser ?? '0')
          .snapshots();
    } on TFirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      log.e("Error al escuchar cambios: ${e.toString()}");
      return const Stream.empty();
    }
  }


  Future<int> getCantidadEstadisticasDiariasPorUsuario() async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot = await _db
          .collection('Estadistica')
          // .doc('61gBjNkAMk5LfBf5zRty')
          .doc(currentUser ?? '0')
          .collection('diario')
          .get();
      return snapshot.docs.length;
    } on TFirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'getEstadisticaDiariaPorFecha: Algo salió mal, intente de nuevo';
    }
  }

  //Carga de Estadisticas
  Future<void> cargaEstadisticas() async {
    try {
      List<EstadisticasDiaria> semanaEstadisticas = [];
      DateTime hoy = DateTime.now();

      int diaSemana = hoy.weekday;
      DateTime lunes = hoy.subtract(Duration(days: diaSemana - 1));
      List<DateTime> semana =
          List.generate(7, (index) => lunes.add(Duration(days: index)));

      for (var dia in semana) {
        //DateTime fecha = hoy.subtract(Duration(days: i));
        String fechaFormato = DateFormat('yyyy-MM-dd').format(dia);

        EstadisticasDiaria? obj =
            await getEstadisticaDiariaPorFecha(fechaFormato);
        if (obj != null) {
          semanaEstadisticas.add(obj);
        } else {
          var estadisticaDiaria = EstadisticasDiaria(
            fecha: fechaFormato,
            estadoAnimo: TTexts.sinRegistros,
            descripcionAnimo: TTexts.sinRegistros,
            cantPlanTotal: 0,
            cantPlanCumplido: 0,
            logros: [],
            fechaRegistro: DateTime.parse(fechaFormato),
          );
          await saveEstadisticaDiaria(estadisticaDiaria, fechaFormato,currentUser ?? '0');
          semanaEstadisticas.add(estadisticaDiaria);
        }
      }
    } catch (e) {
      log.e("Error: cargaEstadisticas:  ${e.toString()}");
      throw Exception(e);
    }
  }

  Future<void> procesarPlanesEstadisticaDiaria(DateTime fecha) async {
    log.i("procesarPlanesEstadisticaDiaria: Inicio");
    try {
      String fechaRegistro = DateFormat('yyyy-MM-dd').format(fecha);
      final planRepository = Get.put(PlanRepository());
      var planes = await planRepository.obtenerPlanesDiariosPorUsuarioFechaPlan(currentUser ?? '0',fechaRegistro);

      // Calcular la cantidad total de planes
      int totalPlanes = planes.length;
      // Filtrar los planes cumplidos (estadoPlan == 1)
      List<PlanDiario> planesCumplidos = planes
          .where((plan) => plan.estadoPlan == TTexts.estadoCompletado)
          .toList();

      // Calcular la cantidad de planes cumplidos
      int totalPlanesCumplidos = planesCumplidos.length;
      // Obtener la lista de tipoLogro de los planes cumplidos
      List<int> tipoLogrosCumplidos =
          planesCumplidos.map((plan) => plan.tipoLogro).toList();


      var estadisticaDiaria = EstadisticasDiaria(
        fecha: fechaRegistro,
        cantPlanTotal: totalPlanes,
        cantPlanCumplido: totalPlanesCumplidos,
        logros: tipoLogrosCumplidos,
        fechaRegistro: fecha,
      );

      await updatePlanesEstadisticaDiaria(currentUser ?? '0', fechaRegistro, estadisticaDiaria);

       Get.delete<PlanRepository>();    
      log.i("procesarPlanesEstadisticaDiaria: Se registró la estadística diaria");
    } catch (e) {
      log.e("Error: ${e.toString()}");
      throw Exception(e);
    } finally {
      log.i("procesarPlanesEstadisticaDiaria: Fin");
    }
  }

   Future<void> procesarRecomendacionEstadisticaDiaria(DateTime fecha) async {
    log.i("procesarRecomendacionEstadisticaDiaria: Inicio");
    try {
      String fechaRegistro = DateFormat('yyyy-MM-dd').format(fecha);
       final historyRepository = Get.put(HistoryRepository());
      HistoryAdviceDetail? historyAdviceDetail = await historyRepository
          .obtenerHistorialRecomendacion(currentUser ?? '0', fecha);


      var estadisticaDiaria = EstadisticasDiaria(
        fecha: fechaRegistro,
        estadoAnimo: historyAdviceDetail?.estadoAnimo ?? '',
        descripcionAnimo: historyAdviceDetail?.title ?? '',
        fechaRegistro: fecha,
      );

      await updateRecomendacionEstadisticaDiaria(currentUser ?? '0', fechaRegistro, estadisticaDiaria);

       Get.delete<HistoryRepository>();    
      log.i("procesarRecomendacionEstadisticaDiaria: Se registró la estadística diaria");
    } catch (e) {
      log.e("Error: ${e.toString()}");
      throw Exception(e);
    } finally {
      log.i("procesarRecomendacionEstadisticaDiaria: Fin");
    }
  }
}
