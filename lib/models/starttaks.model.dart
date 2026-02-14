import 'package:save_the_world_flutter_app/models/game.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/modifier.model.dart';
import 'package:save_the_world_flutter_app/models/task.model.dart';
import 'package:flutter/foundation.dart';

class StartTask extends Modifier {
  final String nameOfTask;
  final bool reverse;

  StartTask({required String task, this.reverse = false})
      : nameOfTask = task,
        super(
            name: "StartTask",
            description:
                "starts a Task depending on reverse either forward or reverse");

  factory StartTask.fromJson(Map<String, dynamic> json) {
    return StartTask(
      task: json['task'] as String,
      reverse: json['reverse'] as bool? ?? false,
    );
  }

  @override
  void modify() {
    try {
      Task? found = Game.tasks.firstWhere((tsk) => tsk.name == nameOfTask);
      if (reverse == false) {
        found.start();
      } else {
        found.controller.reverse(from: 0.99);
      }
    } catch (e) {
      debugPrint("StartTask: Task not found: $nameOfTask");
    }
  }

  @override
  String info() {
    return "${super.info()}start $nameOfTask";
  }
}
