/// Usuario del sistema (tabla Usuario).
class UserModel {
  const UserModel({
    this.id,
    required this.nombre,
    this.direccion = '',
    required this.correo,
    required this.contrasena,
    this.activo = true,
    this.fechaRegistro,
    required this.idRol,
  });

  final int? id; // id_usuario (null cuando aún no se ha guardado)
  final String nombre;
  final String direccion;
  final String correo;
  final String contrasena; // contraseña (en la API real va cifrada)
  final bool activo; // estado
  final DateTime? fechaRegistro;
  final int idRol; // id_rol

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: (json['id_usuario'] as num?)?.toInt(),
    nombre: '${json['nombre'] ?? ''}',
    direccion: '${json['direccion'] ?? ''}',
    correo: '${json['correo'] ?? ''}',
    contrasena: '${json['contraseña'] ?? json['contrasena'] ?? ''}',
    activo: json['estado'] as bool? ?? true,
    fechaRegistro: DateTime.tryParse('${json['fecha_registro'] ?? ''}'),
    idRol: ((json['oRol'] ?? json['id_rol']) as num?)?.toInt() ?? 0,
  );

  Map<String, dynamic> toJson() => {
    'id_usuario': id ?? 0,
    'nombre': nombre,
    'direccion': direccion,
    'correo': correo,
    'contraseña': contrasena,
    'estado': activo,
    'fecha_registro': (fechaRegistro ?? DateTime.now()).toIso8601String(),
    'oRol': idRol,
    'nombre_rol': '',
  };

  UserModel copyWith({
    int? id,
    String? nombre,
    String? direccion,
    String? correo,
    String? contrasena,
    bool? activo,
    DateTime? fechaRegistro,
    int? idRol,
  }) {
    return UserModel(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      direccion: direccion ?? this.direccion,
      correo: correo ?? this.correo,
      contrasena: contrasena ?? this.contrasena,
      activo: activo ?? this.activo,
      fechaRegistro: fechaRegistro ?? this.fechaRegistro,
      idRol: idRol ?? this.idRol,
    );
  }
}
