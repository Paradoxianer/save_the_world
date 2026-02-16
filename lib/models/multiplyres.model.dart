import 'package:save_the_world_flutter_app/models/game.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/modifier.model.dart';
import 'package:save_the_world_flutter_app/models/ressource.model.dart';

class MultiplyRes extends Modifier {
  final String targetResName; // Welche Ressource bekommt den Bonus? (z.B. "Money")
  final String factorResName; // Welche Ressource ist die Basis? (z.B. "Member")
  final double multiplier;    // Faktor (z. lifetime value / contribution per member)

  MultiplyRes({
    required this.targetResName,
    required this.factorResName,
    required this.multiplier,
  }) : super(
          name: "MultiplyRes",
          description: "Adds resources based on a multiplier of another resource.",
        );

  factory MultiplyRes.fromJson(Map<String, dynamic> jsn) {
    return MultiplyRes(
      targetResName: jsn['targetResName'] as String,
      factorResName: jsn['factorResName'] as String,
      multiplier: (jsn['multiplier'] as num).toDouble(),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'targetResName': targetResName,
      'factorResName': factorResName,
      'multiplier': multiplier,
    };
  }

  @override
  void modify() {
    final factorRes = Game.ressources[factorResName];
    final targetRes = Game.ressources[targetResName];

    if (factorRes != null && targetRes != null) {
      // Berechnung: (Aktueller Wert der Basis) * Multiplikator
      double bonusAmount = factorRes.value * multiplier;
      
      // Wir nutzen eine temporäre Ressource, um die .add() Logik (inkl. Max-Check) zu nutzen
      targetRes.add(Ressource(name: targetResName, value: bonusAmount));
    }
  }

  @override
  String info() {
    return "Adds $targetResName based on $factorResName (factor: $multiplier)";
  }
}
