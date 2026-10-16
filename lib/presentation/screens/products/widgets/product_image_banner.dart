import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

class ProductImageBanner extends StatelessWidget {
  const ProductImageBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      width: double.infinity,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF3A3028), Color(0xFF1F3156)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: DarkColors.borde),
      ),
      child: const Text('📦', style: TextStyle(fontSize: 64)),
    );
  }
}