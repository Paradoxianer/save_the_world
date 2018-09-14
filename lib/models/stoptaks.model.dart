import 'package:save_the_world_flutter_app/models/game.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/gameelement.model.dart';
import 'package:save_the_world_flutter_app/models/modifier.model.dart';
import 'package:save_the_world_flutter_app/models/task.model.dart';

class StopTask extends Modifier {
  GameElement workOnItem;
  String nameOfTask;

  StopTask({String task})
      : super(
      name: "StopTask",
            description:
            "stops the given Task if its in the active Task List") {
    this.nameOfTask = task;
  }

  modify() {
    Task found = Game.tasks.firstWhere((tsk) => tsk.name == nameOfTask);
    if (found != null) {
      found.stop();
    }
  }
}
