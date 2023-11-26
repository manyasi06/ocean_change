// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ocean_change/screens/login_screen.dart';
import 'package:ocean_change/widgets/map/export_csv_screen.dart';


void main() {

  testWidgets("TestLoginWidget", (widgetTester) async  {

    await widgetTester.pumpWidget(const MaterialApp(
      home: Material(
        child : LoginScreen()
      )
    ));

    final title = find.text('Ocean Change');
    expect(title.description, 'text "Ocean Change"');

  });

  testWidgets("TestCsvButton", (widgetTester) async{
    await widgetTester.pumpWidget(const MaterialApp(
        home: Material(
          child: ExportCsvScreen(),
        ),
    ));

    final checkbox =find.byType(Checkbox);
    expect(checkbox, findsOneWidget);

    final button = find.byType(ElevatedButton);
    expect(button, findsOneWidget);
  });
}
