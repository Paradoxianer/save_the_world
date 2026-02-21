import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:save_the_world_flutter_app/main.dart' as app;
import 'package:save_the_world_flutter_app/models/game.ressource.model.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Onboarding & First Stage Progression', () {
    
    setUp(() {
      Game.resetInstance();
    });

    tearDown(() async {
      // Dem Framework Zeit geben, auslaufende Ticks zu verarbeiten
      await ImageCache().clear(); 
      Game.resetInstance();
    });

    testWidgets('Complete Onboarding and arrive at Stage 1', (WidgetTester tester) async {
      app.main();
      
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pump(const Duration(milliseconds: 500));

      // 1. DSGVO Dialog
      final acceptButton = find.byKey(const Key('dsgvo-accept-button'));
      bool dialogFound = false;
      for (int i = 0; i < 20; i++) {
        await tester.pump(const Duration(milliseconds: 200));
        if (acceptButton.evaluate().isNotEmpty) {
          dialogFound = true;
          break;
        }
      }
      expect(dialogFound, isTrue, reason: "DSGVO Dialog nicht erschienen");
      await tester.tap(acceptButton);
      await tester.pump(const Duration(milliseconds: 500));

      // 2. Story Intro
      final continueButton = find.byKey(const Key('onboarding-continue-button'));
      expect(continueButton, findsOneWidget);
      await tester.tap(continueButton);
      await tester.pump(const Duration(milliseconds: 500));

      // 3. Im Spiel: Startzustand prüfen
      expect(find.text('RETTE DIE WELT'), findsOneWidget);
      expect(find.text('LVL 0'), findsOneWidget); 
      
      // 4. Stufenaufstieg simulieren
      final memberRes = Game.ressources['Member'];
      if (memberRes != null) {
        memberRes.value = 21.0; 
      }
      
      // Zeit für Level-Up Animationen
      for(int i=0; i<5; i++) {
        await tester.pump(const Duration(milliseconds: 500));
      }

      // 5. Celebration Dialog bestätigen
      expect(find.text('GRATULATION!'), findsOneWidget);
      
      final celebButton = find.byKey(const Key('celebration-continue-button'));
      expect(celebButton, findsOneWidget);
      
      await tester.tap(celebButton, warnIfMissed: false);
      
      // Dialog-Ausblendung abwarten
      for(int i=0; i<5; i++) {
        await tester.pump(const Duration(milliseconds: 500));
      }

      // 6. Verifikation: Wir sind in LVL 1
      expect(find.text('LVL 1'), findsOneWidget);
      
      // Finaler Pump um sicherzustellen, dass keine Animationen mehr in der Queue sind
      await tester.pump(const Duration(seconds: 1));
    });
  });
}
