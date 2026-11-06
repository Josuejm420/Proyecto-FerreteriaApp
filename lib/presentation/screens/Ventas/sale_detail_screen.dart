import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_icons.dart';
import '../../../core/errors/api_exception.dart';
import '../../../core/utils/formatters.dart';
import '../../../data/models/sale_model.dart';
import '../../../data/models/user_role.dart';
import '../../../data/repositories/sales_repository.dart';
import '../../widgets/confirm_dialog.dart';
import '../../widgets/document_lines_card.dart';
import '../../widgets/document_status_banner.dart';
import '../../widgets/info_card.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/screen_title_bar.dart';

class SaleDetailScreen extends StatefulWidget {
  const SaleDetailScreen({super.key, required this.sale, required this.role});

  final SaleModel sale;
  final UserRole role;

  @override
  State<SaleDetailScreen> createState() => _SaleDetailScreenState();
}

class _SaleDetailScreenState extends State<SaleDetailScreen> {
  final _repository = SalesRepository.instance;

  late SaleModel _sale;
  bool _isSaving = false;
  bool _isLoadingDetails = false;

  bool get _isAdmin => widget.role == UserRole.administrador;

  @override
  void initState() {
    super.initState();
    _sale = widget.sale;
    if (_sale.detalles.isEmpty && _sale.id != null) {
      _loadDetails();
    }
  }

  Future<void> _loadDetails() async {
    setState(() => _isLoadingDetails = true);
    final details = await _repository.getDetalles(_sale.id!);
    if (!mounted) return;
    setState(() {
      _sale = _sale.copyWith(detalles: details);
      _isLoadingDetails = false;
    });
  }

  Future<void> _onAnular() async {
    final confirmed = await showConfirmDialog(
      context,
      title: '¿Anular esta factura?',
      message: '${_sale.numeroComprobante}\nEsta acción no se puede deshacer.',
      confirmText: 'Anular',
      destructive: true,
    );
    if (!confirmed || !mounted) return;

    setState(() => _isSaving = true);
    try {
      final updated = await _repository.anular(_sale);
      if (!mounted) return;

      setState(() {
        _sale = updated;
        _isSaving = false;
      });
      _showMessage('Factura anulada correctamente');
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() => _isSaving = false);
      _showMessage(e.message);
    } catch (_) {
      if (!mounted) return;
      setState(() => _isSaving = false);
      _showMessage('Error al anular la factura en el servidor');
    }
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
    final lines = [
      for (final d in _sale.detalles)
        DocumentLine(
          nombre: d.productoNombre ?? _repository.productoNombre(d.productoId),
          cantidad: d.cantidad,
          subtotal: d.subtotal,
        ),
    ];

    return Scaffold(
      backgroundColor: DarkColors.fondo,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          children: [
            ScreenTitleBar(
              title: 'Factura ${_sale.numeroComprobante}',
              onBack: () => Navigator.pop(context),
            ),
            const SizedBox(height: 16),
            DocumentStatusBanner(anulada: _sale.anulada),
            const SizedBox(height: 16),
            InfoCard(
              rows: [
                ('Comprobante', _sale.numeroComprobante),
                ('Fecha de venta', AppFormat.date(_sale.fechaVenta)),
                ('Cliente', _repository.clienteNombre(_sale)),
                (
                  'Atendió',
                  _sale.atendio.isNotEmpty ? _sale.atendio : 'Vendedor',
                ),
              ],
            ),
            const SizedBox(height: 20),
            const _SectionLabel('Detalle de productos'),
            const SizedBox(height: 10),
            if (_isLoadingDetails)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: CircularProgressIndicator(
                    color: DarkColors.naranjaBoton,
                  ),
                ),
              )
            else if (lines.isEmpty)
              const Padding(
                padding: EdgeInsets.all(12),
                child: Text(
                  'No hay productos detallados en esta factura',
                  style: TextStyle(color: DarkColors.textoSuave),
                ),
              )
            else
              DocumentLinesCard(lines: lines),
            const SizedBox(height: 20),
            const _SectionLabel('Totales'),
            const SizedBox(height: 10),
            InfoCard(
              highlightIndex: 3,
              rows: [
                ('Subtotal', AppFormat.money(_sale.subtotal)),
                ('IVA (15 %)', AppFormat.money(_sale.iva)),
                ('Descuento', '- ${AppFormat.money(_sale.descuento)}'),
                ('Total', AppFormat.money(_sale.total)),
                ('Monto pagado', AppFormat.money(_sale.montoPago)),
                ('Cambio', AppFormat.money(_sale.montoCambio)),
              ],
            ),
            const SizedBox(height: 24),
            if (_sale.anulada)
              const SizedBox.shrink()
            else if (_isAdmin)
              PrimaryButton(
                text: 'Anular factura',
                icon: AppIcons.anular,
                isLoading: _isSaving,
                onPressed: _onAnular,
                backgroundColor: DarkColors.rojo,
                foregroundColor: Colors.white,
              )
            else
              const Text(
                'Solo el administrador puede anular documentos.',
                textAlign: TextAlign.center,
                style: TextStyle(color: DarkColors.textoSuave),
              ),
          ],
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: DarkColors.textoSuave,
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
