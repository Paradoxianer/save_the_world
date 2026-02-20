import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:save_the_world_flutter_app/models/money.ressource.model.dart';
import 'package:save_the_world_flutter_app/widgets/ressource.item.dart';

void main() {
  group('RessourceItem Widget Tests', () {
    testWidgets('RessourceItem displays initial value', (WidgetTester tester) async {
      final money = Money(value: 50.0);
      
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: RessourceItem(money),
        ),
      ));

      expect(find.text('50'), findsOneWidget);
    });

    testWidgets('RessourceItem updates text and triggers feedback on value change', (WidgetTester tester) async {
      final money = Money(value: 100.0);
      
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: RessourceItem(money),
        ),
      ));

      expect(find.text('100'), findsOneWidget);

      // Change value
      money.value = 150.0;
      
      // Rebuild and wait for animations
      await tester.pump(); 
      expect(find.text('150'), findsOneWidget);

      // Check for floating feedback text (contains "+50")
      // Since it's in an Overlay, we need to pump and check
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.text('+50'), findsOneWidget);
    });

    testWidgets('RessourceItem shows red feedback for subtraction', (WidgetTester tester) async {
      final money = Money(value: 100.0);
      
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: RessourceItem(money),
        ),
      ));

      money.value = 80.0;
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('20'), findsOneWidget); // The diff is 20
      
      final feedbackText = tester.widget<Text>(find.text('20'));
      expect(feedbackText.style?.color, Colors.red);
    });
  });
}
