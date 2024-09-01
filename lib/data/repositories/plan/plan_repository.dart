import 'package:app_health_connect/config/helper/logging.dart';
import 'package:app_health_connect/features/authentication/models/plan_diario.dart';
import 'package:app_health_connect/utils/constants/text_strings.dart';
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
      DocumentReference docRef =  _db.collection("PlanDiario").doc();
      plan.idDocumento = docRef.id;
      await docRef.set(plan.toJson());

      //await _db.collection("PlanDiario").add(plan.toJson());
      //.doc(plan.idUsuario)
      //.set(plan.toJson());
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

  Future<void> updateLogro(String documentId, int completada) async {
    try {
      await _db.collection("PlanDiario").doc(documentId).update({
        'completada': completada,
      });
    } on TFirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Algo salió mal, intente de nuevo';
    }
  }

  Future<void> actualizarLogro(String idUsuario, String dia, int completada) async {
    try {
      // Realizar la consulta para obtener el documento que corresponde al usuario y día específicos
      QuerySnapshot querySnapshot = await _db
          .collection('PlanDiario')
          .where('idUsuario', isEqualTo: idUsuario)
          .where('idUsuario', isEqualTo: idUsuario)
          .where('dia', isEqualTo: dia)
          .get();

      // Verificar si se encontró algún documento
      if (querySnapshot.docs.isNotEmpty) {
        // Asumimos que solo hay un documento que cumple con los criterios
        DocumentSnapshot documentSnapshot = querySnapshot.docs.first;

        // Obtener el ID del documento
        String documentId = documentSnapshot.id;

        // Actualizar el campo `completada`
        await _db.collection('PlanDiario').doc(documentId).update({
          'completada': completada,
        });

        log.i('Campo completada actualizado correctamente para el usuario $idUsuario y el día $dia.');
      } else {
        log.i('No se encontró ningún plan diario para el usuario $idUsuario en el día $dia.');
      }
    } catch (e) {
      log.e('Error al actualizar el campo completada: $e');
      throw Exception('Error al actualizar el campo completada.');
    }
  }


  Future<List<PlanDiario>> getPlanesDiariosByUserId(String idUsuario) async {
    final currentDayIndex = DateTime.now().weekday - 1;
    try {
      QuerySnapshot querySnapshot = await _db
          .collection('PlanDiario')
          .where('idUsuario', isEqualTo: idUsuario)
          .where('dia', isEqualTo: TTexts.dias[currentDayIndex].trim())
          .get();

      List<PlanDiario> planesDiarios = querySnapshot.docs.map((doc) {
        return PlanDiario.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();

      return planesDiarios;
    } catch (e) {
      log.i('Error al obtener planes diarios: $e');
      return [];
    }
  }

  Stream<List<PlanDiario>> getStreamPlanesDiariosByUserId(String idUsuario) {
    final currentDayIndex = DateTime.now().weekday - 1;
    try {
      return _db
          .collection('PlanDiario')
          .where('idUsuario', isEqualTo: idUsuario)
          .where('dia', isEqualTo: TTexts.dias[currentDayIndex].trim())
          .snapshots()
          .map((QuerySnapshot querySnapshot) {
            return querySnapshot.docs.map((doc) {
              return PlanDiario.fromMap(doc.data() as Map<String, dynamic>);
            }).toList();
          });
    } catch (e) {
      log.i('Error al obtener planes diarios: $e');
      return Stream.error('Error al obtener planes diarios: $e');
    }
  }






}
