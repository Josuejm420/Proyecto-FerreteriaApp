import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import 'product_field_style.dart';

class ProductDropdown<T> extends StatelessWidget {
  const ProductDropdown({
    super.key,
    required this.label,
    required this.items,
    required this.itemLabel,
    required this.onChanged,
    this.value,
    this.validator,
  });

  final String label;
  final T? value;
  final List<T> items;
  final String Function(T) itemLabel;
  final ValueChanged<T?> onChanged;
  final String? Function(T?)? validator;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FieldLabel(label),
        DropdownButtonFormField<T>(
          initialValue: value,
          isExpanded: true,
          dropdownColor: DarkColors.tarjeta,
          iconEnabledColor: DarkColors.textoSuave,
          borderRadius: BorderRadius.circular(16),
          style: const TextStyle(color: Colors.white, fontSize: 17),
          decoration: productInputDecoration(),
          validator: validator,
          onChanged: onChanged,
          items: [
            for (final item in items)
              DropdownMenuItem<T>(value: item, child: Text(itemLabel(item))),
          ],
        ),
      ],
    );
  }
}