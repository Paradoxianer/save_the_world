import 'package:save_the_world_flutter_app/models/game.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/modifier.model.dart';
import 'package:save_the_world_flutter_app/models/weighted_random_event.model.dart';

class AddToRandom extends Modifier {
  final String nameOfTask; // Umbenannt von task -> nameOfTask für Konsistenz
  final String? resourceName;
  final double? resourceThreshold;

  AddToRandom({required String task, this.resourceName, this.resourceThreshold})
      : nameOfTask = task,
        super(
            name: "AddToRandom",
            description: "Adds the given Task Name to the Random List");

  factory AddToRandom.fromJson(Map<String, dynamic> jsn) {
    return AddToRandom(
      task: (jsn['nameOfTask'] ?? jsn['task']) as String,
      resourceName: jsn['resourceName'] as String?,
      resourceThreshold: (jsn['resourceThreshold'] as num?)?.toDouble(),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'nameOfTask': nameOfTask,
      if (resourceName != null) 'resourceName': resourceName,
      if (resourceThreshold != null) 'resourceThreshold': resourceThreshold,
    };
  }

  @override
  void modify() {
    final game = Game.getInstance();
    // Ressourcenabhängig: Chance pro Roll statt fixer Aufnahme in den
    // Gleichverteilungs-Pool (siehe updateGame()/weightedRandomEvents).
    if (resourceName != null && resourceThreshold != null) {
      game.weightedRandomEvents[nameOfTask] =
          WeightedRandomEvent(resourceName: resourceName!, threshold: resourceThreshold!);
    } else {
      game.randomTasks.add(nameOfTask);
    }
  }

  @override
  String info() {
    if (resourceName != null && resourceThreshold != null) {
      return "${super.info()}add to random: $nameOfTask (gewichtet nach $resourceName, Schwelle $resourceThreshold)";
    }
    return "${super.info()}add to random: $nameOfTask";
  }
}
