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
      game.isLoading = true; 
      Game.tasks.clear();
    });

    test('Complex progression: Task A disables itself and enables Task B', () {
      final taskB = Task(name: "Follow-up Task", enabled: false);
      final taskA = Task(
        name: "Initial Task",
        enabled: true,
        modifier: [
          DisableTaskModifier(taskName: "Initial Task"),
          AddTask(task: "Follow-up Task"),
          EnableTaskModifier(taskName: "Follow-up Task"),
        ],
      );

      // WICHTIG: Beide Tasks müssen im globalen Pool sein, damit Modifier sie finden
      game.allTasks = [taskA, taskB];
      game.addTask(taskA);
      
      taskA.finished();

      expect(taskA.enabled, isFalse, reason: "Task A sollte sich selbst deaktiviert haben");
      expect(Game.tasks.any((t) => t.name == "Follow-up Task"), isTrue, reason: "Task B sollte hinzugefügt worden sein");
      
      final foundB = Game.tasks.firstWhere((t) => t.name == "Follow-up Task");
      expect(foundB.enabled, isTrue, reason: "Task B sollte aktiviert worden sein");
    });
  });
}
