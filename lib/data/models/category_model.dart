class CategoryModel {
  const CategoryModel({
    this.id,
    required this.nombre,
    this.descripcion = '',
    this.activo = true,
  });

  final int? id; // null cuando la categoría aún no se ha guardado
  final String nombre;
  final String descripcion;
  final bool activo;

  CategoryModel copyWith({
    int? id,
    String? nombre,
    String? descripcion,
    bool? activo,
  }) {
    return CategoryModel(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      descripcion: descripcion ?? this.descripcion,
      activo: activo ?? this.activo,
    );
  }
}