import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

enum CatalogFilter { todo, categorias, presentaciones }

/// Tres botones: Todo / Categorías / Presentaciones.
class CatalogFilterBar extends StatelessWidget {
  const CatalogFilterBar({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  final CatalogFilter selected;
  final ValueChanged<CatalogFilter> onChanged;

  static const _labels = {
    CatalogFilter.todo: 'Todo',
    CatalogFilter.categorias: 'Categorías',
    CatalogFilter.presentaciones: 'Presentaciones',
  };

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (final filter in CatalogFilter.values) ...[
          if (filter != CatalogFilter.values.first) const SizedBox(width: 8),
          Expanded(
            child: _FilterButton(
              label: _labels[filter]!,
              selected: filter == selected,
              onTap: () => onChanged(filter),
            ),
          ),
        ],
      ],
    );
  }
}

class _FilterButton extends StatelessWidget {
  const _FilterButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? DarkColors.naranjaBoton : DarkColors.tarjeta,
      borderRadius: BorderRadius.circular(20),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: 44,
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: selected ? DarkColors.naranjaBoton : DarkColors.borde,
            ),
          ),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              label,
              style: TextStyle(
                color: selected
                    ? const Color(0xFF1A1A1A)
                    : DarkColors.textoSuave,
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ),
    );
  }
}