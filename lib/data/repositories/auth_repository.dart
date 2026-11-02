import '../../core/network/api_client.dart';
import '../models/user_session.dart';

/// Inicio y cierre de sesión contra la API.
class AuthRepository {
  AuthRepository(this._api);

  final ApiClient _api;

  /// SUPOSICIÓN: POST /auth/login con { "correo": ..., "contrasena": ... }
  Future<UserSession> login(String correo, String contrasena) async {
    final data = await _api.post(
      '/auth/login',
      body: {'correo': correo.trim(), 'contrasena': contrasena},
    );

    final session = UserSession.fromJson(data as Map<String, dynamic>);
    _api.setToken(session.token); // desde aquí todas las peticiones lo llevan
    return session;
  }

  void logout() => _api.setToken(null);
}