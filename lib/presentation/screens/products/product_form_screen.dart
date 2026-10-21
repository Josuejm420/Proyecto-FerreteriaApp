import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../data/models/products_model.dart';
import '../../../data/repositories/products_repository.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/screen_title_bar.dart';
import 'products_validators.dart';
import 'widgets/product_dropdown.dart';
import 'widgets/product_text_field.dart';

/// Formulario para crear (product == null) o editar un producto.
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

  String? _categoria;
  ProductPresentation? _presentacion;
  bool _activo = true;
  bool _isSaving = false;

  bool get _isEditing => widget.product != null;

  @override
  void initState() {
    super.initState();
    final product = widget.product;

    _nombreController = TextEditingController(text: product?.nombre ?? '');
    _descripcionController =
        TextEditingController(text: product?.descripcion ?? '');

    if (product != null) {
      _categoria = ProductsRepository.categorias.contains(product.categoria)
          ? product.categoria
          : null;
      _presentacion = ProductsRepository.presentaciones
          .where((p) => p.nombre == product.presentacion)
          .firstOrNull;
      _activo = product.activo;
    }
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _descripcionController.dispose();
    super.dispose();
  }

  // --- Eventos ---
  void _onCategoryChanged(String? value) => setState(() => _categoria = value);

  void _onPresentationChanged(ProductPresentation? value) {
    setState(() => _presentacion = value);
  }

  void _onActiveChanged(bool? value) => setState(() => _activo = value ?? true);

  Future<void> _onSave() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) return;

    final categoria = _categoria;
    final presentacion = _presentacion;
    if (categoria == null || presentacion == null) {
      _formKey.currentState?.validate();
      return;
    }

    setState(() => _isSaving = true);

    final base = widget.product;

    final product = ProductsModel(
      id: base?.id,
      nombre: _nombreController.text.trim(),
      descripcion: _descripcionController.text.trim(),
      categoria: categoria,
      presentacion: presentacion.nombre,
      unidadMedida: presentacion.unidad,
      peso: base?.peso,
      fechaRegistro: base?.fechaRegistro ?? DateTime.now(),
      activo: _activo,
    );

    final saved = await ProductsRepository.instance.save(product);

    if (!mounted) return;
    setState(() => _isSaving = false);
    Navigator.pop(context, saved); // devuelve el producto guardado
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
            Form(
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
                  ProductDropdown<String>(
                    label: 'Categoría',
                    value: _categoria,
                    items: ProductsRepository.categorias,
                    itemLabel: (c) => c,
                    onChanged: _onCategoryChanged,
                    validator: ProductsValidators.categoria,
                  ),
                  const SizedBox(height: 16),
                  ProductDropdown<ProductPresentation>(
                    label: 'Presentación',
                    value: _presentacion,
                    items: ProductsRepository.presentaciones,
                    itemLabel: (p) => '${p.nombre} (${p.unidad})',
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
                        side: const BorderSide(
                          color: DarkColors.textoSuave,
                          width: 2,
                        ),
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
            ),
          ],
        ),
      ),
    );
  }
}