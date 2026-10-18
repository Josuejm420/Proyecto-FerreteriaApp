import '../models/sale_model.dart';
import 'clients_repository.dart';
import 'products_repository.dart';

/// Repositorio de facturas en memoria (datos de ejemplo).
/// Cuando tengan API, solo cambian el interior de estos métodos.
class SalesRepository {
  SalesRepository._();

  static final SalesRepository instance = SalesRepository._();

  final List<SaleModel> _sales = [
    SaleModel(
      id: 1,
      numeroComprobante: 'F-0001',
      fechaVenta: DateTime(2026, 10, 14),
      clienteId: 1,
      atendio: 'Juan Pérez',
      montoPago: 2500,
      detalles: const [
        SaleDetailModel(productoId: 1, cantidad: 1, precioVenta: 1450),
        SaleDetailModel(productoId: 4, cantidad: 2, precioVenta: 180),
      ],
    ),
    SaleModel(
      id: 2,
      numeroComprobante: 'F-0002',
      fechaVenta: DateTime(2026, 10, 14),
      clienteId: 2,
      atendio: 'Don Antonio Ruiz',
      descuento: 50,
      montoPago: 2000,
      anulada: true,
      detalles: const [
        SaleDetailModel(productoId: 2, cantidad: 5, precioVenta: 320),
      ],
    ),
    SaleModel(
      id: 3,
      numeroComprobante: 'F-0003',
      fechaVenta: DateTime(2026, 10, 15),
      clienteId: 3,
      atendio: 'Juan Pérez',
      montoPago: 1600,
      detalles: const [
        SaleDetailModel(productoId: 3, cantidad: 2, precioVenta: 650),
      ],
    ),
  ];

  /// Las más recientes primero.
  List<SaleModel> getAll() {
    final list = [..._sales];
    list.sort((a, b) {
      final byDate = b.fechaVenta.compareTo(a.fechaVenta);
      return byDate != 0 ? byDate : (b.id ?? 0).compareTo(a.id ?? 0);
    });
    return list;
  }

  /// Marca la factura como anulada y devuelve la factura actualizada.
  Future<SaleModel> anular(SaleModel sale) async {
    await Future.delayed(const Duration(milliseconds: 400));

    final updated = sale.copyWith(anulada: true);
    final index = _sales.indexWhere((s) => s.id == sale.id);
    if (index != -1) _sales[index] = updated;
    return updated;
  }

  // En la base de datos estos dos nombres salen de un JOIN con
  // Cliente y Producto; aquí los buscamos en sus repositorios.
  String clienteNombre(SaleModel sale) {
    final client = ClientsRepository.instance.findById(sale.clienteId);
    return client?.nombre ?? 'Consumidor final';
  }

  String productoNombre(int productoId) {
    for (final product in ProductsRepository.instance.getAll()) {
      if (product.id == productoId) return product.nombre;
    }
    return 'Producto #$productoId';
  }
}
