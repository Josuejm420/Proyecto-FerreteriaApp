import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

/// Tarjeta "Mis datos" con filas de etiqueta y valor.
class ProfileDataCard extends StatelessWidget {
  const ProfileDataCard({
    super.key,
    required this.nombre,
    required this.correo,
    required this.direccion,
    required this.estado,
    required this.miembroDesde,
  });

  final String nombre;
  final String correo;
  final String direccion;
  final String estado;
  final String miembroDesde;

  @override
  Widget build(BuildContext context) {
    final rows = <(String, String)>[
      ('Nombre', nombre),
      ('Correo', correo),
      ('Dirección', direccion),
      ('Estado', estado),
      ('Miembro desde', miembroDesde),
    ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: DarkColors.tarjeta,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        children: [
          for (var i = 0; i < rows.length; i++) ...[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Row(
                children: [
                  Text(
                    rows[i].$1,
                    style: const TextStyle(
                      color: DarkColors.textoSuave,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      rows[i].$2,
                      textAlign: TextAlign.end,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (i < rows.length - 1)
              const Divider(height: 1, color: DarkColors.borde),
          ],
        ],
      ),
    );
  }
}