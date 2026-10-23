import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../home_module.dart';

class ModuleCard extends StatelessWidget {
  const ModuleCard({super.key, required this.module, required this.onTap});

  final HomeModule module;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: DarkColors.tarjeta,
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 48,
                height: 48,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: module.color,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(module.icon, color: module.accent, size: 26),
              ),
              Text(
                module.label,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}