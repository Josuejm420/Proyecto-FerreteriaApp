import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../data/models/products_model.dart';

/// Tarjeta con los datos del producto (etiqueta a la izquierda, valor a la derecha).
class ProductInfoCard extends StatelessWidget {
  const ProductInfoCard({super.key, required this.product});

  final ProductsModel product;

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return '$day/$month/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final peso = product.peso;
    final rows = <(String, String)>[
      ('Descripción', product.descripcion.isEmpty ? '–' : product.descripcion),
      ('Categoría', product.categoria),
      ('Presentación', product.presentacion),
      ('Unidad de medida', product.unidadMedida),
      ('Peso', peso == null ? '–' : '$peso'),
      ('Fecha de registro', _formatDate(product.fechaRegistro)),
    ];

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
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
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