import 'package:save_the_world_flutter_app/models/game.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/gameelement.model.dart';
import 'package:save_the_world_flutter_app/models/modifier.model.dart';
import 'package:save_the_world_flutter_app/models/ressource.model.dart';

class SubtractRes extends Modifier {
  GameElement workOnItem;
  List<Ressource> ressources;
  Map<String, Ressource> workOnRes;

  SubtractRes({this.ressources, this.workOnRes = null}) : super();

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
