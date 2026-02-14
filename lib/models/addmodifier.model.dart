import 'dart:convert';

import 'package:save_the_world_flutter_app/models/game.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/modifier.model.dart';
import 'package:save_the_world_flutter_app/models/task.model.dart';
import 'package:flutter/foundation.dart';

class AddModifer extends Modifier {
  final String? nameOfTask;
  final List<Modifier> mymodifer;

  AddModifer({String? task, required List<Modifier> modifier})
      : nameOfTask = task,
        mymodifer = modifier,
        super(
            name: "AddModifer",
            description: "Adds the given list of Modifier to the given task");

  factory AddModifer.fromJson(Map<String, dynamic> jsn) {
    final dynamic decodedModifier = jsn['modifier'];
    List<dynamic> modList;
    if (decodedModifier is String) {
      modList = json.decode(decodedModifier) as List;
    } else {
      modList = decodedModifier as List;
    }

    List<Modifier> modifierList =
        modList.map((i) => Modifier.fromJson(i as Map<String, dynamic>)).toList();
    return AddModifer(task: jsn['task'] as String?, modifier: modifierList);
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'task': nameOfTask,
      'modifier': json.encode(mymodifer),
    };
  }

  @override
  void modify() {
    Task? found;
    if (nameOfTask != null) {
      try {
        found = Game.tasks.firstWhere((tsk) => tsk.name == nameOfTask);
      } catch (e) {
        debugPrint("AddModifier: Task not found: $nameOfTask");
      }
    } else if (workOnItem is Task) {
      found = workOnItem as Task;
    }

    if (found != null) {
      found.myModifier.addAll(mymodifer);
    }
  }

  @override
  String info() {
    return "${super.info()}addmodifier: $mymodifer to $nameOfTask";
  }
}
