import '../../core/di/service_locator.dart';
import '../../core/network/api_client.dart';
import '../models/sale_model.dart';
import 'clients_repository.dart';
import 'products_repository.dart';

class SalesRepository {
  SalesRepository([ApiClient? api])
    : _api =
          api ??
          (getIt.isRegistered<ApiClient>() ? getIt<ApiClient>() : ApiClient());

  final ApiClient _api;

  static SalesRepository get instance => getIt.isRegistered<SalesRepository>()
      ? getIt<SalesRepository>()
      : _defaultInstance;
  static final SalesRepository _defaultInstance = SalesRepository();

  List<SaleModel> _cachedSales = [];

  List<SaleModel> getAllCached() => List.unmodifiable(_cachedSales);

  /// Obtiene las facturas desde la API (GET /Factura_).
  Future<List<SaleModel>> getAll({bool forceRefresh = false}) async {
    if (_cachedSales.isNotEmpty && !forceRefresh) {
      return _cachedSales;
    }

    try {
      final dynamic response = await _api.get('/Factura_');
      if (response is List) {
        final list = response
            .whereType<Map<String, dynamic>>()
            .map(SaleModel.fromJson)
            .toList();

        list.sort((a, b) {
          final byDate = b.fechaVenta.compareTo(a.fechaVenta);
          return byDate != 0 ? byDate : (b.id ?? 0).compareTo(a.id ?? 0);
        });

        _cachedSales = list;
        return _cachedSales;
      }
      return _cachedSales;
    } catch (_) {
      if (_cachedSales.isNotEmpty) return _cachedSales;
      rethrow;
    }
  }

  Future<List<SaleDetailModel>> getDetalles(int facturaId) async {
    try {
      final dynamic response = await _api.get('/Detalle_factura');
      if (response is List) {
        return response
            .whereType<Map<String, dynamic>>()
            .map(SaleDetailModel.fromJson)
            .where((d) => d.facturaId == facturaId)
            .toList();
      }
    } catch (_) {}
    return const [];
  }

  Future<SaleModel> anular(SaleModel sale) async {
    final updated = sale.copyWith(anulada: true);
    if (sale.id != null) {
      await _api.put('/Factura_/${sale.id}', body: updated.toJson());
    }

    final index = _cachedSales.indexWhere((s) => s.id == sale.id);
    if (index != -1) {
      _cachedSales[index] = updated;
    }
    return updated;
  }

  String clienteNombre(SaleModel sale) {
    if (sale.clienteNombre != null && sale.clienteNombre!.isNotEmpty) {
      return sale.clienteNombre!;
    }
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
