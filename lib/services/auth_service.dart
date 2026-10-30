import '../data/models/user_role.dart';

/// Servicio de autenticación (simulado, sin backend).
/// Cuando tengas API, solo cambias el interior de login().
class AuthService {
  // Cuentas de demostración: cada correo trae su contraseña y su rol.
  static const Map<String, ({String password, UserRole role})> _demoAccounts = {
    'antonio@dontono.com': (
      password: '12345678',
      role: UserRole.administrador,
    ),
    'juan@dontono.com': (password: '12345678', role: UserRole.empleado),
  };

  /// Devuelve el rol de la cuenta si el correo y la contraseña son correctos.
  /// Si no coinciden, devuelve null.
  Future<UserRole?> login(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));

    final account = _demoAccounts[email.trim().toLowerCase()];
    if (account == null || account.password != password) return null;
    return account.role;
  }
}