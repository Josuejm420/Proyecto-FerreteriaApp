import 'package:flutter/material.dart';

import 'package:app_ferreteria/core/constants/app_colors.dart';
import 'package:app_ferreteria/presentation/screens/home/widgets/home_kpi_card.dart';
import 'package:app_ferreteria/presentation/screens/home/widgets/home_menu_drawer.dart';

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
      number: 1,
      title: 'Variación de ventas por cliente, descompuesta en causas',
      question: '¿Por qué bajó lo que compra este cliente?',
      formula:
          'Ventas = número de facturas × unidades por factura × precio promedio por unidad.',
      diagnosis:
          'Compara cada factor con el período anterior para identificar cuál explica la caída.',
      decision:
          'Si cayó la frecuencia, reactiva al cliente; si bajaron las unidades por factura, ofrece venta cruzada; si cayó el precio, revisa los descuentos.',
    ),
    _KpiData(
      number: 2,
      title: 'Recencia y clientes en riesgo de fuga',
      question: '¿Qué clientes están por dejar de comprar?',
      formula:
          'Días desde la última compra comparados con el intervalo habitual de compra de ese cliente.',
      diagnosis:
          'Detecta a los clientes cuya demora de compra supera su intervalo habitual.',
      decision: 'Contacta al cliente antes de perderlo.',
    ),
    _KpiData(
      number: 3,
      title: 'Segmentación RFM: recencia, frecuencia y valor',
      question: '¿Qué clientes merecen más atención o descuentos?',
      formula:
          'Clasificación de clientes según recencia, frecuencia de compra y valor monetario.',
      diagnosis:
          'Agrupa a los clientes en campeones, en riesgo y de bajo valor.',
      decision:
          'Define estrategias distintas de atención, retención y descuentos para cada segmento.',
    ),
    _KpiData(
      number: 4,
      title: 'Categorías abandonadas por cliente',
      question: '¿Qué categoría dejó de comprar este cliente?',
      formula:
          'Categorías compradas en el período anterior que ya no aparecen en el actual, junto con su impacto en ventas.',
      diagnosis:
          'Identifica las categorías ausentes y cuánto representaban en las ventas del cliente.',
      decision:
          'Revisa el precio o la disponibilidad de la categoría, u ofrécela activamente.',
    ),
    _KpiData(
      number: 5,
      title: 'Margen bruto y variación del margen descompuesta',
      question: '¿Por qué cambió mi rentabilidad?',
      formula: 'Margen = (precio de venta − descuento − costo) × cantidad.',
      diagnosis:
          'Separa la variación en efecto precio, efecto costo, efecto descuento y efecto mix de productos.',
      decision:
          'Ajusta precios, cambia el mix de productos o renegocia costos.',
    ),
    _KpiData(
      number: 6,
      title: 'Matriz ABC de ventas frente a margen',
      question: '¿Qué productos venden mucho, pero ganan poco?',
      formula:
          'Clasifica productos A, B y C por ventas y cruza esa clasificación con su margen.',
      diagnosis:
          'Distingue los productos con alto o bajo aporte en ventas y rentabilidad.',
      decision:
          'Promociona los de alto margen, revisa el precio de los de bajo margen y considera descontinuar los de baja venta y bajo margen.',
    ),
    _KpiData(
      number: 7,
      title: 'Efectividad del descuento',
      question: '¿Mis descuentos generan más venta o solo regalan margen?',
      formula:
          'Compara ticket, unidades y margen de facturas con descuento contra las que no lo tienen, por vendedor, cliente y producto.',
      diagnosis:
          'Evalúa si el aumento de ticket o unidades compensa el margen cedido en los descuentos.',
      decision:
          'Limita o redirige descuentos y capacita a vendedores que descuentan de más.',
    ),
  ];

  void _selectSection(int index) {
    Navigator.of(context).pop();
    setState(() => _selectedSection = index);
  }

  @override
  Widget build(BuildContext context) {
    final section = _sections[_selectedSection];

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
          for (final kpi
              in _allKpis
                  .skip(section.firstKpiIndex)
                  .take(section.lastKpiIndex - section.firstKpiIndex)) ...[
            HomeKpiCard(
              number: kpi.number,
              title: kpi.title,
              question: kpi.question,
              formula: kpi.formula,
              diagnosis: kpi.diagnosis,
              decision: kpi.decision,
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
  const _KpiData({
    required this.number,
    required this.title,
    required this.question,
    required this.formula,
    required this.diagnosis,
    required this.decision,
  });

  final int number;
  final String title;
  final String question;
  final String formula;
  final String diagnosis;
  final String decision;
}
