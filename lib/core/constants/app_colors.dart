import 'package:flutter/material.dart';

/// Colores compartidos por el tema general, Login y Perfil.
class AppColors {
  AppColors._();

  static const Color azul = Color(0xFF102A43);
  static const Color fondo = Color(0xFFF5F5F5);
  static const Color texto = Colors.black87;
  static const Color gris = Colors.grey;
  static const Color naranja = Color(0xFFFFA500);
}

/// Colores del tema oscuro del menú principal.
class DarkColors {
  DarkColors._();

  static const Color fondo = Color(0xFF0E1424);
  static const Color tarjeta = Color(0xFF1A2138);
  static const Color textoSuave = Color(0xFFA9B1C7);
  static const Color naranja = Color(0xFFFF8A1F);
  static const Color indicador = Color(0xFF4A3426);
  static const Color chip = Color(0xFF1B2559);

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
