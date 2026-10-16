import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../data/models/supplier_model.dart';
import '../../../data/repositories/suppliers_repository.dart';
import '../../widgets/screen_title_bar.dart';
import 'supplier_form_screen.dart';
import 'widgets/supplier_list_card.dart';
import 'widgets/supplier_search_field.dart';

class SuppliersScreen extends StatefulWidget {
  const SuppliersScreen({super.key, this.showBack = false});

  /// true cuando se abre como pantalla aparte (con flecha para volver).
  final bool showBack;

  @override
  State<SuppliersScreen> createState() => _SuppliersScreenState();
}

class _SuppliersScreenState extends State<SuppliersScreen> {
  final _repository = SuppliersRepository.instance;
  final _searchController = TextEditingController();

  List<SupplierModel> _suppliers = [];
  String _query = '';

  @override
  void initState() {
    super.initState();
    _suppliers = _repository.getAll();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// Proveedores que coinciden con el texto buscado (por nombre).
  List<SupplierModel> get _filtered {
    final query = _query.trim().toLowerCase();
    if (query.isEmpty) return _suppliers;
    return _suppliers
        .where((s) => s.nombre.toLowerCase().contains(query))
        .toList();
  }

  // --- Eventos ---
  void _reload() => setState(() => _suppliers = _repository.getAll());

  void _onSearchChanged(String value) => setState(() => _query = value);

  Future<void> _openCreate() async {
    final created = await Navigator.push<SupplierModel>(
      context,
      MaterialPageRoute(builder: (context) => const SupplierFormScreen()),
    );
    if (!mounted) return;
    _reload();
    if (created != null) _showMessage('Proveedor creado correctamente');
  }

  Future<void> _openEdit(SupplierModel supplier) async {
    final updated = await Navigator.push<SupplierModel>(
      context,
      MaterialPageRoute(
        builder: (context) => SupplierFormScreen(supplier: supplier),
      ),
    );
    if (!mounted) return;
    _reload();
    if (updated != null) _showMessage('Proveedor actualizado correctamente');
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
        tooltip: 'Nuevo proveedor',
        backgroundColor: DarkColors.naranjaBoton,
        foregroundColor: const Color(0xFF1A1A1A),
        shape: const CircleBorder(),
        child: const Icon(Icons.add, size: 32),
      ),
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
            Expanded(
              child: items.isEmpty
                  ? Center(
                      child: Text(
                        _suppliers.isEmpty
                            ? 'Aún no hay proveedores registrados'
                            : 'No se encontraron proveedores',
                        style: const TextStyle(color: DarkColors.textoSuave),
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(16, 4, 16, 96),
                      itemCount: items.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final supplier = items[index];
                        return SupplierListCard(
                          supplier: supplier,
                          onTap: () => _openEdit(supplier),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}  