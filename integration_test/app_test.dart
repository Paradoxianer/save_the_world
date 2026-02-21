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

      // 1. DSGVO Dialog (Warte bis zu 5 Sek)
      bool dialogFound = false;
      for (int i = 0; i < 10; i++) {
        await tester.pump(const Duration(milliseconds: 500));
        if (find.text('AGB & DATENSCHUTZ').evaluate().isNotEmpty) {
          dialogFound = true;
          break;
        }
      }
      expect(dialogFound, isTrue, reason: "DSGVO Dialog nicht erschienen");
      await tester.tap(find.byKey(const Key('dsgvo-accept-button')));
      await tester.pumpAndSettle();

      // 2. Story Intro wegklicken
      expect(find.text('DEIN RUF'), findsOneWidget);
      await tester.tap(find.byKey(const Key('onboarding-continue-button')));
      await tester.pumpAndSettle();

      // 3. Im Spiel: Startzustand prüfen
      expect(find.text('RETTE DIE WELT'), findsOneWidget);
      expect(find.text('LVL 0'), findsOneWidget); 
      
      // 4. Stufenaufstieg simulieren (Stage 0 -> 1)
      final memberRes = Game.ressources['Member'];
      if (memberRes != null) {
        memberRes.value = 21.0; // Threshold für Stage 1 ist 20
      }
      
      // Dem Game-Loop Zeit geben, den Level-Up zu bemerken (kein pumpAndSettle wegen Ticker!)
      await tester.pump(const Duration(seconds: 1));
      await tester.pump(const Duration(seconds: 1));

      // 5. Celebration Dialog bestätigen
      expect(find.text('GRATULATION!'), findsOneWidget);
      await tester.tap(find.text('WEITER DIENEN'));
      
      // Zeit zum Ausfaden geben
      await tester.pump(const Duration(seconds: 1));
      await tester.pump(const Duration(seconds: 1));

      // 6. Verifikation: Wir sind in LVL 1 (Anzeige im StageItem)
      expect(find.text('LVL 1'), findsOneWidget);
    });
  });
}
