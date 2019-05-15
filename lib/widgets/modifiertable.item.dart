import 'package:flutter/material.dart';
import 'package:save_the_world_flutter_app/models/modifier.model.dart';

class ModifierTable extends StatelessWidget {
  final List<Modifier> modifierList;

  ModifierTable({this.modifierList});

  @override
  Widget build(BuildContext context) {
    if ((modifierList != null) && (modifierList.length > 0)) {
      List<TableRow> list = new List<TableRow>();
      for (var i = 0; i < modifierList.length; i++) {
        list.add(returnRow(modifierList[i]));
      }
      return Table(children: list);
    } else
      return Text("--");
  }

  TableRow returnRow(modifier) {
    if (modifier != null) {
      return new TableRow(
          children: <Widget>[
            Text(modifier.info())
          ]
      );
    } else
      return new TableRow(children: <Widget>[Text("---")]);
  }
}
