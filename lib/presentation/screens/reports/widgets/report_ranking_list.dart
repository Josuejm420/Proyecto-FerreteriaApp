import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

/// Una fila del ranking: nombre, valor y barra de progreso.
class RankingItem {
  const RankingItem({
    required this.label,
    required this.value,
    required this.fraction,
    this.subtitle,
  });

  final String label;
  final String value; // texto a la derecha (ej. "12 uds")
  final double fraction; // 0.0 a 1.0 (largo de la barra)
  final String? subtitle;
}

/// Lista con posición, valor y barra de color. Se usa en los 3 rankings.
class ReportRankingList extends StatelessWidget {
  const ReportRankingList({super.key, required this.items});

  final List<RankingItem> items;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: DarkColors.tarjeta,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: DarkColors.borde),
      ),
      child: Column(
        children: [
          for (var i = 0; i < items.length; i++) ...[
            if (i > 0) const SizedBox(height: 16),
            _RankingRow(position: i + 1, item: items[i]),
          ],
        ],
      ),
    );
  }
}

class _RankingRow extends StatelessWidget {
  const _RankingRow({required this.position, required this.item});

  final int position;
  final RankingItem item;

  @override
  Widget build(BuildContext context) {
    final index = (position - 1) % DarkColors.acentosProducto.length;
    final accent = DarkColors.acentosProducto[index];
    final iconBackground = DarkColors.fondosIconoProducto[index];

    return Column(
      children: [
        Row(
          children: [
            Container(
              width: 32,
              height: 32,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: iconBackground,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '$position',
                style: TextStyle(
                  color: accent,
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  if (item.subtitle != null)
                    Text(
                      item.subtitle!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: DarkColors.textoSuave,
                        fontSize: 13,
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Text(
              item.value,
              style: TextStyle(
                color: accent,
                fontSize: 15,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(
            value: item.fraction.clamp(0.0, 1.0),
            minHeight: 8,
            backgroundColor: DarkColors.campo,
            valueColor: AlwaysStoppedAnimation<Color>(accent),
          ),
        ),
      ],
    );
  }
}