import 'package:save_the_world_flutter_app/models/game.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/modifier.model.dart';

class AddToRandom extends Modifier {
  final String nameOfTask; // Umbenannt von task -> nameOfTask für Konsistenz

  AddToRandom({required String task})
      : nameOfTask = task,
        super(
            name: "AddToRandom",
            description: "Adds the given Task Name to the Random List");

  factory AddToRandom.fromJson(Map<String, dynamic> jsn) {
    return AddToRandom(task: (jsn['nameOfTask'] ?? jsn['task']) as String);
  }

  @override
  Map<String, dynamic> toJson() {
    return {'name': name, 'nameOfTask': nameOfTask};
  }

  @override
  void modify() {
    Game.getInstance().randomTasks.add(nameOfTask);
  }

  @override
  String info() {
    return "${super.info()}add to random: $nameOfTask";
  }
}
