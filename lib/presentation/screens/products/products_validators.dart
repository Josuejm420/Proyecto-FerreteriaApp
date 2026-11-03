import '../../../data/models/category_model.dart';
import '../../../data/models/presentation_model.dart';

class ProductsValidators {
  ProductsValidators._();

  static String? nombre(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return 'Ingresa el nombre del producto';
    if (text.length < 3) return 'Mínimo 3 caracteres';
    if (text.length > 50) return 'Máximo 50 caracteres';
    return null;
  }

  static String? categoria(CategoryModel? value) {
    return value == null ? 'Selecciona una categoría' : null;
  }

  static String? presentacion(PresentationModel? value) {
    return value == null ? 'Selecciona una presentación' : null;
  }
}