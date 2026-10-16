import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_routes.dart';
import '../../../data/models/products_model.dart';
import '../../../data/repositories/products_repository.dart';
import '../../widgets/screen_title_bar.dart';
import 'product_form_screen.dart';
import 'widgets/category_filter.dart';
import 'widgets/product_list_card.dart';
import 'widgets/product_search_field.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key, this.showBack = false});

  /// true cuando se abre como pantalla aparte (con flecha para volver).
  final bool showBack;

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  final _repository = ProductsRepository.instance;
  final _searchController = TextEditingController();

  List<ProductsModel> _products = [];
  String? _selectedCategory; // null = Todos
  String _query = '';

  @override
  void initState() {
    super.initState();
    _products = _repository.getAll();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<ProductsModel> get _filtered {
    final query = _query.trim().toLowerCase();
    return _products.where((p) {
      final matchesCategory =
          _selectedCategory == null || p.categoria == _selectedCategory;
      final matchesQuery =
          query.isEmpty || p.nombre.toLowerCase().contains(query);
      return matchesCategory && matchesQuery;
    }).toList();
  }

  // --- Eventos ---
  void _reload() => setState(() => _products = _repository.getAll());

  void _onSearchChanged(String value) => setState(() => _query = value);

  void _onCategorySelected(String? category) {
    setState(() => _selectedCategory = category);
  }

  Future<void> _openDetail(ProductsModel product) async {
    await Navigator.pushNamed(
      context,
      AppRoutes.productDetail,
      arguments: product,
    );
    if (mounted) _reload(); // el detalle pudo editar o desactivar
  }

  Future<void> _openCreate() async {
    final created = await Navigator.push<ProductsModel>(
      context,
      MaterialPageRoute(builder: (context) => const ProductFormScreen()),
    );
    if (!mounted) return;
    _reload();
    if (created != null) _showMessage('Producto creado correctamente');
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
        tooltip: 'Nuevo producto',
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
                title: 'Productos',
                onBack: widget.showBack ? () => Navigator.pop(context) : null,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ProductSearchField(
                controller: _searchController,
                onChanged: _onSearchChanged,
              ),
            ),
            const SizedBox(height: 12),
            CategoryFilter(
              categories: ProductsRepository.categorias,
              selected: _selectedCategory,
              onSelected: _onCategorySelected,
            ),
            const SizedBox(height: 12),
            Expanded(
              child: items.isEmpty
                  ? const Center(
                      child: Text(
                        'No se encontraron productos',
                        style: TextStyle(color: DarkColors.textoSuave),
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(16, 4, 16, 96),
                      itemCount: items.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final product = items[index];
                        return ProductListCard(
                          product: product,
                          onTap: () => _openDetail(product),
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
