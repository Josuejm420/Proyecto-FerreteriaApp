class ClientModel {
  const ClientModel({
    this.id,
    required this.documento,
    required this.nombre,
    this.correo = '',
    required this.telefono,
    this.activo = true,
  });

  final int? id;
  final String documento;
  final String nombre;
  final String correo;
  final String telefono;
  final bool activo;

  factory ClientModel.fromJson(Map<String, dynamic> json) {
    final rawId = json['id_cliente'] ?? json['idCliente'] ?? json['id'];
    final id = rawId is num ? rawId.toInt() : int.tryParse('$rawId');

    final rawActivo = json['estado'] ?? json['activo'];
    final bool activo = rawActivo is bool ? rawActivo : true;

    return ClientModel(
      id: id,
      documento: (json['documento'] ?? '').toString().trim(),
      nombre: (json['nombre'] ?? '').toString().trim(),
      correo: (json['correo'] ?? '').toString().trim(),
      telefono: (json['telefono'] ?? '').toString().trim(),
      activo: activo,
    );
  }

  Map<String, dynamic> toJson() => {
    if (id != null) 'id_cliente': id,
    'documento': documento,
    'nombre': nombre,
    'correo': correo,
    'telefono': telefono,
    'estado': activo,
  };

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
