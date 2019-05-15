import 'package:save_the_world_flutter_app/models/game.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/modifier.model.dart';
import 'package:save_the_world_flutter_app/models/ressource.model.dart';

class SetMin extends Modifier {
  String workOn;
  double newMin;

  SetMin({String ressource, this.newMin})
      : super(
            name: "SetMin",
            description:
                "Sets a new min boder for the a given game ressource") {
    workOn = ressource;
  }

  factory SetMin.fromJson(Map<String, dynamic> jsn) {
    return SetMin(ressource: jsn['ressource'], newMin: jsn['newMin']);
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'name': name,
      'ressource': workOn,
      'newMin': newMin
    };
  }

  modify() {
    if (workOn != null) {
      Ressource tmpRes = Game.ressources[workOn];
      if (tmpRes != null)
        tmpRes..min = newMin;
    }
  }

  String info() {
    return super.info() + "set min of " + workOn + " to " + newMax;
  }
}
