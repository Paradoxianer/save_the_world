import 'package:save_the_world_flutter_app/models/game.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/modifier.model.dart';
import 'package:save_the_world_flutter_app/models/ressource.model.dart';

class SetMin extends Modifier {
  final String workOn;
  final double newMin;

  SetMin({required String ressource, required this.newMin})
      : workOn = ressource,
        super(
            name: "SetMin",
            description: "Sets a new min border for a given game resource");

  factory SetMin.fromJson(Map<String, dynamic> jsn) {
    return SetMin(
      ressource: jsn['ressource'] as String,
      newMin: (jsn['newMin'] as num).toDouble(),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'ressource': workOn,
      'newMin': newMin,
    };
  }

  @override
  void modify() {
    Ressource? tmpRes = Game.ressources[workOn];
    if (tmpRes != null) {
      tmpRes.min = newMin;
    }
  }

  @override
  String info() {
    return "${super.info()}set min of $workOn to $newMin";
  }
}
