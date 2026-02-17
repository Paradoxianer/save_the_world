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
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(snackbarMessage, style: const TextStyle(fontWeight: FontWeight.bold)),
            backgroundColor: const Color.fromRGBO(180, 70, 70, 0.9),
            behavior: SnackBarBehavior.floating, // Fits the cartoon look better
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          )
      );
      Game.getInstance().snackbarMessage = null;
    }
    
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      // ADDED: Bottom padding to ensure the last task is not covered by snackbars or UI elements
      padding: const EdgeInsets.fromLTRB(0, 8, 0, 100),
      itemBuilder: (BuildContext context, int index) =>
          TaskItem(task: Game.tasks[index]),
      itemCount: Game.tasks.length,
    );
  }
}
