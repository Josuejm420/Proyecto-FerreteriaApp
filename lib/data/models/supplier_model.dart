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