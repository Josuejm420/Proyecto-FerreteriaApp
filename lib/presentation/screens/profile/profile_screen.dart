import 'package:flutter/material.dart';

import '../../../core/constants/app_routes.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_icons.dart';
import '../../../data/models/user_role.dart';
import 'widgets/account_option_tile.dart';
import 'widgets/dashed_notice.dart';
import 'widgets/profile_data_card.dart';
import 'widgets/profile_header_card.dart';
import 'widgets/profile_stat_card.dart';
import 'widgets/profile_title_bar.dart';
import 'widgets/section_title.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key, required this.userName, required this.role});

  final String userName;
  final UserRole role;

  // Datos de ejemplo: luego vendrán de la base de datos.
  static const _address = 'Jinotepe, Carazo';
  static const _memberSince = '12/01/2026';
  static const _lockedMessage =
      'Para modificar tus datos, tienes que decírselo a tu administrador';

  List<String> get _permissions => role == UserRole.administrador
      ? const [
          'Ver y registrar ventas',
          'Gestionar productos y catálogos',
          'Administrar clientes y proveedores',
          'Registrar compras',
          'Consultar reportes',
          'Gestionar usuarios y roles',
        ]
      : const [
          'Ver y registrar ventas',
          'Consultar productos y catálogos',
          'Consultar clientes',
        ];

  // --- Eventos ---
  void _onLockedTap(BuildContext context) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(
          content: Text(_lockedMessage),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  void _onPermissionsTap(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: DarkColors.tarjeta,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (_) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    AppIcons.permisosPerfil,
                    color: DarkColors.naranja,
                    size: 26,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Mis permisos · ${role.label}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              for (final permission in _permissions)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    children: [
                      const Icon(
                        AppIcons.vigente,
                        color: Color(0xFF22A55B),
                        size: 22,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          permission,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

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
      bottom: false,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        children: [
          const ProfileTitleBar(),
          const SizedBox(height: 16),
          ProfileHeaderCard(
            name: userName,
            role: role.label,
            email: role.demoEmail,
          ),
          const SizedBox(height: 14),
          const IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: ProfileStatCard(
                    icon: AppIcons.ventas,
                    label: 'Facturas atendidas',
                    value: '0',
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: ProfileStatCard(
                    icon: AppIcons.dinero,
                    label: 'Total vendido',
                    value: 'C\$ 0.00',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const SectionTitle(icon: AppIcons.cuenta, text: 'Mi cuenta'),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: DarkColors.tarjeta,
              borderRadius: BorderRadius.circular(28),
            ),
            child: Column(
              children: [
                AccountOptionTile(
                  icon: AppIcons.editar,
                  iconColor: const Color(0xFFF5A524),
                  iconBackground: const Color(0xFF4A3F35),
                  title: 'Editar mis datos',
                  trailing: const Icon(
                    AppIcons.candado,
                    color: DarkColors.textoSuave,
                    size: 22,
                  ),
                  onTap: () => _onLockedTap(context),
                ),
                const SizedBox(height: 10),
                AccountOptionTile(
                  icon: AppIcons.contrasena,
                  iconColor: const Color(0xFF3B82F6),
                  iconBackground: const Color(0xFF1F3156),
                  title: 'Cambiar contraseña',
                  trailing: const Icon(
                    AppIcons.candado,
                    color: DarkColors.textoSuave,
                    size: 22,
                  ),
                  onTap: () => _onLockedTap(context),
                ),
                const SizedBox(height: 10),
                AccountOptionTile(
                  icon: AppIcons.permisosPerfil,
                  iconColor: const Color(0xFF22A55B),
                  iconBackground: const Color(0xFF1B3B3F),
                  title: 'Mis permisos',
                  trailing: const Icon(
                    AppIcons.siguiente,
                    color: DarkColors.textoSuave,
                  ),
                  onTap: () => _onPermissionsTap(context),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const SectionTitle(icon: AppIcons.datos, text: 'Mis datos'),
          const SizedBox(height: 12),
          ProfileDataCard(
            nombre: userName,
            correo: role.demoEmail,
            direccion: _address,
            estado: 'Activo',
            miembroDesde: _memberSince,
          ),
          const SizedBox(height: 16),
          const DashedNotice(icon: AppIcons.candado, text: '$_lockedMessage.'),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: () => _onLogout(context),
            style: FilledButton.styleFrom(
              backgroundColor: DarkColors.rojo,
              foregroundColor: Colors.white,
              minimumSize: const Size.fromHeight(56),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
            ),
            child: const Text(
              'Cerrar sesión',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}
