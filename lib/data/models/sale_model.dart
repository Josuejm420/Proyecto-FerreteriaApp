import '../../core/constants/app_values.dart';

class SaleDetailModel {
  const SaleDetailModel({
    this.id,
    this.facturaId,
    required this.productoId,
    this.productoNombre,
    required this.cantidad,
    required this.precioVenta,
    this.iva,
    this.fechaRegistro,
  });

  final int? id;
  final int? facturaId;
  final int productoId;
  final String? productoNombre;
  final int cantidad;
  final double precioVenta;
  final double? iva;
  final DateTime? fechaRegistro;

  double get subtotal => cantidad * precioVenta;
  double get totalIva => iva ?? (subtotal * AppValues.tasaIva);

  factory SaleDetailModel.fromJson(Map<String, dynamic> json) {
    return SaleDetailModel(
      id:
          (json['id_detalle_factura'] ?? json['idDetalleFactura'] ?? json['id'])
              as int?,
      facturaId:
          (json['id_factura'] ?? json['idFactura'] ?? json['facturaId'])
              as int?,
      productoId:
          (json['id_producto'] ??
                  json['idProducto'] ??
                  json['productoId'] as num?)
              ?.toInt() ??
          0,
      productoNombre:
          (json['producto_nombre'] ??
                  json['nombreProducto'] ??
                  json['nombre_producto'] ??
                  json['producto'])
              ?.toString(),
      cantidad: (json['cantidad'] as num?)?.toInt() ?? 1,
      precioVenta:
          (json['precio_venta'] ?? json['precioVenta'] as num?)?.toDouble() ??
          0.0,
      iva: (json['iva'] as num?)?.toDouble(),
      fechaRegistro: json['fecha_registro'] != null
          ? DateTime.tryParse(json['fecha_registro'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    if (id != null) 'id_detalle_factura': id,
    if (facturaId != null) 'id_factura': facturaId,
    'id_producto': productoId,
    'cantidad': cantidad,
    'precio_venta': precioVenta,
    if (iva != null) 'iva': iva,
  };
}

class SaleModel {
  const SaleModel({
    this.id,
    required this.numeroComprobante,
    required this.fechaVenta,
    this.clienteId,
    this.clienteNombre,
    this.usuarioId,
    required this.atendio,
    this.descuento = 0,
    required this.montoPago,
    this._montoCambio,
    this._total,
    this.detalles = const [],
    this.anulada = false,
  });

  final int? id;
  final String numeroComprobante;
  final DateTime fechaVenta;
  final int? clienteId;
  final String? clienteNombre;
  final int? usuarioId;
  final String atendio;
  final double descuento;
  final double montoPago;
  final double? _montoCambio;
  final double? _total;
  final List<SaleDetailModel> detalles;
  final bool anulada;

  double get subtotal => detalles.fold<double>(0, (sum, d) => sum + d.subtotal);

  double get iva => detalles.fold<double>(0, (sum, d) => sum + d.totalIva);

  /// Si la API ya envía el total, lo usa; de lo contrario lo calcula desde detalles.
  double get total =>
      _total ?? (subtotal > 0 ? (subtotal + iva - descuento) : montoPago);

  double get montoCambio =>
      _montoCambio ?? (montoPago > total ? montoPago - total : 0);

  factory SaleModel.fromJson(Map<String, dynamic> json) {
    final rawId = json['id_factura'] ?? json['idFactura'] ?? json['id'];
    final id = rawId is num ? rawId.toInt() : int.tryParse('$rawId');

    DateTime fecha;
    final rawFecha = json['fecha_venta'] ?? json['fechaVenta'] ?? json['fecha'];
    if (rawFecha != null) {
      fecha = DateTime.tryParse(rawFecha.toString()) ?? DateTime.now();
    } else {
      fecha = DateTime.now();
    }

    final rawComprobante =
        json['numero_comprobante'] ??
        json['numeroComprobante'] ??
        json['comprobante'];
    final comprobante =
        (rawComprobante != null && '$rawComprobante'.trim().isNotEmpty)
        ? '$rawComprobante'.trim()
        : 'F-${id ?? 0}';

    List<SaleDetailModel> detalles = const [];
    final rawDetalles =
        json['detalle_Factura'] ??
        json['Detalle_Factura'] ??
        json['detalles'] ??
        json['detallesVentas'];
    if (rawDetalles is List) {
      detalles = rawDetalles
          .whereType<Map<String, dynamic>>()
          .map(SaleDetailModel.fromJson)
          .toList();
    }

    final rawAnulada =
        json['anulada'] ??
        (json.containsKey('estado') ? json['estado'] == false : null);

    return SaleModel(
      id: id,
      numeroComprobante: comprobante,
      fechaVenta: fecha,
      clienteId:
          (json['id_cliente'] ?? json['idCliente'] ?? json['clienteId'])
              as int?,
      clienteNombre:
          (json['cliente_nombre'] ??
                  json['clienteNombre'] ??
                  json['nombre_cliente'] ??
                  json['cliente'])
              ?.toString(),
      usuarioId:
          (json['id_usuario'] ?? json['idUsuario'] ?? json['usuarioId'])
              as int?,
      atendio:
          (json['atendio'] ??
                  json['nombre_usuario'] ??
                  json['nombreUsuario'] ??
                  json['usuario'])
              ?.toString() ??
          '',
      descuento: (json['descuento'] as num?)?.toDouble() ?? 0.0,
      montoPago:
          (json['monto_pago'] ?? json['montoPago'] as num?)?.toDouble() ?? 0.0,
      montoCambio: (json['monto_cambio'] ?? json['montoCambio'] as num?)
          ?.toDouble(),
      total: (json['total'] as num?)?.toDouble(),
      detalles: detalles,
      anulada: rawAnulada == true,
    );
  }

  Map<String, dynamic> toJson() => {
    if (id != null) 'id_factura': id,
    'fecha_venta': fechaVenta.toIso8601String(),
    'monto_pago': montoPago,
    'monto_cambio': montoCambio,
    'numero_comprobante': numeroComprobante,
    'id_cliente': clienteId,
    'id_usuario': usuarioId ?? 1,
    'descuento': descuento,
    'total': total,
    if (detalles.isNotEmpty)
      'Detalle_Factura': detalles.map((d) => d.toJson()).toList(),
  };

  SaleModel copyWith({
    int? id,
    String? numeroComprobante,
    DateTime? fechaVenta,
    int? clienteId,
    String? clienteNombre,
    int? usuarioId,
    String? atendio,
    double? descuento,
    double? montoPago,
    double? montoCambio,
    double? total,
    List<SaleDetailModel>? detalles,
    bool? anulada,
  }) {
    return SaleModel(
      id: id ?? this.id,
      numeroComprobante: numeroComprobante ?? this.numeroComprobante,
      fechaVenta: fechaVenta ?? this.fechaVenta,
      clienteId: clienteId ?? this.clienteId,
      clienteNombre: clienteNombre ?? this.clienteNombre,
      usuarioId: usuarioId ?? this.usuarioId,
      atendio: atendio ?? this.atendio,
      descuento: descuento ?? this.descuento,
      montoPago: montoPago ?? this.montoPago,
      montoCambio: montoCambio ?? _montoCambio,
      total: total ?? _total,
      detalles: detalles ?? this.detalles,
      anulada: anulada ?? this.anulada,
    );
  }
}
