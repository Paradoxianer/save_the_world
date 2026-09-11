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
      // WICHTIG: NICHT über Game.getInstance().getTask() suchen - das
      // durchsucht allTasks, und allTasks wird bei jedem Stage-Wechsel
      // komplett ersetzt (siehe Game.initStage(): "allTasks =
      // allStages[stg].allTasks"), nicht ergänzt. Eine aus einer früheren
      // Stage geerbte Aufgabe, die sich selbst entfernen will, fand sich
      // dort nach dem Stage-Wechsel nie wieder - RemoveTask(self) verpuffte
      // lautlos, die Aufgabe blieb als Karteileiche für immer in
      // Game.tasks/workOnList hängen (und im Bot-Simulator, der Fristen
      // nach jedem Ereignis neu einplant, sogar in einer Endlos-Verpasst-
      // Schleife). Stattdessen direkt in der Zielliste selbst suchen - dort
      // liegt die tatsächlich aktive Instanz ohnehin bereits vor.
      final List<Task> searchList = workOnList ?? Game.tasks;
      Task? found;
      for (final t in searchList) {
        if (t.name == nameOfTask) {
          found = t;
          break;
        }
      }
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
