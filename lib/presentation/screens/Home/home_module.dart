import 'package:flutter/material.dart';

import '../../../core/constants/app_icons.dart';
import '../../../core/constants/app_routes.dart';

/// Un módulo del menú: abre una ruta o cambia de pestaña.
class HomeModule {
  const HomeModule({
    required this.icon,
    required this.label,
    required this.color,
    required this.accent,
    this.route,
    this.tabIndex,
    this.adminOnly = false,
  });

  final IconData icon;
  final String label;
  final Color color; // fondo del cuadro del ícono
  final Color accent; // color del ícono
  final String? route;
  final int? tabIndex; // 1 = Ventas, 2 = Productos (pestañas de la barra)
  final bool adminOnly;
}

const List<HomeModule> homeModules = [
  HomeModule(
    icon: AppIcons.ventas,
    label: 'Ventas',
    color: Color(0xFF4A3F35),
    accent: Color(0xFFF5A524),
    tabIndex: 1,
  ),
  HomeModule(
    icon: AppIcons.productos,
    label: 'Productos',
    color: Color(0xFF1F3156),
    accent: Color(0xFF3B82F6),
    tabIndex: 2,
  ),
  HomeModule(
    icon: AppIcons.clientes,
    label: 'Clientes',
    color: Color(0xFF1B3B3F),
    accent: Color(0xFF22A55B),
    route: AppRoutes.clients,
  ),
  HomeModule(
    icon: AppIcons.compras,
    label: 'Compras',
    color: Color(0xFF2E2A52),
    accent: Color(0xFFA855F7),
    route: AppRoutes.purchases,
    adminOnly: true,
  ),
  HomeModule(
    icon: AppIcons.proveedores,
    label: 'Proveedores',
    color: Color(0xFF4A3F35),
    accent: Color(0xFFF5A524),
    route: AppRoutes.suppliers,
    adminOnly: true,
  ),
  HomeModule(
    icon: AppIcons.catalogos,
    label: 'Catálogos',
    color: Color(0xFF1F3156),
    accent: Color(0xFF3B82F6),
    route: AppRoutes.catalogs,
  ),
  HomeModule(
    icon: AppIcons.usuarios,
    label: 'Gestion de usuarios',
    color: Color(0xFF1B3B3F),
    accent: Color(0xFF22A55B),
    route: AppRoutes.usersRoles,
    adminOnly: true,
  ),
  HomeModule(
    icon: AppIcons.reportes,
    label: 'Reportes',
    color: Color(0xFF2E2A52),
    accent: Color(0xFFA855F7),
    route: AppRoutes.reports,
    adminOnly: true,
  ),
];