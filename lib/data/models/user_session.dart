import 'dart:convert';

import 'user_role.dart';

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
  final String rolDescripcion;

  UserRole get role => rolDescripcion.trim().toLowerCase() == 'administrador'
      ? UserRole.administrador
      : UserRole.empleado;

  static const _roleClaim =
      'http://schemas.microsoft.com/ws/2008/06/identity/claims/role';

  factory UserSession.fromJson(Map<String, dynamic> json) {
    final token = json['token'] as String;
    final claims = _decodePayload(token);

    return UserSession(
      token: token,
      id: int.tryParse('${claims['id_usuario']}') ?? 0,
      nombre: '${claims['nombre'] ?? ''}',
      correo: '${claims['correo'] ?? ''}',
      rolDescripcion: '${claims[_roleClaim] ?? claims['role'] ?? ''}',
    );
  }

  static Map<String, dynamic> _decodePayload(String token) {
    final parts = token.split('.');
    if (parts.length != 3) {
      throw const FormatException('Token con formato inválido');
    }
    final normalized = base64Url.normalize(parts[1]);
    final json = utf8.decode(base64Url.decode(normalized));
    return jsonDecode(json) as Map<String, dynamic>;
  }
}
