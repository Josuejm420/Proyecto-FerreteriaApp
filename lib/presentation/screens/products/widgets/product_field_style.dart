import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

OutlineInputBorder _border(Color color, [double width = 1]) {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(16),
    borderSide: BorderSide(color: color, width: width),
  );
}

/// InputDecoration oscuro compartido por los campos del formulario.
InputDecoration productInputDecoration({String? hint}) {
  return InputDecoration(
    hintText: hint,
    hintStyle: TextStyle(color: DarkColors.textoSuave.withValues(alpha: 0.6)),
    filled: true,
    fillColor: DarkColors.tarjeta,
    contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
    border: _border(DarkColors.borde),
    enabledBorder: _border(DarkColors.borde),
    focusedBorder: _border(DarkColors.naranjaBoton, 2),
    errorBorder: _border(const Color(0xFFFF8A80)),
    focusedErrorBorder: _border(const Color(0xFFFF8A80), 2),
    errorStyle: const TextStyle(color: Color(0xFFFF8A80)),
  );
}

/// Etiqueta pequeña que va encima de cada campo.
class FieldLabel extends StatelessWidget {
  const FieldLabel(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(color: DarkColors.textoSuave, fontSize: 15),
      ),
    );
  }
}