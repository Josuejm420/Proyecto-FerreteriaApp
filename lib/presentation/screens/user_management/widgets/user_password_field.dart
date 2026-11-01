import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_icons.dart';
import '../../products/widgets/product_field_style.dart';

/// Campo de contraseña oscuro con botón para mostrar u ocultar el texto.
class UserPasswordField extends StatefulWidget {
  const UserPasswordField({
    super.key,
    required this.controller,
    required this.label,
    this.hint,
    this.textInputAction,
    this.validator,
  });

  final TextEditingController controller;
  final String label;
  final String? hint;
  final TextInputAction? textInputAction;
  final String? Function(String?)? validator;

  @override
  State<UserPasswordField> createState() => _UserPasswordFieldState();
}

class _UserPasswordFieldState extends State<UserPasswordField> {
  bool _hidden = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FieldLabel(widget.label),
        TextFormField(
          controller: widget.controller,
          obscureText: _hidden,
          textInputAction: widget.textInputAction,
          validator: widget.validator,
          cursorColor: Colors.white,
          style: const TextStyle(color: Colors.white, fontSize: 17),
          decoration: productInputDecoration(hint: widget.hint).copyWith(
            suffixIcon: IconButton(
              tooltip: _hidden ? 'Mostrar' : 'Ocultar',
              icon: Icon(
                _hidden ? AppIcons.visibilidad : AppIcons.ocultar,
                color: DarkColors.textoSuave,
              ),
              onPressed: () => setState(() => _hidden = !_hidden),
            ),
          ),
        ),
      ],
    );
  }
}