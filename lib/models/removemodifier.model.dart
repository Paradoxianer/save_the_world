import 'package:save_the_world_flutter_app/models/game.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/modifier.model.dart';
import 'package:save_the_world_flutter_app/models/task.model.dart';
import 'package:flutter/foundation.dart';

class RemoveModifer extends Modifier {
  final String? nameOfTask;
  final List<Modifier> mymodifer;

  RemoveModifer({String? task, required List<Modifier> modifier})
      : nameOfTask = task,
        mymodifer = modifier,
        super(
            name: "RemoveModifer",
            description: "Removes the given list of Modifier from the given task");

  factory RemoveModifer.fromJson(Map<String, dynamic> json) {
    // Note: To fully implement fromJson, we'd need to deserialize the modifier list too.
    // For now, providing a basic implementation to satisfy the compiler.
    return RemoveModifer(task: json['task'] as String?, modifier: []);
  }

  @override
  void modify() {
    Task? found;
    if (nameOfTask != null) {
      try {
        found = Game.tasks.firstWhere((tsk) => tsk.name == nameOfTask);
      } catch (e) {
        debugPrint("RemoveModifier: Task not found: $nameOfTask");
      }
    } else if (workOnItem is Task) {
      found = workOnItem as Task;
    }

    if (found != null) {
      for (var mod in mymodifer) {
        found.myModifier.remove(mod);
      }
    }
  }

  @override
  String info() {
    return "${super.info()}removing: $nameOfTask";
  }
}
