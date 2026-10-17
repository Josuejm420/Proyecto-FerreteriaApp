import 'package:app_ferreteria/presentation/screens/Clientes/clients_validator.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../data/models/client_model.dart';
import '../../../data/repositories/clients_repository.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/screen_title_bar.dart';

/// Formulario para crear (client == null) o editar un cliente.
class ClientFormScreen extends StatefulWidget {
  const ClientFormScreen({super.key, this.client});

  final ClientModel? client;

  @override
  State<ClientFormScreen> createState() => _ClientFormScreenState();
}

class _ClientFormScreenState extends State<ClientFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _documentoController;
  late final TextEditingController _nombreController;
  late final TextEditingController _correoController;
  late final TextEditingController _telefonoController;

  bool _activo = true;
  bool _isSaving = false;

  bool get _isEditing => widget.client != null;

  @override
  void initState() {
    super.initState();
    final client = widget.client;

    _documentoController = TextEditingController(text: client?.documento ?? '');
    _nombreController = TextEditingController(text: client?.nombre ?? '');
    _correoController = TextEditingController(text: client?.correo ?? '');
    _telefonoController = TextEditingController(text: client?.telefono ?? '');
    _activo = client?.activo ?? true;
  }

  @override
  void dispose() {
    _documentoController.dispose();
    _nombreController.dispose();
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

    final client = ClientModel(
      id: widget.client?.id,
      documento: _documentoController.text.trim(),
      nombre: _nombreController.text.trim(),
      correo: _correoController.text.trim(),
      telefono: _telefonoController.text.trim(),
      activo: _activo,
    );

    final saved = await ClientsRepository.instance.save(client);

    if (!mounted) return;
    setState(() => _isSaving = false);
    Navigator.pop(context, saved); // devuelve el cliente guardado
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
              title: _isEditing ? 'Editar cliente' : 'Nuevo cliente',
              onBack: () => Navigator.pop(context),
            ),
            const SizedBox(height: 20),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  AppTextField(
                    controller: _documentoController,
                    label: 'Documento',
                    hint: 'Ej. 001-120590-0001A',
                    textCapitalization: TextCapitalization.characters,
                    textInputAction: TextInputAction.next,
                    validator: ClientsValidators.documento,
                  ),
                  const SizedBox(height: 16),
                  AppTextField(
                    controller: _nombreController,
                    label: 'Nombre',
                    hint: 'Ej. Carlos Mendoza',
                    textCapitalization: TextCapitalization.words,
                    textInputAction: TextInputAction.next,
                    validator: ClientsValidators.nombre,
                  ),
                  const SizedBox(height: 16),
                  AppTextField(
                    controller: _correoController,
                    label: 'Correo (opcional)',
                    hint: 'Ej. cliente@mail.com',
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    validator: ClientsValidators.correo,
                  ),
                  const SizedBox(height: 16),
                  AppTextField(
                    controller: _telefonoController,
                    label: 'Teléfono',
                    hint: 'Ej. 8845-1122',
                    keyboardType: TextInputType.phone,
                    textInputAction: TextInputAction.done,
                    validator: ClientsValidators.telefono,
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
