class FormValidator {
  static String? required(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Este campo es requerido';
    }
    return null;
  }

  static String? minLength(String? value, int min) {
    if (value == null || value.isEmpty) return null;
    if (value.length < min) {
      return 'Mínimo $min caracteres';
    }
    return null;
  }

  static String? maxLength(String? value, int max) {
    if (value == null || value.isEmpty) return null;
    if (value.length > max) {
      return 'Máximo $max caracteres';
    }
    return null;
  }

  static String? number(String? value) {
    if (value == null || value.isEmpty) return null;
    if (double.tryParse(value) == null) {
      return 'Ingresa un número válido';
    }
    return null;
  }
}
