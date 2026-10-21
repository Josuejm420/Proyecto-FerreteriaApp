class PresentationValidators {
  PresentationValidators._();

  static String? nombre(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return 'Ingresa el nombre de la presentación';
    if (text.length < 2) return 'Mínimo 2 caracteres';
    return null;
  }

  static String? unidadMedida(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return 'Ingresa la unidad de medida';
    return null;
  }

  static String? peso(String? value) {
    final text = (value?.trim() ?? '').replaceAll(',', '.');
    if (text.isEmpty) return 'Ingresa el peso';
    final number = double.tryParse(text);
    if (number == null) return 'Ingresa un número válido';
    if (number <= 0) return 'El peso debe ser mayor que 0';
    return null;
  }
}