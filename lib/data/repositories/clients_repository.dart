import '../../core/di/service_locator.dart';
import '../../core/network/api_client.dart';
import '../models/client_model.dart';

class ClientsRepository {
  ClientsRepository([ApiClient? api])
    : _api =
          api ??
          (getIt.isRegistered<ApiClient>() ? getIt<ApiClient>() : ApiClient());

  final ApiClient _api;

  static ClientsRepository get instance =>
      getIt.isRegistered<ClientsRepository>()
      ? getIt<ClientsRepository>()
      : _defaultInstance;
  static final ClientsRepository _defaultInstance = ClientsRepository();

  List<ClientModel> _cachedClients = [];

  List<ClientModel> getAllCached() => List.unmodifiable(_cachedClients);

  ClientModel? findById(int? id) {
    if (id == null) return null;
    for (final client in _cachedClients) {
      if (client.id == id) return client;
    }
    return null;
  }

  Future<List<ClientModel>> getAll({bool forceRefresh = false}) async {
    if (_cachedClients.isNotEmpty && !forceRefresh) {
      return _cachedClients;
    }

    try {
      final dynamic response = await _api.get('/Cliente');
      if (response is List) {
        final list = response
            .whereType<Map<String, dynamic>>()
            .map(ClientModel.fromJson)
            .toList();

        list.sort(
          (a, b) => a.nombre.toLowerCase().compareTo(b.nombre.toLowerCase()),
        );

        _cachedClients = list;
        return _cachedClients;
      }
      return _cachedClients;
    } catch (_) {
      if (_cachedClients.isNotEmpty) return _cachedClients;
      rethrow;
    }
  }

  Future<ClientModel> save(ClientModel client) async {
    if (client.id == null) {
      final dynamic response = await _api.post(
        '/Cliente',
        body: client.toJson(),
      );
      final created = response is Map<String, dynamic>
          ? ClientModel.fromJson(response)
          : client;

      _cachedClients.insert(0, created);
      return created;
    } else {
      await _api.put('/Cliente/${client.id}', body: client.toJson());

      final index = _cachedClients.indexWhere((c) => c.id == client.id);
      if (index != -1) {
        _cachedClients[index] = client;
      }
      return client;
    }
  }
}
