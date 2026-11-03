import 'category_model.dart';
import 'presentation_model.dart';

class ProductsModel {
  const ProductsModel({
    this.id,
    required this.nombre,
    required this.descripcion,
    required this.categoriaId,
    required this.categoria,
    required this.presentacionId,
    required this.presentacion,
    required this.unidadMedida,
    this.peso,
    required this.fechaRegistro,
    this.activo = true,
  });

  final int? id; // null cuando el producto aún no se ha guardado
  final String nombre;
  final String descripcion;
  final int categoriaId;
  final String categoria; // nombre, solo para mostrar
  final int presentacionId;
  final String presentacion; // nombre, solo para mostrar
  final String unidadMedida;
  final double? peso;
  final DateTime fechaRegistro;
  final bool activo;

  /// Lee un producto de la API. La API solo manda ids de categoría y
  /// presentación, así que los nombres se buscan en los catálogos.
  factory ProductsModel.fromJson(
    Map<String, dynamic> json, {
    required Map<int, CategoryModel> categories,
    required Map<int, PresentationModel> presentations,
  }) {
    final categoriaId = (json['id_categoria'] as num).toInt();
    final presentacionId = (json['id_presentacion'] as num).toInt();
    final category = categories[categoriaId];
    final presentation = presentations[presentacionId];

    return ProductsModel(
      id: (json['id_producto'] as num?)?.toInt(),
      nombre: ((json['nombre'] as String?) ?? '').trim(),
      descripcion: ((json['descripcion'] as String?) ?? '').trim(),
      categoriaId: categoriaId,
      categoria: category?.nombre ?? 'Sin categoría',
      presentacionId: presentacionId,
      presentacion: presentation?.nombre ?? 'Sin presentación',
      unidadMedida: presentation?.unidadMedida ?? '',
      peso: presentation?.peso,
      fechaRegistro:
          DateTime.tryParse('${json['fecha_registro'] ?? ''}') ?? DateTime.now(),
      activo: (json['estado'] as bool?) ?? true,
    );
  }

  /// Formato que espera la API al crear o editar.
  Map<String, dynamic> toJson() => {
    if (id != null) 'id_producto': id,
    'nombre': nombre,
    'descripcion': descripcion, // la API falla con null: siempre texto
    'id_categoria': categoriaId,
    'id_presentacion': presentacionId,
    'estado': activo,
  };

  ProductsModel copyWith({
    int? id,
    String? nombre,
    String? descripcion,
    int? categoriaId,
    String? categoria,
    int? presentacionId,
    String? presentacion,
    String? unidadMedida,
    bool? activo,
  }) {
    return ProductsModel(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      descripcion: descripcion ?? this.descripcion,
      categoriaId: categoriaId ?? this.categoriaId,
      categoria: categoria ?? this.categoria,
      presentacionId: presentacionId ?? this.presentacionId,
      presentacion: presentacion ?? this.presentacion,
      unidadMedida: unidadMedida ?? this.unidadMedida,
      peso: peso,
      fechaRegistro: fechaRegistro,
      activo: activo ?? this.activo,
    );
  }
}