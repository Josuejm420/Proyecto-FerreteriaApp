import '../../core/network/api_client.dart';
import '../models/supplier_model.dart';

/// Proveedores contra la API (/api/proveedor).
class SuppliersRepository {
  SuppliersRepository(this._api);

  final ApiClient _api;

  Future<List<SupplierModel>> getAll() async {
    final data = await _api.get('/proveedor');
    return (data as List)
        .map((item) => SupplierModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  /// Crea el proveedor si no tiene id; si lo tiene, lo actualiza.
  /// La API solo responde un texto, así que se devuelve el mismo proveedor.
  Future<SupplierModel> save(SupplierModel supplier) async {
    if (supplier.id == null) {
      await _api.post('/proveedor', body: supplier.toJson());
    } else {
      await _api.put('/proveedor', body: supplier.toJson());
    }
    return supplier;
  }
}