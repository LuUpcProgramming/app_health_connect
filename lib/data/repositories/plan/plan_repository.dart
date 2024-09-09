import 'package:app_health_connect/config/helper/logging.dart';
import 'package:app_health_connect/features/authentication/models/plan_diario.dart';
import 'package:app_health_connect/features/authentication/models/recomendacion.dart';
import 'package:app_health_connect/utils/constants/text_strings.dart';
import 'package:app_health_connect/utils/exceptions/firebase_exceptions.dart';
import 'package:app_health_connect/utils/exceptions/format_exceptions.dart';
import 'package:app_health_connect/utils/exceptions/platform_exceptions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

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

  Future<void> updateEstadoCompletado(String documentId, int estadoPlan) async {
    try {
      await _db.collection("PlanDiario").doc(documentId).update({
        'estadoPlan': estadoPlan,
      });
    } on TFirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Algo salió mal, intente de nuevo';
    }
  }


  Future<List<PlanDiario>> getPlanesDiariosByUserId(String idUsuario) async {
    final currentDayIndex = DateTime.now().weekday - 1;
    try {
      QuerySnapshot querySnapshot = await _db
          .collection('PlanDiario')
          .where('idUsuario', isEqualTo: idUsuario)
          .where('diaPlan', isEqualTo: TTexts.dias[currentDayIndex].trim())
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
          .where('diaPlan', isEqualTo: TTexts.dias[currentDayIndex].trim())
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

   Stream<List<PlanDiario>> getStreamPlanesDiariosByUserIdDiaLogro(String idUsuario) {
    final currentDayIndex = DateTime.now().weekday - 1;
    try {
      return _db
          .collection('PlanDiario')
          .where('idUsuario', isEqualTo: idUsuario)
          .where('diaPlan', isEqualTo: TTexts.dias[currentDayIndex].trim())
          .where('estadoPlan', isEqualTo: TTexts.estadoPendiente)
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

    //Se obtienen los planes diarios del usuario que no han sido completados de día anterior o días anteriores
  Future<List<PlanDiario>> getPlanesDiariosParaConfirmacion(String idUsuario) async {
    final currentDayIndex = DateTime.now();
    String fecha = DateFormat('yyyy-MM-dd').format(currentDayIndex);

    try {
      QuerySnapshot querySnapshot = await _db
          .collection('PlanDiario')
          .where('idUsuario', isEqualTo: idUsuario)
          .where('fechaPlan', isLessThan: fecha) 
          .where('estadoPlan', isEqualTo: TTexts.estadoPendiente)
          .get();

      List<PlanDiario> result = querySnapshot.docs.map((doc) {
        return PlanDiario.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();


      return result;
    } catch (e) {
      log.i('Error al obtener planes diarios: $e');
      return [];
    }
  }

  Future<List<Recomendacion>> getRecomendaciones(String idUsuario) async {
    List<Recomendacion> recomendaciones = [];
    try {
      QuerySnapshot querySnapshot = await _db
          .collection('Recomendacion')
          .where('idUsuario', isEqualTo: idUsuario)
          .get();

      recomendaciones = querySnapshot.docs.map((doc) {
        return Recomendacion.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
      ordenarRecomendacionesPorFechaYHora(recomendaciones);
      
      return recomendaciones;
    } catch (e) {
      log.e('Error al obtener recomendaciones: $e');
      return [];
    } 
  }

   Future<void> saveRecomendacion(Recomendacion recomendacion) async {
    try {
      DocumentReference docRef =  _db.collection("Recomendacion").doc();
      recomendacion.idDocumento = docRef.id;
      await docRef.set(recomendacion.toJson());
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


  void ordenarRecomendacionesPorFechaYHora(
      List<Recomendacion> recomendaciones) {
    recomendaciones.sort((a, b) {
      // Concatenar fecha y hora
      String fechaHoraA = "${a.fechaRegistro} ${a.horaRegistro}";
      String fechaHoraB = "${b.fechaRegistro} ${b.horaRegistro}";

      // Convertir las cadenas a objetos DateTime
      DateTime dateTimeA = DateFormat("yyyy-MM-dd HH:mm").parse(fechaHoraA);
      DateTime dateTimeB = DateFormat("yyyy-MM-dd HH:mm").parse(fechaHoraB);

      // Ordenar de más reciente a más antiguo
      return dateTimeB.compareTo(dateTimeA);
    });
  }






}
