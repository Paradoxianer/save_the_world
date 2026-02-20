import 'package:flutter_test/flutter_test.dart';
import 'package:save_the_world_flutter_app/models/game.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/addres.model.dart';
import 'package:save_the_world_flutter_app/models/addtask.model.dart';
import 'package:save_the_world_flutter_app/models/removetask.model.dart';
import 'package:save_the_world_flutter_app/models/task.model.dart';
import 'package:save_the_world_flutter_app/models/money.ressource.model.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Modifier System Tests', () {
    late Game game;

    setUp(() {
      Game.mInstance = null;
      game = Game.getInstance();
      game.isLoading = true; // Verhindert Plugin-Fehler (path_provider)
      Game.tasks.clear();
      game.allTasks = [Task(name: "New Mission")];
    });

    test('AddTask & RemoveTask Modifiers', () {
      const taskName = "New Mission";
      
      // Fix: AddTask erwartet String
      AddTask(task: taskName).modify();
      expect(Game.tasks.any((t) => t.name == taskName), isTrue);
      
      // Fix: RemoveTask Parameter heißt 'task'
      RemoveTask(task: taskName).modify();
      expect(Game.tasks.any((t) => t.name == taskName), isFalse);
    });

    test('AddRes Modifier should increase global resources', () {
      final money = Game.ressources["Money"]!;
      money.value = 10.0;
      AddRes(ressources: [Money(value: 50.0)]).modify();
      expect(money.value, 60.0);
    });
  });
}
