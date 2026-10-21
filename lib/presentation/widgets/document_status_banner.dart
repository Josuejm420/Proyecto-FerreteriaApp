import 'package:app_ferreteria/core/constants/app_icons.dart';
import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';

/// Franja grande con "Documento vigente" o "Documento anulado".
class DocumentStatusBanner extends StatelessWidget {
  const DocumentStatusBanner({super.key, required this.anulada});

  final bool anulada;

  @override
  Widget build(BuildContext context) {
    final color = anulada ? DarkColors.inactivo : DarkColors.activo;
    final background = anulada
        ? DarkColors.inactivoFondo
        : DarkColors.activoFondo;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(anulada ? AppIcons.anular : AppIcons.vigente, color: color),
          const SizedBox(width: 8),
          Text(
            anulada ? 'Documento anulado' : 'Documento vigente',
            style: TextStyle(
              color: color,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
