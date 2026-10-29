class UserManagementValidators {
  UserManagementValidators._();

  static String? nombre(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return 'Ingresa el nombre del usuario';
    if (text.length < 3) return 'Mínimo 3 caracteres';
    return null;
  }

  /// La dirección es opcional.
  static String? direccion(String? value) => null;

  static String? correo(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return 'Ingresa el correo';
    if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(text)) {
      return 'Ingresa un correo electrónico válido';
    }
    return null;
  }

  /// Al crear es obligatoria; al editar se puede dejar vacía (se mantiene).
  static String? contrasena(String? value, {required bool isEditing}) {
    final text = value ?? '';
    if (text.isEmpty) {
      return isEditing ? null : 'Ingresa la contraseña';
    }
    if (text.length < 8) return 'Mínimo 8 caracteres';
    return null;
  }

  static String? rol(int? value) {
    if (value == null) return 'Selecciona un rol';
    return null;
  }
}