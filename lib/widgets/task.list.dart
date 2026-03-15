import 'package:flutter/material.dart';
import 'package:save_the_world_flutter_app/models/game.ressource.model.dart';
import 'package:save_the_world_flutter_app/widgets/task.item.dart';
import 'package:save_the_world_flutter_app/widgets/comic_snackbar.dart';

class TaskList extends StatefulWidget {
  const TaskList({super.key});

  @override
  TaskListState createState() => TaskListState();
}

class TaskListState extends State<TaskList> {
  @override
  void initState() {
    super.initState();
    Game.notifier.addListener(_tasksChanged);
  }

  @override
  void dispose() {
    Game.notifier.removeListener(_tasksChanged);
    super.dispose();
  }

  void _tasksChanged() {
    if (!mounted) return;
    
    final snackbarMessage = Game.getInstance().snackbarMessage;
    if (snackbarMessage != null) {
      ComicSnackBar.show(context, snackbarMessage);
      Game.getInstance().snackbarMessage = null;
    }
    
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      // Padding am Ende, damit der letzte Task nicht von der Snackbar verdeckt wird
      padding: const EdgeInsets.fromLTRB(0, 8, 0, 120),
      itemBuilder: (BuildContext context, int index) =>
          TaskItem(task: Game.tasks[index]),
      itemCount: Game.tasks.length,
    );
  }
}
