import 'package:save_the_world_flutter_app/models/game.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/gameelement.model.dart';
import 'package:save_the_world_flutter_app/models/modifier.model.dart';
import 'package:save_the_world_flutter_app/models/task.model.dart';

class RemoveTask extends Modifier {
  GameElement workOnItem;
  String taskName;
  List<Task> workOnList;

  RemoveTask({String task, List<Task> workOnList = null})
      : super(name: "RemoveTask", description: "Modifer which remove Tasks") {
    this.taskName = task;
    this.workOnList = workOnList;
  }

  modify() {
    Task found = Game.getInstance()
        .availableTasks()
        .firstWhere((tsk) => tsk.name == taskName);
    if (found != null) {
      if (workOnList != null) {
        workOnList.remove(found);
      } else
        Game.getInstance().removeTask(found);
    }
  }
}
