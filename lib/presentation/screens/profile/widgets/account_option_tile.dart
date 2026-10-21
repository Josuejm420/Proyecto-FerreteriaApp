import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

/// Fila de "Mi cuenta": icono en círculo, título y un widget al final.
class AccountOptionTile extends StatelessWidget {
  const AccountOptionTile({
    super.key,
    required this.emoji,
    required this.iconBackground,
    required this.title,
    required this.trailing,
    required this.onTap,
  });

  final String emoji;
  final Color iconBackground;
  final String title;
  final Widget trailing;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: DarkColors.campo,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: iconBackground,
                ),
                child: Text(emoji, style: const TextStyle(fontSize: 22)),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(color: Colors.white, fontSize: 17),
                ),
              ),
              trailing,
            ],
          ),
        ),
      ),
    );
  }
}