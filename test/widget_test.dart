import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:app_ferreteria/main.dart';

void main() {
  testWidgets(
    'login button opens home without requiring credentials',
    (tester) async {
      await tester.pumpWidget(const FerreteriaApp());

      expect(find.text('Bienvenido'), findsOneWidget);
      expect(find.text('Correo electrónico'), findsOneWidget);
      expect(find.text('Contraseña'), findsOneWidget);

      final passwordTextField = find.descendant(
        of: find.byType(TextFormField).at(1),
        matching: find.byType(TextField),
      );
      expect(tester.widget<TextField>(passwordTextField).obscureText, isTrue);

      await tester.tap(find.byTooltip('Mostrar contraseña'));
      await tester.pump();

      expect(tester.widget<TextField>(passwordTextField).obscureText, isFalse);

      await tester.tap(find.text('Iniciar sesión'));
      await tester.pumpAndSettle();

      expect(find.text('Don Toño - Admin'), findsOneWidget);
      expect(find.text('Métricas del sistema'), findsOneWidget);
      expect(find.text('Productos en inventario'), findsOneWidget);
    },
  );
}
