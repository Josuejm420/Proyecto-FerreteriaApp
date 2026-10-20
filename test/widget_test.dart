import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:app_ferreteria/main.dart';
import 'package:app_ferreteria/core/constants/app_routes.dart';
import 'package:app_ferreteria/data/models/products_model.dart';
import 'package:app_ferreteria/data/models/user_role.dart';
import 'package:app_ferreteria/presentation/screens/Home/home_screen.dart';
import 'package:app_ferreteria/presentation/screens/login/login_screen.dart';
import 'package:app_ferreteria/presentation/screens/profile/profile_screen.dart';
import 'package:app_ferreteria/presentation/screens/products/product_detail_screen.dart';
import 'package:app_ferreteria/presentation/screens/products/product_form_screen.dart';
import 'package:app_ferreteria/presentation/screens/products/products_screen.dart';
import 'package:app_ferreteria/presentation/screens/products/widgets/product_list_card.dart';
import 'package:app_ferreteria/presentation/screens/users/user_profile_screen.dart';

void main() {
  testWidgets('login authenticates and opens the Home dashboard', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(800, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const FerreteriaApp());

    expect(find.byType(LoginScreen), findsOneWidget);
    expect(find.text('Ferretería Don Toño'), findsOneWidget);
    expect(find.text('Correo electrónico'), findsOneWidget);
    expect(find.text('Contraseña'), findsOneWidget);

    final passwordField = find.descendant(
      of: find.byType(TextFormField).at(1),
      matching: find.byType(TextField),
    );
    expect(tester.widget<TextField>(passwordField).obscureText, isTrue);
    await tester.tap(find.byTooltip('Mostrar contraseña'));
    await tester.pump();
    expect(tester.widget<TextField>(passwordField).obscureText, isFalse);

    await tester.ensureVisible(find.text('Iniciar sesión'));
    await tester.tap(find.text('Iniciar sesión'));
    await tester.pumpAndSettle();

    expect(find.byType(HomeScreen), findsOneWidget);
    expect(find.text('Don Antonio Ruiz'), findsOneWidget);
    expect(find.byType(NavigationBar), findsOneWidget);
  });

  testWidgets('profile route is registered', (tester) async {
    await tester.pumpWidget(const FerreteriaApp());

    Navigator.of(
      tester.element(find.byType(LoginScreen)),
    ).pushNamed(UserProfileScreen.routeName);
    await tester.pumpAndSettle();

    expect(find.text('Perfil de usuario'), findsOneWidget);
    expect(find.text('Nombre'), findsOneWidget);
    expect(find.text('Dirección'), findsOneWidget);
    expect(find.text('Correo electrónico'), findsOneWidget);
    expect(find.text('Rol'), findsOneWidget);
  });

  testWidgets('Home profile tab displays the complete profile screen', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(800, 1200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const FerreteriaApp());
    Navigator.of(
      tester.element(find.byType(LoginScreen)),
    ).pushNamed(HomeScreen.routeName);
    await tester.pumpAndSettle();

    await tester.tap(find.text('Perfil'));
    await tester.pumpAndSettle();

    expect(find.byType(ProfileScreen), findsOneWidget);
    expect(find.text('Mi cuenta'), findsOneWidget);
    expect(find.text('Mis datos'), findsOneWidget);
  });

  testWidgets('Home products tab displays the product catalog', (tester) async {
    tester.view.physicalSize = const Size(800, 1200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const FerreteriaApp());
    Navigator.of(
      tester.element(find.byType(LoginScreen)),
    ).pushNamed(HomeScreen.routeName);
    await tester.pumpAndSettle();

    await tester.tap(
      find.descendant(
        of: find.byType(NavigationBar),
        matching: find.text('Productos'),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(ProductsScreen), findsOneWidget);
    expect(find.text('Taladro eléctrico 600W'), findsOneWidget);
  });

  testWidgets('products can be created, edited, deactivated and activated', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(800, 1200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const FerreteriaApp());
    Navigator.of(
      tester.element(find.byType(LoginScreen)),
    ).pushNamed(HomeScreen.routeName);
    await tester.pumpAndSettle();
    await tester.tap(
      find.descendant(
        of: find.byType(NavigationBar),
        matching: find.text('Productos'),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Nuevo producto'));
    await tester.pumpAndSettle();
    expect(find.byType(ProductFormScreen), findsOneWidget);
    expect(
      tester
          .widget<TextFormField>(find.byType(TextFormField).first)
          .controller
          ?.text,
      isEmpty,
    );

    const createdName = 'Producto widget nuevo';
    await tester.enterText(find.byType(TextFormField).first, createdName);
    await tester.tap(find.byType(DropdownButtonFormField<String>).first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Pinturas').last);
    await tester.pumpAndSettle();
    await tester.tap(
      find.byType(DropdownButtonFormField<ProductPresentation>).first,
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Unidad (unidad)').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Guardar'));
    await tester.pumpAndSettle();

    expect(find.byType(ProductsScreen), findsOneWidget);
    expect(find.text(createdName), findsOneWidget);
    expect(find.text('Producto creado correctamente'), findsOneWidget);
    expect(find.text('Producto widget nuevo'), findsOneWidget);

    await tester.tap(find.text(createdName));
    await tester.pumpAndSettle();
    expect(find.byType(ProductDetailScreen), findsOneWidget);
    await tester.ensureVisible(find.text('Editar'));
    await tester.tap(find.text('Editar'));
    await tester.pumpAndSettle();

    expect(find.byType(ProductFormScreen), findsOneWidget);
    final nameField = tester.widget<TextFormField>(
      find.byType(TextFormField).first,
    );
    expect(nameField.controller?.text, createdName);
    const updatedName = 'Producto widget editado';
    await tester.enterText(find.byType(TextFormField).first, updatedName);
    await tester.tap(find.text('Guardar'));
    await tester.pumpAndSettle();
    expect(find.byType(ProductDetailScreen), findsOneWidget);
    expect(find.text(updatedName), findsOneWidget);

    await tester.ensureVisible(find.text('Desactivar'));
    await tester.tap(find.text('Desactivar'));
    await tester.pumpAndSettle();
    expect(find.text('¿Quieres desactivar este producto?'), findsOneWidget);
    await tester.tap(
      find.descendant(
        of: find.byType(AlertDialog),
        matching: find.text('Desactivar'),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('● Inactivo'), findsOneWidget);

    Navigator.of(tester.element(find.byType(ProductDetailScreen))).pop();
    await tester.pumpAndSettle();
    final productsScreen = find.byType(ProductsScreen);
    expect(
      find.descendant(of: productsScreen, matching: find.text(updatedName)),
      findsOneWidget,
    );
    final productCard = find.ancestor(
      of: find.text(updatedName),
      matching: find.byType(ProductListCard),
    );
    expect(
      find.descendant(of: productCard, matching: find.text('● Inactivo')),
      findsOneWidget,
    );

    await tester.tap(
      find.descendant(of: productsScreen, matching: find.text(updatedName)),
    );
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Activar'));
    await tester.tap(find.text('Activar'));
    await tester.pumpAndSettle();
    expect(find.text('¿Quieres activar este producto?'), findsOneWidget);
    await tester.tap(
      find.descendant(
        of: find.byType(AlertDialog),
        matching: find.text('Activar'),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('● Activo'), findsOneWidget);
  });

  testWidgets('enhanced profile route receives the selected role', (
    tester,
  ) async {
    await tester.pumpWidget(const FerreteriaApp());

    Navigator.of(
      tester.element(find.byType(LoginScreen)),
    ).pushNamed(AppRoutes.profile, arguments: UserRole.empleado);
    await tester.pumpAndSettle();

    expect(find.text('Juan Pérez'), findsOneWidget);
    expect(find.text('Empleado'), findsOneWidget);
  });

  testWidgets('product detail route falls back safely without arguments', (
    tester,
  ) async {
    await tester.pumpWidget(const FerreteriaApp());

    Navigator.of(
      tester.element(find.byType(LoginScreen)),
    ).pushNamed(AppRoutes.productDetail);
    await tester.pumpAndSettle();

    expect(find.byType(ProductsScreen), findsOneWidget);
  });
}
