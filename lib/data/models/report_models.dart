/// Resumen general de ventas (sin facturas anuladas).
class SalesSummary {
  const SalesSummary({required this.totalVendido, required this.facturas});

  final double totalVendido;
  final int facturas;

  /// Venta promedio por factura (ticket promedio).
  double get ventaPromedio => facturas == 0 ? 0 : totalVendido / facturas;
}

/// Ventas acumuladas de un producto.
class ProductSalesStat {
  const ProductSalesStat({
    required this.productoId,
    required this.nombre,
    required this.cantidad,
    required this.ingreso,
    required this.facturas,
  });

  final int productoId;
  final String nombre;
  final int cantidad; // unidades vendidas
  final double ingreso; // dinero vendido (con IVA)
  final int facturas; // en cuántas facturas aparece

  /// Venta promedio del producto por factura.
  double get promedio => facturas == 0 ? 0 : ingreso / facturas;
}

/// Ventas acumuladas de un cliente.
class ClientSalesStat {
  const ClientSalesStat({
    required this.nombre,
    required this.ingreso,
    required this.facturas,
  });

  final String nombre;
  final double ingreso;
  final int facturas;

  /// Venta promedio del cliente por factura.
  double get promedio => facturas == 0 ? 0 : ingreso / facturas;
}

/// Ventas de una semana (lunes a domingo).
class WeekSalesStat {
  const WeekSalesStat({
    required this.inicio,
    required this.fin,
    required this.total,
    required this.facturas,
  });

  final DateTime inicio;
  final DateTime fin;
  final double total;
  final int facturas;
}