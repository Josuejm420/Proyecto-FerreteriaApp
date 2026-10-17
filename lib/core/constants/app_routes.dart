import 'package:flutter/material.dart';

import '../../data/models/products_model.dart';
import '../../data/models/user_role.dart';
import '../../presentation/screens/Home/home_screen.dart';
import '../../presentation/screens/category/catalogs_screen.dart';
import '../../presentation/screens/login/login_screen.dart';
import '../../presentation/screens/profile/profile_screen.dart';
import '../../presentation/screens/products/product_detail_screen.dart';
import '../../presentation/screens/products/product_form_screen.dart';
import '../../presentation/screens/products/products_screen.dart';
import '../../presentation/screens/suppliers/suppliers_screen.dart';
import '../../presentation/screens/Clientes/clients_screen.dart';
import '../../presentation/screens/users/user_profile_screen.dart';
import '../../presentation/widgets/section_placeholder_screen.dart';

class AppRoutes {
  AppRoutes._();

  static const String root = '/';
  static const String login = '/login';
  static const String home = '/home';
  static const String profile = '/profile';
  static const String userProfile = UserProfileScreen.routeName;

  // Productos
  static const String products = '/products';
  static const String productDetail = '/product-detail';
  static const String productForm = '/product-form';

  // Otros módulos del menú principal
  static const String sales = '/sales';
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
    profile: (context) {
      final arguments = ModalRoute.of(context)?.settings.arguments;
      final role = arguments is UserRole ? arguments : UserRole.administrador;
      return ProfileScreen(userName: role.demoName, role: role);
    },
    userProfile: (context) => const UserProfileScreen(),

    // Módulo de Productos (Pantallas reales)
    products: (context) => const ProductsScreen(showBack: true),
    productDetail: (context) {
      final product =
          ModalRoute.of(context)!.settings.arguments as ProductsModel;
      return ProductDetailScreen(product: product);
    },
    productForm: (context) {
      // Sin argumentos = producto nuevo; con argumento = editar.
      final product =
          ModalRoute.of(context)?.settings.arguments as ProductsModel?;
      return ProductFormScreen(product: product);
    },

        // Módulo de Proveedores (Pantalla real)
        suppliers: (context) => const SuppliersScreen(showBack: true),

        // Módulo de Catálogos: categorías y presentaciones (Pantalla real)
        catalogs: (context) => const CatalogsScreen(showBack: true),

        // Placeholders para los demás módulos
        sales: (context) =>
            const SectionPlaceholderScreen(title: 'Ventas', emoji: '🧾'),
        clients: (context) =>
            const SectionPlaceholderScreen(title: 'Clientes', emoji: '👥'),
        purchases: (context) =>
            const SectionPlaceholderScreen(title: 'Compras', emoji: '🚚'),
        usersRoles: (context) =>
            const SectionPlaceholderScreen(title: 'Usuarios y roles', emoji: '🔐'),
        reports: (context) =>
            const SectionPlaceholderScreen(title: 'Reportes', emoji: '📊'),
      };
}
    // Módulo de Proveedores (Pantallas reales)
    suppliers: (context) => const SuppliersScreen(showBack: true),

    // Módulo de Clientes (Pantalla real)
    clients: (context) => const ClientsScreen(showBack: true),

    // Placeholders para los demás módulos
    sales: (context) =>
        const SectionPlaceholderScreen(title: 'Ventas', emoji: '🧾'),
    purchases: (context) =>
        const SectionPlaceholderScreen(title: 'Compras', emoji: '🚚'),
    catalogs: (context) =>
        const SectionPlaceholderScreen(title: 'Catálogos', emoji: '🏷️'),
    usersRoles: (context) =>
        const SectionPlaceholderScreen(title: 'Usuarios y roles', emoji: '🔐'),
    reports: (context) =>
        const SectionPlaceholderScreen(title: 'Reportes', emoji: '📊'),
  };
}
