import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/di/service_locator.dart';
import '../../../core/errors/api_exception.dart';
import '../../../data/models/category_model.dart';
import '../../../data/models/presentation_model.dart';
import '../../../data/models/products_model.dart';
import '../../../data/repositories/products_repository.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/screen_title_bar.dart';
import 'products_validators.dart';
import 'widgets/product_dropdown.dart';
import 'widgets/product_text_field.dart';


class ProductFormScreen extends StatefulWidget {
  const ProductFormScreen({super.key, this.product});

  final ProductsModel? product;

  @override
  State<ProductFormScreen> createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nombreController;
  late final TextEditingController _descripcionController;

  List<CategoryModel> _categories = [];
  List<PresentationModel> _presentations = [];
  CategoryModel? _categoria;
  PresentationModel? _presentacion;
  bool _activo = true;
  bool _isSaving = false;
  bool _isLoadingCatalogs = true;
  String? _catalogsError;

  bool get _isEditing => widget.product != null;

  @override
  void initState() {
    super.initState();
    final product = widget.product;

    _nombreController = TextEditingController(text: product?.nombre ?? '');
    _descripcionController =
        TextEditingController(text: product?.descripcion ?? '');
    _activo = product?.activo ?? true;

    _loadCatalogs();
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _descripcionController.dispose();
    super.dispose();
  }

  
  Future<void> _loadCatalogs() async {
    try {
      final catalogs = await getIt<ProductsRepository>().loadCatalogs();
      if (!mounted) return;

      final product = widget.product;
      
      final categories = catalogs.categories
          .where((c) => c.activo || c.id == product?.categoriaId)
          .toList();
      final presentations = catalogs.presentations
          .where((p) => p.activo || p.id == product?.presentacionId)
          .toList();

      setState(() {
        _categories = categories;
        _presentations = presentations;
        
        _categoria =
            categories.where((c) => c.id == product?.categoriaId).firstOrNull;
        _presentacion = presentations
            .where((p) => p.id == product?.presentacionId)
            .firstOrNull;
        _catalogsError = null;
      });
    } on ApiException catch (e) {
      if (mounted) setState(() => _catalogsError = e.message);
    } catch (_) {
      if (mounted) {
        setState(() => _catalogsError = 'No se pudieron cargar los catálogos');
      }
    } finally {
      if (mounted) setState(() => _isLoadingCatalogs = false);
    }
  }

  void _onRetryCatalogs() {
    setState(() {
      _isLoadingCatalogs = true;
      _catalogsError = null;
    });
    _loadCatalogs();
  }

 
  void _onCategoryChanged(CategoryModel? value) =>
      setState(() => _categoria = value);

  void _onPresentationChanged(PresentationModel? value) {
    setState(() => _presentacion = value);
  }

  void _onActiveChanged(bool? value) => setState(() => _activo = value ?? true);

  void _showError(String text) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(text),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  Future<void> _onSave() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) return;

    final categoria = _categoria;
    final presentacion = _presentacion;
    if (categoria == null || presentacion == null) return;

    setState(() => _isSaving = true);

    final base = widget.product;

    final product = ProductsModel(
      id: base?.id,
      nombre: _nombreController.text.trim(),
      descripcion: _descripcionController.text.trim(),
      categoriaId: categoria.id!,
      categoria: categoria.nombre,
      presentacionId: presentacion.id!,
      presentacion: presentacion.nombre,
      unidadMedida: presentacion.unidadMedida,
      peso: presentacion.peso,
      fechaRegistro: base?.fechaRegistro ?? DateTime.now(),
      activo: _activo,
    );

    try {
      final saved = await getIt<ProductsRepository>().save(product);
      if (!mounted) return;
      Navigator.pop(context, saved); // devuelve el producto guardado
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() => _isSaving = false);
      _showError(e.message);
    } catch (_) {
      if (!mounted) return;
      setState(() => _isSaving = false);
      _showError('No se pudo guardar el producto');
    }
  }

  Widget _buildContent() {
    if (_isLoadingCatalogs) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 48),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (_catalogsError != null) {
      return _InfoCard(
        message: _catalogsError!,
        actionLabel: 'Reintentar',
        onAction: _onRetryCatalogs,
      );
    }

    if (_categories.isEmpty || _presentations.isEmpty) {
      return const _InfoCard(
        message: 'Antes de registrar productos necesitas al menos una '
            'categoría y una presentación activas. Créalas en Catálogos.',
      );
    }

    return Form(
      key: _formKey,
      child: Column(
        children: [
          ProductTextField(
            controller: _nombreController,
            label: 'Nombre del producto',
            hint: 'Ej. Taladro eléctrico 600W',
            textInputAction: TextInputAction.next,
            validator: ProductsValidators.nombre,
          ),
          const SizedBox(height: 16),
          ProductTextField(
            controller: _descripcionController,
            label: 'Descripción',
            hint: 'Describe el producto',
            maxLines: 3,
          ),
          const SizedBox(height: 16),
          ProductDropdown<CategoryModel>(
            label: 'Categoría',
            value: _categoria,
            items: _categories,
            itemLabel: (c) => c.nombre,
            onChanged: _onCategoryChanged,
            validator: ProductsValidators.categoria,
          ),
          const SizedBox(height: 16),
          ProductDropdown<PresentationModel>(
            label: 'Presentación',
            value: _presentacion,
            items: _presentations,
            itemLabel: (p) => '${p.nombre} (${p.unidadMedida})',
            onChanged: _onPresentationChanged,
            validator: ProductsValidators.presentacion,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Text(
                _activo ? 'Estado (activo)' : 'Estado (inactivo)',
                style: const TextStyle(
                  color: DarkColors.textoSuave,
                  fontSize: 16,
                ),
              ),
              const Spacer(),
              Checkbox(
                value: _activo,
                onChanged: _onActiveChanged,
                activeColor: DarkColors.checkAzul,
                checkColor: const Color(0xFF14192E),
                side: const BorderSide(color: DarkColors.textoSuave, width: 2),
              ),
            ],
          ),
          const SizedBox(height: 20),
          PrimaryButton(
            text: 'Guardar',
            isLoading: _isSaving,
            onPressed: _onSave,
            backgroundColor: DarkColors.naranjaBoton,
            foregroundColor: const Color(0xFF1A1A1A),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DarkColors.fondo,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          children: [
            ScreenTitleBar(
              title: _isEditing ? 'Editar producto' : 'Nuevo producto',
              onBack: () => Navigator.pop(context),
            ),
            const SizedBox(height: 20),
            _buildContent(),
          ],
        ),
      ),
    );
  }
}


class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.message, this.actionLabel, this.onAction});

  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: DarkColors.tarjeta,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
          if (actionLabel != null) ...[
            const SizedBox(height: 12),
            FilledButton(
              onPressed: onAction,
              style: FilledButton.styleFrom(
                backgroundColor: DarkColors.naranjaBoton,
                foregroundColor: const Color(0xFF1A1A1A),
              ),
              child: Text(actionLabel!),
            ),
          ],
        ],
      ),
    );
  }
}