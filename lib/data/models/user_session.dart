import 'user_role.dart';

/// Sesión del usuario que inició sesión (respuesta de POST /auth/login).
///
/// SUPOSICIÓN: la API responde
///   { "token": "...",
///     "usuario": { "id_usuario": 1, "nombre": "...", "correo": "...",
///                  "rol": "Administrador" } }
/// Si tu API usa otros nombres, solo cambias fromJson().
class UserSession {
  const UserSession({
    required this.token,
    required this.id,
    required this.nombre,
    required this.correo,
    required this.rolDescripcion,
  });

  final String token;
  final int id;
  final String nombre;
  final String correo;
  final String rolDescripcion; // descripcion de la tabla Rol

  /// Rol que usa la app para decidir qué módulos mostrar.
  UserRole get role => rolDescripcion.trim().toLowerCase() == 'administrador'
      ? UserRole.administrador
      : UserRole.empleado;

  factory UserSession.fromJson(Map<String, dynamic> json) {
    final user = json['usuario'] as Map<String, dynamic>;
    return UserSession(
      token: json['token'] as String,
      id: user['id_usuario'] as int,
      nombre: user['nombre'] as String,
      correo: user['correo'] as String,
      rolDescripcion: user['rol'] as String,
    );
  }
}