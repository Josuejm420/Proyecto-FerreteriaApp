import '../models/role_model.dart';
import '../models/user_model.dart';

/// Repositorio de usuarios y roles en memoria (datos de ejemplo).
/// Cuando tengas API, solo cambias el interior de estos métodos.
class UsersRepository {
  UsersRepository._();

  static final UsersRepository instance = UsersRepository._();

  int _nextId = 4;

  static const List<RoleModel> _roles = [
    RoleModel(
      id: 1,
      descripcion: 'Administrador',
      permisos: [
        'Ventas',
        'Productos',
        'Clientes',
        'Compras',
        'Proveedores',
        'Catálogos',
        'Gestión de usuarios',
        'Reportes',
      ],
    ),
    RoleModel(
      id: 2,
      descripcion: 'Empleado',
      permisos: ['Ventas', 'Productos', 'Clientes', 'Catálogos'],
    ),
  ];

  final List<UserModel> _users = [
    UserModel(
      id: 1,
      nombre: 'Don Antonio Ruiz',
      direccion: 'Jinotepe, Carazo',
      correo: 'antonio@dontono.com',
      contrasena: '12345678',
      idRol: 1,
      fechaRegistro: DateTime(2026, 1, 10),
    ),
    UserModel(
      id: 2,
      nombre: 'Juan Pérez',
      direccion: 'Diriamba, Carazo',
      correo: 'juan@dontono.com',
      contrasena: '12345678',
      idRol: 2,
      fechaRegistro: DateTime(2026, 3, 2),
    ),
    UserModel(
      id: 3,
      nombre: 'María López',
      direccion: 'San Marcos, Carazo',
      correo: 'maria@dontono.com',
      contrasena: '12345678',
      idRol: 2,
      activo: false,
      fechaRegistro: DateTime(2026, 5, 18),
    ),
  ];

  // --- Consultas ---
  List<UserModel> getAll() => List.unmodifiable(_users);

  List<RoleModel> getRoles() => _roles;

  RoleModel roleById(int id) {
    return _roles.firstWhere((r) => r.id == id, orElse: () => _roles.last);
  }

  /// true si ya existe otro usuario con ese correo.
  bool emailExists(String correo, {int? excludeId}) {
    final email = correo.trim().toLowerCase();
    return _users.any(
      (u) => u.id != excludeId && u.correo.trim().toLowerCase() == email,
    );
  }

  /// Crea el usuario si no tiene id; si lo tiene, lo actualiza.
  Future<UserModel> save(UserModel user) async {
    await Future.delayed(const Duration(milliseconds: 400));

    if (user.id == null) {
      final created = user.copyWith(id: _nextId++, fechaRegistro: DateTime.now());
      _users.insert(0, created);
      return created;
    }

    final index = _users.indexWhere((u) => u.id == user.id);
    if (index == -1) {
      _users.insert(0, user);
    } else {
      _users[index] = user;
    }
    return user;
  }
}