/// Custom exception class to handle various Firebase authentication-related errors.
class TFirebaseAuthException implements Exception {
  /// The error code associated with the exception.

  final String code;

  /// Constructor that takes an error code.
  TFirebaseAuthException(this.code);

  /// Get the corresponding error message based on the error code.

  String get message {
    switch (code) {
      case 'email-already-in-use':
        return 'La dirección de correo electrónico ya está registrada. Por favor, use un correo diferente.';
      case 'invalid-email':
        return 'La dirección de correo electrónico proporcionada es inválida. Por favor, ingrese un correo válido.';
      case 'weak-password':
        return 'La contraseña es demasiado débil. Por favor, elija una contraseña más fuerte.';
      case 'user-disabled':
        return 'Esta cuenta de usuario ha sido deshabilitada. Por favor, contacte al soporte para asistencia.';
      case 'user-not-found':
        return 'Usuario no encontrado.';
      case 'wrong-password':
        return 'Contraseña incorrecta. Por favor, intente de nuevo.';
      case 'invalid-verification-code':
        return 'Código de verificación inválido. Por favor, ingrese un código válido.';
      case 'invalid-verification-id':
        return 'ID de verificación inválido. Por favor, solicite un nuevo código de verificación.';
      case 'quota-exceeded':
        return 'Cuota excedida. Por favor, intente de nuevo más tarde.';
      case 'email-already-exists':
        return 'La dirección de correo electrónico ya existe. Por favor, use un correo diferente.';
      case 'provider-already-linked':
        return 'La cuenta ya está vinculada con otro proveedor.';
      case 'requires-recent-login':
        return 'Esta operación es sensible y requiere autenticación reciente. Por favor, inicie sesión de nuevo.';
      case 'credential-already-in-use':
        return 'Esta credencial ya está asociada con otra cuenta de usuario.';
      case 'user-mismatch':
        return 'Las credenciales proporcionadas no corresponden al usuario previamente autenticado.';
      case 'account-exists-with-different-credential':
        return 'Ya existe una cuenta con el mismo correo electrónico pero con diferentes credenciales de inicio de sesión.';
      case 'operation-not-allowed':
        return 'Esta operación no está permitida. Contacte al soporte para asistencia.';
      case 'expired-action-code':
        return 'El código de acción ha expirado. Por favor, solicite un nuevo código de acción.';
      case 'invalid-action-code':
        return 'El código de acción es inválido. Por favor, verifique el código e intente de nuevo.';
      case 'missing-action-code':
        return 'Falta el código de acción. Por favor, proporcione un código de acción válido.';
      case 'user-token-expired':
        return 'El token del usuario ha expirado y se requiere autenticación. Por favor, inicie sesión de nuevo.';
      case 'invalid-credential':
        return 'La credencial/contraseña actual proporcionada es inválida o ha expirado.';
      case 'user-token-revoked':
        return 'El token del usuario ha sido revocado. Por favor, inicie sesión de nuevo.';
      case 'invalid-message-payload':
        return 'La carga útil del mensaje de verificación de la plantilla de correo electrónico es inválida.';
      case 'invalid-sender':
        return 'El remitente de la plantilla de correo electrónico es inválido. Por favor, verifique el correo del remitente.';
      case 'invalid-recipient-email':
        return 'La dirección de correo electrónico del destinatario es inválida. Por favor, proporcione un correo válido.';
      case 'missing-iframe-start':
        return 'La plantilla de correo electrónico no tiene la etiqueta de inicio del iframe.';
      case 'missing-iframe-end':
        return 'La plantilla de correo electrónico no tiene la etiqueta de fin del iframe.';
      case 'missing-iframe-src':
        return 'La plantilla de correo electrónico no tiene el atributo src del iframe.';
      case 'auth-domain-config-required':
        return 'La configuración de authDomain es requerida para el enlace de verificación del código de acción.';
      case 'missing-app-credential':
        return 'Faltan las credenciales de la aplicación. Por favor, proporcione credenciales válidas.';
      case 'invalid-app-credential':
        return 'Las credenciales de la aplicación son inválidas. Por favor, proporcione credenciales válidas.';
      case 'session-cookie-expired':
        return 'La cookie de sesión de Firebase ha expirado. Por favor, inicie sesión de nuevo.';
      case 'uid-already-exists':
        return 'El ID de usuario proporcionado ya está en uso por otro usuario.';
      case 'invalid-cordova-configuration':
        return 'La configuración de Cordova proporcionada es inválida.';
      case 'app-deleted':
        return 'Esta instancia de FirebaseApp ha sido eliminada.';
      case 'user-token-mismatch':
        return 'El token del usuario proporcionado no coincide con el ID de usuario autenticado.';
      case 'web-storage-unsupported':
        return 'El almacenamiento web no es compatible o está deshabilitado.';
      case 'app-not-authorized':
        return 'La aplicación no está autorizada para usar Firebase Authentication con la clave API proporcionada.';
      case 'keychain-error':
        return 'Ocurrió un error en el llavero. Por favor, verifique el llavero e intente de nuevo.';
      case 'internal-error':
        return 'Ocurrió un error interno de autenticación. Por favor, intente de nuevo más tarde.';
      case 'INVALID_LOGIN_CREDENTIALS':
        return 'Credenciales de inicio de sesión inválidas.';
      default:
        return 'Ocurrió un error inesperado de autenticación. Por favor, intente de nuevo.';
    }
  }
  
}
