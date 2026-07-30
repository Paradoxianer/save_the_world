import 'package:flutter_test/flutter_test.dart';
import 'package:save_the_world_flutter_app/models/game.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/task.model.dart';
import 'package:save_the_world_flutter_app/models/weighted_random_event.model.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Ressourcengewichtete Zufallsevents (AddToRandom mit Schwelle)', () {
    late Game game;

    setUp(() {
      Game.mInstance = null;
      game = Game.getInstance();
      game.isLoading = true; // Blockiert automatische Datei-Operationen
      Game.tasks.clear();
      game.weightedRandomEvents.clear();
    });

    test('Feuert garantiert, wenn der Ressourcenwert die Schwelle erreicht',
        () {
      final wonder = Task(name: "Wunder");
      game.allTasks = [wonder];
      game.weightedRandomEvents["Wunder"] =
          const WeightedRandomEvent(resourceName: "Faith", threshold: 100.0);
      Game.ressources["Faith"]!.setValue(200.0); // deutlich über der Schwelle

      game.isLoading = false;
      game.updateGame(const Duration(seconds: 11));

      expect(Game.tasks.any((t) => t.name == "Wunder"), isTrue,
          reason: "chance wird auf 1.0 gedeckelt - muss also immer feuern.");
    });

    test('Feuert nie bei Ressourcenwert 0', () {
      final wonder = Task(name: "Wunder");
      game.allTasks = [wonder];
      game.weightedRandomEvents["Wunder"] =
          const WeightedRandomEvent(resourceName: "Faith", threshold: 100.0);
      Game.ressources["Faith"]!.setValue(0.0);

      game.isLoading = false;
      game.updateGame(const Duration(seconds: 11));

      expect(Game.tasks.any((t) => t.name == "Wunder"), isFalse);
    });

    test('Bereits aktive Events werden nicht erneut hinzugefügt', () {
      final wonder = Task(name: "Wunder");
      game.allTasks = [wonder];
      game.addTask(wonder);
      game.weightedRandomEvents["Wunder"] =
          const WeightedRandomEvent(resourceName: "Faith", threshold: 100.0);
      Game.ressources["Faith"]!.setValue(200.0);

      game.isLoading = false;
      game.updateGame(const Duration(seconds: 11));

      expect(Game.tasks.where((t) => t.name == "Wunder").length, 1);
    });

    test('initStage() leert weightedRandomEvents (stage-scoped, kein Carryover)',
        () {
      game.weightedRandomEvents["Wunder"] =
          const WeightedRandomEvent(resourceName: "Faith", threshold: 100.0);
      game.initStage(0);
      expect(game.weightedRandomEvents, isEmpty);
    });
  });
}
