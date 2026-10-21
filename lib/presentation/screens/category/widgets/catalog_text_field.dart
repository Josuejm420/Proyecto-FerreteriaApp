import 'package:flutter/material.dart';

import '../../products/widgets/product_field_style.dart';

/// Campo de texto compartido por los formularios de categoría y presentación.
class CatalogTextField extends StatelessWidget {
  const CatalogTextField({
    super.key,
    required this.controller,
    required this.label,
    this.hint,
    this.keyboardType,
    this.textCapitalization = TextCapitalization.none,
    this.textInputAction,
    this.validator,
  });

  final TextEditingController controller;
  final String label;
  final String? hint;
  final TextInputType? keyboardType;
  final TextCapitalization textCapitalization;
  final TextInputAction? textInputAction;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FieldLabel(label),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          textCapitalization: textCapitalization,
          textInputAction: textInputAction,
          validator: validator,
          cursorColor: Colors.white,
          style: const TextStyle(color: Colors.white, fontSize: 17),
          decoration: productInputDecoration(hint: hint),
        ),
      ],
    );
  }
}