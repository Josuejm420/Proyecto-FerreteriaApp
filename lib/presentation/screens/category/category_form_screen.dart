import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../data/models/category_model.dart';
import '../../../data/repositories/categories_repository.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/screen_title_bar.dart';
import 'category_validators.dart';
import 'widgets/catalog_text_field.dart';

/// Formulario para crear (category == null) o editar una categoría.
class CategoryFormScreen extends StatefulWidget {
  const CategoryFormScreen({super.key, this.category});

  final CategoryModel? category;

  @override
  State<CategoryFormScreen> createState() => _CategoryFormScreenState();
}

class _CategoryFormScreenState extends State<CategoryFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nombreController;
  late final TextEditingController _descripcionController;

  bool _activo = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final category = widget.category;

    _nombreController = TextEditingController(text: category?.nombre ?? '');
    _descripcionController =
        TextEditingController(text: category?.descripcion ?? '');
    _activo = category?.activo ?? true;
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _descripcionController.dispose();
    super.dispose();
  }

  // --- Eventos ---
  void _onActiveChanged(bool? value) => setState(() => _activo = value ?? true);

  Future<void> _onSave() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    final category = CategoryModel(
      id: widget.category?.id,
      nombre: _nombreController.text.trim(),
      descripcion: _descripcionController.text.trim(),
      activo: _activo,
    );

    final saved = await CategoriesRepository.instance.save(category);

    if (!mounted) return;
    setState(() => _isSaving = false);
    Navigator.pop(context, saved); // devuelve la categoría guardada
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
              title: 'Categoría',
              onBack: () => Navigator.pop(context),
            ),
            const SizedBox(height: 20),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  CatalogTextField(
                    controller: _nombreController,
                    label: 'Nombre de categoría',
                    hint: 'Ej. Herramientas eléctricas',
                    textCapitalization: TextCapitalization.sentences,
                    textInputAction: TextInputAction.next,
                    validator: CategoryValidators.nombre,
                  ),
                  const SizedBox(height: 16),
                  CatalogTextField(
                    controller: _descripcionController,
                    label: 'Descripción',
                    hint: 'Opcional',
                    textCapitalization: TextCapitalization.sentences,
                    textInputAction: TextInputAction.done,
                    validator: CategoryValidators.descripcion,
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