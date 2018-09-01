import 'package:flutter/material.dart';
import 'package:save_the_world_flutter_app/RessourceTable.dart';
import 'package:save_the_world_flutter_app/models/task.model.dart';

class TaskItem extends StatelessWidget {
  final Task task;

  const TaskItem({this.task});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: RessourceTable(task.award),
      title: Text(task.name),
      subtitle: Text(task.description),
      trailing: RessourceTable(task.cost)
    ),
  }
}