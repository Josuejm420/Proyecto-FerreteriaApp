import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../data/models/sale_model.dart';
import '../../../data/models/user_role.dart';
import '../../../data/repositories/sales_repository.dart';
import '../../widgets/app_search_field.dart';
import '../../widgets/screen_title_bar.dart';
import '../Home/widgets/stat_card.dart';
import 'sale_detail_screen.dart';
import '../Ventas/widgets/sales_list_card.dart';

/// Lista de ventas (solo consulta y anulación; no se registran facturas aquí).
class SalesScreen extends StatefulWidget {
  const SalesScreen({super.key, required this.role, this.showBack = false});

  /// Rol del usuario: solo el administrador puede anular facturas.
  final UserRole role;

  /// true cuando se abre como pantalla aparte (con flecha para volver).
  final bool showBack;

  @override
  State<SalesScreen> createState() => _SalesScreenState();
}

class _SalesScreenState extends State<SalesScreen> {
  final _repository = SalesRepository.instance;
  final _searchController = TextEditingController();

  List<SaleModel> _sales = [];
  String _query = '';

  @override
  void initState() {
    super.initState();
    _sales = _repository.getAll();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// Facturas que coinciden con lo buscado (por comprobante o cliente).
  List<SaleModel> get _filtered {
    final query = _query.trim().toLowerCase();
    if (query.isEmpty) return _sales;
    return _sales
        .where(
          (s) =>
              s.numeroComprobante.toLowerCase().contains(query) ||
              _repository.clienteNombre(s).toLowerCase().contains(query),
        )
        .toList();
  }

  // --- Eventos ---
  void _onSearchChanged(String value) => setState(() => _query = value);

  Future<void> _openDetail(SaleModel sale) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SaleDetailScreen(sale: sale, role: widget.role),
      ),
    );
    if (!mounted) return;
    // Al volver, recarga por si la factura se anuló.
    setState(() => _sales = _repository.getAll());
  }

  @override
  Widget build(BuildContext context) {
    final items = _filtered;
    final anuladas = _sales.where((s) => s.anulada).length;
    final emitidas = _sales.length - anuladas;

    return Scaffold(
      backgroundColor: DarkColors.fondo,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: ScreenTitleBar(
                title: 'Ventas',
                onBack: widget.showBack ? () => Navigator.pop(context) : null,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: StatCard(label: 'Emitidas', value: '$emitidas'),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: StatCard(label: 'Anuladas', value: '$anuladas'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: AppSearchField(
                controller: _searchController,
                onChanged: _onSearchChanged,
                hint: 'Buscar por comprobante o cliente',
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: items.isEmpty
                  ? Center(
                      child: Text(
                        _sales.isEmpty
                            ? 'Aún no hay ventas registradas'
                            : 'No se encontraron ventas',
                        style: const TextStyle(color: DarkColors.textoSuave),
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                      itemCount: items.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final sale = items[index];
                        return SaleListCard(
                          sale: sale,
                          onTap: () => _openDetail(sale),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
