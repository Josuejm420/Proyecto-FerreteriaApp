import 'package:flutter/material.dart';

class LoginPasswordField extends StatelessWidget {
  const LoginPasswordField({
    required this.controller,
    required this.isPasswordVisible,
    required this.onVisibilityChanged,
    super.key,
  });

  final TextEditingController controller;
  final bool isPasswordVisible;
  final VoidCallback onVisibilityChanged;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: !isPasswordVisible,
      textInputAction: TextInputAction.done,
      autofillHints: const [AutofillHints.password],
      onFieldSubmitted: (_) => FocusScope.of(context).unfocus(),
      decoration: InputDecoration(
        labelText: 'Contraseña',
        prefixIcon: const Icon(Icons.lock_outline),
        suffixIcon: IconButton(
          onPressed: onVisibilityChanged,
          tooltip: isPasswordVisible
              ? 'Ocultar contraseña'
              : 'Mostrar contraseña',
          icon: Icon(
            isPasswordVisible ? Icons.visibility_off : Icons.visibility,
          ),
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Ingresa tu contraseña';
        }
        return null;
      },
    );
  }
}
