import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:my_app/main.dart';

void main() {
  testWidgets('Smoke test de Oliva y Pimienta', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MiApp());

    // 0. Navegar a la pantalla de Login desde la Home
    await tester.tap(find.text('Entrar'));
    await tester.pumpAndSettle();

    // 1. Llenar el formulario de Login
    await tester.enterText(
      find.byType(TextFormField).at(0),
      'usuario@test.com',
    );
    await tester.enterText(find.byType(TextFormField).at(1), '123456');

    // 2. Presionar el botón de Iniciar Sesión
    await tester.tap(find.text('Iniciar Sesión'));

    // 3. Esperar a que la animación de transición termine
    await tester.pumpAndSettle();

    // Verificar que el título de la App Bar aparece
    expect(find.text('Oliva y Pimienta'), findsWidgets);

    // Verificar que existe al menos una sección (ej. Entradas)
    expect(find.text('Entradas'), findsOneWidget);

    // Verificar que el botón de pedido está presente
    expect(find.text('Mi pedido'), findsOneWidget);

    // Simular un toque en el plato "Bruschetta"
    await tester.tap(find.text('Bruschetta'));
    await tester
        .pumpAndSettle(); // Esperar a que termine la animación del SnackBar

    // Verificar que aparece el mensaje de confirmación
    expect(find.text('Seleccionaste Bruschetta'), findsOneWidget);
  });
}
