import 'package:save_the_world_flutter_app/models/gameelement.model.dart';
import 'package:save_the_world_flutter_app/models/gameitem.model.dart';

class Modifier implements GameItem {
  GameElement workOnItem;
  GameElement elementToWorkWith;
  Modifier({this.workOnItem,this.elementToWorkWith});
}