import 'package:save_the_world_flutter_app/models/game.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/gameelement.model.dart';
import 'package:save_the_world_flutter_app/models/modifier.model.dart';
import 'package:save_the_world_flutter_app/models/task.model.dart';

class RemoveModifer extends Modifier {
  GameElement workOnItem;
  String nameOfTask;
  List<Modifier> mymodifer;

  RemoveModifer({String task, List<Modifier> modifier})
      : super(
      name: "RemoveModifer",
      description: "Removes the given list of Modifier from the given task") {
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
      int i = 0;
      for (i = 0; i < mymodifer.length; i++)
        found.myModifier.remove(mymodifer[i]);
    }
  }

  String info() {
    return super.info() + "removing: " + nameOfTask;
  }
}
