import 'package:flutter/material.dart';

import '../../data/models/user_role.dart';
import '../../presentation/screens/Home/home_screen.dart';
import '../../presentation/screens/login/login_screen.dart';
import '../../presentation/widgets/section_placeholder_screen.dart';
import '../../presentation/screens/Home/home_screen.dart';
import '../../presentation/screens/login/login_screen.dart';
import '../../presentation/screens/Home/widgets/section_placeholder_screen.dart';
import '../../presentation/screens/users/user_profile_screen.dart';

class AppRoutes {
  AppRoutes._();

  static const String root = '/';
  static const String login = '/login';
  static const String home = '/home';

  // Módulos del menú principal
  static const String sales = '/sales';
  static const String products = '/products';
  static const String clients = '/clients';
  static const String purchases = '/purchases';
  static const String suppliers = '/suppliers';
  static const String catalogs = '/catalogs';
  static const String usersRoles = '/users-roles';
  static const String reports = '/reports';

  static Map<String, WidgetBuilder> get routes => {
    root: (context) => const LoginScreen(),
    login: (context) => const LoginScreen(),
    home: (context) {
      final arguments = ModalRoute.of(context)?.settings.arguments;
      final role = arguments is UserRole ? arguments : UserRole.administrador;
      return HomeScreen(userName: role.demoName, role: role);
    },

    // Cuando crees cada pantalla real, reemplaza el placeholder.
    sales: (context) =>
        const SectionPlaceholderScreen(title: 'Ventas', emoji: '🧾'),
    products: (context) =>
        const SectionPlaceholderScreen(title: 'Productos', emoji: '📦'),
    clients: (context) =>
        const SectionPlaceholderScreen(title: 'Clientes', emoji: '👥'),
    purchases: (context) =>
        const SectionPlaceholderScreen(title: 'Compras', emoji: '🚚'),
    suppliers: (context) =>
        const SectionPlaceholderScreen(title: 'Proveedores', emoji: '🏭'),
    catalogs: (context) =>
        const SectionPlaceholderScreen(title: 'Catálogos', emoji: '🏷️'),
    usersRoles: (context) =>
        const SectionPlaceholderScreen(title: 'Usuarios y roles', emoji: '🔐'),
    reports: (context) =>
        const SectionPlaceholderScreen(title: 'Reportes', emoji: '📊'),
  };
}
        root: (context) => const LoginScreen(),
        login: (context) => const LoginScreen(),
        home: (context) => const HomeScreen(),
        UserProfileScreen.routeName: (context) => const UserProfileScreen(),

        // Cuando crees cada pantalla real, reemplaza el placeholder.
        sales: (context) =>
            const SectionPlaceholderScreen(title: 'Ventas', emoji: '🧾'),
        products: (context) =>
            const SectionPlaceholderScreen(title: 'Productos', emoji: '📦'),
        clients: (context) =>
            const SectionPlaceholderScreen(title: 'Clientes', emoji: '👥'),
        purchases: (context) =>
            const SectionPlaceholderScreen(title: 'Compras', emoji: '🚚'),
        suppliers: (context) =>
            const SectionPlaceholderScreen(title: 'Proveedores', emoji: '🏭'),
        catalogs: (context) =>
            const SectionPlaceholderScreen(title: 'Catálogos', emoji: '🏷️'),
        usersRoles: (context) => const SectionPlaceholderScreen(
            title: 'Usuarios y roles', emoji: '🔐'),
        reports: (context) =>
            const SectionPlaceholderScreen(title: 'Reportes', emoji: '📊'),
      };
}
