import 'package:flutter/material.dart';

import '../../../../data/models/user_role.dart';
import '../home_module.dart';
import 'home_header.dart';
import 'module_card.dart';
import 'stat_card.dart';
import 'welcome_card.dart';

/// Contenido de la pestaña "Inicio".
class HomeDashboard extends StatelessWidget {
  const HomeDashboard({
    super.key,
    required this.userName,
    required this.role,
    required this.onOpenTab,
  });

  final String userName;
  final UserRole role;
  final ValueChanged<int> onOpenTab;

  // --- Evento: abrir un módulo ---
  void _openModule(BuildContext context, HomeModule module) {
    if (module.tabIndex != null) {
      onOpenTab(module.tabIndex!);
      return;
    }

    final route = module.route;
    if (route == null || route.isEmpty) return;

    Navigator.pushNamed(context, route);
  }

  @override
  Widget build(BuildContext context) {
    final modules = homeModules
        .where((m) => !m.adminOnly || role == UserRole.administrador)
        .toList();

    return SafeArea(
      bottom: false,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        children: [
          const HomeHeader(),
          const SizedBox(height: 16),
          WelcomeCard(name: userName, role: role.label),
          const SizedBox(height: 14),
          // Datos de ejemplo: luego vendrán de la base de datos.
          const IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: StatCard(
                    label: 'Ventas de hoy',
                    value: 'C\$ 1,495.00',
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: StatCard(label: 'Facturas', value: '1'),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: StatCard(label: 'Productos activos', value: '5'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          GridView.count(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.3,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              for (final module in modules)
                ModuleCard(
                  module: module,
                  onTap: () => _openModule(context, module),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
