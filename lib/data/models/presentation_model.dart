class PresentationModel {
  const PresentationModel({
    this.id,
    required this.nombre,
    required this.unidadMedida,
    required this.peso,
    this.activo = true,
  });

  final int? id; // null cuando la presentación aún no se ha guardado
  final String nombre;
  final String unidadMedida;
  final double peso;
  final bool activo;

  /// 42.5 -> "42.5", 100.0 -> "100"
  String get pesoTexto =>
      peso == peso.truncateToDouble() ? peso.toInt().toString() : '$peso';

  /// Texto corto para la lista: "kg · 42.5 kg", "unidad · 100 uds", "unidad".
  String get resumen {
    if (unidadMedida.toLowerCase() == 'unidad') {
      return peso <= 1 ? 'unidad' : 'unidad · $pesoTexto uds';
    }
    return '$unidadMedida · $pesoTexto $unidadMedida';
  }

  PresentationModel copyWith({
    int? id,
    String? nombre,
    String? unidadMedida,
    double? peso,
    bool? activo,
  }) {
    return PresentationModel(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      unidadMedida: unidadMedida ?? this.unidadMedida,
      peso: peso ?? this.peso,
      activo: activo ?? this.activo,
    );
  }
}