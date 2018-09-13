import 'package:save_the_world_flutter_app/models/game.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/gameelement.model.dart';
import 'package:save_the_world_flutter_app/models/modifier.model.dart';
import 'package:save_the_world_flutter_app/models/ressource.model.dart';

class AddRes extends Modifier {
  GameElement workOnItem;
  List<Ressource> ressources;
  Map<String, Ressource> workOnRes;

  AddRes(List<Ressource> ressources, [Map<String, Ressource> workOnRes = null])
      :
        super(name: "AddRes", description: "Adds a list of Ressource") {
    this.ressources = ressources;
    this.workOnRes = workOnRes;
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
