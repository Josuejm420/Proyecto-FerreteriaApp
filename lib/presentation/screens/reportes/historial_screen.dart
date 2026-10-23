import 'package:flutter/material.dart';

const Color _azulOscuro = Color(0xFF102A43);
const Color _amarillo = Color(0xFFF2B705); 
const Color _fondo = Color(0xFFF5F6FA);

class _Operacion {
  final String numero;
  final DateTime fecha;
  final String tercero; // Cliente (venta) o Proveedor (compra)
  final double total;
  final String estado;
  final List<_Linea> lineas;

  const _Operacion({
    required this.numero,
    required this.fecha,
    required this.tercero,
    required this.total,
    required this.estado,
    required this.lineas,
  });
}

class _Linea {
  final String producto;
  final int cantidad;
  final double precio;

  const _Linea(this.producto, this.cantidad, this.precio);
}

final List<_Operacion> _ventasDemo = [
  _Operacion(
    numero: '001',
    fecha: DateTime(2026, 9, 30),
    tercero: 'Cliente General',
    total: 2450,
    estado: 'Completada',
    lineas: const [
      _Linea('Martillo 16 oz', 2, 350),
      _Linea('Caja de clavos 2"', 5, 150),
      _Linea('Cinta métrica 5 m', 4, 250),
    ],
  ),
  _Operacion(
    numero: '002',
    fecha: DateTime(2026, 9, 29),
    tercero: 'Juan Pérez',
    total: 5800,
    estado: 'Completada',
    lineas: const [
      _Linea('Taladro eléctrico', 1, 3800),
      _Linea('Juego de brocas', 2, 1000),
    ],
  ),
  _Operacion(
    numero: '003',
    fecha: DateTime(2026, 9, 28),
    tercero: 'María López',
    total: 1250,
    estado: 'Completada',
    lineas: const [
      _Linea('Pintura blanca 1 gal', 1, 850),
      _Linea('Brocha 3"', 2, 200),
    ],
  ),
];

final List<_Operacion> _comprasDemo = [
  _Operacion(
    numero: '001',
    fecha: DateTime(2026, 9, 30),
    tercero: 'Distribuidora Central',
    total: 8500,
    estado: 'Recibida',
    lineas: const [
      _Linea('Cemento 42.5 kg', 50, 150),
      _Linea('Varilla 3/8"', 20, 50),
    ],
  ),
  _Operacion(
    numero: '002',
    fecha: DateTime(2026, 9, 27),
    tercero: 'Ferretería Nacional',
    total: 12300,
    estado: 'Recibida',
    lineas: const [
      _Linea('Taladro eléctrico', 3, 2800),
      _Linea('Juego de brocas', 6, 650),
    ],
  ),
  _Operacion(
    numero: '003',
    fecha: DateTime(2026, 9, 25),
    tercero: 'Comercial ABC',
    total: 6750,
    estado: 'Recibida',
    lineas: const [
      _Linea('Pintura blanca 1 gal', 10, 450),
      _Linea('Brocha 3"', 15, 150),
    ],
  ),
];

class HistorialScreen extends StatefulWidget {
  const HistorialScreen({super.key});

  @override
  State<HistorialScreen> createState() => _HistorialScreenState();
}

class _HistorialScreenState extends State<HistorialScreen> {
  bool _verVentas = true; // true = Ventas, false = Compras
  String _busqueda = '';
  DateTimeRange? _rangoFechas;

  List<_Operacion> get _fuente => _verVentas ? _ventasDemo : _comprasDemo;

  List<_Operacion> get _filtradas {
    final q = _busqueda.trim().toLowerCase();
    return _fuente.where((op) {
      final coincideTexto = q.isEmpty ||
          op.tercero.toLowerCase().contains(q) ||
          op.numero.contains(q);

      final coincideFecha = _rangoFechas == null ||
          (!_soloFecha(op.fecha).isBefore(_soloFecha(_rangoFechas!.start)) &&
              !_soloFecha(op.fecha).isAfter(_soloFecha(_rangoFechas!.end)));

      return coincideTexto && coincideFecha;
    }).toList();
  }

  DateTime _soloFecha(DateTime d) => DateTime(d.year, d.month, d.day);

