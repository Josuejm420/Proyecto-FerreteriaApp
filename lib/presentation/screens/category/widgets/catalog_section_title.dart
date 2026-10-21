import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

/// Título de sección con barrita naranja: "Categorías", "Presentaciones".
class CatalogSectionTitle extends StatelessWidget {
  const CatalogSectionTitle(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 22,
          decoration: BoxDecoration(
            color: DarkColors.naranjaBoton,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}