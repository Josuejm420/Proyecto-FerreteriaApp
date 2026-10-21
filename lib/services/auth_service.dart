/// Servicio de autenticación (simulado, sin backend).
/// Cuando tengas API, solo cambias el interior de login().
class AuthService {
  static const String _demoEmail = 'antonio@dontono.com';
  static const String _demoPassword = '12345678';

  Future<bool> login(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    return email.trim().toLowerCase() == _demoEmail &&
        password == _demoPassword;
  }
}
