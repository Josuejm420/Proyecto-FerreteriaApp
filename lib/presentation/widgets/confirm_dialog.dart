import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';

/// Ventana de confirmación. Devuelve true si el usuario confirma.
/// Uso: if (await showConfirmDialog(context, ...)) { ... }
Future<bool> showConfirmDialog(
  BuildContext context, {
  required String title,
  required String message,
  required String confirmText,
  bool destructive = false, // true = botón rojo (acciones como anular)
}) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      backgroundColor: DarkColors.tarjeta,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      title: Text(
        title,
        style: const TextStyle(color: Colors.white, fontSize: 19),
      ),
      content: Text(
        message,
        style: const TextStyle(color: DarkColors.textoSuave),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialogContext, false),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(dialogContext, true),
          style: FilledButton.styleFrom(
            backgroundColor: destructive
                ? DarkColors.rojo
                : DarkColors.naranjaBoton,
            foregroundColor: destructive
                ? Colors.white
                : const Color(0xFF1A1A1A),
          ),
          child: Text(confirmText),
        ),
      ],
    ),
  );
  return result == true;
}
