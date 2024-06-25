import 'package:app_health_connect/config/helper/logging.dart';
import 'package:app_health_connect/data/repositories/user/user_repository.dart';
import 'package:app_health_connect/features/authentication/screens/chat/chat_screen.dart';
import 'package:app_health_connect/features/authentication/screens/login/login.dart';
import 'package:app_health_connect/features/authentication/screens/onboarding/onboarding.dart';
import 'package:app_health_connect/features/authentication/screens/signup/verify_email.dart';
import 'package:app_health_connect/features/authentication/screens/welcome/welcome.dart';
import 'package:app_health_connect/navigation_menu.dart';
import 'package:app_health_connect/utils/exceptions/firebase_auth_exceptions.dart';
import 'package:app_health_connect/utils/exceptions/firebase_exceptions.dart';
import 'package:app_health_connect/utils/exceptions/format_exceptions.dart';
import 'package:app_health_connect/utils/exceptions/platform_exceptions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class AuthenticationRepository extends GetxController {
  static AuthenticationRepository get instance => Get.find();

  ///Variables
  final log = logger(AuthenticationRepository);
  final deviceStorage = GetStorage();
  final _auth = FirebaseAuth.instance;
  User? get authUser => _auth.currentUser;

  /// Llamado del main.dart
  @override
  void onReady() {
    FlutterNativeSplash.remove();
    //Redirige a la pantalla apropiada
    //Get.offAll(() => const WelcomeScreen());
    //Get.offAll(() => const NavigationMenu());
    //Get.offAll(() => const DashboardScreen());
    //Get.offAll(() => const HistorialAdviceScreen());
    //Get.offAll(() => const EstadisticasScreen());
    // Get.offAll(() => const ChatScreen());
    screenRedirect();
  }

  //Función para Screens relevantes
  screenRedirect() async {
    log.i("screenRedirect: Comienza Redirección de Screens");
    final user = _auth.currentUser;
    if (user != null) {
      if (user.emailVerified) {
        log.i("screenRedirect: Usuario tiene email verificado");
        //Verificar que haya ingresado sus datos previos en la interacción preliminar
        final userRepository = Get.put(UserRepository());
        final existeDetalleUsuario =
            await userRepository.checkUserDetailExistence(user.uid);
        log.i("screenRedirect: existeDetalleUsuario: $existeDetalleUsuario");
        if (existeDetalleUsuario) {
          log.i(
              "screenRedirect: Usuario ya tiene su detalle, se redirige a Dashboard");
          Get.offAll(() => const NavigationMenu());
        } else {
          log.i(
              "screenRedirect: Usuario es nuevo, se redirige al screen de presentación");
          Get.offAll(() => const WelcomeScreen());
        }
      } else {
        log.i(
            "screenRedirect: Usuario no tiene email verificado. Se redirige a VerifyEmailScreen");
        Get.offAll(() => VerifyEmailScreen(email: _auth.currentUser?.email));
      }
    } else {
      //Local Storage
      log.i(
          "screenRedirect: Usuario no existe, se redirige a pantalla Inicial");
      deviceStorage.writeIfNull('IsFirstTime', true);
      if (kDebugMode) {
        print("=================== GET STORAGE AUTH REPOSITORY ==============");
        print(deviceStorage.read('IsFirstTime'));
      }
      // Revisar si es la primera vez de ejecutar la APP
      deviceStorage.read('IsFirstTime') != true
          ? Get.offAll(() => const LoginScreen())
          : Get.offAll(() => const OnboardingScreen());
    }
    log.i("screenRedirect: Termina Redirección de Screens");
  }

  /* -------------------------------- Email y Contraseña -Inicio de Sesión- Registro************** */
  /// [EmailAutnentication)- Inicio de Sesión
  Future<UserCredential> loginWithEmailAndPassword(
      String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(
          email: email, password: password);
    } on TFirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } on TFirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Algo salió mal, intente de nuevo ';
    }
  }

  /// [EmailAuthentication] - Registro
  Future<UserCredential> registerWithEmailAndPassword(
      String email, String password) async {
    try {
      return await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
    } on TFirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } on TFirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Algo salió mal, intente de nuevo ';
    }
  }

  /// [Email Verificationj Verificacion de Email
  Future<void> sendEmailVerification() async {
    try {
      await _auth.currentUser?.sendEmailVerification();
    } on TFirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
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

  /// [ReAuthenticate)

  /// [Email/uthentication)
  ///
  ///
  ///

  /******************** ./ end Funciones adicionales ***********/

  /// [LogoutUser] Valido para cualquier autenticación
  Future<void> logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      Get.offAll(() => const LoginScreen());
    } on TFirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
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
