import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const Color azul = Color(0xFF102A43);
  static const Color fondo = Color(0xFFF5F5F5);
  static const Color texto = Colors.black87;
  static const Color gris = Colors.grey;
  static const Color naranja = Color(0xFFE65100);
  static const Color rojo = Color(0xFFD32F2F);
}

class DarkColors {
  DarkColors._();

  // Superficies y fondos generales
  static const Color fondo = Color(0xFF0E1424);
  static const Color tarjeta = Color(0xFF1A2138);
  static const Color textoSuave = Color(0xFFA9B1C7);
  static const Color naranja = Color(0xFFFF8A1F);
  static const Color naranjaBoton = Color(0xFFF5A524);
  static const Color indicador = Color(0xFF4A3426);
  static const Color chip = Color(0xFF1B2559);
  static const Color campo = Color(0xFF161C33);
  static const Color borde = Color(0xFF2A3358);
  static const Color selectorFondo = Color(0xFF111729);
  static const Color selectorActivo = Color(0xFF1F2F6E);
  static const Color rojo = Color(0xFFD64545);
  static const Color avisoFondo = Color(0xFF3A2D22);

  // Productos (Estados y Acentos)
  static const Color activo = Color(0xFF4CD08A);
  static const Color activoFondo = Color(0xFF1E3A2F);
  static const Color inactivo = Color(0xFFFF6B6B);
  static const Color inactivoFondo = Color(0xFF3D2024);
  static const Color checkAzul = Color(0xFF5BA4E6);

  static const List<Color> acentosProducto = [
    Color(0xFFF5A524),
    Color(0xFF3B82F6),
    Color(0xFF22A55B),
    Color(0xFFA855F7),
  ];
  
  static const List<Color> fondosIconoProducto = [
    Color(0xFF4A3F35),
    Color(0xFF1F3156),
    Color(0xFF1B3B3F),
    Color(0xFF2E2A52),
  ];

  // Gradientes
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
  
  static const List<Color> degradadoPerfil = [
    Color(0xFF2B3F8F),
    Color(0xFF4A4FC4),
    Color(0xFF6A4FC4),
  ];
}