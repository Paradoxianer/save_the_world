import 'package:flutter/material.dart';
import 'package:save_the_world_flutter_app/models/game.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/task.model.dart';
import 'package:save_the_world_flutter_app/widgets/ressourcetable.item.dart';


class TaskProgressIndicator extends StatefulWidget {
  final Task task;

  TaskProgressIndicator({this.task});

  @override
  TaskProgressIndicatorState createState() =>
      new TaskProgressIndicatorState(task);
}

class TaskProgressIndicatorState extends State<TaskProgressIndicator>
    with SingleTickerProviderStateMixin {
  Task task;

  TaskProgressIndicatorState(Task task) {
    this.task = task;
  }

  @override
  void initState() {
    super.initState();
    task.controller.addListener(listen);
  }

  @override
  void dispose() {
    super.dispose();
    task.controller.removeListener(listen);
  }

  @override
  Widget build(BuildContext context) {
    LinearProgressIndicator progressIndicator;
    if (task.controller.status == AnimationStatus.dismissed) {
      progressIndicator = new LinearProgressIndicator(
          value: task.controller.value,
          backgroundColor: Colors.white
      );
    }
    else {
      if (task.controller.status == AnimationStatus.reverse) {
        progressIndicator = new LinearProgressIndicator(
          value: task.controller.value,
          backgroundColor: Colors.redAccent,
        );
      }
      else
        progressIndicator =
        new LinearProgressIndicator(value: task.controller.value);
    }
    return progressIndicator;
  }

  listen() {
    setState(() {});
  }

}



class TaskItem extends StatelessWidget {
  final Task task;

  const TaskItem({this.task});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(6.0),
      child: Column(
        children: <Widget>[
          ListTile(
            contentPadding: EdgeInsets.all(0.0),
            leading: RessourceTable(ressourceList: task.cost),
            title: Text(task.name),
            subtitle: Text(task.description),
            trailing: RessourceTable(ressourceList: task.award),
            onTap: _handleTap,
          ),
          TaskProgressIndicator(task: task)
        ],
      ),
    );
  }

  void _handleTap() {
    int listSize = task.cost.length;
    bool canDo = true;
    for (int i = 0; i < listSize; i++) {
      canDo =
          canDo && Game.ressources[task.cost[i].name].canSubtract(task.cost[i]);
    }
    if (canDo == true) {
      task.start();
    }
    else {
      print("to less ressources");
    }
  }
}