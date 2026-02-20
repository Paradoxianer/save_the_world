import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:save_the_world_flutter_app/models/addtask.model.dart';
import 'package:save_the_world_flutter_app/models/game.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/task.model.dart';
import 'package:save_the_world_flutter_app/models/task_activation.modifier.dart';

void main() {
  // Mock für Path Provider, damit keine MissingPluginException fliegt
  TestWidgetsFlutterBinding.ensureInitialized();
  const MethodChannel('plugins.flutter.io/path_provider').setMockMethodCallHandler((methodCall) async => ".");

  group('Comprehensive Game Logic Tests', () {
    late Game game;

    setUp(() {
      Game.mInstance = null;
      game = Game.getInstance();
      game.isLoading = true; // Verhindert automatische Datei-Operationen während des Tests
      Game.tasks.clear();
      game.allTasks = [];
    });

    test('Task Activation & Pool System', () {
      final task = Task(name: "LockedTask", enabled: false);
      game.allTasks = [task];
      game.addTask(task);
      
      expect(task.enabled, isFalse);
      EnableTaskModifier(taskName: "LockedTask").modify();
      expect(task.enabled, isTrue);
    });

    test('Score Calculation Logic', () {
      // Testet: Kurze Zeit + wenig Klicks = Hoher Score
      int highSchore = game.calculateScore(const Duration(seconds: 30), 10, 0);
      // Testet: Lange Zeit + viele Klicks = Niedriger Score
      int lowScore = game.calculateScore(const Duration(minutes: 5), 100, 0);
      
      expect(highSchore, greaterThan(lowScore));
      expect(highSchore, lessThanOrEqualTo(1000));
    });

    test('Persistence: JSON Round-trip', () {
      game.stage = 3;
      final data = game.toJson();
      final encoded = json.encode(data);
      final decoded = json.decode(encoded);
      expect(decoded['stage'], 3);
    });
  });
}
