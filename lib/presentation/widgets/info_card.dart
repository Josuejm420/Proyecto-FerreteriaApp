import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';

/// Tarjeta de datos: etiqueta a la izquierda y valor a la derecha.
/// Sirve para cualquier detalle (facturas, compras...).
/// [highlightIndex] resalta una fila, por ejemplo el Total.
class InfoCard extends StatelessWidget {
  const InfoCard({super.key, required this.rows, this.highlightIndex});

  final List<(String, String)> rows;
  final int? highlightIndex;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: DarkColors.tarjeta,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        children: [
          for (var i = 0; i < rows.length; i++) ...[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    rows[i].$1,
                    style: const TextStyle(
                      color: DarkColors.textoSuave,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Text(
                      rows[i].$2,
                      textAlign: TextAlign.end,
                      style: TextStyle(
                        color: i == highlightIndex
                            ? DarkColors.naranja
                            : Colors.white,
                        fontSize: i == highlightIndex ? 19 : 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (i < rows.length - 1)
              const Divider(height: 1, color: DarkColors.borde),
          ],
        ],
      ),
    );
  }
}
