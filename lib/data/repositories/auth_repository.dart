import '../../core/network/api_client.dart';
import '../models/user_session.dart';

/// Inicio y cierre de sesión contra la API.
class AuthRepository {
  AuthRepository(this._api);

  final ApiClient _api;

  /// POST /api/login/IniciarSesion  ->  { "token": "..." }
  Future<UserSession> login(String correo, String contrasena) async {
    final data = await _api.post(
      '/login/IniciarSesion',
      body: {'correo': correo.trim(), 'contraseña': contrasena},
    );

    final token = (data as Map<String, dynamic>)['token'] as String;
    final session = UserSession.fromToken(token);
    _api.setToken(token); // desde aquí todas las peticiones llevan el token
    return session;
  }

  void logout() => _api.setToken(null);
}