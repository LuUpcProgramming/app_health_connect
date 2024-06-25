import 'package:app_health_connect/config/helper/logging.dart';
import 'package:app_health_connect/features/authentication/models/history_advice.dart';
import 'package:app_health_connect/utils/exceptions/firebase_exceptions.dart';
import 'package:app_health_connect/utils/exceptions/format_exceptions.dart';
import 'package:app_health_connect/utils/exceptions/platform_exceptions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class HistoryRepository extends GetxController {
  static HistoryRepository get instance => Get.find();

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final log = logger(HistoryRepository);


   Future<HistoryAdvice> getHistoryRecommendationByUser(String userId) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> doc =
          await _db.collection("History").doc(userId).get();
      if (doc.exists) {
        return HistoryAdvice.fromSnapshot(doc);
      } else {
        return HistoryAdvice.fromSnapshot(doc);
        //throw Exception('Error en obtener historial de recomendaciones');
      }
    } on TFirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Algo salió mal, intente de nuevo $e';
    }
  }



}
