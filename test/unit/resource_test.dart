import 'package:flutter_test/flutter_test.dart';
import 'package:save_the_world_flutter_app/models/game.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/money.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/member.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/ressource.model.dart';

void main() {
  group('Ressource Model Tests', () {
    test('Standard values and constraints', () {
      final res = Ressource(name: "Test", value: 50.0, min: 0.0, max: 100.0);
      
      expect(res.value, 50.0);
      
      res.add(Ressource(name: "Test", value: 60.0));
      expect(res.value, 100.0, reason: "Should cap at max");
      
      res.subtract(Ressource(name: "Test", value: 110.0));
      expect(res.value, 0.0, reason: "Should cap at min");
    });

    test('Dynamic Multiplier Calculation (Smart Awards)', () {
      // Setup global resources for multiplier lookup
      final game = Game.getInstance();
      Game.ressources["Member"] = Member(value: 10.0);
      
      final dynamicAward = Money(
        value: 2.0, 
        multiplierResourceName: "Member", 
        multiplierValue: 1.5
      );

      // Formula: base (2.0) * Member (10.0) * factor (1.5) = 30.0
      expect(dynamicAward.value, 30.0);
      
      // Change dependency
      Game.ressources["Member"]?.value = 20.0;
      expect(dynamicAward.value, 60.0, reason: "Award should react to dependency change");
    });
  });
}
