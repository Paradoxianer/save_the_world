import 'package:save_the_world_flutter_app/models/gameelement.model.dart';
import 'package:save_the_world_flutter_app/models/modifier.model.dart';
import 'package:save_the_world_flutter_app/models/ressource.model.dart';

class AddRes extends Modifier {
  GameElement workOnItem;
  List<Ressource> ressources;
  Map<String, Ressource> workOnRes;

  AddRes({this.ressources, this.workOnRes}) : super();

  modify() {
    int listSize = ressources.length;
    for (int i = 0; i < listSize; i++) {
      workOnRes[ressources[i].name].add(ressources[i]);
    }
  }
}
