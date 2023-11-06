import 'package:flutter/material.dart';
import 'package:ocean_change/screens/create_account_screen.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Create Account Screen', () {
    testWidgets('Should find 1 elevated button widgets', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: Material(
            child: CreateAccountScreen()),
      ),
      );
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('Should find text in popup on weak password entry', (WidgetTester tester) async {
      const testKey1 = Key('email_field');
      const testKey2 = Key('password_field');
      await tester.pumpWidget(const MaterialApp(
        home: Material(
          child: CreateAccountScreen()),
      ),
      );
      await tester.enterText(find.byKey(testKey1), 'test@test.com');
      await tester.enterText(find.byKey(testKey2), 'abcdefgh');
      await tester.tap(find.byType(ElevatedButton));
      print('Button Pressed');
      await tester.pump(const Duration(seconds: 1));

      expect(find.text("Password Requirements:\n"
          "- Must be at least 8 characters long\n"
          "- Must contain uppercase and lowercase letters\n"
          "- Must contain at least one digit (0-9)\n"
          "- Must contain at least one special character [ !@#\$%^&*(),.?\":{}|<> ]"), findsOneWidget);
    });
  });
}