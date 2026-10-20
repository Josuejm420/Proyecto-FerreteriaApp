import '../../core/constants/app_values.dart';

/// Una línea de la factura (tabla Detalle_Factura).
class SaleDetailModel {
  const SaleDetailModel({
    required this.productoId,
    required this.cantidad,
    required this.precioVenta,
  });

  final int productoId; // id_producto
  final int cantidad;
  final double precioVenta;

  double get subtotal => cantidad * precioVenta;
  double get iva => subtotal * AppValues.tasaIva;
}

/// Una factura de venta (tabla Factura).
class SaleModel {
  const SaleModel({
    this.id,
    required this.numeroComprobante,
    required this.fechaVenta,
    this.clienteId,
    required this.atendio,
    this.descuento = 0,
    required this.montoPago,
    required this.detalles,
    this.anulada = false,
  });

  final int? id; // id_factura
  final String numeroComprobante;
  final DateTime fechaVenta;
  final int? clienteId; // id_cliente: null = Consumidor final
  final String atendio; // nombre del usuario (id_usuario en la BD)
  final double descuento;
  final double montoPago;
  final List<SaleDetailModel> detalles;
  final bool anulada; // nuevo campo "estado" que hay que agregar a la BD

  double get subtotal => detalles.fold<double>(0, (sum, d) => sum + d.subtotal);
  double get iva => detalles.fold<double>(0, (sum, d) => sum + d.iva);
  double get total => subtotal + iva - descuento;
  double get montoCambio => montoPago > total ? montoPago - total : 0;

  SaleModel copyWith({bool? anulada}) {
    return SaleModel(
      id: id,
      numeroComprobante: numeroComprobante,
      fechaVenta: fechaVenta,
      clienteId: clienteId,
      atendio: atendio,
      descuento: descuento,
      montoPago: montoPago,
      detalles: detalles,
      anulada: anulada ?? this.anulada,
    );
  }
}
