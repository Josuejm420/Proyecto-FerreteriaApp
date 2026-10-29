import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_icons.dart';

/// Aviso que se muestra cuando no hay ventas en el periodo elegido.
class ReportEmptyMessage extends StatelessWidget {
  const ReportEmptyMessage({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 16),
      decoration: BoxDecoration(
        color: DarkColors.tarjeta,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: DarkColors.borde),
      ),
      child: Column(
        children: [
          const Icon(AppIcons.reportes, size: 40, color: DarkColors.textoSuave),
          const SizedBox(height: 10),
          Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(color: DarkColors.textoSuave, fontSize: 15),
          ),
        ],
      ),
    );
  }
}