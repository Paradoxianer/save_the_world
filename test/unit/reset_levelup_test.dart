import 'package:flutter_test/flutter_test.dart';
import 'package:save_the_world_flutter_app/models/game.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/member.ressource.model.dart';

/// Regression für einen vom Nutzer gemeldeten Bug: Nach Drücken des
/// "Reset"-Buttons (resetGame()) blieb der Stufenaufstieg für den Rest der
/// Sitzung komplett aus, egal wie hoch die Mitgliederzahl stieg.
///
/// Ursache: initRes() ERSETZT das Member-Ressourcen-Objekt durch eine neue
/// Instanz. Der levelListener war aber nur EINMAL im Konstruktor an das
/// ursprüngliche Objekt angehängt - nach resetGame() (das initRes() erneut
/// aufruft) hing der Listener am verworfenen alten Objekt und feuerte nie
/// wieder.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Stufenaufstieg nach resetGame() / jumpToStage()', () {
    tearDown(() {
      Game.mInstance?.dispose();
      Game.mInstance = null;
    });

    test('Stufenaufstieg funktioniert nach resetGame() weiterhin', () {
      Game.mInstance = null;
      final game = Game.getInstance();
      game.isLoading = false;

      game.resetGame();
      expect(game.stage, 0, reason: 'Vorbedingung: Reset landet in Stage 0.');

      // Simuliert normales Spielen NACH dem Reset: Mitglieder wachsen über
      // die Stage-0-Schwelle (20) hinaus.
      Game.ressources[Member().name]?.setValue(25.0);

      expect(
        game.stage,
        greaterThan(0),
        reason: 'Nach einem Reset muss der Stufenaufstieg weiterhin '
            'auslösen, sobald die Mitgliederzahl die Schwelle übersteigt - '
            'sonst bleibt der Spieler für den Rest der Sitzung in Stage 0 '
            'hängen, egal wie hoch die Mitgliederzahl steigt.',
      );
    });

    test('Stufenaufstieg funktioniert nach jumpToStage() weiterhin', () {
      Game.mInstance = null;
      final game = Game.getInstance();
      game.isLoading = false;

      game.jumpToStage(2);
      expect(game.stage, 2, reason: 'Vorbedingung: Sprung nach Stage 2.');

      // Mitgliederzahl über die Stage-2-Schwelle (80) hinaus wachsen lassen.
      Game.ressources[Member().name]?.setValue(85.0);

      expect(
        game.stage,
        greaterThan(2),
        reason: 'Auch nach jumpToStage() muss der Stufenaufstieg-Listener '
            'weiterhin am aktuellen Member-Objekt hängen.',
      );
    });
  });
}
