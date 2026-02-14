import 'package:save_the_world_flutter_app/models/task.model.dart';

class Stage {
  final int level;
  final int member;
  final String description;
  final List<String> activeTasks;
  final List<String> randomTasks;
  final List<Task> allTasks;

  Stage({
    required this.level,
    this.member = 0,
    this.description = "",
    this.activeTasks = const [],
    this.randomTasks = const [],
    this.allTasks = const [],
  });
}
