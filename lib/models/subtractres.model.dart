import 'package:save_the_world_flutter_app/models/gameelement.model.dart';
import 'package:save_the_world_flutter_app/models/modifier.model.dart';
import 'package:save_the_world_flutter_app/models/ressource.model.dart';

class SubtractRes extends Modifier {
  GameElement workOnItem;
  List<Ressource> ressources;
  Map<String, Ressource> workOnRes;

  SubtractRes({this.ressources, this.workOnRes}) : super();

  modify() {
    int listSize = ressources.length;
    for (int i = 0; i < listSize; i++) {
      workOnRes[ressources[i].name].subtract(ressources[i]);
    }
  }
}
