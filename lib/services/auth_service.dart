import '../data/models/user_role.dart';

/// Servicio de autenticación (simulado, sin backend).
/// Cuando tengas API, solo cambias el interior de login().
class AuthService {
  static const Map<String, ({String password, UserRole role})> _demoAccounts = {
    'antonio@dontono.com': (
      password: '12345678',
      role: UserRole.administrador,
    ),
    'juan@dontono.com': (
      password: '12345678',
      role: UserRole.empleado,
    ),
  };

  Future<UserRole?> login(
    String email,
    String password, [
    UserRole? selectedRole,
  ]) async {
    await Future.delayed(const Duration(seconds: 1));

    final normalizedEmail = email.trim().toLowerCase();
    final account = _demoAccounts[normalizedEmail];
    if (account == null || account.password != password) {
      return null;
    }

    final expectedRole = selectedRole ?? account.role;
    if (expectedRole != account.role) {
      return null;
    }

    return account.role;
  }
}
