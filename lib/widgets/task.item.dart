import 'package:flutter/material.dart';
import 'package:save_the_world_flutter_app/models/game.ressource.model.dart';
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
      onTap: _handleTap,
    );
  }

  void _handleTap() {
    int listSize = task.cost.length;
    for (int i = 0; i < listSize; i++) {
      Game.ressources[task.cost[i].name].subtract(task.cost[i]);
      print(Game.ressources[task.cost[i].name].name + " " + Game.ressources[task.cost[i].name].value.toString()+"\n");
      }
    task.modify();
    listSize = task.award.length;
    for (int i = 0; i < listSize; i++) {
      Game.ressources[task.award[i].name].add(task.award[i]);
      print(Game.ressources[task.award[i].name].name + " " + Game.ressources[task.award[i].name].value.toString()+"\n");
    }
    Game.tasks.remove(this);
  }
}