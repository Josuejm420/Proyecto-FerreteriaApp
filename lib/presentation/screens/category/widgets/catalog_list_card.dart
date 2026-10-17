import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../products/widgets/status_chip.dart';

/// Tarjeta compartida por categorías y presentaciones.
class CatalogListCard extends StatelessWidget {
  const CatalogListCard({
    super.key,
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.activo,
    required this.accentIndex,
    required this.onTap,
  });

  final String emoji;
  final String title;
  final String subtitle;
  final bool activo;
  final int accentIndex; // elige el color de la franja y del icono
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final accent = DarkColors.acentosProducto[accentIndex];
    final iconBackground = DarkColors.fondosIconoProducto[accentIndex];

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
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: iconBackground,
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Text(emoji, style: const TextStyle(fontSize: 26)),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              subtitle,
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
                      StatusChip(activo: activo),
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