import 'package:app_health_connect/config/helper/logging.dart';
import 'package:app_health_connect/data/repositories/user/user_repository.dart';
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
    // Get.offAll(() => const DailyPlanScreen());
    // Get.offAll(() => const CustomSuccessWidget());
    //  Get.offAll(() => const PlanDiarioDetalle());
    //Get.offAll(() => const LoginScreen());
    //Get.offAll(() => const OnboardingScreen());
    //Get.offAll(() => const ProfileScreen());
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
          Get.offAll(() => const NavigationMenu(),
              transition: Transition.fade,
              duration: const Duration(milliseconds: 600));
        } else {
          log.i(
              "screenRedirect: Usuario es nuevo, se redirige al screen de presentación");
          Get.offAll(() => const WelcomeScreen(),
              transition: Transition.rightToLeft,
              duration: const Duration(milliseconds: 600));
        }
      } else {
        log.i(
            "screenRedirect: Usuario no tiene email verificado. Se redirige a VerifyEmailScreen");
        Get.offAll(() => VerifyEmailScreen(email: _auth.currentUser?.email),
            transition: Transition.rightToLeft,
            duration: const Duration(milliseconds: 600));
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
          ? Get.offAll(() => const LoginScreen(),
              transition: Transition.rightToLeft,
              duration: const Duration(milliseconds: 600))
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
      throw 'Credenciales Incorrectas. Por Favor Intente de Nuevo';
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

  /// Forget Password
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
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
  Future<void> reauthenticateAndChangePassword(String currentPassword, String newPassword) async {
    try {
       User? user = FirebaseAuth.instance.currentUser;

      if (user != null && user.email != null) {
        // Crear las credenciales con el email del usuario actual y la contraseña actual
        AuthCredential credential = EmailAuthProvider.credential(
          email: user.email!,
          password: currentPassword,
        );

        // Volver a autenticar al usuario
        await user.reauthenticateWithCredential(credential);

        // Si la re-autenticación fue exitosa, cambiar la contraseña
        await user.updatePassword(newPassword);
      }  else{
        await logout();
        Get.offAll(() => const LoginScreen(),
            transition: Transition.rightToLeft,
            duration: const Duration(milliseconds: 600));
      }

    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Algo salió mal, intente de nuevo: ${e.toString()}';
    }
  }

  /// [Email/uthentication)
  ///
  ///
  ///

  /******************** ./ end Funciones adicionales ***********/

  /// [LogoutUser] Valido para cualquier autenticación
  Future<void> logout() async {
    try {
      await FirebaseAuth.instance.signOut();
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
