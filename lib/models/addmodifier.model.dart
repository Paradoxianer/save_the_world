import 'dart:convert';

import 'package:save_the_world_flutter_app/models/game.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/gameelement.model.dart';
import 'package:save_the_world_flutter_app/models/modifier.model.dart';
import 'package:save_the_world_flutter_app/models/task.model.dart';

class AddModifer extends Modifier {
  GameElement workOnItem;
  String nameOfTask;
  List<Modifier> mymodifer;

  AddModifer({String task, List<Modifier> modifier})
      : super(
      name: "AddModifer",
      description: "Adds the given list of Modifier to the given task") {
    this.nameOfTask = task;
    this.mymodifer = modifier;
  }

  factory AddModifer.fromJson(Map<String, dynamic> jsn){
    var modList = json.decode(jsn['modifier']) as List;
    List<Modifier> modifierList = modList.map((i) => Modifier.fromJson(i))
        .toList();
    return AddModifer(task: jsn['taks'], modifier: modifierList);
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'name': name,
      'task': nameOfTask,
      'modifier': json.encode(mymodifer)
    };
  }

  modify() {
    Task found;
    if (nameOfTask != null)
      found = Game.tasks.firstWhere((tsk) => tsk.name == nameOfTask);
    else
      found = workOnItem;
    if (found != null) {
      found.myModifier.addAll(mymodifer);
    }
  }
}
