import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../data/models/presentation_model.dart';
import '../../../data/repositories/presentations_repository.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/screen_title_bar.dart';
import 'presentation_validators.dart';
import 'widgets/catalog_text_field.dart';

/// Formulario para crear (presentation == null) o editar una presentación.
class PresentationFormScreen extends StatefulWidget {
  const PresentationFormScreen({super.key, this.presentation});

  final PresentationModel? presentation;

  @override
  State<PresentationFormScreen> createState() => _PresentationFormScreenState();
}

class _PresentationFormScreenState extends State<PresentationFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nombreController;
  late final TextEditingController _unidadController;
  late final TextEditingController _pesoController;

  bool _activo = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final presentation = widget.presentation;

    _nombreController = TextEditingController(text: presentation?.nombre ?? '');
    _unidadController =
        TextEditingController(text: presentation?.unidadMedida ?? '');
    _pesoController = TextEditingController(text: presentation?.pesoTexto ?? '');
    _activo = presentation?.activo ?? true;
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _unidadController.dispose();
    _pesoController.dispose();
    super.dispose();
  }

  // --- Eventos ---
  void _onActiveChanged(bool? value) => setState(() => _activo = value ?? true);

  Future<void> _onSave() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    final presentation = PresentationModel(
      id: widget.presentation?.id,
      nombre: _nombreController.text.trim(),
      unidadMedida: _unidadController.text.trim(),
      peso: double.parse(_pesoController.text.trim().replaceAll(',', '.')),
      activo: _activo,
    );

    final saved = await PresentationsRepository.instance.save(presentation);

    if (!mounted) return;
    setState(() => _isSaving = false);
    Navigator.pop(context, saved); // devuelve la presentación guardada
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
              title: 'Presentación',
              onBack: () => Navigator.pop(context),
            ),
            const SizedBox(height: 20),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  CatalogTextField(
                    controller: _nombreController,
                    label: 'Nombre',
                    hint: 'Ej. Saco',
                    textCapitalization: TextCapitalization.sentences,
                    textInputAction: TextInputAction.next,
                    validator: PresentationValidators.nombre,
                  ),
                  const SizedBox(height: 16),
                  CatalogTextField(
                    controller: _unidadController,
                    label: 'Unidad de medida',
                    hint: 'Ej. kg, lt, m, unidad',
                    textInputAction: TextInputAction.next,
                    validator: PresentationValidators.unidadMedida,
                  ),
                  const SizedBox(height: 16),
                  CatalogTextField(
                    controller: _pesoController,
                    label: 'Peso',
                    hint: 'Ej. 42.5',
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    textInputAction: TextInputAction.done,
                    validator: PresentationValidators.peso,
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