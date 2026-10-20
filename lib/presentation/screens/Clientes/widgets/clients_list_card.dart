import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../data/models/client_model.dart';
import '../../products/widgets/status_chip.dart';

/// Tarjeta de un cliente dentro de la lista.
class ClientListCard extends StatelessWidget {
  const ClientListCard({super.key, required this.client, required this.onTap});

  final ClientModel client;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    // Reutilizamos los colores que ya existen en DarkColors.
    final index = ((client.id ?? 1) - 1) % DarkColors.acentosProducto.length;
    final accent = DarkColors.acentosProducto[index];
    final iconBackground = DarkColors.fondosIconoProducto[index];

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
                        child: Icon(AppIcons.clientes, color: accent, size: 28),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              client.nombre,
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
                              '${client.documento} · ${client.telefono}',
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
                      StatusChip(activo: client.activo),
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
