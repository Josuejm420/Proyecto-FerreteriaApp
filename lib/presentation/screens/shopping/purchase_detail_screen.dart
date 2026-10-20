import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/utils/formatters.dart';
import '../../../data/models/purchase_model.dart';
import '../../../data/repositories/purchases_repository.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/screen_title_bar.dart';
import 'widgets/purchase_cancel_sheet.dart';
import 'widgets/purchase_info_card.dart';
import 'widgets/purchase_items_card.dart';
import 'widgets/purchase_status_banner.dart';

class PurchaseDetailScreen extends StatefulWidget {
  const PurchaseDetailScreen({super.key, required this.purchase});

  final PurchaseModel purchase;

  @override
  State<PurchaseDetailScreen> createState() => _PurchaseDetailScreenState();
}

class _PurchaseDetailScreenState extends State<PurchaseDetailScreen> {
  late PurchaseModel _purchase;
  bool _isCancelling = false;

  @override
  void initState() {
    super.initState();
    _purchase = widget.purchase;
  }

  // --- Eventos ---
  Future<void> _onCancelPressed() async {
    final confirmed = await showCancelPurchaseSheet(context);
    if (confirmed != true || !mounted) return;

    setState(() => _isCancelling = true);

    final updated = await PurchasesRepository.instance.cancel(_purchase.id);

    if (!mounted) return;
    setState(() {
      _purchase = updated;
      _isCancelling = false;
    });

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(
          content: Text('Documento anulado correctamente'),
          behavior: SnackBarBehavior.floating,
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
              title: 'Compra ${_purchase.numero}',
              onBack: () => Navigator.pop(context),
            ),
            const SizedBox(height: 16),
            PurchaseStatusBanner(anulada: _purchase.anulada),
            const SizedBox(height: 16),
            PurchaseInfoCard(
              rows: [
                MapEntry('N° documento', _purchase.numero),
                MapEntry('Fecha de compra', formatDate(_purchase.fecha)),
                MapEntry('Proveedor', _purchase.proveedor),
                MapEntry('Registró', _purchase.registro),
              ],
            ),
            const SizedBox(height: 16),
            PurchaseItemsCard(items: _purchase.items),
            const SizedBox(height: 16),
            PurchaseInfoCard(
              rows: [
                MapEntry('Subtotal', formatMoney(_purchase.subtotal)),
                MapEntry('IVA', formatMoney(_purchase.iva)),
                MapEntry('Total', formatMoney(_purchase.total)),
              ],
            ),
            if (!_purchase.anulada) ...[
              const SizedBox(height: 20),
              PrimaryButton(
                text: 'Anular documento',
                isLoading: _isCancelling,
                onPressed: _onCancelPressed,
                backgroundColor: DarkColors.rojo,
                foregroundColor: Colors.white,
              ),
            ],
          ],
        ),
      ),
    );
  }
}