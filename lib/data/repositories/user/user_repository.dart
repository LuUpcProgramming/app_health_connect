import 'package:app_health_connect/config/helper/logging.dart';
import 'package:app_health_connect/features/authentication/models/user_detail.dart';
import 'package:app_health_connect/features/authentication/models/user_model.dart';
import 'package:app_health_connect/utils/exceptions/firebase_exceptions.dart';
import 'package:app_health_connect/utils/exceptions/format_exceptions.dart';
import 'package:app_health_connect/utils/exceptions/platform_exceptions.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserRepository extends GetxController {
  static UserRepository get instance => Get.find();

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final log = logger(UserRepository);

  Future<void> saveUserRecord(UserModel user) async {
    try {
      await _db.collection("Users").doc(user.id).set(user.toJson());
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

  Future<void> saveUserDetails(UserDetail userDetail) async {
    try {
      await _db
          .collection("UserDetails")
          .doc(userDetail.idUsuario)
          .set(userDetail.toJson());
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

  // Método para obtener un usuario desde Firestore
  Future<UserModel> getUserRecord(String userId) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> doc =
          await _db.collection("Users").doc(userId).get();
      if (doc.exists) {
        log.i('getUserRecord: ${doc.data()}');
        return UserModel.fromSnapshot(doc);
      } else {
        throw Exception('Usuario no encontrado');
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

  //Obtener los datos complementarios del usuario
  Future<UserDetail> getUserDetails(String userId) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> doc =
          await _db.collection("UserDetails").doc(userId).get();
      if (doc.exists) {
        return UserDetail.fromSnapshot(doc);
      } else {
        throw Exception('Usuario no encontrado');
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
}
