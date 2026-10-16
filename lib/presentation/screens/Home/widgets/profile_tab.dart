import 'package:flutter/material.dart';

import '../../../../core/constants/app_routes.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../data/models/user_role.dart';

/// Pestaña "Perfil": datos básicos y cerrar sesión.
class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key, required this.userName, required this.role});

  final String userName;
  final UserRole role;

  void _onLogout(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.login,
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 48,
                backgroundColor: DarkColors.naranja,
                child: Text(
                  userName.isEmpty ? '?' : userName[0].toUpperCase(),
                  style: const TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                userName,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: DarkColors.chip,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  role.label,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(height: 32),
              FilledButton.icon(
                onPressed: () => _onLogout(context),
                style: FilledButton.styleFrom(
                  backgroundColor: DarkColors.naranja,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(220, 48),
                ),
                icon: const Icon(Icons.logout),
                label: const Text('Cerrar sesión'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
