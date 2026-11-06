import '../../core/di/service_locator.dart';
import '../../core/network/api_client.dart';
import '../models/report_models.dart';

enum ReportPeriod { todos, esteMes, ultimos30 }

/// Consulta las métricas agregadas por la API desplegada.
class ReportsRepository {
  ReportsRepository._();
  static final ReportsRepository instance = ReportsRepository._();
  ApiClient get _api => getIt<ApiClient>();

  List<ProductSalesStat> _top = [];
  List<ProductSalesStat> _averageProducts = [];
  List<ClientSalesStat> _averageClients = [];
  List<WeekSalesStat> _weeks = [];

  Future<void> load(ReportPeriod period) async {
    final weeks = switch (period) {
      ReportPeriod.todos => 52,
      ReportPeriod.esteMes => 5,
      ReportPeriod.ultimos30 => 5,
    };
    final results = await Future.wait([
      _api.get('/metricas/productos-mas-vendidos', query: {'limite': 5}),
      _api.get('/metricas/ventas/promedio-producto-cliente', query: {'semanas': weeks}),
      _api.get('/metricas/ventas-por-semana', query: {'semanas': weeks}),
    ]);
    _top = _asList(results[0]).map(_product).toList();
    final average = results[1] is Map ? _asList((results[1] as Map)['datos']) : _asList(results[1]);
    _averageProducts = average.where((e) => e is Map && _text(e, ['tipo', 'agrupacion']).toLowerCase() != 'cliente').map((e) => _averageProduct(e as Map)).toList();
    _averageClients = average.where((e) => e is Map && _text(e, ['tipo', 'agrupacion']).toLowerCase() == 'cliente').map((e) => _averageClient(e as Map)).toList();
    final weekRows = results[2] is Map ? _asList((results[2] as Map)['datos']) : _asList(results[2]);
    _weeks = weekRows.map(_week).toList();
  }

  List<dynamic> _asList(dynamic value) => value is List ? value : const [];
  String _text(Map row, List<String> keys) {
    for (final key in keys) { if (row[key] != null) return '${row[key]}'; }
    return '';
  }
  double _number(Map row, List<String> keys) {
    for (final key in keys) { final value = row[key]; if (value is num) return value.toDouble(); if (value != null) return double.tryParse('$value') ?? 0; }
    return 0;
  }
  int _integer(Map row, List<String> keys) => _number(row, keys).toInt();

  ProductSalesStat _product(dynamic value) {
    final row = value as Map;
    return ProductSalesStat(productoId: int.tryParse(_text(row, ['producto', 'id_producto'])) ?? 0,
      nombre: _text(row, ['productoNombre', 'nombre', 'producto']),
      cantidad: _integer(row, ['cantidadTotal', 'cantidad']), ingreso: _number(row, ['ingreso', 'totalVendido']), facturas: _integer(row, ['facturas', 'cantidadFacturas']));
  }
  ProductSalesStat _averageProduct(Map row) => ProductSalesStat(
    productoId: _integer(row, ['producto', 'id_producto', 'id']),
    nombre: _text(row, ['productoNombre', 'nombre', 'producto']),
    cantidad: _integer(row, ['cantidadTotal', 'cantidad']),
    ingreso: _number(row, ['promedio', 'ventaPromedio', 'montoPromedio']),
    facturas: _integer(row, ['facturas', 'cantidadFacturas']));
  ClientSalesStat _averageClient(Map row) => ClientSalesStat(
    nombre: _text(row, ['clienteNombre', 'nombre', 'cliente']),
    ingreso: _number(row, ['promedio', 'ventaPromedio', 'montoPromedio']),
    facturas: _integer(row, ['facturas', 'cantidadFacturas']));
  WeekSalesStat _week(dynamic value) {
    final row = value as Map;
    final start = DateTime.tryParse(_text(row, ['desde', 'inicio'])) ?? DateTime(1, 1, 1);
    return WeekSalesStat(inicio: start, fin: start.add(const Duration(days: 6)),
      total: _number(row, ['cantidadTotal', 'total']), facturas: _integer(row, ['facturas', 'cantidadFacturas']));
  }

  SalesSummary summary(ReportPeriod period) => SalesSummary(
    totalVendido: _weeks.fold<double>(0, (sum, week) => sum + week.total),
    facturas: _weeks.fold<int>(0, (sum, week) => sum + week.facturas));
  List<ProductSalesStat> topProducts(ReportPeriod period, {int limit = 5}) => _top.take(limit).toList();
  List<ProductSalesStat> averageByProduct(ReportPeriod period) => _averageProducts;
  List<ClientSalesStat> averageByClient(ReportPeriod period) => _averageClients;
  List<WeekSalesStat> salesByWeek(ReportPeriod period, {int weeks = 8}) => _weeks;
}
