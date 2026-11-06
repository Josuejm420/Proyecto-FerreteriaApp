import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/errors/api_exception.dart';
import '../../../data/models/sale_model.dart';
import '../../../data/models/user_role.dart';
import '../../../data/repositories/sales_repository.dart';
import '../../widgets/app_search_field.dart';
import '../../widgets/screen_title_bar.dart';
import '../Home/widgets/stat_card.dart';
import 'sale_detail_screen.dart';
import 'widgets/sales_list_card.dart';

class SalesScreen extends StatefulWidget {
  const SalesScreen({
    super.key,
    required this.role,
    this.showBack = false,
    this.onBack,
  });

  final UserRole role;
  final bool showBack;
  final VoidCallback? onBack;

  @override
  State<SalesScreen> createState() => _SalesScreenState();
}

class _SalesScreenState extends State<SalesScreen> {
  final _repository = SalesRepository.instance;
  final _searchController = TextEditingController();

  List<SaleModel> _sales = [];
  String _query = '';
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadSales();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadSales({bool forceRefresh = false}) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final list = await _repository.getAll(forceRefresh: forceRefresh);
      if (!mounted) return;
      setState(() {
        _sales = list;
        _isLoading = false;
      });
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = e.message;
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _errorMessage = 'No se pudo conectar con el servidor';
        _isLoading = false;
      });
    }
  }

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

  void _onSearchChanged(String value) => setState(() => _query = value);

  Future<void> _openDetail(SaleModel sale) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SaleDetailScreen(sale: sale, role: widget.role),
      ),
    );
    if (!mounted) return;
    _loadSales(forceRefresh: true);
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
                onBack: widget.showBack
                    ? (widget.onBack ?? () => Navigator.pop(context))
                    : null,
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
              child: RefreshIndicator(
                color: DarkColors.naranjaBoton,
                backgroundColor: DarkColors.tarjeta,
                onRefresh: () => _loadSales(forceRefresh: true),
                child: _buildContent(items),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(List<SaleModel> items) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: DarkColors.naranjaBoton),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.cloud_off,
                size: 48,
                color: DarkColors.textoSuave,
              ),
              const SizedBox(height: 12),
              Text(
                _errorMessage!,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: DarkColors.textoSuave,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () => _loadSales(forceRefresh: true),
                icon: const Icon(Icons.refresh),
                label: const Text('Reintentar'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: DarkColors.naranjaBoton,
                  foregroundColor: const Color(0xFF1A1A1A),
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (items.isEmpty) {
      return Center(
        child: Text(
          _sales.isEmpty
              ? 'Aún no hay ventas registradas'
              : 'No se encontraron ventas',
          style: const TextStyle(color: DarkColors.textoSuave),
        ),
      );
    }

    return ListView.separated(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
      itemCount: items.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final sale = items[index];
        return SaleListCard(sale: sale, onTap: () => _openDetail(sale));
      },
    );
  }
}
