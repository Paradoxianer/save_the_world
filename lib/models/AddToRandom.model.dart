import 'package:save_the_world_flutter_app/models/game.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/modifier.model.dart';

class AddToRandom extends Modifier {
  final String task;

  AddToRandom({required this.task})
      : super(
            name: "AddToRandom",
            description: "Adds the given String to the Random List");

  factory AddToRandom.fromJson(Map<String, dynamic> jsn) {
    return AddToRandom(task: jsn['task'] as String);
  }

  @override
  Map<String, dynamic> toJson() {
    return {'name': name, 'task': task};
  }

  @override
  void modify() {
    Game.getInstance().randomTasks.add(task);
  }

  @override
  String info() {
    return "${super.info()}add: $task";
  }
}
