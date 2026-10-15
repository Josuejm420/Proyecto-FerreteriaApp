import 'package:flutter/material.dart';

import 'core/constants/app_colors.dart';
import 'presentation/screens/home/home_screen.dart';
import 'presentation/screens/login/login_screen.dart';
<<<<<<< HEAD
import 'presentation/screens/users/user_profile_screen.dart';
=======
import 'presentation/screens/Home/home_screen.dart';
>>>>>>> 1655f88 (Actualiza login e implementa pantalla Home)

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
      initialRoute: LoginScreen.routeName,
      routes: {
        '/': (context) => const LoginScreen(),
        LoginScreen.routeName: (context) => const LoginScreen(),
        HomeScreen.routeName: (context) => const HomeScreen(),
<<<<<<< HEAD
        UserProfileScreen.routeName: (context) => const UserProfileScreen(),
=======
>>>>>>> 1655f88 (Actualiza login e implementa pantalla Home)
      },
    );
  }
}
