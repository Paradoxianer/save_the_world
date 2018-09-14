import 'package:save_the_world_flutter_app/models/game.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/gameelement.model.dart';
import 'package:save_the_world_flutter_app/models/modifier.model.dart';
import 'package:save_the_world_flutter_app/models/task.model.dart';

class StartTask extends Modifier {
  GameElement workOnItem;
  String nameOfTask;
  bool reverse;

  StartTask({String task, bool reverse = false})
      : super(
            name: "StartTask",
            description:
                "starts a Task debending on reverse either forwad or reverse") {
    this.nameOfTask = task;
    this.reverse = reverse;
  }

  modify() {
    Task found = Game.tasks.firstWhere((tsk) => tsk.name == nameOfTask);
    if (found != null) {
      found.start();
    }
  }
}
