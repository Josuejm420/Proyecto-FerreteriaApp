class SuppliersValidators {
  SuppliersValidators._();

  static String? nombre(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return 'Ingresa el nombre del proveedor';
    if (text.length < 3) return 'Mínimo 3 caracteres';
    if (text.length > 50) return 'Máximo 50 caracteres';
    return null;
  }

  static String? documento(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return 'Ingresa el documento';
    if (text.length > 100) return 'Máximo 100 caracteres';
    return null;
  }

  /// El correo es opcional, pero si se escribe debe ser válido.
  static String? correo(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return null;
    if (text.length > 50) return 'Máximo 50 caracteres';
    if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(text)) {
      return 'Ingresa un correo electrónico válido';
    }
    return null;
  }

  static String? telefono(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return 'Ingresa el teléfono';
    final digits = text.replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.length < 8) return 'El teléfono debe tener al menos 8 dígitos';
    if (text.length > 20) return 'Máximo 20 caracteres';
    return null;
  }
}