import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

/// Tarjeta con filas "etiqueta ... valor". Sirve para los datos de la
/// compra y para los totales (Subtotal, IVA, Total).
class PurchaseInfoCard extends StatelessWidget {
  const PurchaseInfoCard({super.key, required this.rows});

  final List<MapEntry<String, String>> rows;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: DarkColors.tarjeta,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          for (final row in rows)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: DarkColors.borde)),
              ),
              child: Row(
                children: [
                  Text(
                    row.key,
                    style: const TextStyle(
                      color: DarkColors.textoSuave,
                      fontSize: 17,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      row.value,
                      textAlign: TextAlign.right,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}