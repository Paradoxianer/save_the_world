import 'package:flutter/material.dart';
import 'package:save_the_world_flutter_app/models/game.ressource.model.dart';
import 'package:save_the_world_flutter_app/widgets/task.item.dart';

class TaskList extends StatefulWidget {
  const TaskList({super.key});

  @override
  TaskListState createState() => TaskListState();
}

class TaskListState extends State<TaskList> {
  @override
  void initState() {
    super.initState();
    // We only listen to Game.notifier which triggers when tasks are added/removed
    Game.notifier.addListener(_tasksChanged);
  }

  @override
  void dispose() {
    Game.notifier.removeListener(_tasksChanged);
    super.dispose();
  }

  void _tasksChanged() {
    if (!mounted) return;
    
    // Handle snackbar messages if any (kept logic from previous version)
    final snackbarMessage = Game.getInstance().snackbarMessage;
    if (snackbarMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(snackbarMessage),
            backgroundColor: const Color.fromRGBO(180, 70, 70, 0.6),
          )
      );
      Game.getInstance().snackbarMessage = null;
    }
    
    // Rebuild only when the task list itself changes
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (BuildContext context, int index) =>
          TaskItem(task: Game.tasks[index]),
      itemCount: Game.tasks.length,
    );
  }
}
