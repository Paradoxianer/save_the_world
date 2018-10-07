import 'package:save_the_world_flutter_app/models/game.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/modifier.model.dart';
import 'package:save_the_world_flutter_app/models/ressource.model.dart';

class SetMax extends Modifier {
  Ressource workOn;
  double newMax;

  SetMax({String ressource, this.newMax})
      : super(
            name: "SetMax",
            description:
                "Sets a new max boder for the a given game ressource") {
    workOn = Game.ressources[ressource];
  }

  factory SetMax.fromJson(Map<String, dynamic> jsn) {
    return SetMax(ressource: jsn['ressource'], newMax: jsn['newMax']);
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'name': name,
      'ressource': workOn.name,
      'newMax': newMax
    };
  }

  modify() {
    if (workOn != null) {
      workOn.max = newMax;
    }
  }
}
