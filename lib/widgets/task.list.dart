import 'package:flutter/material.dart';
import 'package:save_the_world_flutter_app/models/game.ressource.model.dart';
import 'package:save_the_world_flutter_app/widgets/task.item.dart';

class TaskList extends StatefulWidget {
  @override
  TaskListState createState() => TaskListState();
}

class TaskListState extends State<TaskList> {
  TaskListState();

  @override
  void initState() {
    super.initState();
    print("addListener valueChanged");
    Game.getInstance().addListener(valueChanged);
  }

  @override
  void dispose() {
    super.dispose();
    Game.getInstance().removeListener(valueChanged());
  }

  valueChanged() {
    if (Game
        .getInstance()
        .snackbarMessage != null) {
      Scaffold.of(context).showSnackBar(
          SnackBar(
            content: Text(Game
                .getInstance()
                .snackbarMessage),
            backgroundColor: Color.fromRGBO(180, 70, 70, 0.6),
          )
      );
    }
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
