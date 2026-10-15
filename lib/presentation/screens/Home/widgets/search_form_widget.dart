import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

/// Campo de búsqueda con InputDecoration, icono de lupa y botón para limpiar.
class SearchFormWidget extends StatefulWidget {
  const SearchFormWidget({super.key, this.onSearch});

  final ValueChanged<String>? onSearch;

  @override
  State<SearchFormWidget> createState() => _SearchFormWidgetState();
}

class _SearchFormWidgetState extends State<SearchFormWidget> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // --- Eventos ---
  void _onSubmit(String value) {
    final text = value.trim();
    if (text.isEmpty) return;

    FocusScope.of(context).unfocus();

    if (widget.onSearch != null) {
      widget.onSearch!(text);
    } else {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text('Buscando: $text'),
            behavior: SnackBarBehavior.floating,
          ),
        );
    }
  }

  void _onClear() => _controller.clear();

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      textInputAction: TextInputAction.search,
      onSubmitted: _onSubmit,
      decoration: InputDecoration(
        hintText: 'Buscar producto, cliente o proveedor',
        prefixIcon: const Icon(Icons.search),
        suffixIcon: ValueListenableBuilder<TextEditingValue>(
          valueListenable: _controller,
          builder: (context, value, _) {
            if (value.text.isEmpty) return const SizedBox.shrink();
            return IconButton(
              icon: const Icon(Icons.close),
              tooltip: 'Limpiar',
              onPressed: _onClear,
            );
          },
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.azul, width: 2),
        ),
      ),
    );
  }
}