import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/utils/formatters.dart';

/// Una línea del detalle: "2 × Tornillos" y su subtotal.
class DocumentLine {
  const DocumentLine({
    required this.nombre,
    required this.cantidad,
    required this.subtotal,
  });

  final String nombre;
  final int cantidad;
  final double subtotal;
}

/// Tarjeta con las líneas de una factura o de una compra.
class DocumentLinesCard extends StatelessWidget {
  const DocumentLinesCard({super.key, required this.lines});

  final List<DocumentLine> lines;

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
          for (var i = 0; i < lines.length; i++) ...[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      '${lines[i].cantidad} × ${lines[i].nombre}',
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    AppFormat.money(lines[i].subtotal),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            if (i < lines.length - 1)
              const Divider(height: 1, color: DarkColors.borde),
          ],
        ],
      ),
    );
  }
}
