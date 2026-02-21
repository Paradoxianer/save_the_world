import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:save_the_world_flutter_app/main.dart' as app;
import 'package:save_the_world_flutter_app/models/game.ressource.model.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Onboarding & First Stage Progression', () {
    testWidgets('Complete Onboarding and arrive at Stage 1', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // 1. DSGVO Dialog
      bool dialogFound = false;
      for (int i = 0; i < 10; i++) {
        await tester.pump(const Duration(milliseconds: 500));
        if (find.text('AGB & DATENSCHUTZ').evaluate().isNotEmpty) {
          dialogFound = true;
          break;
        }
      }
      expect(dialogFound, isTrue);
      await tester.tap(find.byKey(const Key('dsgvo-accept-button')));
      await tester.pumpAndSettle();

      // 2. Story Intro
      expect(find.text('DEIN RUF'), findsOneWidget);
      await tester.tap(find.byKey(const Key('onboarding-continue-button')));
      await tester.pumpAndSettle();

      // 3. Hauptbildschirm
      expect(find.text('RETTE DIE WELT'), findsOneWidget);
      expect(find.text('LVL 0'), findsOneWidget);

      // 4. Stufenaufstieg simulieren
      final memberRes = Game.ressources['Member'];
      if (memberRes != null) {
        memberRes.value = 21.0; // Überschreitet Threshold für LVL 1
      }
      
      // Dem Game-Loop Zeit geben, den Level-Up zu triggern
      await tester.pump(const Duration(seconds: 1));
      await tester.pumpAndSettle();

      // 5. Celebration Dialog bestätigen
      expect(find.text('GRATULATION!'), findsOneWidget);
      await tester.tap(find.text('WEITER DIENEN'));
      await tester.pumpAndSettle();

      // 6. Verifikation: Wir sind in LVL 1
      expect(find.text('LVL 1'), findsOneWidget);
    });
  });
}
