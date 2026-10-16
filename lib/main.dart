import 'package:flutter/material.dart';

import 'core/constants/app_routes.dart';
import 'core/constants/app_colors.dart';
import 'core/constants/app_routes.dart';

void main() {
  runApp(const FerreteriaApp());
}

class FerreteriaApp extends StatelessWidget {
  const FerreteriaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ferretería',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.azul,
          primary: AppColors.azul,
          surface: AppColors.fondo,
        ),
        scaffoldBackgroundColor: Colors.white,
        useMaterial3: true,
      ),
      initialRoute: AppRoutes.login,
      routes: AppRoutes.routes,
    );
  }
}
