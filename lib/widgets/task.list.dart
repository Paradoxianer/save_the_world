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
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Text("📢", style: TextStyle(fontSize: 24)),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    snackbarMessage.toUpperCase(),
                    style: const TextStyle(
                      fontWeight: FontWeight.w900, // w900 entspricht 'black' und ist kompatibler
                      color: Colors.white,
                      letterSpacing: 0.5,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
            backgroundColor: Colors.blueAccent,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 6),
            margin: const EdgeInsets.fromLTRB(16, 0, 16, 80),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
              side: const BorderSide(color: Colors.black, width: 2.5),
            ),
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
