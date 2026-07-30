import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:save_the_world_flutter_app/data_manager.dart';
import 'package:save_the_world_flutter_app/models/game.ressource.model.dart';

/// Ersetzt echte Datei-/Plugin-Zugriffe durch fest verdrahtete JSON-Antworten,
/// damit loadState() kontrolliert mit einem präparierten (kaputten)
/// Spielstand getestet werden kann.
class _FakeDataManager extends DataManager {
  final Map<String, String?> data;
  _FakeDataManager(this.data);

  @override
  Future<String?> readData(String fileName) async => data[fileName];

  @override
  Future<void> writeJson(String fileName, String jsonString) async {}
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Stufenaufstieg-Nachholung bei fehlerhaftem/alten Spielstand', () {
    tearDown(() {
      Game.mInstance?.dispose();
      Game.mInstance = null;
    });

    test('loadState() korrigiert eine Stage, die nicht mehr zur '
        'gespeicherten Mitgliederzahl passt', () async {
      Game.mInstance = null;
      final game = Game.getInstance();

      // Simuliert exakt den Bug aus dem Screenshot: Ein (z.B. durch einen
      // früheren Fehler) gespeicherter Stand zeigt Stage 0, obwohl die
      // gespeicherte Mitgliederzahl (24.3) die Stage-0-Schwelle (20) längst
      // überschritten hat.
      final resJson = json.encode({
        'Member': {'value': 24.3, 'min': 1.0, 'max': 20.0},
      });
      final gameJson = json.encode({'stage': 0});

      game.dataManager = _FakeDataManager({
        'gameRes': resJson,
        'allTasks': null,
        'Game': gameJson,
      });

      await game.loadState();

      expect(game.isLoading, isFalse);
      expect(
        game.stage,
        greaterThan(0),
        reason: 'Ein gespeicherter Stand mit Member=24.3 aber Stage=0 muss '
            'beim Laden nachträglich korrigiert werden - sonst bleibt der '
            'Spieler dauerhaft in der falschen Stage haengen, selbst nachdem '
            'der Stufenaufstieg-Bug fuer NEUE Faelle laengst gefixt ist.',
      );
    });

    test('loadState() lässt einen konsistenten Spielstand unangetastet', () async {
      Game.mInstance = null;
      final game = Game.getInstance();

      final resJson = json.encode({
        'Member': {'value': 15.0, 'min': 1.0, 'max': 20.0},
      });
      final gameJson = json.encode({'stage': 0});

      game.dataManager = _FakeDataManager({
        'gameRes': resJson,
        'allTasks': null,
        'Game': gameJson,
      });

      await game.loadState();

      expect(game.stage, 0,
          reason: 'Ein konsistenter Stand (Member unter der Schwelle) darf '
              'nicht faelschlich vorzeitig aufsteigen.');
    });
  });
}
