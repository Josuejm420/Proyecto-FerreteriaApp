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