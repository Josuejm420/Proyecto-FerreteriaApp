/// Rol del sistema (tabla Rol) con los menús que puede usar (tabla Permiso).
class RoleModel {
  const RoleModel({
    required this.id,
    required this.descripcion,
    this.permisos = const [],
    this.fechaRegistro,
  });

  final int id; // id_rol
  final String descripcion; // descripcion
  final List<String> permisos; // nombre_menu de cada Permiso del rol
  final DateTime? fechaRegistro; // fecha_registro
}