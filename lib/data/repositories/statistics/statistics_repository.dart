
import 'package:app_health_connect/config/helper/logging.dart';
import 'package:app_health_connect/features/authentication/models/statistics.dart';
import 'package:app_health_connect/utils/exceptions/firebase_exceptions.dart';
import 'package:app_health_connect/utils/exceptions/format_exceptions.dart';
import 'package:app_health_connect/utils/exceptions/platform_exceptions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class StatisticsRepository extends GetxController {
  static StatisticsRepository get instance => Get.find();

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final log = logger(StatisticsRepository);
 // final RxBool hasDataChanged = false.obs;

  Future<EstadisticasDiaria> getEstadisticaDiariaPorFecha(String fecha) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> doc = await _db
          .collection('Estadistica')
          .doc('61gBjNkAMk5LfBf5zRty')
          .collection('diario')
          .doc(fecha)
          .get();
      if (doc.exists) {
        log.i('getEstadisticaDiariaPorFecha: ${doc.data().toString()}');
        return EstadisticasDiaria.fromSnapshot(doc);
      } else {
        return EstadisticasDiaria.fromSnapshot(doc);
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
          .doc('61gBjNkAMk5LfBf5zRty')
          .collection('semanal')
          .doc('61gBjNkAMk5LfBf5zRty')
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
          .doc('61gBjNkAMk5LfBf5zRty')
          .collection('semanal')
          .doc('61gBjNkAMk5LfBf5zRty')
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

  Future<void> saveEstadisticaDiaria(
      EstadisticasDiaria estadisticaDiaria, String fecha) async {
    try {
      await _db
          .collection("Estadistica")
          .doc('61gBjNkAMk5LfBf5zRty')
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
          .doc('61gBjNkAMk5LfBf5zRty')
          .collection('semanal')
          .doc('61gBjNkAMk5LfBf5zRty')
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

/*   Stream<bool> listenToWeeklyStatistics() {
    try {
      return _db
          .collection('Estadistica')
          .doc('61gBjNkAMk5LfBf5zRty')
          .collection('semanal')
          .doc('61gBjNkAMk5LfBf5zRty')
          .snapshots()
          .map((snapshot) => snapshot.exists);
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
  } */

  Stream<DocumentSnapshot<Map<String, dynamic>>> listenToWeeklyStatistics() {
    try {
      return _db
          .collection('Estadistica')
          .doc('61gBjNkAMk5LfBf5zRty')
          .collection('semanal')
          .doc('61gBjNkAMk5LfBf5zRty')
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
          .doc('61gBjNkAMk5LfBf5zRty')
          .collection('mensual')
          .doc('61gBjNkAMk5LfBf5zRty')
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

/*   Future<bool> validarUltimaEjecucionStats(String userId) async {
    try {
      bool resultado = true;
      DocumentSnapshot<Map<String, dynamic>> doc = await _db
          .collection('Estadistica')
          .doc('61gBjNkAMk5LfBf5zRty')
          .isBlank;

      return doc.exists;
    } on TFirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Algo salió mal, intente de nuevo';
    }
  } */
}
