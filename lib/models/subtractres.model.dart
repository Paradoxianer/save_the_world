import 'package:save_the_world_flutter_app/models/game.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/gameelement.model.dart';
import 'package:save_the_world_flutter_app/models/modifier.model.dart';
import 'package:save_the_world_flutter_app/models/ressource.model.dart';

class SubtractRes extends Modifier {
  GameElement workOnItem;
  List<Ressource> ressources;
  Map<String, Ressource> workOnRes;

  SubtractRes({this.ressources, this.workOnRes = null}) : super();

  factory SubtractRes.fromJson(Map<String, dynamic> json){
    var resList = json['ressources'] as List;
    List<Ressource> ressourceList = resList.map((i) => Ressource.fromJson(i))
        .toList();
    return SubtractRes(ressources: ressourceList);
  }

  Map<String, dynamic> toJson() {
    String rString;
    if (ressources != null)
      rString = ressources.map((i) => i.toJson()).toString();
    return <String, dynamic>{
      'name': name,
      'ressources': rString
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
