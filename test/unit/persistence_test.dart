import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:save_the_world_flutter_app/models/game.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/money.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/ressource.model.dart';
import 'package:save_the_world_flutter_app/models/task.model.dart';

void main() {
  group('Persistence & Serialization Tests', () {
    test('Resource JSON round-trip with Multipliers', () {
      final original = Money(
        value: 10.0,
        multiplierResourceName: "Member",
        multiplierValue: 2.5
      );

      final jsonString = json.encode(original.toJson());
      final Map<String, dynamic> decodedMap = json.decode(jsonString);
      final restored = Ressource.fromJson(decodedMap);

      expect(restored.name, "Money");
      expect(restored.multiplierResourceName, "Member");
      expect(restored.multiplierValue, 2.5);
      // Note: Base value should be restored, dynamic value depends on Game instance
    });

    test('Task JSON round-trip with Modifier Flags', () {
      final originalTask = Task(
        name: "Test Task",
        enabled: false,
        isMilestone: true
      );

      final jsonString = json.encode(originalTask.toJson());
      final restoredTask = Task.fromJson(json.decode(jsonString));

      expect(restoredTask.name, "Test Task");
      expect(restoredTask.enabled, isFalse);
      expect(restoredTask.isMilestone, isTrue);
    });

    test('Full Game State consistency after load simulation', () {
      // Setup a game state
      Game.mInstance = null;
      final game = Game.getInstance();
      game.stage = 5;
      game.recordClick();
      game.recordClick();
      
      final gameData = game.toJson();
      
      // Simulate fresh start
      Game.mInstance = null;
      final newGame = Game.getInstance();
      
      // Manually trigger load with the saved data
      newGame.loadGame(json.encode(gameData));
      
      expect(newGame.stage, 5);
      expect(newGame.stageClicks, 2);
      expect(Game.ressources["Stage"]?.value, 5.0);
    });
  });
}
