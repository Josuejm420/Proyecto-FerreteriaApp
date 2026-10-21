import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

class StatusChip extends StatelessWidget {
  const StatusChip({super.key, required this.activo});

  final bool activo;

  @override
  Widget build(BuildContext context) {
    final color = activo ? DarkColors.activo : DarkColors.inactivo;
    final background =
        activo ? DarkColors.activoFondo : DarkColors.inactivoFondo;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        activo ? '● Activo' : '● Inactivo',
        style: TextStyle(
          color: color,
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}