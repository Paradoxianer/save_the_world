import 'package:flutter/material.dart';
import 'package:save_the_world_flutter_app/models/modifier.model.dart';

class ModifierTable extends StatelessWidget {
  final List<Modifier> modifierList;

  const ModifierTable({super.key, this.modifierList = const []});

  @override
  Widget build(BuildContext context) {
    if (modifierList.isNotEmpty) {
      final List<TableRow> rows = [];
      for (var modifier in modifierList) {
        rows.add(_buildRow(modifier));
      }
      return Table(children: rows);
    } else {
      return const Text("--");
    }
  }

  TableRow _buildRow(Modifier? modifier) {
    return TableRow(
      children: <Widget>[
        Text(modifier?.info() ?? "---"),
      ],
    );
  }
}
