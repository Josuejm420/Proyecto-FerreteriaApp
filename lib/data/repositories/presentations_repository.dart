import '../models/presentation_model.dart';

/// Repositorio de presentaciones en memoria (datos de ejemplo).
/// Cuando tengas API, solo cambias el interior de estos métodos.
class PresentationsRepository {
  PresentationsRepository._();

  static final PresentationsRepository instance = PresentationsRepository._();

  int _nextId = 6;

  final List<PresentationModel> _presentations = [
    const PresentationModel(
      id: 1,
      nombre: 'Unidad',
      unidadMedida: 'unidad',
      peso: 1,
    ),
    const PresentationModel(
      id: 2,
      nombre: 'Saco',
      unidadMedida: 'kg',
      peso: 42.5,
    ),
    const PresentationModel(
      id: 3,
      nombre: 'Galón',
      unidadMedida: 'lt',
      peso: 3.78,
    ),
    const PresentationModel(
      id: 4,
      nombre: 'Caja',
      unidadMedida: 'unidad',
      peso: 100,
    ),
    const PresentationModel(
      id: 5,
      nombre: 'Metro',
      unidadMedida: 'm',
      peso: 1,
    ),
  ];

  List<PresentationModel> getAll() => List.unmodifiable(_presentations);

  /// Crea la presentación si no tiene id; si lo tiene, la actualiza.
  Future<PresentationModel> save(PresentationModel presentation) async {
    await Future.delayed(const Duration(milliseconds: 400));

    if (presentation.id == null) {
      final created = presentation.copyWith(id: _nextId++);
      _presentations.add(created);
      return created;
    }

    final index = _presentations.indexWhere((p) => p.id == presentation.id);
    if (index == -1) {
      _presentations.add(presentation);
    } else {
      _presentations[index] = presentation;
    }
    return presentation;
  }
}