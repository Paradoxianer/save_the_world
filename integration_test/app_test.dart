import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:save_the_world_flutter_app/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Onboarding & First-Launch Flow', () {
    testWidgets('should display DSGVO dialog, accept it, and show the main screen', 
      (WidgetTester tester) async {
        // Start the app
        app.main();
        await tester.pumpAndSettle();

        // 1. Verify DSGVO / Onboarding dialog appears automatically
        expect(find.text('Willkommen bei Save the World!'), findsOneWidget, 
          reason: "Onboarding dialog should appear on first launch.");
        expect(find.byKey(const Key('privacy-checkbox')), findsOneWidget);

        // 2. Interact with the dialog
        await tester.tap(find.byKey(const Key('privacy-checkbox')));
        await tester.pumpAndSettle();

        // 3. Find and tap the continue button
        final continueButton = find.byKey(const Key('onboarding-continue-button'));
        expect(continueButton, findsOneWidget);
        await tester.tap(continueButton);
        await tester.pumpAndSettle();

        // 4. Verify Story-Intro appears
        expect(find.text('Unsere Mission'), findsOneWidget, 
          reason: "Story intro should follow the DSGVO dialog.");
        final gotItButton = find.byKey(const Key('onboarding-continue-button'));
        await tester.tap(gotItButton);
        await tester.pumpAndSettle();

        // 5. Verify the main app screen is now visible
        expect(find.text('RETTE DIE WELT'), findsOneWidget);
        expect(find.text('AUFGABEN'), findsOneWidget);
        expect(find.text('STUFEN'), findsOneWidget);
    });
  });
}
