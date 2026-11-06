import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_icons.dart';
import '../../../core/errors/api_exception.dart';
import '../../../data/models/client_model.dart';
import '../../../data/repositories/clients_repository.dart';
import '../../widgets/app_search_field.dart';
import '../../widgets/screen_title_bar.dart';
import 'client_form_screen.dart';
import 'widgets/clients_list_card.dart';

class ClientsScreen extends StatefulWidget {
  const ClientsScreen({super.key, this.showBack = false});

  final bool showBack;

  @override
  State<ClientsScreen> createState() => _ClientsScreenState();
}

class _ClientsScreenState extends State<ClientsScreen> {
  final _repository = ClientsRepository.instance;
  final _searchController = TextEditingController();

  List<ClientModel> _clients = [];
  String _query = '';
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadClients();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadClients({bool forceRefresh = false}) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final list = await _repository.getAll(forceRefresh: forceRefresh);
      if (!mounted) return;
      setState(() {
        _clients = list;
        _isLoading = false;
      });
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = e.message;
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _errorMessage = 'No se pudo conectar con el servidor';
        _isLoading = false;
      });
    }
  }

  List<ClientModel> get _filtered {
    final query = _query.trim().toLowerCase();
    if (query.isEmpty) return _clients;
    return _clients
        .where(
          (c) =>
              c.nombre.toLowerCase().contains(query) ||
              c.documento.toLowerCase().contains(query),
        )
        .toList();
  }

  void _onSearchChanged(String value) => setState(() => _query = value);

  Future<void> _openCreate() async {
    final created = await Navigator.push<ClientModel>(
      context,
      MaterialPageRoute(builder: (context) => const ClientFormScreen()),
    );
    if (!mounted) return;
    if (created != null) {
      _showMessage('Cliente creado correctamente');
      _loadClients(forceRefresh: true);
    }
  }

  Future<void> _openEdit(ClientModel client) async {
    final updated = await Navigator.push<ClientModel>(
      context,
      MaterialPageRoute(builder: (context) => ClientFormScreen(client: client)),
    );
    if (!mounted) return;
    if (updated != null) {
      _showMessage('Cliente actualizado correctamente');
      _loadClients(forceRefresh: true);
    }
  }

  void _showMessage(String text) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(text), behavior: SnackBarBehavior.floating),
      );
  }

  @override
  Widget build(BuildContext context) {
    final items = _filtered;

    return Scaffold(
      backgroundColor: DarkColors.fondo,
      floatingActionButton: FloatingActionButton(
        onPressed: _openCreate,
        tooltip: 'Nuevo cliente',
        backgroundColor: DarkColors.naranjaBoton,
        foregroundColor: const Color(0xFF1A1A1A),
        shape: const CircleBorder(),
        child: const Icon(AppIcons.agregar, size: 32),
      ),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: ScreenTitleBar(
                title: 'Clientes',
                onBack: widget.showBack ? () => Navigator.pop(context) : null,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: AppSearchField(
                controller: _searchController,
                onChanged: _onSearchChanged,
                hint: 'Buscar cliente',
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: RefreshIndicator(
                color: DarkColors.naranjaBoton,
                backgroundColor: DarkColors.tarjeta,
                onRefresh: () => _loadClients(forceRefresh: true),
                child: _buildContent(items),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(List<ClientModel> items) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: DarkColors.naranjaBoton),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.cloud_off,
                size: 48,
                color: DarkColors.textoSuave,
              ),
              const SizedBox(height: 12),
              Text(
                _errorMessage!,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: DarkColors.textoSuave,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () => _loadClients(forceRefresh: true),
                icon: const Icon(Icons.refresh),
                label: const Text('Reintentar'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: DarkColors.naranjaBoton,
                  foregroundColor: const Color(0xFF1A1A1A),
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (items.isEmpty) {
      return Center(
        child: Text(
          _clients.isEmpty
              ? 'Aún no hay clientes registrados'
              : 'No se encontraron clientes',
          style: const TextStyle(color: DarkColors.textoSuave),
        ),
      );
    }

    return ListView.separated(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 96),
      itemCount: items.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final client = items[index];
        return ClientListCard(client: client, onTap: () => _openEdit(client));
      },
    );
  }
}
