import '../../core/di/service_locator.dart';
import '../../core/network/api_client.dart';
import '../models/sale_model.dart';
import 'clients_repository.dart';
//import 'products_repository.dart';

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

    // Temporal: nombres de los productos de ejemplo de las ventas demo.
  // Se elimina cuando conectemos Ventas con la API (ahí el nombre viene del JOIN).
  static const _demoProductNames = {
    1: 'Taladro eléctrico 600W',
    2: 'Cemento Canal 42.5 kg',
    3: 'Pintura látex blanca',
    4: 'Tornillos para madera 3"',
    5: 'Martillo de uña 16 oz',
    6: 'Tubo PVC 1/2"',
  };

  String productoNombre(int productoId) {
    return _demoProductNames[productoId] ?? 'Producto #$productoId';
  }
}
