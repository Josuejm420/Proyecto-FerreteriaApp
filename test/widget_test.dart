import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:app_ferreteria/main.dart';
import 'package:app_ferreteria/presentation/screens/home/home_screen.dart';
import 'package:app_ferreteria/presentation/screens/login/login_screen.dart';
import 'package:app_ferreteria/presentation/screens/users/user_profile_screen.dart';

void main() {
  testWidgets(
    'login validates fields and allows toggling password visibility',
    (tester) async {
      await tester.pumpWidget(const FerreteriaApp());

      expect(find.text('Bienvenido'), findsOneWidget);
      expect(find.text('Correo electrónico'), findsOneWidget);
      expect(find.text('Contraseña'), findsOneWidget);

      await tester.tap(find.text('Iniciar sesión'));
      await tester.pump();

      expect(find.text('Ingresa tu correo electrónico'), findsOneWidget);
      expect(find.text('Ingresa tu contraseña'), findsOneWidget);

      await tester.enterText(
        find.byType(TextFormField).at(0),
        'persona@ejemplo.com',
      );
      await tester.enterText(find.byType(TextFormField).at(1), 'clave123');

      final passwordTextField = find.descendant(
        of: find.byType(TextFormField).at(1),
        matching: find.byType(TextField),
      );
      expect(tester.widget<TextField>(passwordTextField).obscureText, isTrue);

      await tester.tap(find.byTooltip('Mostrar contraseña'));
      await tester.pump();

      expect(tester.widget<TextField>(passwordTextField).obscureText, isFalse);

      await tester.tap(find.text('Iniciar sesión'));
      await tester.pump();

      expect(
        find.text(
          'Formulario válido. Falta conectar el servicio de autenticación.',
        ),
        findsOneWidget,
      );
    },
  );

  testWidgets('profile route displays name, address, email, and role', (
    tester,
  ) async {
    await tester.pumpWidget(const FerreteriaApp());

    await Navigator.of(
      tester.element(find.byType(LoginScreen)),
    ).pushNamed(UserProfileScreen.routeName);
    await tester.pumpAndSettle();

    expect(find.text('Perfil de usuario'), findsOneWidget);
    expect(find.text('Nombre'), findsOneWidget);
    expect(find.text('Dirección'), findsOneWidget);
    expect(find.text('Correo electrónico'), findsOneWidget);
    expect(find.text('Rol'), findsOneWidget);
    expect(find.text('Usuario'), findsOneWidget);
  });

  testWidgets('home route displays KPI dashboard and navigation', (
    tester,
  ) async {
    await tester.pumpWidget(const FerreteriaApp());

    await Navigator.of(
      tester.element(find.byType(LoginScreen)),
    ).pushNamed(HomeScreen.routeName);
    await tester.pumpAndSettle();

    expect(find.byType(HomeScreen), findsOneWidget);
    expect(find.text('Resumen de indicadores'), findsOneWidget);
    expect(
      find.text('Variación de ventas por cliente, descompuesta en causas'),
      findsOneWidget,
    );
    expect(find.byType(NavigationBar), findsOneWidget);
    expect(find.byIcon(Icons.menu), findsOneWidget);
  });

  testWidgets('home navigation switches to the products KPI section', (
    tester,
  ) async {
    await tester.pumpWidget(const FerreteriaApp());

    await Navigator.of(
      tester.element(find.byType(LoginScreen)),
    ).pushNamed(HomeScreen.routeName);
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.inventory_2_outlined));
    await tester.pumpAndSettle();

    expect(find.text('Indicadores de productos'), findsOneWidget);
    expect(
      find.text('Margen bruto y variación del margen descompuesta'),
      findsOneWidget,
    );
    expect(find.text('Efectividad del descuento'), findsNothing);
  });

  testWidgets('home drawer navigates to the discounts KPI section', (
    tester,
  ) async {
    await tester.pumpWidget(const FerreteriaApp());

    await Navigator.of(
      tester.element(find.byType(LoginScreen)),
    ).pushNamed(HomeScreen.routeName);
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.menu));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Descuentos y vendedores'));
    await tester.pumpAndSettle();

    expect(find.text('Descuentos y vendedores'), findsOneWidget);
    expect(find.text('Efectividad del descuento'), findsOneWidget);
    expect(find.text('Matriz ABC de ventas frente a margen'), findsNothing);
  });
}
