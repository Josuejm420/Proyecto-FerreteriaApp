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

  /// Lee una categoría tal como la devuelve la API.
  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: (json['id_categoria'] as num?)?.toInt(),
      nombre: (json['nombre_categoria'] as String?) ?? '',
      descripcion: (json['descripcion'] as String?) ?? '',
      activo: (json['estado'] as bool?) ?? true,
    );
  }

  /// Formato que espera la API al crear o editar.
  Map<String, dynamic> toJson() => {
    if (id != null) 'id_categoria': id,
    'nombre_categoria': nombre,
    'descripcion': descripcion, // la API falla con null: siempre texto
    'estado': activo,
  };

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