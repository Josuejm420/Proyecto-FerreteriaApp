import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

class LoginHeader extends StatelessWidget {
  const LoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: DarkColors.naranjaBoton,
            borderRadius: BorderRadius.circular(26),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: const Text('🛠️', style: TextStyle(fontSize: 42)),
        ),
        const SizedBox(height: 20),
        const Text(
          'Ferretería Don Toño',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Panel administrativo',
          style: TextStyle(color: Color(0xFFD0D6EE), fontSize: 17),
        ),
      ],
    );
  }
}