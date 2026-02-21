import 'package:flutter_test/flutter_test.dart';
import 'package:save_the_world_flutter_app/models/game.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/task.model.dart';
import 'package:save_the_world_flutter_app/models/addtask.model.dart';
import 'package:save_the_world_flutter_app/models/task_activation.modifier.dart';
import 'package:save_the_world_flutter_app/models/member.ressource.model.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Modifier Chain & Lifecycle Tests', () {
    late Game game;

    setUp(() {
      Game.mInstance = null;
      game = Game.getInstance();
      game.isLoading = true; // CRITICAL: Stop auto-loading from disk in tests
      Game.tasks.clear();
    });

    test('Complex progression: Task A disables itself and enables Task B', () {
      // Setup: Task B starts disabled and is not in the game yet
      final taskB = Task(name: "Follow-up Task", enabled: false);
      game.allTasks = [taskB]; // Put it in the global pool
      
      final taskA = Task(
        name: "Initial Task",
        enabled: true,
        modifier: [
          DisableTaskModifier(taskName: "Initial Task"),
          AddTask(task: "Follow-up Task"), // Fix: Pass String, not Task object
          EnableTaskModifier(taskName: "Follow-up Task"),
        ],
      );

      game.addTask(taskA);
      
      // Execute
      taskA.finished();

      expect(taskA.enabled, isFalse, reason: "Task A should be disabled");
      expect(Game.tasks.any((t) => t.name == "Follow-up Task"), isTrue, reason: "Task B should be added");
      
      final foundB = Game.tasks.firstWhere((t) => t.name == "Follow-up Task");
      expect(foundB.enabled, isTrue, reason: "Task B should be enabled");
    });
  });
}
