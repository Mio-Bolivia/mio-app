class PasswordValidator {
  static const int minLength = 8;
  static const int maxLength = 128;

  static bool hasUppercase(String password) =>
      password.contains(RegExp(r'[A-Z]'));

  static bool hasLowercase(String password) =>
      password.contains(RegExp(r'[a-z]'));

  static bool hasDigit(String password) => password.contains(RegExp(r'[0-9]'));

  static bool hasSpecialChar(String password) =>
      password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));

  static String? validate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor ingresa tu contraseña';
    }
    if (value.length < minLength) {
      return 'Mínimo $minLength caracteres';
    }
    if (value.length > maxLength) {
      return 'Máximo $maxLength caracteres';
    }
    return null;
  }
}
