import '../../core/di/service_locator.dart';
import '../../core/errors/api_exception.dart';
import '../../core/network/api_client.dart';
import '../models/role_model.dart';
import '../models/user_model.dart';

/// Usuarios persistidos en la API.
class UsersRepository {
  UsersRepository._();
  static final UsersRepository instance = UsersRepository._();
  ApiClient get _api => getIt<ApiClient>();

  static const List<RoleModel> _roles = [
    RoleModel(id: 1, descripcion: 'Administrador', permisos: ['Ventas','Productos','Clientes','Compras','Proveedores','Catálogos','Gestión de usuarios','Reportes']),
    RoleModel(id: 2, descripcion: 'Empleado', permisos: ['Ventas','Productos','Clientes','Catálogos']),
  ];
  List<UserModel> _users = [];
  List<UserModel> getAll() => List.unmodifiable(_users);
  List<RoleModel> getRoles() => _roles;
  RoleModel roleById(int id) => _roles.firstWhere((r) => r.id == id, orElse: () => _roles.last);
  bool emailExists(String correo, {int? excludeId}) => _users.any((u) => u.id != excludeId && u.correo.trim().toLowerCase() == correo.trim().toLowerCase());

  Future<List<UserModel>> refresh() async {
    final data = await _api.get('/Usuario_Controllers');
    final rows = data is List
        ? data
        : data is Map && data['datos'] is List
            ? data['datos'] as List
            : data is Map && data['data'] is List
                ? data['data'] as List
                : null;
    if (rows != null) {
      _users = rows.whereType<Map<String, dynamic>>().map(UserModel.fromJson).toList();
    }
    return getAll();
  }

  Future<UserModel> save(UserModel user) async {
    if (user.id != null) {
      throw const ApiException('La API proporcionada solo documenta creación de usuarios (POST).');
    }
    final response = await _api.post('/Usuario_Controllers', body: user.toJson());
    UserModel saved = user;
    if (response is Map<String, dynamic>) {
      final candidate = response['usuario'] ?? response['data'] ?? response;
      if (candidate is Map<String, dynamic>) {
        try { saved = UserModel.fromJson(candidate); } catch (_) {}
      }
    }
    _users = [saved, ..._users.where((u) => u.correo.toLowerCase() != saved.correo.toLowerCase())];
    try { await refresh(); } catch (_) {}
    return _users.firstWhere((u) => u.correo.toLowerCase() == user.correo.toLowerCase(), orElse: () => saved);
  }
}
