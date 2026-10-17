import '../models/client_model.dart';

/// Repositorio de clientes en memoria (datos de ejemplo).
/// Cuando tengan API, solo cambian el interior de estos métodos.
class ClientsRepository {
  ClientsRepository._();

  static final ClientsRepository instance = ClientsRepository._();

  int _nextId = 4;

  final List<ClientModel> _clients = [
    const ClientModel(
      id: 1,
      documento: '001-120590-0001A',
      nombre: 'Carlos Mendoza',
      correo: 'carlos@mail.com',
      telefono: '8845-1122',
    ),
    const ClientModel(
      id: 2,
      documento: 'J0310000054321',
      nombre: 'Constructora Jinotepe',
      correo: 'compras@cjinotepe.com',
      telefono: '2532-1000',
    ),
    const ClientModel(
      id: 3,
      documento: '001-050388-0005B',
      nombre: 'Ana Gutiérrez',
      correo: 'ana.g@mail.com',
      telefono: '8791-3344',
      activo: false,
    ),
  ];

  List<ClientModel> getAll() => List.unmodifiable(_clients);

  ClientModel? findById(int? id) {
    for (final client in _clients) {
      if (client.id == id) return client;
    }
    return null;
  }

  Future<ClientModel> save(ClientModel client) async {
    await Future.delayed(const Duration(milliseconds: 400));

    if (client.id == null) {
      final created = client.copyWith(id: _nextId++);
      _clients.insert(0, created);
      return created;
    }

    final index = _clients.indexWhere((c) => c.id == client.id);
    if (index == -1) {
      _clients.insert(0, client);
    } else {
      _clients[index] = client;
    }
    return client;
  }
}
