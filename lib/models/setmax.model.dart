import 'package:save_the_world_flutter_app/models/game.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/modifier.model.dart';
import 'package:save_the_world_flutter_app/models/ressource.model.dart';

class SetMax extends Modifier {
  final String workOn;
  final double newMax;

  SetMax({required String ressource, required this.newMax})
      : workOn = ressource,
        super(
            name: "SetMax",
            description: "Sets a new max border for a given game resource");

  factory SetMax.fromJson(Map<String, dynamic> jsn) {
    return SetMax(
      ressource: jsn['ressource'] as String,
      newMax: (jsn['newMax'] as num).toDouble(),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'ressource': workOn,
      'newMax': newMax,
    };
  }

  @override
  void modify() {
    Ressource? tmpRes = Game.ressources[workOn];
    if (tmpRes != null) {
      tmpRes.max = newMax;
    }
  }

  @override
  String info() {
    return "${super.info()}set max of $workOn to $newMax";
  }
}
