import 'package:save_the_world_flutter_app/models/game.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/gameelement.model.dart';
import 'package:save_the_world_flutter_app/models/modifier.model.dart';
import 'package:save_the_world_flutter_app/models/task.model.dart';

class AddTask extends Modifier {
  GameElement workOnItem;
  List<Task> tasks;
  List<Task> workOnList;

  AddTask(List<Task> tasksToAdd, [List<Task> workOnList = null])
      : super(
            name: "AddTask",
            description:
                "Adds the given List of Task to the Game or the given TaskList") {
    this.tasks = tasksToAdd;
    this.workOnList = workOnList;
  }

  modify() {
    if (workOnList != null) {
      workOnList.addAll(tasks);
    } else
      tasks.forEach(Game.getInstance().addTask);
  }
}
