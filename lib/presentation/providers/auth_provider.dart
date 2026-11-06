import 'package:flutter/foundation.dart';

import '../../core/errors/api_exception.dart';
import '../../data/models/user_session.dart';
import '../../data/repositories/auth_repository.dart';


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

  
  Future<bool> login(String correo, String contrasena) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _session = await _repository.login(correo, contrasena);
      return true;
    } on ApiException catch (e) {
      // DIAGNÓSTICO: muestra el código y el mensaje reales de la API.
      debugPrint('Login falló: ${e.statusCode} - ${e.message}');
      _errorMessage = '${e.statusCode ?? ''} ${e.message}'.trim();
      return false;
    } catch (e, stack) {
    
      debugPrint('Error leyendo la respuesta del login: $e');
      debugPrint('$stack');
      _errorMessage = 'La respuesta del servidor no tiene el formato esperado';
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
