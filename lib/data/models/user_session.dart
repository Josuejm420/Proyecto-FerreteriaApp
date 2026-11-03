import 'dart:convert';

import 'user_role.dart';

/// Sesión del usuario. Los datos salen del JWT que devuelve
/// POST /api/login/IniciarSesion (la API solo responde { "token": "..." }).
class UserSession {
  const UserSession({
    required this.token,
    required this.id,
    required this.nombre,
    required this.correo,
    required this.rolDescripcion,
    required this.expiraEn,
  });

  final String token;
  final int id;
  final String nombre;
  final String correo;
  final String rolDescripcion; // Rol.descripcion: "Administrador" / "Empleado"
  final DateTime expiraEn;

  bool get isExpired => DateTime.now().isAfter(expiraEn);

  UserRole get role => rolDescripcion.trim().toLowerCase() == 'administrador'
      ? UserRole.administrador
      : UserRole.empleado;

  // La API guarda el rol con el nombre largo de .NET; por si acaso, también "role".
  static const _roleKeys = [
    'http://schemas.microsoft.com/ws/2008/06/identity/claims/role',
    'role',
  ];

  factory UserSession.fromToken(String token) {
    final parts = token.split('.');
    if (parts.length != 3) throw const FormatException('Token inválido');

    final payload =
        jsonDecode(utf8.decode(base64Url.decode(base64Url.normalize(parts[1]))))
            as Map<String, dynamic>;

    dynamic rol;
    for (final key in _roleKeys) {
      if (payload[key] != null) {
        rol = payload[key];
        break;
      }
    }
    if (rol is List && rol.isNotEmpty) rol = rol.first;

    return UserSession(
      token: token,
      id: int.parse('${payload['id_usuario']}'),
      nombre: '${payload['nombre']}',
      correo: '${payload['correo']}',
      rolDescripcion: '$rol',
      expiraEn: DateTime.fromMillisecondsSinceEpoch(
        (payload['exp'] as int) * 1000,
      ),
    );
  }
}