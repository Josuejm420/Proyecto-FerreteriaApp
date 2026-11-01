import '../models/report_models.dart';
import '../models/sale_model.dart';
import 'sales_repository.dart';

/// Periodo que se puede consultar en los reportes.
enum ReportPeriod { todos, esteMes, ultimos30 }

/// Calcula las métricas a partir de las facturas (sin contar las anuladas).
/// Cuando tengas API, estas consultas pasan a ser consultas SQL (GROUP BY).
class ReportsRepository {
  ReportsRepository._();

  static final ReportsRepository instance = ReportsRepository._();

  final _sales = SalesRepository.instance;

  /// Facturas vigentes dentro del periodo elegido.
  List<SaleModel> _validSales(ReportPeriod period) {
    final now = DateTime.now();
    final limit = now.subtract(const Duration(days: 30));

    return _sales.getAll().where((sale) {
      if (sale.anulada) return false;
      return switch (period) {
        ReportPeriod.todos => true,
        ReportPeriod.esteMes =>
          sale.fechaVenta.year == now.year &&
              sale.fechaVenta.month == now.month,
        ReportPeriod.ultimos30 => sale.fechaVenta.isAfter(limit),
      };
    }).toList();
  }

  // --- Resumen ---
  SalesSummary summary(ReportPeriod period) {
    final sales = _validSales(period);
    final total = sales.fold<double>(0, (sum, sale) => sum + sale.total);
    return SalesSummary(totalVendido: total, facturas: sales.length);
  }

  // --- Producto más vendido ---
  List<ProductSalesStat> _productStats(ReportPeriod period) {
    final quantity = <int, int>{};
    final income = <int, double>{};
    final invoices = <int, int>{};

    for (final sale in _validSales(period)) {
      final seen = <int>{};
      for (final detail in sale.detalles) {
        final id = detail.productoId;
        quantity[id] = (quantity[id] ?? 0) + detail.cantidad;
        income[id] = (income[id] ?? 0) + detail.subtotal + detail.iva;
        if (seen.add(id)) invoices[id] = (invoices[id] ?? 0) + 1;
      }
    }

    return [
      for (final id in quantity.keys)
        ProductSalesStat(
          productoId: id,
          nombre: _sales.productoNombre(id),
          cantidad: quantity[id]!,
          ingreso: income[id]!,
          facturas: invoices[id]!,
        ),
    ];
  }

  /// Productos ordenados por unidades vendidas (el más vendido primero).
  List<ProductSalesStat> topProducts(ReportPeriod period, {int limit = 5}) {
    final list = _productStats(period);
    list.sort((a, b) {
      final byQuantity = b.cantidad.compareTo(a.cantidad);
      return byQuantity != 0 ? byQuantity : b.ingreso.compareTo(a.ingreso);
    });
    return list.take(limit).toList();
  }

  // --- Venta promedio por producto ---
  List<ProductSalesStat> averageByProduct(ReportPeriod period) {
    final list = _productStats(period);
    list.sort((a, b) => b.promedio.compareTo(a.promedio));
    return list;
  }

  // --- Venta promedio por cliente ---
  List<ClientSalesStat> averageByClient(ReportPeriod period) {
    final income = <int, double>{};
    final invoices = <int, int>{};
    final names = <int, String>{};

    for (final sale in _validSales(period)) {
      final key = sale.clienteId ?? 0; // 0 = Consumidor final
      income[key] = (income[key] ?? 0) + sale.total;
      invoices[key] = (invoices[key] ?? 0) + 1;
      names[key] = _sales.clienteNombre(sale);
    }

    final list = [
      for (final key in income.keys)
        ClientSalesStat(
          nombre: names[key]!,
          ingreso: income[key]!,
          facturas: invoices[key]!,
        ),
    ];
    list.sort((a, b) => b.promedio.compareTo(a.promedio));
    return list;
  }

  // --- Ventas por semana ---
  DateTime _weekStart(DateTime date) {
    // weekday: lunes = 1 ... domingo = 7
    return DateTime(date.year, date.month, date.day - (date.weekday - 1));
  }

  /// Ventas por semana, de la más antigua a la más reciente.
  /// Las semanas sin ventas aparecen en cero.
  List<WeekSalesStat> salesByWeek(ReportPeriod period, {int weeks = 8}) {
    final totals = <DateTime, double>{};
    final counts = <DateTime, int>{};

    for (final sale in _validSales(period)) {
      final key = _weekStart(sale.fechaVenta);
      totals[key] = (totals[key] ?? 0) + sale.total;
      counts[key] = (counts[key] ?? 0) + 1;
    }

    if (totals.isEmpty) return [];

    final keys = totals.keys.toList()..sort();
    final result = <WeekSalesStat>[];
    var cursor = keys.first;
    final last = keys.last;

    while (!cursor.isAfter(last)) {
      result.add(
        WeekSalesStat(
          inicio: cursor,
          fin: DateTime(cursor.year, cursor.month, cursor.day + 6),
          total: totals[cursor] ?? 0,
          facturas: counts[cursor] ?? 0,
        ),
      );
      cursor = DateTime(cursor.year, cursor.month, cursor.day + 7);
    }

    return result.length > weeks
        ? result.sublist(result.length - weeks)
        : result;
  }
}