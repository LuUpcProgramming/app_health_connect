import 'package:app_health_connect/config/helper/logging.dart';
import 'package:app_health_connect/features/authentication/models/chat_message.dart';
import 'package:app_health_connect/features/authentication/models/history_advice.dart';
import 'package:app_health_connect/utils/exceptions/firebase_exceptions.dart';
import 'package:app_health_connect/utils/exceptions/format_exceptions.dart';
import 'package:app_health_connect/utils/exceptions/platform_exceptions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class ChatRepository extends GetxController {
  static ChatRepository get instance => Get.find();

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final log = logger(ChatRepository);

/* 
  Future<void> saveMessageToFirestore(Map<String, dynamic> message) async {
    try {
      await _db.collection("Chats").add(message);
      log.i("Mensaje guardado en Firestore: $message");
    } on FirebaseException catch (e) {
      log.e("Error al guardar mensaje en Firestore: ${e.message}");
    } catch (e) {
      log.e("Algo salió mal al guardar mensaje en Firestore: $e");
    }
  } */

   Future<void> saveMessageToFirestore(ChatMessageModel message) async {
    try {
      await _db.collection("Chats").doc(message.idUsuario).set(message.toJson(), SetOptions(merge: true));
      log.i("Historial de mensajes guardado en Firestore para el usuario ${message.idUsuario}");
    } on FirebaseException catch (e) {
      log.e("Error al guardar historial de mensajes en Firestore: ${e.message}");
    } catch (e) {
      log.e("Algo salió mal al guardar historial de mensajes en Firestore: $e");
    }
  }

  Future<void> saveHistorialRecomendacion(HistoryAdvice message) async {
    try {
      await _db.collection("History").doc(message.idUsuario).set(message.toJson());
      log.i("Historial de mensajes guardado en Firestore para el usuario ${message.idUsuario}");
    } on FirebaseException catch (e) {
      log.e("Error al guardar historial de mensajes en Firestore: ${e.message}");
    } catch (e) {
      log.e("Algo salió mal al guardar historial de mensajes en Firestore: $e");
    }
  }



/*   Future<List<ChatMessageModel>> cargarHistorialDesdeBD() async {
    QuerySnapshot snapshot = await _db.collection('Chats').get();
    return snapshot.docs.map((doc) {
      return ChatMessageModel.fromJson(doc.data() as Map<String, dynamic>, doc.id);
    }).toList();
  } */

  Future<ChatMessageModel> cargarHistorialMensajesPorUsuario(String userId) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> doc =
          await _db.collection("Chats").doc(userId).get();
      if (doc.exists) {
        return ChatMessageModel.fromSnapshot(doc);
      } else {
        return ChatMessageModel.fromSnapshot(doc);
      }
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

  /* List<Future<HistoryAdvice>> cargarHistorial(String userId) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> doc =
          await _db.collection("Chats").doc(userId).get();
      if (doc.exists) {
        return ChatMessageModel.fromSnapshot(doc);
      } else {
        return ChatMessageModel.fromSnapshot(doc);
      }
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

  Future<void> removeConversacion(String userId) async {
    try {
      await _db.collection("Chats").doc(userId).delete();
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
