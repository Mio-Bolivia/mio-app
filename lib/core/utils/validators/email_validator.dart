class EmailValidator {
  static const _emailPattern = r'^[^@\s]+@[^@\s]+\.[^@\s]+$';

  static bool isValid(String email) {
    return RegExp(_emailPattern).hasMatch(email);
  }

  static String? validate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor ingresa tu email';
    }
    if (!isValid(value)) {
      return 'Ingresa un email válido';
    }
    return null;
  }
}
