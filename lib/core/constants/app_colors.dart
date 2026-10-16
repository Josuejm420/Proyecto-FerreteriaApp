import 'package:flutter/material.dart';

class AppColors {
  static const Color azul = Color(0xFF102A43);
  static const Color fondo = Color(0xFFF5F5F5);
  static const Color texto = Colors.black87;
  static const Color gris = Colors.grey;
  static const Color naranja = Color(0xFFE65100);
  static const Color rojo = Color(0xFFD32F2F);
}

/// Colores del tema oscuro (menú principal y login).
class DarkColors {
  DarkColors._();

  static const Color fondo = Color(0xFF0E1424);
  static const Color tarjeta = Color(0xFF1A2138);
  static const Color textoSuave = Color(0xFFA9B1C7);
  static const Color naranja = Color(0xFFFF8A1F);
  static const Color naranjaBoton = Color(0xFFF5A524);
  static const Color indicador = Color(0xFF4A3426);
  static const Color chip = Color(0xFF1B2559);

  // Login
  static const Color campo = Color(0xFF161C33);
  static const Color borde = Color(0xFF2A3358);
  static const Color selectorFondo = Color(0xFF111729);
  static const Color selectorActivo = Color(0xFF1F2F6E);

  static const List<Color> degradadoLogin = [
    Color(0xFF1B2A6B),
    Color(0xFF2B3F8F),
    Color(0xFF5A5A85),
    Color(0xFF7B6560),
  ];
  static const List<double> stopsLogin = [0.0, 0.35, 0.7, 1.0];

  static const List<Color> degradadoHeader = [
    Color(0xFF1B2A6B),
    Color(0xFF2B3F8F),
  ];
  static const List<Color> degradadoStat = [
    Color(0xFF22337A),
    Color(0xFF2F4DA3),
  ];
  static const List<Color> degradadoBienvenida = [
    Color(0xFFF5A524),
    Color(0xFFFF7A18),
  ];
}