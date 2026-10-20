import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

/// Etiqueta "Emitida" (verde) o "Anulada" (roja).
class PurchaseStatusChip extends StatelessWidget {
  const PurchaseStatusChip({super.key, required this.anulada});

  final bool anulada;

  @override
  Widget build(BuildContext context) {
    final color = anulada ? DarkColors.inactivo : DarkColors.activo;
    final background =
        anulada ? DarkColors.inactivoFondo : DarkColors.activoFondo;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        anulada ? '● Anulada' : '● Emitida',
        style: TextStyle(
          color: color,
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}