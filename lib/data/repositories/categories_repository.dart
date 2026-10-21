import '../models/category_model.dart';

/// Repositorio de categorías en memoria (datos de ejemplo).
/// Cuando tengas API, solo cambias el interior de estos métodos.
class CategoriesRepository {
  CategoriesRepository._();

  static final CategoriesRepository instance = CategoriesRepository._();

  int _nextId = 6;

  final List<CategoryModel> _categories = [
    const CategoryModel(id: 1, nombre: 'Herramientas eléctricas'),
    const CategoryModel(id: 2, nombre: 'Herramientas manuales'),
    const CategoryModel(id: 3, nombre: 'Pinturas'),
    const CategoryModel(id: 4, nombre: 'Construcción'),
    const CategoryModel(id: 5, nombre: 'Plomería'),
  ];

  List<CategoryModel> getAll() => List.unmodifiable(_categories);

  /// Crea la categoría si no tiene id; si lo tiene, la actualiza.
  Future<CategoryModel> save(CategoryModel category) async {
    await Future.delayed(const Duration(milliseconds: 400));

    if (category.id == null) {
      final created = category.copyWith(id: _nextId++);
      _categories.add(created);
      return created;
    }

    final index = _categories.indexWhere((c) => c.id == category.id);
    if (index == -1) {
      _categories.add(category);
    } else {
      _categories[index] = category;
    }
    return category;
  }
}