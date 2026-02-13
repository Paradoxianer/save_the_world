import 'package:save_the_world_flutter_app/models/task.model.dart';

class Stage {
  int level;
  int member;
  String description;
  List<String> activeTasks;
  List<String> randomTasks;
  List<Task> allTasks;

  Stage({this.level, this.activeTasks, this.randomTasks, this.allTasks});
}
