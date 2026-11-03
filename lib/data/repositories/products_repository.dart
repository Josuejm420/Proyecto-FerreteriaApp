import '../../core/network/api_client.dart';
import '../models/category_model.dart';
import '../models/presentation_model.dart';
import '../models/products_model.dart';
import 'categories_repository.dart';
import 'presentations_repository.dart';

/// Categorías y presentaciones disponibles para elegir en el formulario.
class ProductCatalogs {
  const ProductCatalogs({required this.categories, required this.presentations});

  final List<CategoryModel> categories;
  final List<PresentationModel> presentations;
}

/// Productos contra la API (/api/producto).
class ProductsRepository {
  ProductsRepository(
    this._api,
    this._categoriesRepository,
    this._presentationsRepository,
  );

  final ApiClient _api;
  final CategoriesRepository _categoriesRepository;
  final PresentationsRepository _presentationsRepository;

  Future<ProductCatalogs> loadCatalogs() async {
    final categories = await _categoriesRepository.getAll();
    final presentations = await _presentationsRepository.getAll();
    return ProductCatalogs(categories: categories, presentations: presentations);
  }

  /// Productos con el nombre de su categoría y presentación ya resueltos.
  Future<List<ProductsModel>> getAll() async {
    final data = await _api.get('/producto');
    final catalogs = await loadCatalogs();

    final categories = {
      for (final c in catalogs.categories)
        if (c.id != null) c.id!: c,
    };
    final presentations = {
      for (final p in catalogs.presentations)
        if (p.id != null) p.id!: p,
    };

    final products = (data as List)
        .map(
          (item) => ProductsModel.fromJson(
            item as Map<String, dynamic>,
            categories: categories,
            presentations: presentations,
          ),
        )
        .toList();

    products.sort((a, b) => (b.id ?? 0).compareTo(a.id ?? 0)); // nuevos primero
    return products;
  }

  /// Crea el producto si no tiene id; si lo tiene, lo actualiza.
  /// La API solo responde un texto, así que se devuelve el mismo producto.
  Future<ProductsModel> save(ProductsModel product) async {
    if (product.id == null) {
      await _api.post('/producto', body: product.toJson());
    } else {
      await _api.put('/producto', body: product.toJson());
    }
    return product;
  }
}