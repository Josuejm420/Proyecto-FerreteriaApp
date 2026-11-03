import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_routes.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/primary_button.dart';
import 'login_validators.dart';
import 'widgets/login_header.dart';
import 'widgets/login_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  static const routeName = AppRoutes.login;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordFocus = FocusNode();

  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  void _togglePasswordVisibility() {
    setState(() => _obscurePassword = !_obscurePassword);
  }

  void _onRoleChanged(UserRole role) {
    setState(() {
      _selectedRole = role;
      _emailController.text = role.demoEmail;
      _emailController.selection = TextSelection.fromPosition(
        TextPosition(offset: _emailController.text.length),
      );
      _passwordController.text = '12345678';
    });
  }

  Future<void> _onLogin() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;

    final auth = context.read<AuthProvider>();
    final success = await auth.login(
      _emailController.text.trim(),
      _passwordController.text,
    );

    if (!mounted) return;

    if (success) {
      // El rol y el nombre se leen de la sesión (AuthProvider) en las rutas.
      Navigator.pushReplacementNamed(context, AppRoutes.home);
    } else {
      _showMessage(auth.errorMessage ?? 'No se pudo iniciar sesión');
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
                          const SizedBox(height: 20),
                          RoleSelector(
                            selected: _selectedRole,
                            onChanged: _onRoleChanged,
                          ),
                          const SizedBox(height: 20),
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
                tooltip: _obscurePassword
                    ? 'Mostrar contraseña'
                    : 'Ocultar contraseña',
                icon: Icon(
                  _obscurePassword ? Icons.visibility_off : Icons.visibility,
                  color: DarkColors.textoSuave,
                ),
                onPressed: _togglePasswordVisibility,
              ),
            ),
            const SizedBox(height: 24),
            PrimaryButton(
              text: 'Iniciar sesión',
              isLoading: context.select<AuthProvider, bool>(
                (provider) => provider.isLoading,
              ),
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