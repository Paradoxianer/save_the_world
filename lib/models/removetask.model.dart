import 'package:save_the_world_flutter_app/models/game.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/modifier.model.dart';
import 'package:save_the_world_flutter_app/models/task.model.dart';
import 'package:flutter/foundation.dart';

class RemoveTask extends Modifier {
  final String nameOfTask;
  final List<Task>? workOnList;

  RemoveTask({required String task, this.workOnList})
      : nameOfTask = task,
        super(name: "RemoveTask", description: "Modifier which remove Tasks");

  factory RemoveTask.fromJson(Map<String, dynamic> json) {
    return RemoveTask(task: json['task'] as String);
  }

  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{'name': name, 'task': nameOfTask};
  }

  @override
  void modify() {
    try {
      debugPrint("modify() $name \t $nameOfTask");
      Task? found = Game.getInstance().getTask(nameOfTask);
      if (found != null) {
        if (workOnList != null) {
          workOnList!.remove(found);
        } else {
          Game.getInstance().removeTask(found);
        }
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  String info() {
    return "${super.info()}removing: $nameOfTask";
  }
}
