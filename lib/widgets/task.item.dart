import 'package:flutter/material.dart';
import 'package:save_the_world_flutter_app/models/task.model.dart';
import 'package:save_the_world_flutter_app/widgets/ressourcetable.item.dart';

class TaskItem extends StatelessWidget {
  final Task task;

  const TaskItem({this.task});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: RessourceTable(ressourceList: task.cost),
      title: Text(task.name),
      subtitle: Text(task.description),
      trailing: RessourceTable(ressourceList: task.award),
    );
  }
}