import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:xelafy/pantallas/login.dart';

void main() {
  //group agrupa una seri de pruebas unitarias
  group("Probar los widgets de la app", () {
    ///El objetivo de una prueba de widget es verificar que la interfaz de
    ///usuario de cada widget se ve y se comporta como se espera. Básicamente,
    ///las pruebas se realizan volviendo a renderizar los widgets en código con datos simulados.

    testWidgets("Probar laos textForm Field en inicio de sesion",
        (WidgetTester tester) async {
      //encontrar todos los widgets necesarios
      final probarCorreoTextFormField = find.byKey(ValueKey("textFielCorreo"));
      final probarPassTextFormField = find.byKey(ValueKey("textFielPass"));

      //ejecutar la prueba real
      await tester.pumpWidget(MaterialApp(
        home: Login(),
      ));
      //probamos los text field
      await tester.enterText(
          probarCorreoTextFormField, "Probando textFiel Correo");
      await tester.enterText(probarPassTextFormField, "Probando textFiel pass");
      await tester.pump();

      //comprobar salidas
      expect(find.text("Probando textFiel Correo Electronico"), findsOneWidget);
      expect(find.text("Probando textFiel password"), findsOneWidget);
    });

    testWidgets("Probar boton del login", (WidgetTester tester) async {
      final boton = find.text("Ingresar");
      await tester.pumpWidget(MaterialApp(
        home: Login(),
      ));
      expect(boton, findsOneWidget);

      await tester.tap(boton);
      await tester.pump(); //reconstruye un widget

      expect(find.text("Ingresar"), findsOneWidget);
    });
  });
}
