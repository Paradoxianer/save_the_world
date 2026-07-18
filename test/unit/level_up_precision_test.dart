import 'package:flutter_test/flutter_test.dart';
import 'package:save_the_world_flutter_app/models/game.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/member.ressource.model.dart';

/// Regression für einen gemeldeten Bug: Der Spieler sah "21" Mitglieder
/// (Stufe 0 -> 1 Schwelle ist 20), aber der Stufenaufstieg-Screen erschien
/// nicht. Ursache: viele kleine fraktionale Awards (0.5, 0.75, 0.9, ...)
/// akkumulieren Gleitkomma-Rundungsfehler, sodass der interne Wert z.B.
/// 20.999999999999996 statt exakt 21.0 ist. Die Anzeige rundet das zu "21",
/// aber `members.floor()` in levelListener() lieferte fälschlich 20.
///
/// Hinweis: Ressource.setValue() ruft notifyListeners() SYNCHRON auf, und
/// levelListener() hängt als Listener am Member-Resource. Das Setzen des
/// Werts allein löst den Stufenaufstieg also bereits aus - ein zusätzlicher
/// manueller Aufruf von levelListener() ist nicht nötig und würde die
/// Zwischen-Assertion nur verfälschen.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Stufenaufstieg: Gleitkomma-Präzision', () {
    late Game game;

    setUp(() {
      Game.mInstance = null;
      game = Game.getInstance();
      game.isLoading = false;
      Game.tasks.clear();
      game.stage = 0;
      Game.ressources[Member().name]?.max = double.maxFinite;
    });

    test('Stufenaufstieg löst aus, obwohl die Summe knapp unter der '
        'Ganzzahl-Schwelle liegt (Float-Drift)', () {
      // Reproduziert exakt die Situation aus dem Bugreport: nach vielen
      // kleinen Additionen (0.5, 0.75, 0.9, ...) landet der Wert praktisch,
      // aber nicht exakt bei 21.0. Dies ist der nächst-kleinere double-Wert
      // vor 21.0 - genau das Muster, das Gleitkomma-Rundungsfehler erzeugen.
      const double drifted = 20.999999999999996;
      expect(drifted, lessThan(21.0));
      expect(drifted, greaterThan(20.999));

      Game.ressources[Member().name]?.setValue(drifted);

      expect(game.stage, greaterThan(0),
          reason:
              'Bei einem Mitgliederwert knapp unter, aber praktisch bei 21 '
              '(Float-Drift) MUSS der Stufenaufstieg trotzdem auslösen - '
              'der Spieler sieht ja bereits "21" auf dem Bildschirm.');
    });

    test('Echte Zwischenwerte (z.B. 20.5) lösen KEINEN Stufenaufstieg aus',
        () {
      Game.ressources[Member().name]?.setValue(20.5);
      expect(game.stage, 0,
          reason: 'Bei 20.5 Mitgliedern ist die Schwelle von >20 noch nicht '
              'wirklich überschritten - kein vorzeitiger Aufstieg.');
    });

    test('Exakt 21.0 löst den Stufenaufstieg aus', () {
      Game.ressources[Member().name]?.setValue(21.0);
      expect(game.stage, greaterThan(0));
    });
  });
}
