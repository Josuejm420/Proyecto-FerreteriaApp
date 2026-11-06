import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/di/service_locator.dart';
import '../../../core/errors/api_exception.dart';
import '../../../data/models/supplier_model.dart';
import '../../../data/models/user_role.dart';
import '../../../data/repositories/suppliers_repository.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/screen_title_bar.dart';
import 'supplier_form_screen.dart';
import 'widgets/supplier_list_card.dart';
import 'widgets/supplier_search_field.dart';

class SuppliersScreen extends StatefulWidget {
  const SuppliersScreen({super.key, this.showBack = false});

  
  final bool showBack;

  @override
  State<SuppliersScreen> createState() => _SuppliersScreenState();
}

class _SuppliersScreenState extends State<SuppliersScreen> {
  final _repository = getIt<SuppliersRepository>();
  final _searchController = TextEditingController();

  List<SupplierModel> _suppliers = [];
  String _query = '';
  bool _isLoading = true;
  String? _errorMessage;

  
  bool get _canEdit =>
      context.read<AuthProvider>().session?.role == UserRole.administrador;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  
  Future<void> _load() async {
    try {
      final suppliers = await _repository.getAll();
      if (!mounted) return;
      setState(() {
        _suppliers = suppliers;
        _errorMessage = null;
      });
    } on ApiException catch (e) {
      _onLoadError(e.message);
    } catch (_) {
      _onLoadError('No se pudieron cargar los proveedores');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _onLoadError(String message) {
    if (!mounted) return;
    setState(() => _errorMessage = message);
   
    if (_suppliers.isNotEmpty) _showMessage(message);
  }

  void _onRetry() {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    _load();
  }

  
  List<SupplierModel> get _filtered {
    final query = _query.trim().toLowerCase();
    if (query.isEmpty) return _suppliers;
    return _suppliers
        .where((s) => s.nombre.toLowerCase().contains(query))
        .toList();
  }

  
  void _onSearchChanged(String value) => setState(() => _query = value);

  Future<void> _openCreate() async {
    final created = await Navigator.push<SupplierModel>(
      context,
      MaterialPageRoute(builder: (context) => const SupplierFormScreen()),
    );
    if (!mounted) return;
    _load();
    if (created != null) _showMessage('Proveedor creado correctamente');
  }

  Future<void> _openEdit(SupplierModel supplier) async {
    if (!_canEdit) {
      _showMessage('Solo el administrador puede modificar proveedores');
      return;
    }
    final updated = await Navigator.push<SupplierModel>(
      context,
      MaterialPageRoute(
        builder: (context) => SupplierFormScreen(supplier: supplier),
      ),
    );
    if (!mounted) return;
    _load();
    if (updated != null) _showMessage('Proveedor actualizado correctamente');
  }

  void _showMessage(String text) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(text), behavior: SnackBarBehavior.floating),
      );
  }

  Widget _buildError() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: DarkColors.tarjeta,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _errorMessage ?? 'No se pudieron cargar los proveedores',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
              const SizedBox(height: 12),
              FilledButton(
                onPressed: _onRetry,
                style: FilledButton.styleFrom(
                  backgroundColor: DarkColors.naranjaBoton,
                  foregroundColor: const Color(0xFF1A1A1A),
                ),
                child: const Text('Reintentar'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody(List<SupplierModel> items) {
    if (_isLoading && _suppliers.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null && _suppliers.isEmpty) return _buildError();

    if (items.isEmpty) {
      return Center(
        child: Text(
          _suppliers.isEmpty
              ? 'Aún no hay proveedores registrados'
              : 'No se encontraron proveedores',
          style: const TextStyle(color: DarkColors.textoSuave),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _load,
      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 96),
        itemCount: items.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final supplier = items[index];
          return SupplierListCard(
            supplier: supplier,
            onTap: () => _openEdit(supplier),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final items = _filtered;

    return Scaffold(
      backgroundColor: DarkColors.fondo,
      floatingActionButton: _canEdit
          ? FloatingActionButton(
              onPressed: _openCreate,
              tooltip: 'Nuevo proveedor',
              backgroundColor: DarkColors.naranjaBoton,
              foregroundColor: const Color(0xFF1A1A1A),
              shape: const CircleBorder(),
              child: const Icon(Icons.add, size: 32),
            )
          : null,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: ScreenTitleBar(
                title: 'Proveedores',
                onBack: widget.showBack ? () => Navigator.pop(context) : null,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SupplierSearchField(
                controller: _searchController,
                onChanged: _onSearchChanged,
              ),
            ),
            const SizedBox(height: 12),
            Expanded(child: _buildBody(items)),
          ],
        ),
      ),
    );
  }
}