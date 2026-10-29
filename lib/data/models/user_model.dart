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