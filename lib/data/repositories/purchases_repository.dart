import '../models/purchase_item_model.dart';
import '../models/purchase_model.dart';

/// Repositorio de compras en memoria (datos de ejemplo).
/// Cuando tengas API, solo cambias el interior de estos métodos.
class PurchasesRepository {
  PurchasesRepository._();

  static final PurchasesRepository instance = PurchasesRepository._();

  final List<PurchaseModel> _purchases = [
    PurchaseModel(
      id: 1,
      numero: 'C-1001',
      fecha: DateTime(2026, 10, 10),
      proveedor: 'Herramientas Mundiales S.A.',
      registro: 'Don Antonio Ruiz',
      items: const [
        PurchaseItemModel(
          producto: 'Taladro eléctrico 600W',
          cantidad: 5,
          precioUnitario: 1100,
        ),
      ],
    ),
    PurchaseModel(
      id: 2,
      numero: 'C-1002',
      fecha: DateTime(2026, 10, 12),
      proveedor: 'Cables y Conexiones',
      registro: 'Don Antonio Ruiz',
      items: const [
        PurchaseItemModel(
          producto: 'Cable THHN #12 (rollo)',
          cantidad: 20,
          precioUnitario: 350,
        ),
        PurchaseItemModel(
          producto: 'Breaker 20A',
          cantidad: 12,
          precioUnitario: 400,
        ),
      ],
    ),
  ];

  List<PurchaseModel> getAll() => List.unmodifiable(_purchases);

  /// Marca la compra como anulada y devuelve la compra actualizada.
  Future<PurchaseModel> cancel(int id) async {
    await Future.delayed(const Duration(milliseconds: 400));

    final index = _purchases.indexWhere((p) => p.id == id);
    if (index == -1) throw StateError('Compra no encontrada');

    final updated = _purchases[index].copyWith(anulada: true);
    _purchases[index] = updated;
    return updated;
  }
}