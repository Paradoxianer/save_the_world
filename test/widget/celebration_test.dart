import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:save_the_world_flutter_app/widgets/celebration_dialog.dart';

void main() {
  testWidgets('CelebrationDialog displays stage and statistics correctly', (WidgetTester tester) async {
    // Build the dialog
    await tester.pumpWidget(const MaterialApp(
      home: Scaffold(
        body: CelebrationDialog(
          stage: 2,
          duration: Duration(minutes: 1, seconds: 30),
          clicks: 45,
          score: 850,
        ),
      ),
    ));

    // Wait for the Fade/Scale transition to complete
    await tester.pump(const Duration(milliseconds: 500));

    // Verify Title and Stage
    expect(find.text('GRATULATION!'), findsOneWidget);
    expect(find.text('2'), findsOneWidget);
    
    // Verify Stats
    expect(find.text('1m 30s'), findsOneWidget);
    expect(find.text('45'), findsOneWidget);
    expect(find.text('850'), findsOneWidget);

    // Verify Button
    expect(find.text('WEITER DIENEN'), findsOneWidget);
  });
}
