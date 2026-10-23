import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

/// Título de sección con barra naranja a la izquierda y un ícono.
class SectionTitle extends StatelessWidget {
  const SectionTitle({super.key, required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 24,
          decoration: BoxDecoration(
            color: DarkColors.naranja,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 10),
        Icon(icon, color: DarkColors.naranja, size: 24),
        const SizedBox(width: 8),
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