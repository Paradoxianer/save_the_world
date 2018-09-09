import 'package:save_the_world_flutter_app/models/gameelement.model.dart';
import 'package:save_the_world_flutter_app/models/modifier.model.dart';
import 'package:save_the_world_flutter_app/models/ressource.model.dart';

class Task extends GameElement {
  DateTime duration;
  DateTime timeToSolve;
  DateTime startedAt;

  List<Ressource> cost;
  List<Ressource> award;
  List<Ressource> require;

  Task({String name,String description,this.cost, this.award,this.require, List<Modifier> modifer}) :
        super(name : name, description : description, myModifier : modifer){
    if (myModifier==null){
      myModifier = new List<Modifier>();
     // myModifier.add(Adder(award));
      // myModifier.add(Subtractor(cost));

    }
  }

}