import 'package:flutter/material.dart';
import 'package:save_the_world_flutter_app/models/game.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/task.model.dart';
import 'package:save_the_world_flutter_app/widgets/ressourcetable.item.dart';
import 'package:save_the_world_flutter_app/widgets/task.info.dart';

class TaskProgressIndicator extends StatefulWidget {
  final Task task;

  const TaskProgressIndicator({super.key, required this.task});

  @override
  TaskProgressIndicatorState createState() => TaskProgressIndicatorState();
}

class TaskProgressIndicatorState extends State<TaskProgressIndicator> {
  @override
  void initState() {
    super.initState();
    widget.task.controller.addListener(_onAnimationTick);
  }

  @override
  void dispose() {
    widget.task.controller.removeListener(_onAnimationTick);
    super.dispose();
  }

  void _onAnimationTick() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    Color? backgroundColor;
    Color? valueColor;

    if (widget.task.controller.status == AnimationStatus.dismissed) {
      backgroundColor = Colors.white;
    } else if (widget.task.controller.status == AnimationStatus.reverse) {
      valueColor = Colors.redAccent;
    }

    return LinearProgressIndicator(
      value: widget.task.controller.value,
      backgroundColor: backgroundColor,
      valueColor: valueColor != null ? AlwaysStoppedAnimation<Color>(valueColor) : null,
    );
  }
}

class TaskItem extends StatelessWidget {
  final Task task;

  TaskItem({required this.task}) : super(key: ObjectKey(task));

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(6.0),
      child: Column(
        children: <Widget>[
          ListTile(
            contentPadding: const EdgeInsets.all(1.0),
            leading: RessourceTable(ressourceList: task.cost),
            title: Text(task.name),
            subtitle: Text(task.description),
            trailing: RessourceTable(ressourceList: task.award),
            onTap: _handleTap,
            onLongPress: () {
              showTaskInfo(context, task);
            },
          ),
          TaskProgressIndicator(task: task)
        ],
      ),
    );
  }

  void _handleTap() {
    bool canDo = true;
    for (var costRes in task.cost) {
      final gameRes = Game.ressources[costRes.name];
      if (gameRes == null || !gameRes.canSubtract(costRes)) {
        canDo = false;
        break;
      }
    }

    if (canDo) {
      task.start();
    } else {
      debugPrint("Not enough resources to start task: ${task.name}");
    }
  }
}
