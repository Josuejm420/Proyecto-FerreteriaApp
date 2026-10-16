import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

/// Estructura común: AppBar azul + barra inferior (Inicio, Clientes,
/// Productos, Reportes). Reutilízala en las demás pantallas.
class MainScaffold extends StatelessWidget {
  const MainScaffold({
    super.key,
    required this.titulo,
    required this.currentIndex,
    required this.body,
  });

  final String titulo;
  final int currentIndex;
  final Widget body;

  /// Ruta de cada pestaña. Pon el nombre de la ruta cuando la pantalla exista
  /// (por ejemplo '/clientes'); mientras sea null muestra un aviso.
  static const List<String?> _routes = ['/home', null, null, null];

  void _onDestinationSelected(BuildContext context, int index) {
    if (index == currentIndex) return;

    final route = _routes[index];
    if (route == null) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(
            content: Text('Sección en construcción'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      return;
    }

    Navigator.pushReplacementNamed(context, route);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.fondo,
      appBar: AppBar(
        title: Text(titulo),
        backgroundColor: AppColors.azul,
        foregroundColor: Colors.white,
      ),
      body: body,
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: (index) =>
            _onDestinationSelected(context, index),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Inicio',
          ),
          NavigationDestination(
            icon: Icon(Icons.people_outline),
            selectedIcon: Icon(Icons.people),
            label: 'Clientes',
          ),
          NavigationDestination(
            icon: Icon(Icons.inventory_2_outlined),
            selectedIcon: Icon(Icons.inventory_2),
            label: 'Productos',
          ),
          NavigationDestination(
            icon: Icon(Icons.assessment_outlined),
            selectedIcon: Icon(Icons.assessment),
            label: 'Reportes',
          ),
        ],
      ),
    );
  }
}
