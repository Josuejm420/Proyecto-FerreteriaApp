class SuppliersValidators {
  SuppliersValidators._();

  static String? nombre(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return 'Ingresa el nombre del proveedor';
    if (text.length < 3) return 'Mínimo 3 caracteres';
    return null;
  }

  static String? documento(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return 'Ingresa el documento';
    return null;
  }

  /// El correo es opcional, pero si se escribe debe ser válido.
  static String? correo(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return null;
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
    return null;
  }
}