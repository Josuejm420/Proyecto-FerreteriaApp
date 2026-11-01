import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_icons.dart';
import '../../../data/models/user_model.dart';
import '../../../data/repositories/users_repository.dart';
import '../../widgets/app_search_field.dart';
import '../../widgets/screen_title_bar.dart';
import '../products/widgets/category_filter.dart';
import 'user_form_screen.dart';
import 'widgets/user_list_card.dart';

/// Gestión de usuarios. Solo se muestra en el menú del Administrador.
class UserManagementScreen extends StatefulWidget {
  const UserManagementScreen({super.key, this.showBack = false});

  /// true cuando se abre como pantalla aparte (con flecha para volver).
  final bool showBack;

  @override
  State<UserManagementScreen> createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen> {
  final _repository = UsersRepository.instance;
  final _searchController = TextEditingController();

  List<UserModel> _users = [];
  String _query = '';
  String? _roleFilter; // null = Todos

  @override
  void initState() {
    super.initState();
    _users = _repository.getAll();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// Usuarios que coinciden con el texto (nombre o correo) y con el rol elegido.
  List<UserModel> get _filtered {
    final query = _query.trim().toLowerCase();
    return _users.where((u) {
      final role = _repository.roleById(u.idRol).descripcion;
      final matchesRole = _roleFilter == null || role == _roleFilter;
      final matchesQuery = query.isEmpty ||
          u.nombre.toLowerCase().contains(query) ||
          u.correo.toLowerCase().contains(query);
      return matchesRole && matchesQuery;
    }).toList();
  }

  // --- Eventos ---
  void _reload() => setState(() => _users = _repository.getAll());

  void _onSearchChanged(String value) => setState(() => _query = value);

  void _onRoleSelected(String? role) => setState(() => _roleFilter = role);

  Future<void> _openCreate() async {
    final created = await Navigator.push<UserModel>(
      context,
      MaterialPageRoute(builder: (context) => const UserFormScreen()),
    );
    if (!mounted) return;
    _reload();
    if (created != null) _showMessage('Usuario creado correctamente');
  }

  Future<void> _openEdit(UserModel user) async {
    final updated = await Navigator.push<UserModel>(
      context,
      MaterialPageRoute(builder: (context) => UserFormScreen(user: user)),
    );
    if (!mounted) return;
    _reload();
    if (updated != null) _showMessage('Usuario actualizado correctamente');
  }

  void _showMessage(String text) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(text), behavior: SnackBarBehavior.floating),
      );
  }

  @override
  Widget build(BuildContext context) {
    final items = _filtered;
    final roleNames = [
      for (final role in _repository.getRoles()) role.descripcion,
    ];

    return Scaffold(
      backgroundColor: DarkColors.fondo,
      floatingActionButton: FloatingActionButton(
        onPressed: _openCreate,
        tooltip: 'Nuevo usuario',
        backgroundColor: DarkColors.naranjaBoton,
        foregroundColor: const Color(0xFF1A1A1A),
        shape: const CircleBorder(),
        child: const Icon(AppIcons.usuarioNuevo, size: 28),
      ),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: ScreenTitleBar(
                title: 'Gestión de usuarios',
                onBack: widget.showBack ? () => Navigator.pop(context) : null,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: AppSearchField(
                controller: _searchController,
                onChanged: _onSearchChanged,
                hint: 'Buscar por nombre o correo',
              ),
            ),
            const SizedBox(height: 12),
            CategoryFilter(
              categories: roleNames,
              selected: _roleFilter,
              onSelected: _onRoleSelected,
            ),
            const SizedBox(height: 12),
            Expanded(
              child: items.isEmpty
                  ? Center(
                      child: Text(
                        _users.isEmpty
                            ? 'Aún no hay usuarios registrados'
                            : 'No se encontraron usuarios',
                        style: const TextStyle(color: DarkColors.textoSuave),
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(16, 4, 16, 96),
                      itemCount: items.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final user = items[index];
                        return UserListCard(
                          user: user,
                          role: _repository.roleById(user.idRol),
                          onTap: () => _openEdit(user),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}