import 'package:save_the_world_flutter_app/models/game.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/modifier.model.dart';

class AddToRandom extends Modifier {
  String task;

  AddToRandom({this.task})
      : super(
            name: "AddToRandom",
            description: "Adds the given String to the Random List") {}

  factory AddToRandom.fromJson(Map<String, dynamic> jsn) {
    return AddToRandom(task: jsn['task']);
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{'name': name, 'task': task};
  }

  modify() {
    Game.getInstance().randomTasks.add(task);
  }

  String info() {
    return super.info() + "add: " + task;
  }
}
