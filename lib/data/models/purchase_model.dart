import 'purchase_item_model.dart';

class PurchaseModel {
  const PurchaseModel({
    required this.id,
    required this.numero,
    required this.fecha,
    required this.proveedor,
    required this.registro,
    required this.items,
    this.anulada = false,
  });

  /// IVA aplicado a las compras (15%).
  static const double tasaIva = 0.15;

  final int id;
  final String numero; // Ej. "C-1001"
  final DateTime fecha;
  final String proveedor;
  final String registro; // Quién registró la compra
  final List<PurchaseItemModel> items;
  final bool anulada;

  double get subtotal =>
      items.fold<double>(0, (sum, item) => sum + item.subtotal);
  double get iva => subtotal * tasaIva;
  double get total => subtotal + iva;

  PurchaseModel copyWith({bool? anulada}) {
    return PurchaseModel(
      id: id,
      numero: numero,
      fecha: fecha,
      proveedor: proveedor,
      registro: registro,
      items: items,
      anulada: anulada ?? this.anulada,
    );
  }
}