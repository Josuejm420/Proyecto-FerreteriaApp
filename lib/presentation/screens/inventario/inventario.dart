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
  