  Future<void> _elegirRango() async {
    final rango = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      initialDateRange: _rangoFechas,
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary: _azulOscuro,
            onPrimary: Colors.white,
          ),
        ),
        child: child!,
      ),
    );
    if (rango != null) setState(() => _rangoFechas = rango);
  }

  @override
  Widget build(BuildContext context) {
    final operaciones = _filtradas;

    return Scaffold(
      backgroundColor: _fondo,
      appBar: AppBar(
        backgroundColor: _azulOscuro,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Historial',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Historial de operaciones',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: _azulOscuro,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Consulta las ventas y compras realizadas',
            style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 16),
          _buildSelector(),
          const SizedBox(height: 12),
          _buildBusqueda(),
          const SizedBox(height: 8),
          _buildFiltroFecha(),
          const SizedBox(height: 8),
          if (operaciones.isEmpty)
            _buildVacio()
          else
            ...operaciones.map(_buildTarjeta),
        ],
      ),
    );
  }

  Widget _buildSelector() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: _decoracionTarjeta(),
      child: Row(
        children: [
          _botonSelector('Ventas', true),
          _botonSelector('Compras', false),
        ],
      ),
    );
  }

  Widget _botonSelector(String texto, bool esVentas) {
    final activo = _verVentas == esVentas;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _verVentas = esVentas),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: activo ? _azulOscuro : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          alignment: Alignment.center,
          child: Text(
            texto,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: activo ? _amarillo : _azulOscuro,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBusqueda() {
    return Container(
      decoration: _decoracionTarjeta(),
      child: TextField(
        onChanged: (v) => setState(() => _busqueda = v),
        decoration: InputDecoration(
          hintText: _verVentas
              ? 'Buscar por cliente o número de venta'
              : 'Buscar por proveedor o número de compra',
          hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 14),
          prefixIcon: const Icon(Icons.search, color: _azulOscuro),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }

  Widget _buildFiltroFecha() {
    final rango = _rangoFechas;
    return Row(
      children: [
        ActionChip(
          backgroundColor: Colors.white,
          side: BorderSide(color: Colors.grey.shade300),
          avatar: const Icon(Icons.date_range, size: 18, color: _azulOscuro),
          label: Text(
            rango == null
                ? 'Filtrar por fecha'
                : '${_formatoFecha(rango.start)} - ${_formatoFecha(rango.end)}',
            style: const TextStyle(color: _azulOscuro, fontSize: 13),
          ),
          onPressed: _elegirRango,
        ),
        if (rango != null)
          IconButton(
            tooltip: 'Quitar filtro',
            icon: const Icon(Icons.close, color: _azulOscuro),
            onPressed: () => setState(() => _rangoFechas = null),
          ),
      ],
    );
  }

  Widget _buildTarjeta(_Operacion op) {
    final etiqueta = _verVentas ? 'Venta' : 'Compra';
    final terceroLabel = _verVentas ? 'Cliente' : 'Proveedor';

    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 4),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => _mostrarDetalle(op),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: _decoracionTarjeta(),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: _amarillo.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    _verVentas ? Icons.point_of_sale : Icons.local_shipping,
                    color: _azulOscuro,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$etiqueta #${op.numero}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: _azulOscuro,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '$terceroLabel: ${op.tercero}',
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _formatoFecha(op.fecha),
                        style: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      _formatoMoneda(op.total),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: _azulOscuro,
                      ),
                    ),
                    const SizedBox(height: 6),
                    _chipEstado(op.estado),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _chipEstado(String estado) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        estado,
        style: TextStyle(
          color: Colors.green.shade700,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildVacio() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Column(
        children: [
          Icon(Icons.search_off, size: 48, color: Colors.grey.shade400),
          const SizedBox(height: 8),
          Text(
            'No se encontraron operaciones',
            style: TextStyle(color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

 
  void _mostrarDetalle(_Operacion op) {
    final etiqueta = _verVentas ? 'Venta' : 'Compra';
    final terceroLabel = _verVentas ? 'Cliente' : 'Proveedor';

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              '$etiqueta #${op.numero}',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: _azulOscuro,
              ),
            ),
            const SizedBox(height: 12),
            _filaDetalle('Fecha', _formatoFecha(op.fecha)),
            _filaDetalle(terceroLabel, op.tercero),
            _filaDetalle('Estado', op.estado),
            const Divider(height: 24),
            const Text(
              'Productos',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: _azulOscuro,
              ),
            ),
            const SizedBox(height: 8),
            ...op.lineas.map(
              (l) => _filaDetalle(
                '${l.cantidad} x ${l.producto}',
                _formatoMoneda(l.cantidad * l.precio),
              ),
            ),
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: _azulOscuro,
                  ),
                ),
                Text(
                  _formatoMoneda(op.total),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: _azulOscuro,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _azulOscuro,
                  foregroundColor: _amarillo,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () => Navigator.pop(context),
                child: const Text('Cerrar'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _filaDetalle(String titulo, String valor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(
              titulo,
              style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            valor,
            style: const TextStyle(
              color: _azulOscuro,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  // ----- Utilidades -----
  BoxDecoration _decoracionTarjeta() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.06),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }

  String _formatoFecha(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/'
      '${d.month.toString().padLeft(2, '0')}/${d.year}';

  String _formatoMoneda(double valor) {
    final entero = valor.round().toString();
    final conComas = entero.replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (_) => ',',
    );
    return 'C\$ $conComas';
  }
}
