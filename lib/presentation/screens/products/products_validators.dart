import '../../../data/models/products_model.dart';

class ProductsValidators {
  ProductsValidators._();

  static String? nombre(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return 'Ingresa el nombre del producto';
    if (text.length < 3) return 'Mínimo 3 caracteres';
    return null;
  }

  static String? categoria(String? value) {
    return value == null ? 'Selecciona una categoría' : null;
  }

  static String? presentacion(ProductPresentation? value) {
    return value == null ? 'Selecciona una presentación' : null;
  }
}