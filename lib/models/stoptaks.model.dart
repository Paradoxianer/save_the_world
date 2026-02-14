import 'package:save_the_world_flutter_app/models/game.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/modifier.model.dart';
import 'package:save_the_world_flutter_app/models/task.model.dart';
import 'package:flutter/foundation.dart';

class StopTask extends Modifier {
  final String nameOfTask;

  StopTask({required String task})
      : nameOfTask = task,
        super(
            name: "StopTask",
            description: "stops the given Task if its in the active Task List");

  factory StopTask.fromJson(Map<String, dynamic> json) {
    return StopTask(task: json['task'] as String);
  }

  @override
  Map<String, dynamic> toJson() {
    return {'name': name, 'task': nameOfTask};
  }

  @override
  void modify() {
    try {
      Task? found = Game.tasks.firstWhere((tsk) => tsk.name == nameOfTask);
      found.stop();
    } catch (e) {
      debugPrint("StopTask: Task not found: $nameOfTask");
    }
  }

  @override
  String info() {
    return "${super.info()}stop $nameOfTask";
  }
}
