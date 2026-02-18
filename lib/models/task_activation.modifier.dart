import 'package:save_the_world_flutter_app/models/game.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/modifier.model.dart';

class EnableTaskModifier extends Modifier {
  final String taskName;

  EnableTaskModifier({required this.taskName})
      : super(
          name: "EnableTask",
          description: "Aktiviert einen Task, damit er gestartet werden kann.",
        );

  factory EnableTaskModifier.fromJson(Map<String, dynamic> json) {
    return EnableTaskModifier(taskName: json['taskName'] as String);
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'taskName': taskName,
    };
  }

  @override
  void modify() {
    final task = Game.getInstance().getTask(taskName);
    if (task != null) {
      task.enabled = true;
      Game.notifier.notifyListeners();
    }
  }

  @override
  String info() {
    return "Aktiviert: $taskName";
  }
}

class DisableTaskModifier extends Modifier {
  final String taskName;

  DisableTaskModifier({required this.taskName})
      : super(
          name: "DisableTask",
          description: "Deaktiviert einen Task (Schloss-Symbol).",
        );

  factory DisableTaskModifier.fromJson(Map<String, dynamic> json) {
    return DisableTaskModifier(taskName: json['taskName'] as String);
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'taskName': taskName,
    };
  }

  @override
  void modify() {
    final task = Game.getInstance().getTask(taskName);
    if (task != null) {
      task.enabled = false;
      Game.notifier.notifyListeners();
    }
  }

  @override
  String info() {
    return "Deaktiviert: $taskName";
  }
}
