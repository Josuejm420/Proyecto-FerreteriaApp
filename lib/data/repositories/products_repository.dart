import '../models/products_model.dart';

/// Repositorio de productos en memoria (datos de ejemplo).
/// Cuando tengas API, solo cambias el interior de estos métodos.
class ProductsRepository {
  ProductsRepository._();

  static final ProductsRepository instance = ProductsRepository._();

  static const List<String> categorias = [
    'Herramientas eléctricas',
    'Herramientas manuales',
    'Construcción',
    'Pinturas',
    'Plomería',
  ];

  static const List<ProductPresentation> presentaciones = [
    ProductPresentation('Unidad', 'unidad'),
    ProductPresentation('Saco', 'kg'),
    ProductPresentation('Galón', 'galón'),
    ProductPresentation('Caja', 'caja'),
    ProductPresentation('Metro', 'metro'),
  ];

  int _nextId = 7;

  final List<ProductsModel> _products = [
    ProductsModel(
      id: 1,
      nombre: 'Taladro eléctrico 600W',
      descripcion:
          'Taladro de 600W con mandril de 13 mm para madera, metal y pared.',
      categoria: 'Herramientas eléctricas',
      presentacion: 'Unidad',
      unidadMedida: 'unidad',
      fechaRegistro: DateTime(2026, 3, 12),
    ),
    ProductsModel(
      id: 2,
      nombre: 'Cemento Canal 42.5 kg',
      descripcion: 'Cemento gris de uso general para obra y cimientos.',
      categoria: 'Construcción',
      presentacion: 'Saco',
      unidadMedida: 'kg',
      fechaRegistro: DateTime(2026, 3, 12),
    ),
    ProductsModel(
      id: 3,
      nombre: 'Pintura látex blanca',
      descripcion: 'Pintura látex lavable para interiores y exteriores.',
      categoria: 'Pinturas',
      presentacion: 'Galón',
      unidadMedida: 'galón',
      fechaRegistro: DateTime(2026, 3, 12),
    ),
    ProductsModel(
      id: 4,
      nombre: 'Tornillos para madera 3"',
      descripcion: 'Tornillos de acero con cabeza plana para madera.',
      categoria: 'Construcción',
      presentacion: 'Caja',
      unidadMedida: 'caja',
      fechaRegistro: DateTime(2026, 3, 12),
    ),
    ProductsModel(
      id: 5,
      nombre: 'Martillo de uña 16 oz',
      descripcion: 'Martillo con mango de fibra y cabeza de acero forjado.',
      categoria: 'Herramientas manuales',
      presentacion: 'Unidad',
      unidadMedida: 'unidad',
      fechaRegistro: DateTime(2026, 3, 12),
      activo: false,
    ),
    ProductsModel(
      id: 6,
      nombre: 'Tubo PVC 1/2"',
      descripcion: 'Tubo de PVC de media pulgada para agua potable.',
      categoria: 'Plomería',
      presentacion: 'Metro',
      unidadMedida: 'metro',
      fechaRegistro: DateTime(2026, 3, 12),
    ),
  ];

  List<ProductsModel> getAll() => List.unmodifiable(_products);

  /// Crea el producto si no tiene id; si lo tiene, lo actualiza.
  Future<ProductsModel> save(ProductsModel product) async {
    await Future.delayed(const Duration(milliseconds: 400));

    if (product.id == null) {
      final created = product.copyWith(id: _nextId++);
      _products.insert(0, created);
      return created;
    }

    final index = _products.indexWhere((p) => p.id == product.id);
    if (index == -1) {
      _products.insert(0, product);
    } else {
      _products[index] = product;
    }
    return product;
  }
}