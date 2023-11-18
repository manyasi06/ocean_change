import 'package:flutter/material.dart';
import 'package:ocean_change/screens/login_screen.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
    testWidgets('Should find 3 elevated button widgets', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: Material(
          child:LoginScreen()),
      ),
    );
    expect(find.byType(ElevatedButton), findsNWidgets(3));
    });
}