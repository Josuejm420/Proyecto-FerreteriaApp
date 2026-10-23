import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_icons.dart';

/// Franja superior del detalle: "Documento vigente" o "Documento anulado".
class PurchaseStatusBanner extends StatelessWidget {
  const PurchaseStatusBanner({super.key, required this.anulada});

  final bool anulada;

  @override
  Widget build(BuildContext context) {
    final color = anulada ? DarkColors.inactivo : DarkColors.activo;

    return Container(
      height: 60,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: anulada ? DarkColors.inactivoFondo : DarkColors.activoFondo,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            anulada ? AppIcons.anular : AppIcons.vigente,
            color: color,
            size: 24,
          ),
          const SizedBox(width: 8),
          Text(
            anulada ? 'Documento anulado' : 'Documento vigente',
            style: TextStyle(
              color: color,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}