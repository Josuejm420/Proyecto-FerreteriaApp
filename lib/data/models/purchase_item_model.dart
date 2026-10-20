class PurchaseItemModel {
  const PurchaseItemModel({
    required this.producto,
    required this.cantidad,
    required this.precioUnitario,
  });

  final String producto;
  final int cantidad;
  final double precioUnitario;

  double get subtotal => cantidad * precioUnitario;
}