import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../data/models/purchase_model.dart';
import '../../../data/repositories/purchases_repository.dart';
import '../../widgets/screen_title_bar.dart';
import 'purchase_detail_screen.dart';
import 'widgets/purchase_date_filter.dart';
import 'widgets/purchase_list_card.dart';
import 'widgets/purchase_search_field.dart';

class PurchasesScreen extends StatefulWidget {
  const PurchasesScreen({super.key, this.showBack = false});

  /// true cuando se abre como pantalla aparte (con flecha para volver).
  final bool showBack;

  @override
  State<PurchasesScreen> createState() => _PurchasesScreenState();
}

class _PurchasesScreenState extends State<PurchasesScreen> {
  final _repository = PurchasesRepository.instance;
  final _searchController = TextEditingController();

  List<PurchaseModel> _purchases = [];
  DateTimeRange? _range;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _purchases = _repository.getAll();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  DateTime _dateOnly(DateTime date) => DateTime(date.year, date.month, date.day);

  /// Compras que coinciden con el texto (N° o proveedor) y con el rango de fechas.
  List<PurchaseModel> get _filtered {
    final query = _query.trim().toLowerCase();
    final range = _range;

    return _purchases.where((purchase) {
      final matchesText = query.isEmpty ||
          purchase.numero.toLowerCase().contains(query) ||
          purchase.proveedor.toLowerCase().contains(query);
      if (!matchesText) return false;

      if (range == null) return true;
      final date = _dateOnly(purchase.fecha);
      return !date.isBefore(_dateOnly(range.start)) &&
          !date.isAfter(_dateOnly(range.end));
    }).toList();
  }

  // --- Eventos ---
  void _reload() => setState(() => _purchases = _repository.getAll());

  void _onSearchChanged(String value) => setState(() => _query = value);

  void _clearRange() => setState(() => _range = null);

  Future<void> _pickDateRange() async {
  final now = DateTime.now();
  final picked = await showDateRangePicker(
    context: context,
    firstDate: DateTime(2020),
    lastDate: DateTime(now.year + 1, 12, 31),
    initialDateRange: _range,
    helpText: 'Filtrar por fecha',
    saveText: 'Aplicar',
    confirmText: 'Aplicar',
    cancelText: 'Cancelar',
    fieldStartHintText: 'Fecha inicial',
    fieldEndHintText: 'Fecha final',
    fieldStartLabelText: 'Desde',
    fieldEndLabelText: 'Hasta',
    errorFormatText: 'Formato inválido',
    errorInvalidText: 'Fecha fuera de rango',
    errorInvalidRangeText: 'Rango inválido',
    builder: (context, child) => Theme(
      data: ThemeData.dark().copyWith(
        colorScheme: const ColorScheme.dark(
          primary: DarkColors.naranjaBoton,
          onPrimary: Color(0xFF1A1A1A),
          surface: DarkColors.tarjeta,
          onSurface: Colors.white,
        ),
      ),
      child: child!,
    ),
  );
  if (picked == null) return;
  setState(() => _range = picked);
}
  Future<void> _openDetail(PurchaseModel purchase) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PurchaseDetailScreen(purchase: purchase),
      ),
    );
    if (!mounted) return;
    _reload(); // por si la compra fue anulada
  }

  @override
  Widget build(BuildContext context) {
    final items = _filtered;

    return Scaffold(
      backgroundColor: DarkColors.fondo,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: ScreenTitleBar(
                title: 'Compras',
                onBack: widget.showBack ? () => Navigator.pop(context) : null,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: PurchaseSearchField(
                controller: _searchController,
                onChanged: _onSearchChanged,
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: PurchaseDateFilter(
                range: _range,
                onTap: _pickDateRange,
                onClear: _clearRange,
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: items.isEmpty
                  ? Center(
                      child: Text(
                        _purchases.isEmpty
                            ? 'Aún no hay compras registradas'
                            : 'No se encontraron compras',
                        style: const TextStyle(color: DarkColors.textoSuave),
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                      itemCount: items.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final purchase = items[index];
                        return PurchaseListCard(
                          purchase: purchase,
                          onTap: () => _openDetail(purchase),
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