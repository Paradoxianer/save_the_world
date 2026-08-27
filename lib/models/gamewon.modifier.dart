import 'package:save_the_world_flutter_app/models/game.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/modifier.model.dart';

/// Markiert das Spiel als abgeschlossen und löst den einmaligen Win-Screen
/// aus. Wird ausschließlich vom finalen Task in Stage 32 verwendet.
class GameWonModifier extends Modifier {
  GameWonModifier()
      : super(
          name: "GameWonModifier",
          description: "Markiert das Spiel als abgeschlossen und löst den Win-Screen aus.",
        );

  factory GameWonModifier.fromJson(Map<String, dynamic> jsn) {
    return GameWonModifier();
  }

  @override
  Map<String, dynamic> toJson() {
    return {'name': name};
  }

  @override
  void modify() {
    Game.getInstance().markGameWon();
  }

  @override
  String info() {
    return "Löst den Win-Screen aus - das Spiel ist vollendet.";
  }
}
