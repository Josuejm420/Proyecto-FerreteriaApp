import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_icons.dart';
import '../../../core/utils/formatters.dart';
import '../../../data/models/user_model.dart';
import '../../../data/repositories/users_repository.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/screen_title_bar.dart';
import '../products/widgets/product_dropdown.dart';
import 'user_management_validators.dart';
import 'widgets/role_permissions_card.dart';
import 'widgets/user_password_field.dart';

/// Formulario para crear (user == null) o editar un usuario.
class UserFormScreen extends StatefulWidget {
  const UserFormScreen({super.key, this.user});

  final UserModel? user;

  @override
  State<UserFormScreen> createState() => _UserFormScreenState();
}

class _UserFormScreenState extends State<UserFormScreen> {
  final _repository = UsersRepository.instance;
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nombreController;
  late final TextEditingController _direccionController;
  late final TextEditingController _correoController;
  late final TextEditingController _contrasenaController;

  int? _idRol;
  bool _activo = true;
  bool _isSaving = false;

  bool get _isEditing => widget.user != null;

  @override
  void initState() {
    super.initState();
    final user = widget.user;

    _nombreController = TextEditingController(text: user?.nombre ?? '');
    _direccionController = TextEditingController(text: user?.direccion ?? '');
    _correoController = TextEditingController(text: user?.correo ?? '');
    _contrasenaController = TextEditingController();
    _idRol = user?.idRol;
    _activo = user?.activo ?? true;
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _direccionController.dispose();
    _correoController.dispose();
    _contrasenaController.dispose();
    super.dispose();
  }

  // --- Validaciones ---
  String? _validateCorreo(String? value) {
    final error = UserManagementValidators.correo(value);
    if (error != null) return error;
    final exists = _repository.emailExists(
      value!,
      excludeId: widget.user?.id,
    );
    return exists ? 'Este correo ya está registrado' : null;
  }

  // --- Eventos ---
  void _onRoleChanged(int? value) => setState(() => _idRol = value);

  void _onActiveChanged(bool? value) => setState(() => _activo = value ?? true);

  Future<void> _onSave() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    // Al editar, si no escribe contraseña nueva se conserva la anterior.
    final newPassword = _contrasenaController.text;
    final user = UserModel(
      id: widget.user?.id,
      nombre: _nombreController.text.trim(),
      direccion: _direccionController.text.trim(),
      correo: _correoController.text.trim(),
      contrasena: newPassword.isEmpty
          ? (widget.user?.contrasena ?? '')
          : newPassword,
      activo: _activo,
      fechaRegistro: widget.user?.fechaRegistro,
      idRol: _idRol!,
    );

    final saved = await _repository.save(user);

    if (!mounted) return;
    setState(() => _isSaving = false);
    Navigator.pop(context, saved); // devuelve el usuario guardado
  }

  @override
  Widget build(BuildContext context) {
    final roles = _repository.getRoles();
    final selectedRole = _idRol == null ? null : _repository.roleById(_idRol!);
    final registered = widget.user?.fechaRegistro;

    return Scaffold(
      backgroundColor: DarkColors.fondo,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          children: [
            ScreenTitleBar(
              title: _isEditing ? 'Editar usuario' : 'Nuevo usuario',
              onBack: () => Navigator.pop(context),
            ),
            const SizedBox(height: 20),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  AppTextField(
                    controller: _nombreController,
                    label: 'Nombre',
                    hint: 'Ej. Juan Pérez',
                    textCapitalization: TextCapitalization.words,
                    textInputAction: TextInputAction.next,
                    validator: UserManagementValidators.nombre,
                  ),
                  const SizedBox(height: 16),
                  AppTextField(
                    controller: _direccionController,
                    label: 'Dirección',
                    hint: 'Ej. Jinotepe, Carazo',
                    textCapitalization: TextCapitalization.sentences,
                    textInputAction: TextInputAction.next,
                    validator: UserManagementValidators.direccion,
                  ),
                  const SizedBox(height: 16),
                  AppTextField(
                    controller: _correoController,
                    label: 'Correo',
                    hint: 'Ej. usuario@dontono.com',
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    validator: _validateCorreo,
                  ),
                  const SizedBox(height: 16),
                  UserPasswordField(
                    controller: _contrasenaController,
                    label: _isEditing
                        ? 'Nueva contraseña (opcional)'
                        : 'Contraseña',
                    hint: _isEditing
                        ? 'Déjala vacía para no cambiarla'
                        : 'Mínimo 8 caracteres',
                    textInputAction: TextInputAction.done,
                    validator: (value) => UserManagementValidators.contrasena(
                      value,
                      isEditing: _isEditing,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ProductDropdown<int>(
                    label: 'Rol',
                    value: _idRol,
                    items: [for (final role in roles) role.id],
                    itemLabel: (id) => _repository.roleById(id).descripcion,
                    onChanged: _onRoleChanged,
                    validator: UserManagementValidators.rol,
                  ),
                  if (selectedRole != null) ...[
                    const SizedBox(height: 16),
                    RolePermissionsCard(role: selectedRole),
                  ],
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Text(
                        _activo ? 'Estado (activo)' : 'Estado (inactivo)',
                        style: const TextStyle(
                          color: DarkColors.textoSuave,
                          fontSize: 16,
                        ),
                      ),
                      const Spacer(),
                      Checkbox(
                        value: _activo,
                        onChanged: _onActiveChanged,
                        activeColor: DarkColors.checkAzul,
                        checkColor: const Color(0xFF14192E),
                        side: const BorderSide(
                          color: DarkColors.textoSuave,
                          width: 2,
                        ),
                      ),
                    ],
                  ),
                  if (registered != null) ...[
                    Row(
                      children: [
                        const Icon(
                          AppIcons.calendario,
                          size: 16,
                          color: DarkColors.textoSuave,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Registrado el ${formatDate(registered)}',
                          style: const TextStyle(
                            color: DarkColors.textoSuave,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                  const SizedBox(height: 20),
                  PrimaryButton(
                    text: 'Guardar',
                    isLoading: _isSaving,
                    onPressed: _onSave,
                    backgroundColor: DarkColors.naranjaBoton,
                    foregroundColor: const Color(0xFF1A1A1A),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}