/// Representa un registro de la tabla Cliente.
/// (fecha_registro la genera la base de datos, por eso no va aquí).
class ClientModel {
  const ClientModel({
    this.id,
    required this.documento,
    required this.nombre,
    this.correo = '',
    required this.telefono,
    this.activo = true,
  });

  final int? id; // id_cliente: null cuando el cliente aún no se ha guardado
  final String documento;
  final String nombre;
  final String correo;
  final String telefono;
  final bool activo; // estado

  /// Copia el cliente cambiando solo lo que se indique (por ejemplo, el id).
  ClientModel copyWith({
    int? id,
    String? documento,
    String? nombre,
    String? correo,
    String? telefono,
    bool? activo,
  }) {
    return ClientModel(
      id: id ?? this.id,
      documento: documento ?? this.documento,
      nombre: nombre ?? this.nombre,
      correo: correo ?? this.correo,
      telefono: telefono ?? this.telefono,
      activo: activo ?? this.activo,
    );
  }
}
