import 'package:app_health_connect/config/helper/logging.dart';
import 'package:app_health_connect/features/authentication/models/plan_diario.dart';
import 'package:app_health_connect/utils/exceptions/firebase_exceptions.dart';
import 'package:app_health_connect/utils/exceptions/format_exceptions.dart';
import 'package:app_health_connect/utils/exceptions/platform_exceptions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class PlanRepository extends GetxController {
   static PlanRepository get instance => Get.find();

   final FirebaseFirestore _db = FirebaseFirestore.instance;
  final log = logger(PlanRepository);

  Future<void> savePlanDiario(PlanDiario plan) async {
    try {
      await _db
          .collection("PlanDiario")
          .doc(plan.idUsuario)
          .set(plan.toJson());
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

}

