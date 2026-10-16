import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/constants/app_routes.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/models/user_role.dart';
import '../../../services/auth_service.dart';
import '../../widgets/primary_button.dart';
import 'login_validators.dart';
import 'widgets/login_header.dart';
import 'widgets/login_text_field.dart';
import 'widgets/role_selector.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  // Datos de prueba precargados (quítalos cuando conectes la base de datos).
  final _emailController = TextEditingController(text: 'antonio@dontono.com');
  final _passwordController = TextEditingController(text: '12345678');
  final _passwordFocus = FocusNode();
  final _authService = AuthService();

  UserRole _selectedRole = UserRole.administrador;
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  // --- Eventos ---
  void _togglePasswordVisibility() {
    setState(() => _obscurePassword = !_obscurePassword);
  }

  void _onRoleChanged(UserRole role) {
    setState(() => _selectedRole = role);
  }

  Future<void> _onLogin() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final ok = await _authService.login(
      _emailController.text,
      _passwordController.text,
    );

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (ok) {
      Navigator.pushReplacementNamed(
        context,
        AppRoutes.home,
        arguments: _selectedRole, // el menú se adapta al rol
      );
    } else {
      _showMessage('Correo o contraseña incorrectos');
    }
  }

  void _showMessage(String text) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(text),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  // --- UI ---
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: DarkColors.degradadoLogin,
              stops: DarkColors.stopsLogin,
            ),
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Positioned(
                top: -70,
                right: -90,
                child: Container(
                  width: 260,
                  height: 260,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.15),
                  ),
                ),
              ),
              SafeArea(
                child: Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 420),
                      child: Column(
                        children: [
                          const LoginHeader(),
                          const SizedBox(height: 28),
                          _buildFormCard(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFormCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: DarkColors.tarjeta,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LoginTextField(
              controller: _emailController,
              label: 'Correo electrónico',
              prefixIcon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              validator: Validators.email,
              onFieldSubmitted: (_) => _passwordFocus.requestFocus(),
            ),
            const SizedBox(height: 16),
            LoginTextField(
              controller: _passwordController,
              focusNode: _passwordFocus,
              label: 'Contraseña',
              prefixIcon: Icons.lock_outline,
              obscureText: _obscurePassword,
              textInputAction: TextInputAction.done,
              validator: Validators.password,
              onFieldSubmitted: (_) => _onLogin(),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility_off : Icons.visibility,
                  color: DarkColors.textoSuave,
                ),
                onPressed: _togglePasswordVisibility,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Entrar como (demo)',
              style: TextStyle(color: DarkColors.textoSuave, fontSize: 14),
            ),
            const SizedBox(height: 8),
            RoleSelector(
              selected: _selectedRole,
              onChanged: _onRoleChanged,
            ),
            const SizedBox(height: 16),
            PrimaryButton(
              text: 'Iniciar sesión',
              isLoading: _isLoading,
              onPressed: _onLogin,
              backgroundColor: DarkColors.naranjaBoton,
              foregroundColor: const Color(0xFF1A1A1A),
            ),
          ],
        ),
      ),
    );
  }
}