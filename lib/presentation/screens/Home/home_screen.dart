import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../data/models/user_role.dart';
import 'widgets/main_scaffold.dart';
import 'widgets/metric_card.dart';
import 'widgets/search_form_widget.dart';

class HomeScreen extends StatelessWidget {
﻿import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/constants/app_colors.dart';
import 'home_module.dart';
import 'widgets/home_dashboard.dart';
import 'widgets/profile_tab.dart';
import 'widgets/section_placeholder_screen.dart';

/// Menú principal del administrador: 4 pestañas con barra inferior.
class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    this.userName = 'Don Antonio Ruiz',
    this.role = UserRole.administrador,
  });

  static const routeName = '/home';

  final String userName;
  final UserRole role;

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      titulo: 'Don Toño - ${role.label}',
      currentIndex: 0,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hola, $userName',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.texto,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Aquí puedes administrar tu ferretería',
              style: TextStyle(color: AppColors.gris),
            ),
            const SizedBox(height: 16),
            const SearchFormWidget(),
            const SizedBox(height: 24),
            const Text(
              'Métricas del sistema',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.texto,
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 14,
                crossAxisSpacing: 14,
                children: const [
                  MetricCard(
                    icono: Icons.inventory_2,
                    valor: '128',
                    etiqueta: 'Productos en inventario',
                  ),
                  MetricCard(
                    icono: Icons.warning_amber,
                    valor: '5',
                    etiqueta: 'Productos con poco stock',
                    color: AppColors.naranja,
                  ),
                  MetricCard(
                    icono: Icons.people_alt,
                    valor: '32',
                    etiqueta: 'Clientes registrados',
                  ),
                  MetricCard(
                    icono: Icons.local_shipping,
                    valor: '7',
                    etiqueta: 'Proveedores activos',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  void _onTabSelected(int index) => setState(() => _currentIndex = index);

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: DarkColors.fondo,
        body: IndexedStack(
          index: _currentIndex,
          children: [
            HomeDashboard(
              userName: widget.userName,
              role: widget.role,
              onOpenTab: _onTabSelected,
            ),
            const SectionPlaceholderScreen(title: 'Ventas', emoji: '🧾'),
            const SectionPlaceholderScreen(title: 'Productos', emoji: '📦'),
            ProfileTab(userName: widget.userName, role: widget.role),
          ],
        ),
        bottomNavigationBar: NavigationBarTheme(
          data: NavigationBarThemeData(
            backgroundColor: DarkColors.tarjeta,
            surfaceTintColor: Colors.transparent,
            indicatorColor: DarkColors.indicador,
            height: 72,
            labelTextStyle: WidgetStateProperty.resolveWith((states) {
              final selected = states.contains(WidgetState.selected);
              return TextStyle(
                fontSize: 12,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                color: selected ? DarkColors.naranja : DarkColors.textoSuave,
              );
            }),
          ),
          child: NavigationBar(
            selectedIndex: _currentIndex,
            onDestinationSelected: _onTabSelected,
            destinations: const [
              NavigationDestination(
                icon: Text('🏠', style: TextStyle(fontSize: 22)),
                label: 'Inicio',
              ),
              NavigationDestination(
                icon: Text('🧾', style: TextStyle(fontSize: 22)),
                label: 'Ventas',
              ),
              NavigationDestination(
                icon: Text('📦', style: TextStyle(fontSize: 22)),
                label: 'Productos',
              ),
              NavigationDestination(
                icon: Text('👤', style: TextStyle(fontSize: 22)),
                label: 'Perfil',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
