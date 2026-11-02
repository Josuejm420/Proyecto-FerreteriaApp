import 'package:flutter/foundation.dart';

import '../../data/models/user_role.dart';
import '../../data/models/user_session.dart';
import '../../services/auth_service.dart';

/// Estado de la sesión: quién inició sesión, si está cargando y el error.
class AuthProvider extends ChangeNotifier {
  AuthProvider(this._authService);

  final AuthService _authService;

  UserSession? _session;
  bool _isLoading = false;
  String? _errorMessage;

  UserSession? get session => _session;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isLoggedIn => _session != null;

  /// true si el login fue correcto. Si falla, deja el motivo en errorMessage.
  Future<bool> login(String correo, String contrasena) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final role = await _authService.login(correo, contrasena);
      if (role == null) {
        _errorMessage = 'Correo o contraseña incorrectos';
        return false;
      }

      _session = UserSession(
        token: 'demo-token',
        id: role == UserRole.administrador ? 1 : 2,
        nombre: role.demoName,
        correo: correo.trim(),
        rolDescripcion: role.label,
      );
      return true;
    } catch (_) {
      _errorMessage = 'El servidor respondió algo inesperado';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void logout() {
    _session = null;
    notifyListeners();
  }
}