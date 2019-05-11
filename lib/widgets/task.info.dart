import 'package:flutter/material.dart';
import 'package:save_the_world_flutter_app/models/task.model.dart';
import 'package:save_the_world_flutter_app/widgets/ressourcetable.item.dart';

void showTaskInfo(BuildContext context, Task tsk) {
  showDialog(
      context: context,
      barrierDismissible: true, // user must tap button for close dialog!
      builder: (BuildContext context) {
        return SimpleDialog(
            title: Text(tsk.name),
            contentPadding: EdgeInsets.all(6.0),
            children: <Widget>[
              Column(
                children: <Widget>[
                  Text(tsk.description),
                  SingleChildScrollView(
                    child: Table(
                      children: <TableRow>[
                        TableRow(children: <Widget>[
                          Text("Dauer:"),
                          Text(tsk.duration.toString())
                        ]),
                        TableRow(children: <Widget>[
                          Text("Zeit zum lösen:"),
                          Text(tsk.timeToSolve.toString()),
                        ]),
                        TableRow(children: <Widget>[
                          Text("Kosten:"),
                          RessourceTable(ressourceList: tsk.cost)
                        ]),
                        TableRow(children: <Widget>[
                          Text("Belohnung:"),
                          RessourceTable(ressourceList: tsk.award)
                        ]),
                        TableRow(children: <Widget>[
                          Text("Verpasst:"),
                          Column(
                              children: tsk.missed
                                  .map(
                                      (mm) => new Text(mm.name, softWrap: true))
                                  .toList())
                        ]),
                        TableRow(children: <Widget>[
                          Text("erfüllt:"),
                          Column(
                              children: tsk.myModifier
                                  .map((mm) =>
                              new Text(
                                mm.name,
                                softWrap: true,
                              ))
                                  .toList())
                        ])
                      ],
                    ),
                  )
                ],
              )
            ]);
      });
}
