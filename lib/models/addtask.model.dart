import 'package:save_the_world_flutter_app/models/game.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/gameelement.model.dart';
import 'package:save_the_world_flutter_app/models/modifier.model.dart';
import 'package:save_the_world_flutter_app/models/task.model.dart';

class AddTask extends Modifier {
  GameElement workOnItem;
  String nameOfTask;
  List<Task> workOnList;

  AddTask({String task, List<Task> workOnList = null})
      : super(
            name: "AddTask",
            description:
                "Adds the given List of Task to the Game or the given TaskList") {
    this.nameOfTask = task;
    this.workOnList = workOnList;
  }

  factory AddTask.fromJson(Map<String, dynamic> json){
    return AddTask(task: json['task']);
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'name': name,
      'task': nameOfTask
    };
  }

  modify() {
    Task found = Game.getInstance().availableTasks().firstWhere((tsk) =>
    tsk.name == nameOfTask);
    if (found != null) {
      if (workOnList != null) {
        workOnList.add(found);
      }
      else {
        Game.getInstance().addTask(found);
      }
    }
  }
}
