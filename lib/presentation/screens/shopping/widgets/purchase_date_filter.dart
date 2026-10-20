import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/formatters.dart';

/// Botón "Filtrar por fecha". Cuando hay un rango elegido, lo muestra
/// y ofrece una X para quitarlo.
class PurchaseDateFilter extends StatelessWidget {
  const PurchaseDateFilter({
    super.key,
    required this.range,
    required this.onTap,
    required this.onClear,
  });

  final DateTimeRange? range;
  final VoidCallback onTap;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final selected = range;
    final label = selected == null
        ? 'Filtrar por fecha'
        : '${formatDate(selected.start)} – ${formatDate(selected.end)}';

    return Material(
      color: selected == null ? DarkColors.tarjeta : DarkColors.chip,
      borderRadius: BorderRadius.circular(20),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: selected == null
                  ? DarkColors.borde
                  : DarkColors.naranjaBoton,
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.calendar_month,
                color: selected == null
                    ? DarkColors.textoSuave
                    : DarkColors.naranjaBoton,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: selected == null
                        ? DarkColors.textoSuave
                        : Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              if (selected != null)
                GestureDetector(
                  onTap: onClear,
                  behavior: HitTestBehavior.opaque,
                  child: const Padding(
                    padding: EdgeInsets.all(6),
                    child: Icon(Icons.close, color: DarkColors.textoSuave),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}