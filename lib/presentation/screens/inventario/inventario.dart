import 'package:flutter/material.dart';
void main() => runApp(const MaterialApp(home: InventarioApp(), debugShowCheckedModeBanner: false));
// -----------------------------------------------------------
// 1. MODELO DE PRODUCTO
// -----------------------------------------------------------
class Producto {
  String nombre, subtitulo, estado;
  int stock;
  double precio;
  IconData icono;
  bool proximo;
  Producto(this.nombre, this.subtitulo, this.stock, this.precio, this.estado, this.icono, [this.proximo = false]);
}
// -----------------------------------------------------------
// 2. PANTALLA PRINCIPAL: INVENTARIO
// -----------------------------------------------------------
class InventarioApp extends StatefulWidget {
  const InventarioApp({super.key});
  @override
  State<InventarioApp> createState() => _InventarioAppState();
}
class _InventarioAppState extends State<InventarioApp> {
  int _tab = 1; // 1 = Pestaña Inventario
  String _filtro = 'Todo';
  String _busqueda = '';
  final Color _azul = const Color(0xFF0D253F);
  // Lista de productos
  final List<Producto> _productos = [
    Producto('Martillo Neumático', 'Stock: 12', 12, 150.0, 'Suficiente', Icons.construction),
    Producto('Cable Eléctrico Pro', 'Stock: 20', 20, 150.0, 'Suficiente', Icons.cable),
    Producto('Cemento 42.5kg', 'Stock: 25', 25, 150.0, 'Suficiente', Icons.inventory_2, true),
    Producto('Tornillo madera 3"', 'Stock: 13', 13, 210.0, 'Suficiente', Icons.hardware),
    Producto('Pintura Látex Pro', 'Stock: 1', 1, 150.0, 'Crítico', Icons.format_paint, true),
  ];
    // Diálogo simple para agregar producto
  void _mostrarDialogoAgregar() {
    final nombreCtrl = TextEditingController();
    final stockCtrl = TextEditingController();
    final precioCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Nuevo Producto'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nombreCtrl, decoration: const InputDecoration(labelText: 'Nombre')),
            TextField(controller: stockCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Stock')),
            TextField(controller: precioCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Precio (C\$)')),
          ],
        ),
         actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancelar')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: _azul),
            onPressed: () {
              if (nombreCtrl.text.isNotEmpty) {
                final stock = int.tryParse(stockCtrl.text) ?? 0;
                setState(() {
                  _productos.add(Producto(
                    nombreCtrl.text,
                    'Stock: $stock',
                    stock,
                    double.tryParse(precioCtrl.text) ?? 0.0,
                    stock <= 5 ? 'Crítico' : 'Suficiente',
                    Icons.handyman,
                  ));
                });
                  Navigator.pop(ctx);
              }
            },
            child: const Text('Guardar', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
    @override
  Widget build(BuildContext context) {
    // Filtrado de productos
    final listaFiltrada = _productos.where((p) {
      final coincide = p.nombre.toLowerCase().contains(_busqueda.toLowerCase());
      if (_filtro == 'Stock Bajo') return coincide && p.estado == 'Crítico';
      if (_filtro == 'Próximo Vencimiento') return coincide && p.proximo;
      return coincide;
    }).toList();
    final titulos = ['Inicio', 'Inventario', 'Facturación', 'Reportes', 'Más'];
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F9),
      appBar: AppBar(
        backgroundColor: _azul,
        leading: const Icon(Icons.menu, color: Colors.white),
        title: Text(titulos[_tab], style: const TextStyle(color: Colors.white)),
      ),
       body: _tab != 1
          ? Center(child: Text('Pantalla de ${titulos[_tab]}', style: const TextStyle(fontSize: 18, color: Colors.grey)))
          : Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  // 1. Buscador
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                    child: TextField(
                      onChanged: (v) => setState(() => _busqueda = v),
                      decoration: const InputDecoration(
                        icon: Icon(Icons.search, color: Colors.grey),
                        hintText: 'Buscar producto',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),