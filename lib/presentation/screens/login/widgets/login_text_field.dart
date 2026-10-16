import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

/// Campo oscuro del login: etiqueta arriba y InputDecoration con icono.
class LoginTextField extends StatelessWidget {
  const LoginTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.prefixIcon,
    this.hint,
    this.suffixIcon,
    this.obscureText = false,
    this.keyboardType,
    this.textInputAction,
    this.focusNode,
    this.validator,
    this.onFieldSubmitted,
  });

  final TextEditingController controller;
  final String label;
  final IconData prefixIcon;
  final String? hint;
  final Widget? suffixIcon;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final FocusNode? focusNode;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onFieldSubmitted;

  OutlineInputBorder _border(Color color, [double width = 1]) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(color: color, width: width),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: DarkColors.textoSuave, fontSize: 14),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          focusNode: focusNode,
          obscureText: obscureText,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          validator: validator,
          onFieldSubmitted: onFieldSubmitted,
          cursorColor: DarkColors.naranja,
          style: const TextStyle(color: Colors.white, fontSize: 16),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: DarkColors.textoSuave.withValues(alpha: 0.6),
            ),
            prefixIcon: Icon(prefixIcon, color: DarkColors.textoSuave),
            suffixIcon: suffixIcon,
            filled: true,
            fillColor: DarkColors.campo,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            border: _border(DarkColors.borde),
            enabledBorder: _border(DarkColors.borde),
            focusedBorder: _border(DarkColors.naranja, 2),
            errorBorder: _border(const Color(0xFFFF8A80)),
            focusedErrorBorder: _border(const Color(0xFFFF8A80), 2),
            errorStyle: const TextStyle(color: Color(0xFFFF8A80)),
          ),
        ),
      ],
    );
  }
}
