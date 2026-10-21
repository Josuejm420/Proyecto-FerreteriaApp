import '../models/supplier_model.dart';

/// Repositorio de proveedores en memoria (datos de ejemplo).
/// Cuando tengas API, solo cambias el interior de estos métodos.
class SuppliersRepository {
  SuppliersRepository._();

  static final SuppliersRepository instance = SuppliersRepository._();

  int _nextId = 4;

  final List<SupplierModel> _suppliers = [
    const SupplierModel(
      id: 1,
      nombre: 'Herramientas Mundiales S.A.',
      documento: 'J0310000012345',
      correo: 'ventas@hmundiales.com',
      telefono: '2552-3100',
    ),
    const SupplierModel(
      id: 2,
      nombre: 'Cables y Conexiones',
      documento: 'J0310000067890',
      correo: 'contacto@cablesyconexiones.com',
      telefono: '2268-4455',
    ),
    const SupplierModel(
      id: 3,
      nombre: 'Pinturas del Sur',
      documento: 'J0310000011111',
      correo: 'info@pinturasdelsur.com',
      telefono: '2222-0000',
      activo: false,
    ),
  ];

  List<SupplierModel> getAll() => List.unmodifiable(_suppliers);

  /// Crea el proveedor si no tiene id; si lo tiene, lo actualiza.
  Future<SupplierModel> save(SupplierModel supplier) async {
    await Future.delayed(const Duration(milliseconds: 400));

    if (supplier.id == null) {
      final created = supplier.copyWith(id: _nextId++);
      _suppliers.insert(0, created);
      return created;
    }

    final index = _suppliers.indexWhere((s) => s.id == supplier.id);
    if (index == -1) {
      _suppliers.insert(0, supplier);
    } else {
      _suppliers[index] = supplier;
    }
    return supplier;
  }
}