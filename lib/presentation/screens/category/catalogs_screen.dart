import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../data/models/category_model.dart';
import '../../../data/models/presentation_model.dart';
import '../../../data/repositories/categories_repository.dart';
import '../../../data/repositories/presentations_repository.dart';
import '../../widgets/screen_title_bar.dart';
import 'category_form_screen.dart';
import 'presentation_form_screen.dart';
import 'widgets/catalog_filter_bar.dart';
import 'widgets/catalog_list_card.dart';
import 'widgets/catalog_search_field.dart';
import 'widgets/catalog_section_title.dart';

class CatalogsScreen extends StatefulWidget {
  const CatalogsScreen({super.key, this.showBack = false});

  /// true cuando se abre como pantalla aparte (con flecha para volver).
  final bool showBack;

  @override
  State<CatalogsScreen> createState() => _CatalogsScreenState();
}

class _CatalogsScreenState extends State<CatalogsScreen> {
  final _categoriesRepository = CategoriesRepository.instance;
  final _presentationsRepository = PresentationsRepository.instance;
  final _searchController = TextEditingController();

  List<CategoryModel> _categories = [];
  List<PresentationModel> _presentations = [];
  CatalogFilter _filter = CatalogFilter.todo;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _categories = _categoriesRepository.getAll();
    _presentations = _presentationsRepository.getAll();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // --- Datos filtrados ---
  bool _matches(String nombre) {
    final query = _query.trim().toLowerCase();
    return query.isEmpty || nombre.toLowerCase().contains(query);
  }

  List<CategoryModel> get _filteredCategories {
    if (_filter == CatalogFilter.presentaciones) return [];
    return _categories.where((c) => _matches(c.nombre)).toList();
  }

  List<PresentationModel> get _filteredPresentations {
    if (_filter == CatalogFilter.categorias) return [];
    return _presentations.where((p) => _matches(p.nombre)).toList();
  }

  String get _searchHint {
    switch (_filter) {
      case CatalogFilter.todo:
        return 'Buscar en catálogos';
      case CatalogFilter.categorias:
        return 'Buscar categoría';
      case CatalogFilter.presentaciones:
        return 'Buscar presentación';
    }
  }

  // --- Eventos ---
  void _reload() {
    setState(() {
      _categories = _categoriesRepository.getAll();
      _presentations = _presentationsRepository.getAll();
    });
  }

  void _onSearchChanged(String value) => setState(() => _query = value);

  void _onFilterChanged(CatalogFilter filter) =>
      setState(() => _filter = filter);

  Future<void> _openCategoryForm([CategoryModel? category]) async {
    final saved = await Navigator.push<CategoryModel>(
      context,
      MaterialPageRoute(
        builder: (context) => CategoryFormScreen(category: category),
      ),
    );
    if (!mounted) return;
    _reload();
    if (saved != null) {
      _showMessage(category == null
          ? 'Categoría creada correctamente'
          : 'Categoría actualizada correctamente');
    }
  }

  Future<void> _openPresentationForm([PresentationModel? presentation]) async {
    final saved = await Navigator.push<PresentationModel>(
      context,
      MaterialPageRoute(
        builder: (context) =>
            PresentationFormScreen(presentation: presentation),
      ),
    );
    if (!mounted) return;
    _reload();
    if (saved != null) {
      _showMessage(presentation == null
          ? 'Presentación creada correctamente'
          : 'Presentación actualizada correctamente');
    }
  }

  /// El botón + crea según el filtro; en "Todo" pregunta qué crear.
  Future<void> _onAddPressed() async {
    switch (_filter) {
      case CatalogFilter.categorias:
        await _openCategoryForm();
        break;
      case CatalogFilter.presentaciones:
        await _openPresentationForm();
        break;
      case CatalogFilter.todo:
        {
          final choice = await _askWhatToCreate();
          if (!mounted) return;
          if (choice == CatalogFilter.categorias) {
            await _openCategoryForm();
          } else if (choice == CatalogFilter.presentaciones) {
            await _openPresentationForm();
          }
        }
        break;
    }
  }

  Future<CatalogFilter?> _askWhatToCreate() {
    return showModalBottomSheet<CatalogFilter>(
      context: context,
      backgroundColor: DarkColors.tarjeta,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            ListTile(
              leading: const Text('🏷️', style: TextStyle(fontSize: 24)),
              title: const Text(
                'Nueva categoría',
                style: TextStyle(color: Colors.white, fontSize: 17),
              ),
              onTap: () => Navigator.pop(sheetContext, CatalogFilter.categorias),
            ),
            ListTile(
              leading: const Text('📏', style: TextStyle(fontSize: 24)),
              title: const Text(
                'Nueva presentación',
                style: TextStyle(color: Colors.white, fontSize: 17),
              ),
              onTap: () =>
                  Navigator.pop(sheetContext, CatalogFilter.presentaciones),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
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
    final categories = _filteredCategories;
    final presentations = _filteredPresentations;
    final isEmpty = categories.isEmpty && presentations.isEmpty;
    final accents = DarkColors.acentosProducto.length;

    return Scaffold(
      backgroundColor: DarkColors.fondo,
      floatingActionButton: FloatingActionButton(
        onPressed: _onAddPressed,
        tooltip: 'Agregar',
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
                title: 'Catálogos',
                onBack: widget.showBack ? () => Navigator.pop(context) : null,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: CatalogSearchField(
                controller: _searchController,
                onChanged: _onSearchChanged,
                hintText: _searchHint,
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: CatalogFilterBar(
                selected: _filter,
                onChanged: _onFilterChanged,
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: isEmpty
                  ? Center(
                      child: Text(
                        _query.trim().isNotEmpty
                            ? 'No se encontraron resultados'
                            : 'Aún no hay elementos en esta lista',
                        style: const TextStyle(color: DarkColors.textoSuave),
                      ),
                    )
                  : ListView(
                      padding: const EdgeInsets.fromLTRB(16, 4, 16, 96),
                      children: [
                        if (categories.isNotEmpty) ...[
                          const CatalogSectionTitle('Categorías'),
                          const SizedBox(height: 12),
                          for (final category in categories) ...[
                            CatalogListCard(
                              emoji: '🏷️',
                              title: category.nombre,
                              subtitle: category.descripcion.isEmpty
                                  ? 'Categoría'
                                  : category.descripcion,
                              activo: category.activo,
                              accentIndex: (category.id ?? 0) % accents,
                              onTap: () => _openCategoryForm(category),
                            ),
                            const SizedBox(height: 12),
                          ],
                        ],
                        if (presentations.isNotEmpty) ...[
                          if (categories.isNotEmpty) const SizedBox(height: 8),
                          const CatalogSectionTitle('Presentaciones'),
                          const SizedBox(height: 12),
                          for (final presentation in presentations) ...[
                            CatalogListCard(
                              emoji: '📏',
                              title: presentation.nombre,
                              subtitle: presentation.resumen,
                              activo: presentation.activo,
                              accentIndex: ((presentation.id ?? 0) + 2) % accents,
                              onTap: () => _openPresentationForm(presentation),
                            ),
                            const SizedBox(height: 12),
                          ],
                        ],
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}