class ProductValidator {
  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Ingresa el nombre del producto';
    }
    if (value.trim().length < 3) {
      return 'El nombre debe tener al menos 3 caracteres';
    }
    if (value.trim().length > 255) {
      return 'El nombre no puede exceder 255 caracteres';
    }
    return null;
  }

  static String? validateDescription(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Ingresa una descripción';
    }
    if (value.trim().length < 20) {
      return 'Agrega más detalle (mínimo 20 caracteres)';
    }
    if (value.trim().length > 2000) {
      return 'La descripción no puede exceder 2000 caracteres';
    }
    return null;
  }

  static String? validatePrice(String? value) {
    if (value == null || value.isEmpty) {
      return 'Ingresa el precio';
    }
    final price = double.tryParse(value);
    if (price == null || price <= 0) {
      return 'Precio inválido';
    }
    if (price > 999999.99) {
      return 'Precio muy alto';
    }
    return null;
  }
}
