import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:app_ferreteria/main.dart';
import 'package:app_ferreteria/presentation/screens/Home/home_screen.dart';
import 'package:app_ferreteria/presentation/screens/login/login_screen.dart';

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
}
