import 'dart:convert';

import 'package:save_the_world_flutter_app/models/game.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/gameelement.model.dart';
import 'package:save_the_world_flutter_app/models/modifier.model.dart';
import 'package:save_the_world_flutter_app/models/ressource.model.dart';

class SubtractRes extends Modifier {
  GameElement workOnItem;
  List<Ressource> ressources;
  Map<String, Ressource> workOnRes;

  SubtractRes({this.ressources, this.workOnRes}) :
        super(name: "SubtractRes", description: "Removes a list of Ressource") {
    if (ressources == null) {
      ressources = new List<Ressource>();
    }
  }

  factory SubtractRes.fromJson(Map<String, dynamic> jsn){
    var resList = json.decode(jsn['ressources']) as List;
    List<Ressource> ressourceList = resList.map((i) => Ressource.fromJson(i))
        .toList();
    return SubtractRes(ressources: ressourceList);
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'name': name,
      'ressources': json.encode(ressources)
    };
  }

  modify() {
    int listSize = ressources.length;
    if (workOnRes != null) {
      for (int i = 0; i < listSize; i++) {
        workOnRes[ressources[i].name].subtract(ressources[i]);
      }
    }
    else {
      for (int i = 0; i < listSize; i++) {
        Game.ressources[ressources[i].name].subtract(ressources[i]);
      }
    }
  }
}
