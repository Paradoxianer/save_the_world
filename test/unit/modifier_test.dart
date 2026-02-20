import 'package:flutter_test/flutter_test.dart';
import 'package:save_the_world_flutter_app/models/game.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/addres.model.dart';
import 'package:save_the_world_flutter_app/models/subtractres.model.dart';
import 'package:save_the_world_flutter_app/models/addtask.model.dart';
import 'package:save_the_world_flutter_app/models/removetask.model.dart';
import 'package:save_the_world_flutter_app/models/addmodifier.model.dart';
import 'package:save_the_world_flutter_app/models/task.model.dart';
import 'package:save_the_world_flutter_app/models/money.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/member.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/task_activation.modifier.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Modifier System Tests', () {
    late Game game;

    setUp(() {
      Game.mInstance = null;
      game = Game.getInstance();
      game.isLoading = false;
      Game.tasks.clear();
    });

    test('AddRes Modifier should increase global resources', () {
      final money = Game.ressources["Money"]!;
      money.value = 10.0;
      
      final modifier = AddRes(ressources: [Money(value: 50.0)]);
      modifier.modify();
      
      expect(money.value, 60.0);
    });

    test('SubtractRes Modifier should decrease global resources', () {
      final money = Game.ressources["Money"]!;
      money.value = 100.0;
      
      final modifier = SubtractRes(ressources: [Money(value: 40.0)]);
      modifier.modify();
      
      expect(money.value, 60.0);
    });

    test('AddTask & RemoveTask Modifiers', () {
      final newTask = Task(name: "New Mission");
      
      // Add
      AddTask(task: newTask).modify();
      expect(Game.tasks.any((t) => t.name == "New Mission"), isTrue);
      
      // Remove
      RemoveTask(taskName: "New Mission").modify();
      expect(Game.tasks.any((t) => t.name == "New Mission"), isFalse);
    });

    test('Nested Modifiers: AddModifier should attach logic to tasks', () {
      final targetTask = Task(name: "Target");
      game.addTask(targetTask);
      
      final nestedModifier = EnableTaskModifier(taskName: "AnotherTask");
      final adder = AddModifer(task: "Target", modifier: [nestedModifier]);
      
      adder.modify();
      
      expect(targetTask.myModifier.contains(nestedModifier), isTrue, 
          reason: "Modifier should be added to the target task's modifier list");
    });

    test('Chain Reaction: Task completion triggers modifiers', () {
      final resultMoney = Game.ressources["Money"]!;
      resultMoney.value = 0.0;

      final task = Task(
        name: "ChainTask",
        modifier: [AddRes(ressources: [Money(value: 100.0)])]
      );
      
      task.finished(); // Simulates animation end
      
      expect(resultMoney.value, 100.0, reason: "Task finish should execute its modifiers");
    });
  });
}
