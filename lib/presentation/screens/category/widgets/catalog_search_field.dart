import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

class CatalogSearchField extends StatelessWidget {
  const CatalogSearchField({
    super.key,
    required this.controller,
    required this.onChanged,
    this.hintText = 'Buscar',
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final String hintText;

  OutlineInputBorder _border(Color color, double width) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(28),
      borderSide: BorderSide(color: color, width: width),
    );
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      textInputAction: TextInputAction.search,
      cursorColor: Colors.white,
      style: const TextStyle(color: Colors.white, fontSize: 17),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: DarkColors.textoSuave.withValues(alpha: 0.7)),
        prefixIcon: const Icon(Icons.search, color: DarkColors.textoSuave),
        suffixIcon: ValueListenableBuilder<TextEditingValue>(
          valueListenable: controller,
          builder: (context, value, _) {
            if (value.text.isEmpty) return const SizedBox.shrink();
            return IconButton(
              icon: const Icon(Icons.close, color: DarkColors.textoSuave),
              tooltip: 'Limpiar',
              onPressed: () {
                controller.clear();
                onChanged('');
              },
            );
          },
        ),
        filled: true,
        fillColor: DarkColors.tarjeta,
        contentPadding: const EdgeInsets.symmetric(vertical: 16),
        border: _border(Colors.white70, 2),
        enabledBorder: _border(Colors.white70, 2),
        focusedBorder: _border(DarkColors.naranjaBoton, 2),
      ),
    );
  }
}