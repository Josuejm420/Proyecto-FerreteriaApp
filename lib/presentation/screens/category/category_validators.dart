class CategoryValidators {
  CategoryValidators._();

  static String? nombre(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return 'Ingresa el nombre de la categoría';
    if (text.length < 3) return 'Mínimo 3 caracteres';
    return null;
  }

  /// La descripción es opcional, pero con un límite de largo.
  static String? descripcion(String? value) {
    final text = value?.trim() ?? '';
    if (text.length > 120) return 'Máximo 120 caracteres';
    return null;
  }
}