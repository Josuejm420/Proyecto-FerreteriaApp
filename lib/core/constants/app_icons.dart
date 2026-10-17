import 'package:flutter/material.dart';

/// Íconos planos (estilo "outlined") de toda la app.
/// Si quieres cambiar un ícono en TODAS las pantallas, solo lo cambias aquí.
/// Se usa así: Icon(AppIcons.clientes)
class AppIcons {
  AppIcons._();

  // Módulos del menú principal
  static const IconData inicio = Icons.home_outlined;
  static const IconData ventas = Icons.receipt_long_outlined;
  static const IconData productos = Icons.inventory_2_outlined;
  static const IconData perfil = Icons.person_outline;
  static const IconData clientes = Icons.people_outline;
  static const IconData compras = Icons.local_shipping_outlined;
  static const IconData proveedores = Icons.storefront_outlined;
  static const IconData catalogos = Icons.sell_outlined;
  static const IconData usuarios = Icons.admin_panel_settings_outlined;
  static const IconData reportes = Icons.assessment_outlined;

  // Acciones comunes
  static const IconData buscar = Icons.search;
  static const IconData limpiar = Icons.close;
  static const IconData agregar = Icons.add;
  static const IconData volver = Icons.arrow_back;
}
