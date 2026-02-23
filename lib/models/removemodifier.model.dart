import 'package:save_the_world_flutter_app/models/game.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/modifier.model.dart';
import 'package:save_the_world_flutter_app/models/task.model.dart';
import 'package:flutter/foundation.dart';

class RemoveModifer extends Modifier {
  final String? nameOfTask; // Konsistent zu AddTask
  final List<Modifier> mymodifer;

  RemoveModifer({String? nameOfTask, required List<Modifier> modifier})
      : nameOfTask = nameOfTask,
        mymodifer = modifier,
        super(
            name: "RemoveModifer",
            description: "Removes the given list of Modifier from the given task");

  factory RemoveModifer.fromJson(Map<String, dynamic> json) {
    return RemoveModifer(
      nameOfTask: (json['nameOfTask'] ?? json['task']) as String?, 
      modifier: []
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'nameOfTask': nameOfTask,
      'mymodifer': mymodifer.map((m) => m.toJson()).toList(),
    };
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
