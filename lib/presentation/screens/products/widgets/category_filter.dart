import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

/// Chips horizontales: "Todos" + una por categoría.
class CategoryFilter extends StatelessWidget {
  const CategoryFilter({
    super.key,
    required this.categories,
    required this.selected,
    required this.onSelected,
  });

  final List<String> categories;
  final String? selected; // null = Todos
  final ValueChanged<String?> onSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: categories.length + 1,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final String? value = index == 0 ? null : categories[index - 1];
          final label = value ?? 'Todos';
          final isSelected = selected == value;

          return GestureDetector(
            onTap: () => onSelected(value),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 18),
              decoration: BoxDecoration(
                color:
                    isSelected ? DarkColors.naranjaBoton : DarkColors.tarjeta,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: isSelected
                      ? DarkColors.naranjaBoton
                      : DarkColors.borde,
                ),
              ),
              child: Text(
                label,
                style: TextStyle(
                  color: isSelected ? const Color(0xFF1A1A1A) : Colors.white,
                  fontSize: 16,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
