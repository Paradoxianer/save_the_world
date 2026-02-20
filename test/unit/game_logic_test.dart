import 'package:flutter_test/flutter_test.dart';
import 'package:save_the_world_flutter_app/models/addtask.model.dart';
import 'package:save_the_world_flutter_app/models/game.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/member.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/money.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/task.model.dart';
import 'package:save_the_world_flutter_app/models/task_activation.modifier.dart';

void main() {
  // Required for Ticker/AnimationController initialization in Game/Task models
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Comprehensive Game Logic Tests', () {
    late Game game;

    setUp(() {
      // Ensure we have a fresh game instance for each test
      Game.mInstance = null;
      game = Game.getInstance();
      game.isLoading = false; // Disable loading block for tests
    });

    test('Task Activation & Lock System', () {
      final task = Task(name: "LockedTask", enabled: false);
      game.addTask(task);
      
      expect(task.enabled, isFalse);
      
      // Simulate click attempt on disabled task
      task.start();
      expect(task.controller.isAnimating, isFalse, reason: "Disabled tasks should not start");
      
      // Enable via modifier
      EnableTaskModifier(taskName: "LockedTask").modify();
      expect(task.enabled, isTrue, reason: "Modifier should enable the task");
      
      // Disable again
      DisableTaskModifier(taskName: "LockedTask").modify();
      expect(task.enabled, isFalse);
    });

    test('Progression-Swap-Pattern (Stage 0 Simulation)', () {
      // Setup environment
      final initialTask = Task(
        name: "Hausbesuch (Tutorial)",
        award: [Member(value: 1.0)],
        modifier: [
          DisableTaskModifier(taskName: "Hausbesuch (Tutorial)"),
          AddTask(task: "Essen in meiner Wohnung"),
        ],
      );
      
      game.addTask(initialTask);
      expect(Game.tasks.any((t) => t.name == "Hausbesuch (Tutorial)"), isTrue);
      
      // Trigger completion
      initialTask.finished();
      
      expect(initialTask.enabled, isFalse, reason: "Tutorial version should be disabled");
      expect(Game.tasks.any((t) => t.name == "Essen in meiner Wohnung"), isTrue, reason: "Next task should be added");
    });

    test('Smart Award Calculation (Multiplier Integration)', () {
      final memberRes = Game.ressources["Member"]!;
      memberRes.value = 10.0;
      
      final dynamicTask = Task(
        name: "Kollekte",
        award: [
          Money(value: 2.0, multiplierResourceName: "Member", multiplierValue: 0.5)
        ]
      );
      
      // Value: 2.0 (base) * 10.0 (members) * 0.5 (multiplier) = 10.0
      expect(dynamicTask.award.first.value, 10.0);
      
      // Grow members
      memberRes.value = 100.0;
      // Value: 2.0 * 100.0 * 0.5 = 100.0
      expect(dynamicTask.award.first.value, 100.0, reason: "Award must update when dependency grows");
    });

    test('Resource Constraint Integrity', () {
      final money = Game.ressources["Money"]!;
      money.min = 0.0;
      money.max = 100.0;
      money.value = 50.0;
      
      // Test Add
      money.add(Money(value: 60.0));
      expect(money.value, 100.0, reason: "Should respect maximum");
      
      // Test Subtract
      money.subtract(Money(value: 110.0));
      expect(money.value, 0.0, reason: "Should respect minimum");
    });

    test('Level-Up Logic & Sync', () {
      final memberRes = Game.ressources["Member"]!;
      game.stage = 0;
      memberRes.value = 5.0;
      
      // Level 1 threshold is 20 (based on globals.dart)
      memberRes.value = 21.0;
      game.levelListener();
      
      expect(game.stage, greaterThan(0), reason: "Exceeding threshold should trigger level up");
      expect(Game.ressources["Stage"]?.value, game.stage.toDouble(), reason: "Stage resource must stay in sync");
    });

    test('Task Affordability Logic', () {
      final task = Task(
        name: "ExpensiveTask",
        cost: [Money(value: 100.0)],
      );
      
      Game.ressources["Money"]?.value = 50.0;
      
      // Manual afford check (logic from TaskItem)
      bool canAfford(Task t) {
        for (var cost in t.cost) {
          final res = Game.ressources[cost.name];
          if (res == null || !res.canSubtract(cost)) return false;
        }
        return true;
      }
      
      expect(canAfford(task), isFalse, reason: "Cannot start task without enough funds");
      
      Game.ressources["Money"]?.value = 150.0;
      expect(canAfford(task), isTrue);
    });
   group('Persistence Tests', () {
      test('Game JSON round-trip consistency', () {
        Game.mInstance = null;
        final g = Game.getInstance();
        g.stage = 3;
        g.recordClick();
        
        final jsonStr = json.encode(g.toJson());
        final data = json.decode(jsonStr) as Map<String, dynamic>;
        
        expect(data['stage'], 3);
        expect(data['stageClicks'], 1);
      });
    });
  });
}
