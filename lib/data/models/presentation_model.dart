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

  /// Lee una presentación tal como la devuelve la API.
  /// En la base `peso` es texto, aquí se convierte a número.
  factory PresentationModel.fromJson(Map<String, dynamic> json) {
    final pesoTexto = '${json['peso'] ?? ''}'.trim().replaceAll(',', '.');

    return PresentationModel(
      id: (json['id_presentacion'] as num?)?.toInt(),
      nombre: ((json['nombre'] as String?) ?? '').trim(),
      unidadMedida: ((json['unidad_medida'] as String?) ?? '').trim(),
      peso: double.tryParse(pesoTexto) ?? 1,
      activo: (json['estado'] as bool?) ?? true,
    );
  }

  /// Formato que espera la API al crear o editar (peso va como texto).
  Map<String, dynamic> toJson() => {
    if (id != null) 'id_presentacion': id,
    'nombre': nombre,
    'unidad_medida': unidadMedida,
    'peso': pesoTexto,
    'estado': activo,
  };

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