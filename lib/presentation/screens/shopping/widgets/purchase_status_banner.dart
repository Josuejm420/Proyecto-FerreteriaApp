import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

/// Franja superior del detalle: "Documento vigente" o "Documento anulado".
class PurchaseStatusBanner extends StatelessWidget {
  const PurchaseStatusBanner({super.key, required this.anulada});

  final bool anulada;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: anulada ? DarkColors.inactivoFondo : DarkColors.activoFondo,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        anulada ? '⛔ Documento anulado' : '✅ Documento vigente',
        style: TextStyle(
          color: anulada ? DarkColors.inactivo : DarkColors.activo,
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}