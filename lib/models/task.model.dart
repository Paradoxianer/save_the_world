import 'package:save_the_world_flutter_app/models/gameelement.model.dart';
import 'package:save_the_world_flutter_app/models/modifier.model.dart';
import 'package:save_the_world_flutter_app/models/ressource.model.dart';

class Task extends GameElement {
  final List<Ressource> cost;
  final List<Ressource> award;
  final List<Ressource> require;

  const Task({String name,String description,this.cost, this.award,this.require, List<Modifier> modifer}) :
        super(name : name, description : description, myModifier : modifer);

}