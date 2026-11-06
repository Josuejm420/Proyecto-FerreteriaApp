import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_icons.dart';
import '../../../core/utils/formatters.dart';
import '../../../data/models/report_models.dart';
import '../../../data/repositories/reports_repository.dart';
import '../../widgets/screen_title_bar.dart';
import '../Home/widgets/stat_card.dart';
import '../products/widgets/category_filter.dart';
import '../profile/widgets/section_title.dart';
import 'widgets/report_empty_message.dart';
import 'widgets/report_ranking_list.dart';
import 'widgets/report_toggle.dart';
import 'widgets/top_product_card.dart';
import 'widgets/weekly_sales_chart.dart';

/// Reportes: producto más vendido, venta promedio y ventas por semana.
/// Solo se muestra en el menú del Administrador.
class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key, this.showBack = false});

  /// true cuando se abre como pantalla aparte (con flecha para volver).
  final bool showBack;

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  final _repository = ReportsRepository.instance;

  static const Map<ReportPeriod, String> _periodLabels = {
    ReportPeriod.esteMes: 'Este mes',
    ReportPeriod.ultimos30: 'Últimos 30 días',
  };

  ReportPeriod _period = ReportPeriod.todos;
  int _averageView = 0; // 0 = por producto, 1 = por cliente
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() { _loading = true; _error = null; });
    try {
      await _repository.load(_period);
    } catch (e) {
      _error = '$e';
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  // --- Eventos ---
  void _onPeriodSelected(String? label) {
    setState(() {
      _period = _periodLabels.entries
              .where((entry) => entry.value == label)
              .map((entry) => entry.key)
              .firstOrNull ??
          ReportPeriod.todos;
    });
    _load();
  }

  void _onAverageViewChanged(int index) {
    setState(() => _averageView = index);
  }

  String _invoicesText(int count) => count == 1 ? '1 factura' : '$count facturas';

  // --- Listas de cada reporte ---
  List<RankingItem> _topProductItems(List<ProductSalesStat> products) {
    final max = products.first.cantidad;
    return [
      for (final p in products)
        RankingItem(
          label: p.nombre,
          subtitle: formatMoney(p.ingreso),
          value: '${p.cantidad} uds',
          fraction: max == 0 ? 0 : p.cantidad / max,
        ),
    ];
  }

  List<RankingItem> _averageItems() {
    if (_averageView == 0) {
      final products = _repository.averageByProduct(_period);
      if (products.isEmpty) return [];
      final max = products.first.promedio;
      return [
        for (final p in products)
          RankingItem(
            label: p.nombre,
            subtitle: _invoicesText(p.facturas),
            value: formatMoney(p.promedio),
            fraction: max == 0 ? 0 : p.promedio / max,
          ),
      ];
    }

    final clients = _repository.averageByClient(_period);
    if (clients.isEmpty) return [];
    final max = clients.first.promedio;
    return [
      for (final c in clients)
        RankingItem(
          label: c.nombre,
          subtitle: _invoicesText(c.facturas),
          value: formatMoney(c.promedio),
          fraction: max == 0 ? 0 : c.promedio / max,
        ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final summary = _repository.summary(_period);
    final hasSales = _repository.topProducts(_period).isNotEmpty || _repository.salesByWeek(_period).isNotEmpty;

    return Scaffold(
      backgroundColor: DarkColors.fondo,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: ScreenTitleBar(
                title: 'Reportes',
                onBack: widget.showBack ? () => Navigator.pop(context) : null,
              ),
            ),
            CategoryFilter(
              categories: _periodLabels.values.toList(),
              selected: _periodLabels[_period],
              onSelected: _onPeriodSelected,
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 32),
                children: [
                  // --- Resumen ---
                  IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: StatCard(
                            label: 'Total vendido',
                            value: formatMoney(summary.totalVendido),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: StatCard(
                            label: 'Facturas',
                            value: '${summary.facturas}',
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: StatCard(
                            label: 'Venta promedio',
                            value: formatMoney(summary.ventaPromedio),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  if (_loading)
                    const Padding(padding: EdgeInsets.all(32), child: Center(child: CircularProgressIndicator()))
                  else if (_error != null)
                    ReportEmptyMessage(text: 'No se pudieron cargar los reportes: $_error')
                  else if (!hasSales)
                    const ReportEmptyMessage(
                      text: 'No hay ventas registradas en este periodo',
                    )
                  else
                    ..._buildReports(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildReports() {
    final topProducts = _repository.topProducts(_period);
    final weeks = _repository.salesByWeek(_period);
    final averages = _averageItems();

    return [
      // --- 1. Producto más vendido ---
      const SectionTitle(icon: AppIcons.trofeo, text: 'Producto más vendido'),
      const SizedBox(height: 12),
      if (topProducts.isNotEmpty) TopProductCard(product: topProducts.first),
      const SizedBox(height: 12),
      if (topProducts.isNotEmpty) ReportRankingList(items: _topProductItems(topProducts)) else const ReportEmptyMessage(text: 'No hay productos vendidos'),
      const SizedBox(height: 28),

      // --- 2. Venta promedio por producto / cliente ---
      const SectionTitle(icon: AppIcons.promedio, text: 'Venta promedio'),
      const SizedBox(height: 12),
      ReportToggle(
        labels: const ['Por producto', 'Por cliente'],
        selected: _averageView,
        onChanged: _onAverageViewChanged,
      ),
      const SizedBox(height: 12),
      if (averages.isNotEmpty) ReportRankingList(items: averages) else const ReportEmptyMessage(text: 'La API no devolvió datos de promedios'),
      const SizedBox(height: 28),

      // --- 3. Ventas por semana ---
      const SectionTitle(icon: AppIcons.graficoSemanal, text: 'Ventas por semana'),
      const SizedBox(height: 12),
      WeeklySalesChart(weeks: weeks),
    ];
  }
}
