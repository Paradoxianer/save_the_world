import 'package:save_the_world_flutter_app/models/game.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/gameelement.model.dart';
import 'package:save_the_world_flutter_app/models/modifier.model.dart';
import 'package:save_the_world_flutter_app/models/task.model.dart';

class AddModifer extends Modifier {
  GameElement workOnItem;
  String nameOfTask;
  List<Modifier> mymodifer;

  AddModifer({String task, List<Modifier> modifier})
      : super(
            name: "AddModifer",
            description: "Adds the given list of Modifier to the given task") {
    this.nameOfTask = task;
    this.mymodifer = modifier;
  }

  modify() {
    Task found;
    if (nameOfTask != null)
      found = Game.tasks.firstWhere((tsk) => tsk.name == nameOfTask);
    else
      found = workOnItem;
    if (found != null) {
      found.myModifier.addAll(mymodifer);
    }
  }
}
