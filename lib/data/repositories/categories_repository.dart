import '../../core/network/api_client.dart';
import '../models/category_model.dart';

/// Categorías contra la API (/api/categoria).
class CategoriesRepository {
  CategoriesRepository(this._api);

  final ApiClient _api;

  Future<List<CategoryModel>> getAll() async {
    final data = await _api.get('/categoria');
    return (data as List)
        .map((item) => CategoryModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  /// Crea la categoría si no tiene id; si lo tiene, la actualiza.
  /// La API solo responde un texto, así que se devuelve la misma categoría.
  Future<CategoryModel> save(CategoryModel category) async {
    if (category.id == null) {
      await _api.post('/categoria', body: category.toJson());
    } else {
      await _api.put('/categoria', body: category.toJson());
    }
    return category;
  }
}