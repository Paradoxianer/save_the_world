import 'dart:convert';

import 'package:save_the_world_flutter_app/models/game.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/gameelement.model.dart';
import 'package:save_the_world_flutter_app/models/modifier.model.dart';
import 'package:save_the_world_flutter_app/models/ressource.model.dart';

class AddRes extends Modifier {
  GameElement workOnItem;
  List<Ressource> ressources;
  Map<String, Ressource> workOnRes;

  AddRes({List<Ressource> ressources, Map<String, Ressource> workOnRes = null})
      :
        super(name: "AddRes", description: "Adds a list of Ressource") {
    this.ressources = ressources;
    this.workOnRes = workOnRes;
  }

  factory AddRes.fromJson(Map<String, dynamic> json){
    var resList = json['ressources'] as List;
    List<Ressource> ressourceList = resList.map((i) => Ressource.fromJson(i))
        .toList();
    return AddRes(ressources: ressourceList);
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
        workOnRes[ressources[i].name].add(ressources[i]);
      }
    }
    else {
      for (int i = 0; i < listSize; i++) {
        Game.ressources[ressources[i].name].add(ressources[i]);
      }
    }
  }
}
