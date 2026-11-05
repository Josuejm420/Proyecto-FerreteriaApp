import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_routes.dart';
import '../../../core/di/service_locator.dart';
import '../../../core/errors/api_exception.dart';
import '../../../data/models/products_model.dart';
import '../../../data/models/user_role.dart';
import '../../../data/repositories/products_repository.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/screen_title_bar.dart';
import 'product_form_screen.dart';
import 'widgets/category_filter.dart';
import 'widgets/product_list_card.dart';
import 'widgets/product_search_field.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key, this.showBack = false, this.onBack});

  /// true cuando se abre como pantalla aparte (con flecha para volver).
  final bool showBack;
  final VoidCallback? onBack;

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  final _repository = getIt<ProductsRepository>();
  final _searchController = TextEditingController();

  List<ProductsModel> _products = [];
  String? _selectedCategory; // null = Todos
  String _query = '';
  bool _isLoading = true;
  String? _errorMessage;

  /// Solo el administrador puede crear (la API rechaza a los demás).
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

  // --- Carga desde la API ---
  Future<void> _load() async {
    try {
      final products = await _repository.getAll();
      if (!mounted) return;
      setState(() {
        _products = products;
        _errorMessage = null;
        // Si la categoría elegida ya no tiene productos, se vuelve a "Todos".
        if (_selectedCategory != null &&
            !products.any((p) => p.categoria == _selectedCategory)) {
          _selectedCategory = null;
        }
      });
    } on ApiException catch (e) {
      _onLoadError(e.message);
    } catch (_) {
      _onLoadError('No se pudieron cargar los productos');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _onLoadError(String message) {
    if (!mounted) return;
    setState(() => _errorMessage = message);
    // Si ya había productos en pantalla, solo se avisa con un mensaje.
    if (_products.isNotEmpty) _showMessage(message);
  }

  void _onRetry() {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    _load();
  }

  // --- Datos filtrados ---
  List<String> get _categoryNames {
    final names = _products.map((p) => p.categoria).toSet().toList();
    names.sort();
    return names;
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
    if (mounted) _load(); // el detalle pudo editar o desactivar
  }

  Future<void> _openCreate() async {
    final created = await Navigator.push<ProductsModel>(
      context,
      MaterialPageRoute(builder: (context) => const ProductFormScreen()),
    );
    if (!mounted) return;
    _load();
    if (created != null) _showMessage('Producto creado correctamente');
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
                _errorMessage ?? 'No se pudieron cargar los productos',
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

  Widget _buildBody(List<ProductsModel> items) {
    if (_isLoading && _products.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null && _products.isEmpty) return _buildError();

    if (items.isEmpty) {
      return Center(
        child: Text(
          _products.isEmpty
              ? 'Aún no hay productos registrados'
              : 'No se encontraron productos',
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
          final product = items[index];
          return ProductListCard(
            product: product,
            onTap: () => _openDetail(product),
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
              tooltip: 'Nuevo producto',
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
                title: 'Productos',
                onBack: widget.showBack
                    ? (widget.onBack ?? () => Navigator.pop(context))
                    : null,
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
              categories: _categoryNames,
              selected: _selectedCategory,
              onSelected: _onCategorySelected,
            ),
            const SizedBox(height: 12),
            Expanded(child: _buildBody(items)),
          ],
        ),
      ),
    );
  }
}
