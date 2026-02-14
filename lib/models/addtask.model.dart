import 'package:save_the_world_flutter_app/models/game.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/modifier.model.dart';
import 'package:save_the_world_flutter_app/models/task.model.dart';
import 'package:flutter/foundation.dart';

class AddTask extends Modifier {
  final String nameOfTask;
  final List<Task>? workOnList;

  AddTask({required String task, this.workOnList})
      : nameOfTask = task,
        super(
            name: "AddTask",
            description:
                "Adds the given List of Task to the Game or the given TaskList");

  factory AddTask.fromJson(Map<String, dynamic> json) {
    return AddTask(task: json['task'] as String);
  }

  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{'name': name, 'task': nameOfTask};
  }

  @override
  void modify() {
    debugPrint("modify $name \t $nameOfTask");
    Task? found = Game.getInstance().getTask(nameOfTask);
    if (found != null) {
      if (workOnList != null) {
        workOnList!.add(found);
      } else {
        Game.getInstance().addTask(found);
      }
    }
  }

  @override
  String info() {
    return "${super.info()}add: $nameOfTask";
  }
}
