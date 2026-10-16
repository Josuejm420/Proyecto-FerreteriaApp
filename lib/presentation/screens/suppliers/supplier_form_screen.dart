import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../data/models/supplier_model.dart';
import '../../../data/repositories/suppliers_repository.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/screen_title_bar.dart';
import 'suppliers_validators.dart';
import 'widgets/supplier_text_field.dart';

/// Formulario para crear (supplier == null) o editar un proveedor.
class SupplierFormScreen extends StatefulWidget {
  const SupplierFormScreen({super.key, this.supplier});

  final SupplierModel? supplier;

  @override
  State<SupplierFormScreen> createState() => _SupplierFormScreenState();
}

class _SupplierFormScreenState extends State<SupplierFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nombreController;
  late final TextEditingController _documentoController;
  late final TextEditingController _correoController;
  late final TextEditingController _telefonoController;

  bool _activo = true;
  bool _isSaving = false;

  bool get _isEditing => widget.supplier != null;

  @override
  void initState() {
    super.initState();
    final supplier = widget.supplier;

    _nombreController = TextEditingController(text: supplier?.nombre ?? '');
    _documentoController =
        TextEditingController(text: supplier?.documento ?? '');
    _correoController = TextEditingController(text: supplier?.correo ?? '');
    _telefonoController = TextEditingController(text: supplier?.telefono ?? '');
    _activo = supplier?.activo ?? true;
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _documentoController.dispose();
    _correoController.dispose();
    _telefonoController.dispose();
    super.dispose();
  }

  // --- Eventos ---
  void _onActiveChanged(bool? value) => setState(() => _activo = value ?? true);

  Future<void> _onSave() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    final supplier = SupplierModel(
      id: widget.supplier?.id,
      nombre: _nombreController.text.trim(),
      documento: _documentoController.text.trim(),
      correo: _correoController.text.trim(),
      telefono: _telefonoController.text.trim(),
      activo: _activo,
    );

    final saved = await SuppliersRepository.instance.save(supplier);

    if (!mounted) return;
    setState(() => _isSaving = false);
    Navigator.pop(context, saved); // devuelve el proveedor guardado
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
              title: _isEditing ? 'Editar proveedor' : 'Nuevo proveedor',
              onBack: () => Navigator.pop(context),
            ),
            const SizedBox(height: 20),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  SupplierTextField(
                    controller: _nombreController,
                    label: 'Nombre',
                    hint: 'Ej. Herramientas Mundiales S.A.',
                    textCapitalization: TextCapitalization.words,
                    textInputAction: TextInputAction.next,
                    validator: SuppliersValidators.nombre,
                  ),
                  const SizedBox(height: 16),
                  SupplierTextField(
                    controller: _documentoController,
                    label: 'Documento',
                    hint: 'Ej. J0310000012345',
                    textCapitalization: TextCapitalization.characters,
                    textInputAction: TextInputAction.next,
                    validator: SuppliersValidators.documento,
                  ),
                  const SizedBox(height: 16),
                  SupplierTextField(
                    controller: _correoController,
                    label: 'Correo',
                    hint: 'Ej. ventas@empresa.com',
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    validator: SuppliersValidators.correo,
                  ),
                  const SizedBox(height: 16),
                  SupplierTextField(
                    controller: _telefonoController,
                    label: 'Teléfono',
                    hint: 'Ej. 2552-3100',
                    keyboardType: TextInputType.phone,
                    textInputAction: TextInputAction.done,
                    validator: SuppliersValidators.telefono,
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