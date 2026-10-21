import 'package:flutter/material.dart';

import 'product_field_style.dart';

class ProductTextField extends StatelessWidget {
  const ProductTextField({
    super.key,
    required this.controller,
    required this.label,
    this.hint,
    this.maxLines = 1,
    this.textInputAction,
    this.validator,
  });

  final TextEditingController controller;
  final String label;
  final String? hint;
  final int maxLines;
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
          maxLines: maxLines,
          minLines: maxLines,
          textCapitalization: TextCapitalization.sentences,
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