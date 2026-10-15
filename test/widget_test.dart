import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:app_ferreteria/main.dart';
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

  testWidgets('profile route shows user details', (tester) async {
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
}
