import 'package:save_the_world_flutter_app/models/game.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/gameelement.model.dart';
import 'package:save_the_world_flutter_app/models/modifier.model.dart';
import 'package:save_the_world_flutter_app/models/task.model.dart';

class RemoveTask extends Modifier {
  GameElement workOnItem;
  String nameOfTask;
  List<Task> workOnList;

  RemoveTask({String task, List<Task> workOnList})
      : super(name: "RemoveTask", description: "Modifer which remove Tasks") {
    this.nameOfTask = task;
    this.workOnList = workOnList;
  }

  factory RemoveTask.fromJson(Map<String, dynamic> json){
    return RemoveTask(task: json['task']);
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'name': name,
      'task': nameOfTask
    };
  }

  modify() {
    try {
      print("modify()" + this.name + "\t" + this.nameOfTask);
      Task found = Game.getInstance().getTask(nameOfTask);
      if (found != null) {
        if (workOnList != null) {
          workOnList.remove(found);
        } else
          Game.getInstance().removeTask(found);
      }
    }
    catch (e) {
      print(e.toString());
    }
  }
}
