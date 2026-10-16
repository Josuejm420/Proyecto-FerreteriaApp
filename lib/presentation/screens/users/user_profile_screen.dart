import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import 'widgets/user_profile_item.dart';

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({super.key});

  static const routeName = '/usuario/perfil';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil de usuario'),
        backgroundColor: AppColors.azul,
        foregroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'lib/assets/patron_de_marca.jpeg',
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: ColoredBox(color: Colors.black.withValues(alpha: 0.38)),
          ),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 440),
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: AppColors.fondo,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.12),
                          blurRadius: 18,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        CircleAvatar(
                          radius: 44,
                          backgroundColor: Theme.of(
                            context,
                          ).colorScheme.primary.withValues(alpha: 0.12),
                          child: Icon(
                            Icons.person_outline,
                            size: 52,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Mi perfil',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 24),
                        const UserProfileItem(
                          label: 'Nombre',
                          value: 'Nombre no registrado',
                          icon: Icons.person_outline,
                        ),
                        const UserProfileItem(
                          label: 'Dirección',
                          value: 'Dirección no registrada',
                          icon: Icons.location_on_outlined,
                        ),
                        const UserProfileItem(
                          label: 'Correo electrónico',
                          value: 'Correo no registrado',
                          icon: Icons.email_outlined,
                        ),
                        const UserProfileItem(
                          label: 'Rol',
                          value: 'Usuario',
                          icon: Icons.badge_outlined,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
