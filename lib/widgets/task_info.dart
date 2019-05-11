import 'package:flutter/material.dart';
import 'package:save_the_world_flutter_app/models/task.model.dart';
import 'package:save_the_world_flutter_app/widgets/ressourcetable.item.dart';

void showTaskInfo(BuildContext context, Task tsk) {
  showDialog(
      context: context,
      barrierDismissible: true, // user must tap button for close dialog!
      builder: (BuildContext context) {
        return SimpleDialog(title: Text(tsk.name), children: <Widget>[
          Column(
            children: <Widget>[
              Text(tsk.description),
              Table(
                children: <TableRow>[
                  TableRow(children: <Widget>[
                    Text("Dauer:"),
                    Text(tsk.duration.toString())
                  ]),
                  TableRow(children: <Widget>[
                    Text("Zeit zum lösen:"),
                    Text(tsk.timeToSolve.toString()),
                  ])
                ],
              ),
              Row(
                children: <Widget>[
                  Text("Kosten:"),
                  RessourceTable(ressourceList: tsk.cost)
                ],
              ),
              Row(
                children: <Widget>[
                  Text("Belohnung:"),
                  RessourceTable(ressourceList: tsk.award)
                ],
              )
            ],
          )
        ]);
      });
}
