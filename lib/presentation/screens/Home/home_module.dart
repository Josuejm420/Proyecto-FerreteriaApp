import 'package:flutter/material.dart';

import '../../../core/constants/app_routes.dart';

enum UserRole {
  administrador('Administrador'),
  vendedor('Vendedor');

  const UserRole(this.label);
  final String label;
}

/// Un módulo del menú: abre una ruta o cambia de pestaña.
class HomeModule {
  const HomeModule({
    required this.emoji,
    required this.label,
    required this.color,
    this.route,
    this.tabIndex,
    this.adminOnly = false,
  });

  final String emoji;
  final String label;
  final Color color;
  final String? route;
  final int? tabIndex; // 1 = Ventas, 2 = Productos (pestañas de la barra)
  final bool adminOnly;
}

const List<HomeModule> homeModules = [
  HomeModule(
    emoji: '🧾',
    label: 'Ventas',
    color: Color(0xFF4A3F35),
    tabIndex: 1,
  ),
  HomeModule(
    emoji: '📦',
    label: 'Productos',
    color: Color(0xFF1F3156),
    tabIndex: 2,
  ),
  HomeModule(
    emoji: '👥',
    label: 'Clientes',
    color: Color(0xFF1B3B3F),
    route: AppRoutes.clients,
  ),
  HomeModule(
    emoji: '🚚',
    label: 'Compras',
    color: Color(0xFF2E2A52),
    route: AppRoutes.purchases,
    adminOnly: true,
  ),
  HomeModule(
    emoji: '🏭',
    label: 'Proveedores',
    color: Color(0xFF4A3F35),
    route: AppRoutes.suppliers,
    adminOnly: true,
  ),
  HomeModule(
    emoji: '🏷️',
    label: 'Catálogos',
    color: Color(0xFF1F3156),
    route: AppRoutes.catalogs,
  ),
  HomeModule(
    emoji: '🔐',
    label: 'Usuarios y roles',
    color: Color(0xFF1B3B3F),
    route: AppRoutes.usersRoles,
    adminOnly: true,
  ),
  HomeModule(
    emoji: '📊',
    label: 'Reportes',
    color: Color(0xFF2E2A52),
    route: AppRoutes.reports,
    adminOnly: true,
  ),
];