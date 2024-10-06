import 'package:firebase_auth/firebase_auth.dart';

/// Custom exception class to handle various Firebase-related errors.
class TFirebaseException implements Exception {
  /// The error code associated with the exception.

  final String code;

  /// Constructor that takes an error code.
  TFirebaseException(this.code);

  /// Get the corresponding error message based on the error code.

  String get message {
    switch (code) {
      case 'unknown':
        return 'Ocurrió un error desconocido de Firebase. Por favor, inténtelo de nuevo.';
      case 'invalid-custom-token':
        return 'El formato del token personalizado es incorrecto. Por favor, revise su token personalizado.';
      case 'custom-token-mismatch':
        return 'El token personalizado corresponde a una audiencia diferente.';
      case 'user-disabled':
        return 'La cuenta de usuario ha sido deshabilitada.';
      case 'user-not-found':
        return 'Usuario no encontrado.';
      case 'invalid-email':
        return 'La dirección de correo electrónico proporcionada es inválida. Por favor, ingrese un correo electrónico válido.';
      case 'email-already-in-use':
        return 'La dirección de correo electrónico ya está registrada. Por favor, use un correo electrónico diferente.';
      case 'wrong-password':
        return 'Contraseña incorrecta. Por favor, inténtelo de nuevo.';
      case 'weak-password':
        return 'La contraseña es demasiado débil. Por favor, elija una contraseña más fuerte.';
      case 'provider-already-linked':
        return 'La cuenta ya está vinculada con otro proveedor.';
      case 'operation-not-allowed':
        return 'Esta operación no está permitida. Contacte al soporte para obtener asistencia.';
      case 'invalid-credential':
        return 'La credencial proporcionada es incorrecta o ha expirado.';
      case 'invalid-verification-code':
        return 'Código de verificación inválido. Por favor, ingrese un código válido.';
      case 'invalid-verification-id':
        return 'ID de verificación inválido. Por favor, solicite un nuevo código de verificación.';
      case 'captcha-check-failed':
        return 'La respuesta de reCAPTCHA es inválida. Por favor, inténtelo de nuevo.';
      case 'app-not-authorized':
        return 'La aplicación no está autorizada para usar Firebase Authentication con la clave API proporcionada.';
      case 'keychain-error':
        return 'Ocurrió un error en el llavero. Por favor, revise el llavero e inténtelo de nuevo.';
      case 'internal-error':
        return 'Ocurrió un error interno de autenticación. Por favor, inténtelo de nuevo más tarde.';
      case 'invalid-app-credential':
        return 'La credencial de la aplicación es inválida. Por favor, proporcione una credencial de aplicación válida.';
      case 'user-mismatch':
        return 'Las credenciales proporcionadas no corresponden al usuario previamente autenticado.';
      case 'requires-recent-login':
        return 'Esta operación es sensible y requiere autenticación reciente. Por favor, inicie sesión de nuevo.';
      case 'quota-exceeded':
        return 'Cuota excedida. Por favor, inténtelo de nuevo más tarde.';
      case 'account-exists-with-different-credential':
        return 'Ya existe una cuenta con el mismo correo electrónico pero con credenciales de inicio de sesión diferentes.';
      case 'missing-iframe-start':
        return 'La plantilla de correo electrónico no tiene la etiqueta de inicio del iframe.';
      case 'missing-iframe-end':
        return 'La plantilla de correo electrónico no tiene la etiqueta de fin del iframe.';
      case 'missing-iframe-src':
        return 'La plantilla de correo electrónico no tiene el atributo src del iframe.';
      case 'auth-domain-config-required':
        return 'La configuración de authDomain es necesaria para el enlace de verificación del código de acción.';
      case 'missing-app-credential':
        return 'Faltan las credenciales de la aplicación. Por favor, proporcione credenciales de aplicación válidas.';
      case 'session-cookie-expired':
        return 'La cookie de sesión de Firebase ha expirado. Por favor, inicie sesión de nuevo.';
      case 'uid-already-exists':
        return 'El ID de usuario proporcionado ya está en uso por otro usuario.';
      case 'web-storage-unsupported':
        return 'El almacenamiento web no es compatible o está deshabilitado.';
      case 'app-deleted':
        return 'Esta instancia de FirebaseApp ha sido eliminada.';
      case 'user-token-mismatch':
        return 'El token del usuario proporcionado no coincide con el ID de usuario autenticado.';
      case 'invalid-message-payload':
        return 'La carga útil del mensaje de verificación de la plantilla de correo electrónico es inválida.';
      case 'invalid-sender':
        return 'El remitente de la plantilla de correo electrónico es inválido. Por favor, verifique el correo electrónico del remitente.';
      case 'invalid-recipient-email':
        return 'La dirección de correo electrónico del destinatario es inválida. Por favor, proporcione un correo electrónico de destinatario válido.';
      case 'missing-action-code':
        return 'Falta el código de acción. Por favor, proporcione un código de acción válido.';
      case 'user-token-expired':
        return 'El token del usuario ha expirado y se requiere autenticación. Por favor, inicie sesión de nuevo.';
      case 'INVALID_LOGIN_CREDENTIALS':
        return 'Credenciales de inicio de sesión inválidas.';
      case 'expired-action-code':
        return 'El código de acción ha expirado. Por favor, solicite un nuevo código de acción.';
      case 'invalid-action-code':
        return 'El código de acción es inválido. Por favor, revise el código e inténtelo de nuevo.';
      case 'credential-already-in-use':
        return 'Esta credencial ya está asociada con otra cuenta de usuario.';
      default:
        return 'Ocurrió un error inesperado de Firebase. Por favor, inténtelo de nuevo.';
    }
  }

}
