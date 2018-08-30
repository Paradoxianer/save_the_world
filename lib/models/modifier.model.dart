import 'package:save_the_world_flutter_app/models/gameelement.model.dart';
import 'package:save_the_world_flutter_app/models/gameitem.model.dart';

class Modifier extends GameItem {
  final GameElement workOnItem;
  final GameElement elementToWorkWith;
  const Modifier({this.workOnItem,this.elementToWorkWith});
}