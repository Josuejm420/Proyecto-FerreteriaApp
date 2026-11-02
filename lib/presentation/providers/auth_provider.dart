import 'package:flutter/foundation.dart';

import '../../core/errors/api_exception.dart';
import '../../data/models/user_session.dart';
import '../../data/repositories/auth_repository.dart';

/// Estado de la sesión: quién inició sesión, si está cargando y el error.
class AuthProvider extends ChangeNotifier {
  AuthProvider(this._repository);

  final AuthRepository _repository;

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
      _session = await _repository.login(correo, contrasena);
      return true;
    } on ApiException catch (e) {
      _errorMessage = e.isUnauthorized
          ? 'Correo o contraseña incorrectos'
          : e.message;
      return false;
    } catch (_) {
      _errorMessage = 'El servidor respondió algo inesperado';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void logout() {
    _repository.logout();
    _session = null;
    notifyListeners();
  }
}