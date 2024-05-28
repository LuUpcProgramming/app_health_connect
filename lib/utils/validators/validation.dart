
class TValidator {
  static String? validateEmptyText(String? fieldName, String? value){
    if(value == null || value.isEmpty){
      return '$fieldName es obligatorio';
    }
    
    return null;
    
  }


  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Correo es obligatorio';
    }

    // Regular expression for email validation
    final emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

    if (!emailRegExp.hasMatch(value)) {
      return 'Correo Electrónico Inválido';
    }

    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Contraseña es Obligatoria';
    }

    // Check for minimum password length
    if (value.length < 6) {
      return 'Contraseña debe tener al menos 6 caracteres';
    }

    // Check for uppercase letters
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'Contraseña debe tener al menos una letra mayúscula';
    }

    // Check for numbers
    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'Contraseña debe tener al menos un número';
    }

    // Check for special characters
    if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return 'Contraseña debe tener al menos un carácter especial';
    }

    return null;
  }

  static String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Teléfono es obligatorio';
    }

    // Regular expression for phone number validation (assuming a 10-digit US phone number format)
    final phoneRegExp = RegExp(r'^\d{9}$');

    if (!phoneRegExp.hasMatch(value)) {
      return 'Formato Inválido (9 dígitos rrequeridos).';
    }

    return null;
  }

// Add more custom validators as needed for your specific requirements.
}
