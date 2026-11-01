import '../data/models/user_role.dart';

/// Servicio de autenticación (simulado, sin backend).
/// Cuando tengas API, solo cambias el interior de login().
class AuthService {
  static const String _demoPassword = '12345678';

  Future<bool> login(
    String email,
    String password, [
    UserRole? role,
  ]) async {
    await Future.delayed(const Duration(seconds: 1));

    final normalizedEmail = email.trim().toLowerCase();
    final expectedEmail = (role ?? UserRole.administrador).demoEmail;

    return normalizedEmail == expectedEmail.toLowerCase() &&
        password == _demoPassword;
  }
}
