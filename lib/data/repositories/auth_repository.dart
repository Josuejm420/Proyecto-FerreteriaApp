import '../../core/network/api_client.dart';
import '../models/user_session.dart';

class AuthRepository {
  AuthRepository(this._api);

  final ApiClient _api;

  Future<UserSession> login(String correo, String contrasena) async {
    final data = await _api.post(
      '/login/IniciarSesion',
      body: {'correo': correo.trim(), 'contraseña': contrasena},
    );

    final session = UserSession.fromJson(data as Map<String, dynamic>);
    _api.setToken(session.token);
    return session;
  }

  void logout() => _api.setToken(null);
}
