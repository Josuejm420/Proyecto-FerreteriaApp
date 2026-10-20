import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../data/models/purchase_item_model.dart';

/// Tarjeta "Detalle" con los productos de la compra: "5 × Taladro ... C$ 5,500.00".
class PurchaseItemsCard extends StatelessWidget {
  const PurchaseItemsCard({super.key, required this.items});

  final List<PurchaseItemModel> items;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 10),
      decoration: BoxDecoration(
        color: DarkColors.tarjeta,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 4,
                height: 22,
                decoration: BoxDecoration(
                  color: DarkColors.naranjaBoton,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 10),
              const Text(
                'Detalle',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          for (final item in items)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: DarkColors.borde)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      '${item.cantidad} × ${item.producto}',
                      style: const TextStyle(color: Colors.white, fontSize: 17),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    formatMoney(item.subtotal),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
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