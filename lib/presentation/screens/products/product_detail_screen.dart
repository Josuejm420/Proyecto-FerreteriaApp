import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../data/models/products_model.dart';
import '../../../data/repositories/products_repository.dart';
import '../../widgets/screen_title_bar.dart';
import 'product_form_screen.dart';
import 'widgets/product_image_banner.dart';
import 'widgets/product_info_card.dart';
import 'widgets/status_chip.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({super.key, required this.product});

  final ProductsModel product;

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  late ProductsModel _product;

  @override
  void initState() {
    super.initState();
    _product = widget.product;
  }

  // --- Eventos ---
  Future<void> _onEdit() async {
    final updated = await Navigator.push<ProductsModel>(
      context,
      MaterialPageRoute(
        builder: (context) => ProductFormScreen(product: _product),
      ),
    );
    if (updated == null || !mounted) return;

    setState(() => _product = updated);
    _showMessage('Producto actualizado correctamente');
  }

  Future<void> _onToggleStatus() async {
    final willDeactivate = _product.activo;
    final action = willDeactivate ? 'desactivar' : 'activar';

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: DarkColors.tarjeta,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Text(
          '¿Quieres $action este producto?',
          style: const TextStyle(color: Colors.white, fontSize: 19),
        ),
        content: Text(
          _product.nombre,
          style: const TextStyle(color: DarkColors.textoSuave),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            style: FilledButton.styleFrom(
              backgroundColor: DarkColors.naranjaBoton,
              foregroundColor: const Color(0xFF1A1A1A),
            ),
            child: Text(action[0].toUpperCase() + action.substring(1)),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    final updated = await ProductsRepository.instance.save(
      _product.copyWith(activo: !_product.activo),
    );
    if (!mounted) return;

    setState(() => _product = updated);
    _showMessage(updated.activo ? 'Producto activado' : 'Producto desactivado');
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
    return Scaffold(
      backgroundColor: DarkColors.fondo,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          children: [
            ScreenTitleBar(
              title: 'Detalle de producto',
              onBack: () => Navigator.pop(context),
            ),
            const SizedBox(height: 16),
            const ProductImageBanner(),
            const SizedBox(height: 16),
            Text(
              _product.nombre,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerLeft,
              child: StatusChip(activo: _product.activo),
            ),
            const SizedBox(height: 16),
            ProductInfoCard(product: _product),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _onEdit,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Colors.white54, width: 2),
                      minimumSize: const Size.fromHeight(56),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    child: const Text(
                      'Editar',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton(
                    onPressed: _onToggleStatus,
                    style: FilledButton.styleFrom(
                      backgroundColor: DarkColors.naranjaBoton,
                      foregroundColor: const Color(0xFF1A1A1A),
                      minimumSize: const Size.fromHeight(56),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    child: Text(
                      _product.activo ? 'Desactivar' : 'Activar',
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
