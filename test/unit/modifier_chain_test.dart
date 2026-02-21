import 'package:flutter_test/flutter_test.dart';
import 'package:save_the_world_flutter_app/models/game.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/task.model.dart';
import 'package:save_the_world_flutter_app/models/addtask.model.dart';
import 'package:save_the_world_flutter_app/models/task_activation.modifier.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Modifier Chain & Lifecycle Tests', () {
    late Game game;

    setUp(() {
      Game.mInstance = null;
      game = Game.getInstance();
      game.isLoading = true; // Blockiert automatische Datei-Operationen
      Game.tasks.clear();
    });

    test('Complex progression: Task A disables itself and enables Task B', () {
      // 1. Erstelle Task B (startet deaktiviert)
      final taskB = Task(name: "Follow-up Task", enabled: false);
      
      // 2. Erstelle Task A (mit Modifikatoren)
      final taskA = Task(
        name: "Initial Task",
        enabled: true,
        modifier: [
          DisableTaskModifier(taskName: "Initial Task"),
          AddTask(task: "Follow-up Task"),
          EnableTaskModifier(taskName: "Follow-up Task"),
        ],
      );

      // 3. WICHTIG: Registriere beide Instanzen im globalen Pool, 
      // damit die Modifier genau diese Objekte finden und verändern.
      game.allTasks = [taskA, taskB];
      
      // Task A zum aktiven Spiel hinzufügen
      game.addTask(taskA);
      
      // 4. Aktion: Task A wird abgeschlossen
      taskA.finished();

      // 5. Assertions
      expect(taskA.enabled, isFalse, reason: "Task A sollte durch den DisableTaskModifier deaktiviert worden sein");
      expect(Game.tasks.any((t) => t.name == "Follow-up Task"), isTrue, reason: "Task B sollte durch AddTask hinzugefügt worden sein");
      
      final foundB = Game.tasks.firstWhere((t) => t.name == "Follow-up Task");
      expect(foundB.enabled, isTrue, reason: "Task B sollte durch EnableTaskModifier aktiviert worden sein");
    });
  });
}
