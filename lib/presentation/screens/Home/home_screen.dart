import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import 'widgets/home_kpi_card.dart';
import 'widgets/home_menu_drawer.dart';     
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static const routeName = '/home';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedSection = 0;

  static const _sections = [
    _HomeSection(
      title: 'Resumen de indicadores',
      subtitle:
          'Analiza el comportamiento de clientes, productos, descuentos y vendedores para decidir qué acciones tomar.',
      firstKpiIndex: 0,
      lastKpiIndex: 7,
    ),
    _HomeSection(
      title: 'Indicadores de clientes',
      subtitle:
          'Identifica cambios de compra, clientes en riesgo y oportunidades de recuperación.',
      firstKpiIndex: 0,
      lastKpiIndex: 4,
    ),
    _HomeSection(
      title: 'Indicadores de productos',
      subtitle:
          'Revisa la rentabilidad y el desempeño de cada producto para optimizar el catálogo.',
      firstKpiIndex: 4,
      lastKpiIndex: 6,
    ),
    _HomeSection(
      title: 'Descuentos y vendedores',
      subtitle:
          'Comprueba si los descuentos impulsan ventas o reducen el margen sin generar valor.',
      firstKpiIndex: 6,
      lastKpiIndex: 7,
    ),
  ];

  static const _allKpis = [
    _KpiData(
      icon: Icons.trending_up,
      title: 'Variación de ventas por cliente, descompuesta en causas',
    ),
    _KpiData(icon: Icons.schedule, title: 'Recencia y clientes en riesgo de fuga'),
    _KpiData(
      icon: Icons.groups_outlined,
      title: 'Segmentación RFM: recencia, frecuencia y valor',
    ),
    _KpiData(icon: Icons.category_outlined, title: 'Categorías abandonadas por cliente'),
    _KpiData(
      icon: Icons.account_balance_wallet_outlined,
      title: 'Margen bruto y variación del margen descompuesta',
    ),
    _KpiData(
      icon: Icons.grid_view,
      title: 'Matriz ABC de ventas frente a margen',
    ),
    _KpiData(icon: Icons.sell_outlined, title: 'Efectividad del descuento'),
  ];

  void _selectSection(int index) {
    Navigator.of(context).pop();
    setState(() => _selectedSection = index);
  }

  @override
  Widget build(BuildContext context) {
    final section = _sections[_selectedSection];
    final kpis = _allKpis
        .skip(section.firstKpiIndex)
        .take(section.lastKpiIndex - section.firstKpiIndex);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Menú principal'),
        backgroundColor: AppColors.azul,
        foregroundColor: Colors.white,
      ),
      drawer: HomeMenuDrawer(
        selectedIndex: _selectedSection,
        onSectionSelected: _selectSection,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            section.title,
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(section.subtitle, style: Theme.of(context).textTheme.bodyLarge),
          const SizedBox(height: 20),
          for (final kpi in kpis) ...[
            HomeKpiCard(
              icon: kpi.icon,
              title: kpi.title,
            ),
            const SizedBox(height: 14),
          ],
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedSection,
        onDestinationSelected: (index) {
          setState(() => _selectedSection = index);
        },
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
            icon: Icon(Icons.sell_outlined),
            selectedIcon: Icon(Icons.sell),
            label: 'Descuentos',
          ),
        ],
      ),
    );
  }
}

class _HomeSection {
  const _HomeSection({
    required this.title,
    required this.subtitle,
    required this.firstKpiIndex,
    required this.lastKpiIndex,
  });

  final String title;
  final String subtitle;
  final int firstKpiIndex;
  final int lastKpiIndex;
}

class _KpiData {
  const _KpiData({required this.icon, required this.title});

  final IconData icon;
  final String title;
}
