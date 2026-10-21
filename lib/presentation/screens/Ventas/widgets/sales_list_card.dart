import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../data/models/sale_model.dart';
import '../../../../data/repositories/sales_repository.dart';
import '../../../widgets/document_status_chip.dart';

/// Tarjeta de una factura dentro de la lista de ventas.
class SaleListCard extends StatelessWidget {
  const SaleListCard({super.key, required this.sale, required this.onTap});

  final SaleModel sale;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    // Las facturas anuladas se pintan en rojo; las demás usan los acentos.
    final index = ((sale.id ?? 1) - 1) % DarkColors.acentosProducto.length;
    final accent = sale.anulada
        ? DarkColors.inactivo
        : DarkColors.acentosProducto[index];
    final iconBackground = sale.anulada
        ? DarkColors.inactivoFondo
        : DarkColors.fondosIconoProducto[index];
    final cliente = SalesRepository.instance.clienteNombre(sale);

    return Material(
      color: DarkColors.tarjeta,
      borderRadius: BorderRadius.circular(22),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(width: 4, color: accent),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: iconBackground,
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Icon(AppIcons.ventas, color: accent, size: 28),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              sale.numeroComprobante,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '$cliente · ${AppFormat.date(sale.fechaVenta)}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: DarkColors.textoSuave,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            AppFormat.money(sale.total),
                            style: TextStyle(
                              color: sale.anulada
                                  ? DarkColors.textoSuave
                                  : Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              decoration: sale.anulada
                                  ? TextDecoration.lineThrough
                                  : null,
                            ),
                          ),
                          const SizedBox(height: 6),
                          DocumentStatusChip(anulada: sale.anulada),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
