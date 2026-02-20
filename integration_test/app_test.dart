import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:save_the_world_flutter_app/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Onboarding & First-Launch Flow', () {
    testWidgets('should display DSGVO, accept it, see story and enter game', 
      (WidgetTester tester) async {
        app.main();
        await tester.pumpAndSettle();

        // 1. DSGVO Dialog akzeptieren
        expect(find.text('AGB & DATENSCHUTZ'), findsOneWidget);
        final acceptBtn = find.byKey(const Key('dsgvo-accept-button'));
        expect(acceptBtn, findsOneWidget);
        await tester.tap(acceptBtn);
        await tester.pumpAndSettle();

        // 2. Story Intro sehen und fortfahren
        expect(find.text('DEIN RUF'), findsOneWidget);
        final continueBtn = find.byKey(const Key('onboarding-continue-button'));
        expect(continueBtn, findsOneWidget);
        await tester.tap(continueBtn);
        await tester.pumpAndSettle();

        // 3. Im Spiel ankommen
        expect(find.text('RETTE DIE WELT'), findsOneWidget);
        expect(find.text('AUFGABEN'), findsOneWidget);
    });
  });
}
