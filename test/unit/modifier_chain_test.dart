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
      game.isLoading = false;
      Game.tasks.clear();
    });

    test('Complex progression: Task A disables itself and enables Task B', () {
      final taskB = Task(name: "Follow-up Task", enabled: false);
      final taskA = Task(
        name: "Initial Task",
        modifier: [
          DisableTaskModifier(taskName: "Initial Task"),
          AddTask(task: taskB),
          EnableTaskModifier(taskName: "Follow-up Task"),
        ],
      );

      game.addTask(taskA);
      
      // Execute Task A
      taskA.finished();

      expect(taskA.enabled, isFalse, reason: "Task A should have disabled itself");
      expect(Game.tasks.any((t) => t.name == "Follow-up Task"), isTrue, reason: "Task B should have been added");
      
      final foundB = Game.tasks.firstWhere((t) => t.name == "Follow-up Task");
      expect(foundB.enabled, isTrue, reason: "Task B should have been enabled by the modifier");
    });

    test('Resource-triggered Stage Transition Logic', () {
      // Simulate Stage 0
      game.stage = 0;
      final memberRes = Game.ressources[Member().name]!;
      memberRes.value = 10.0;
      
      // Trigger level listener manually (threshold for level 1 is 20)
      memberRes.add(Member(value: 15.0));
      game.levelListener();

      expect(game.stage, 1, reason: "Member count > 20 should trigger stage 1");
      expect(Game.ressources["Stage"]?.value, 1.0);
    });
  });
}
