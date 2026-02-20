import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:save_the_world_flutter_app/models/game.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/money.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/ressource.model.dart';
import 'package:save_the_world_flutter_app/models/task.model.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Persistence & Serialization Tests', () {
    tearDown(() {
      Game.mInstance?.dispose();
      Game.mInstance = null;
    });

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
    });

    test('Full Game State consistency after load simulation', () {
      Game.mInstance = null;
      final game = Game.getInstance();
      game.isLoading = true;
      game.stage = 5;
      game.recordClick();
      
      final gameData = game.toJson();
      
      // Simulate fresh start
      Game.mInstance?.dispose();
      Game.mInstance = null;
      final newGame = Game.getInstance();
      newGame.isLoading = true;
      
      newGame.loadGame(json.encode(gameData));
      
      expect(newGame.stage, 5);
      expect(newGame.stageClicks, 1);
    });
  });
}
