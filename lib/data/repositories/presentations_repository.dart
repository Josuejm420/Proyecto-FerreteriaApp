import '../../core/network/api_client.dart';
import '../models/presentation_model.dart';

/// Presentaciones contra la API (/api/Presentacion).
class PresentationsRepository {
  PresentationsRepository(this._api);

  final ApiClient _api;

  Future<List<PresentationModel>> getAll() async {
    final data = await _api.get('/Presentacion');
    return (data as List)
        .map((item) => PresentationModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  /// Crea la presentación si no tiene id; si lo tiene, la actualiza.
  /// La API solo responde un texto, así que se devuelve la misma presentación.
  Future<PresentationModel> save(PresentationModel presentation) async {
    if (presentation.id == null) {
      await _api.post('/Presentacion', body: presentation.toJson());
    } else {
      await _api.put('/Presentacion', body: presentation.toJson());
    }
    return presentation;
  }
}