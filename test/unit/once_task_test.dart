import 'package:flutter_test/flutter_test.dart';
import 'package:save_the_world_flutter_app/models/addtask.model.dart';
import 'package:save_the_world_flutter_app/models/game.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/task.model.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Einmal-Aufgaben (once) / Gatekeeper-Mechanik', () {
    late Game game;

    setUp(() {
      Game.mInstance = null;
      game = Game.getInstance();
      game.isLoading = true; // Blockiert automatische Datei-Operationen
      Game.tasks.clear();
      game.completedOnceTasks.clear();
    });

    test('Meilensteine sind automatisch Einmal-Aufgaben', () {
      final gatekeeper = Task(name: "Gatekeeper", isMilestone: true);
      expect(gatekeeper.once, isTrue);

      final normal = Task(name: "Normal");
      expect(normal.once, isFalse);

      // Explizites once überschreibt den Meilenstein-Default.
      final repeatableMilestone =
          Task(name: "Wiederholbar", isMilestone: true, once: false);
      expect(repeatableMilestone.once, isFalse);
    });

    test('Einmal-Aufgabe entfernt sich nach Abschluss selbst', () {
      final gatekeeper = Task(name: "Gatekeeper", isMilestone: true);
      game.allTasks = [gatekeeper];
      game.addTask(gatekeeper);

      expect(Game.tasks.any((t) => t.name == "Gatekeeper"), isTrue);

      gatekeeper.finished();

      expect(Game.tasks.any((t) => t.name == "Gatekeeper"), isFalse,
          reason: "Einmal-Aufgaben räumen sich nach Abschluss selbst auf.");
      expect(game.completedOnceTasks.contains("Gatekeeper"), isTrue);
    });

    test('Erledigte Einmal-Aufgabe wird durch AddTask NICHT wieder eingeblendet',
        () {
      final gatekeeper = Task(name: "Gatekeeper", isMilestone: true);
      final chainStarter = Task(
        name: "Chain-Starter",
        modifier: [AddTask(task: "Gatekeeper")],
      );
      game.allTasks = [gatekeeper, chainStarter];
      game.addTask(chainStarter);

      // 1. Durchlauf: Chain-Starter blendet den Gatekeeper ein.
      chainStarter.finished();
      expect(Game.tasks.any((t) => t.name == "Gatekeeper"), isTrue);

      // Gatekeeper wird abgeschlossen und verschwindet.
      gatekeeper.finished();
      expect(Game.tasks.any((t) => t.name == "Gatekeeper"), isFalse);

      // 2. Durchlauf: Chain-Starter darf den Gatekeeper NICHT erneut einblenden.
      chainStarter.finished();
      expect(Game.tasks.any((t) => t.name == "Gatekeeper"), isFalse,
          reason: "Ein erledigter Gatekeeper darf nie wieder auftauchen - "
              "auch wenn eine Chain ihn erneut anfordert.");
    });

    test('Wiederholbare Tasks bleiben von der Sperre unberührt', () {
      final normal = Task(name: "Kollekte");
      game.allTasks = [normal];
      game.addTask(normal);

      normal.finished();

      expect(Game.tasks.any((t) => t.name == "Kollekte"), isTrue,
          reason: "Normale Tasks bleiben nach Abschluss aktiv.");
    });

    test('Sperre überlebt Speichern & Laden (Game.json Roundtrip)', () {
      game.markOnceCompleted("Gatekeeper");

      final saved = game.toJson();

      Game.mInstance = null;
      final restored = Game.getInstance();
      restored.isLoading = true;
      restored.loadGame(
          '{"stage": 0, "completedOnceTasks": ["Gatekeeper"]}');

      expect(restored.completedOnceTasks.contains("Gatekeeper"), isTrue);
      expect(saved['completedOnceTasks'], contains("Gatekeeper"));
    });

    test('resetGame löscht die Einmal-Sperren', () {
      game.markOnceCompleted("Gatekeeper");
      game.resetGame();
      expect(game.completedOnceTasks, isEmpty);
    });
  });
}
