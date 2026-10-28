import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

/// Pantalla temporal para las secciones que todavía no existen.
class SectionPlaceholderScreen extends StatelessWidget {
  const SectionPlaceholderScreen({
    super.key,
    required this.title,
    required this.icon,
  });

  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DarkColors.fondo,
      appBar: AppBar(
        title: Text(title),
        backgroundColor: DarkColors.tarjeta,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 64, color: DarkColors.naranja),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Sección en construcción',
              style: TextStyle(color: DarkColors.textoSuave),
            ),
          ],
        ),
      ),
    );
  }
}
