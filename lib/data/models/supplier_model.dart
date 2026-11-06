class SupplierModel {
  const SupplierModel({
    this.id,
    required this.nombre,
    required this.documento,
    this.correo = '',
    required this.telefono,
    this.activo = true,
  });

  final int? id; // null cuando el proveedor aún no se ha guardado
  final String nombre;
  final String documento;
  final String correo;
  final String telefono;
  final bool activo;

  /// Lee un proveedor tal como lo devuelve la API.
  /// Se recortan los espacios: `documento` es NCHAR(100) y llega rellenado.
  factory SupplierModel.fromJson(Map<String, dynamic> json) {
    String text(String key) => ((json[key] as String?) ?? '').trim();

    return SupplierModel(
      id: (json['id_proveedor'] as num?)?.toInt(),
      nombre: text('nombre'),
      documento: text('documento'),
      correo: text('correo'),
      telefono: text('telefono'),
      activo: (json['estado'] as bool?) ?? true,
    );
  }

  /// Formato que espera la API al crear o editar.
  Map<String, dynamic> toJson() => {
    if (id != null) 'id_proveedor': id,
    'nombre': nombre,
    'correo': correo.isEmpty ? null : correo, // el correo es opcional
    'telefono': telefono,
    'documento': documento,
    'estado': activo,
  };

  SupplierModel copyWith({
    int? id,
    String? nombre,
    String? documento,
    String? correo,
    String? telefono,
    bool? activo,
  }) {
    return SupplierModel(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      documento: documento ?? this.documento,
      correo: correo ?? this.correo,
      telefono: telefono ?? this.telefono,
      activo: activo ?? this.activo,
    );
  }
}