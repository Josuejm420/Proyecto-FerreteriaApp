/// Presentación del producto (Unidad, Saco, Galón...) con su unidad de medida.
class ProductPresentation {
  const ProductPresentation(this.nombre, this.unidad);

  final String nombre;
  final String unidad;
}

class ProductsModel {
  const ProductsModel({
    this.id,
    required this.nombre,
    required this.descripcion,
    required this.categoria,
    required this.presentacion,
    required this.unidadMedida,
    this.peso,
    required this.fechaRegistro,
    this.activo = true,
  });

  final int? id; // null cuando el producto aún no se ha guardado
  final String nombre;
  final String descripcion;
  final String categoria;
  final String presentacion;
  final String unidadMedida;
  final double? peso;
  final DateTime fechaRegistro;
  final bool activo;

  ProductsModel copyWith({
    int? id,
    String? nombre,
    String? descripcion,
    String? categoria,
    String? presentacion,
    String? unidadMedida,
    bool? activo,
  }) {
    return ProductsModel(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      descripcion: descripcion ?? this.descripcion,
      categoria: categoria ?? this.categoria,
      presentacion: presentacion ?? this.presentacion,
      unidadMedida: unidadMedida ?? this.unidadMedida,
      peso: peso,
      fechaRegistro: fechaRegistro,
      activo: activo ?? this.activo,
    );
  }
}