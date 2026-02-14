import 'package:flutter/material.dart';
import 'package:save_the_world_flutter_app/models/ressource.model.dart';
import 'package:save_the_world_flutter_app/widgets/ressource.item.dart';

class RessourceTable extends StatelessWidget {
  final List<Ressource> ressourceList;
  final int rows = 2;
  final double size;

  const RessourceTable({
    super.key,
    required this.ressourceList,
    this.size = 20.0,
  });

  @override
  Widget build(BuildContext context) {
    if (ressourceList.isEmpty) return const SizedBox.shrink();

    final int columnCount = (ressourceList.length / rows).ceil();
    final List<TableRow> tableRows = [];

    for (var i = 0; i < rows; i++) {
      tableRows.add(_buildRow(i, columnCount));
    }

    return Table(
      defaultColumnWidth: FixedColumnWidth(size + 5.0),
      children: tableRows,
    );
  }

  TableRow _buildRow(int row, int columnCount) {
    final List<Widget> cells = [];
    final int start = row * columnCount;
    final int end = start + columnCount;

    for (var i = start; i < end; i++) {
      if (i < ressourceList.length) {
        cells.add(RessourceItem(ressourceList[i], size: size));
      } else {
        cells.add(const SizedBox.shrink());
      }
    }
    return TableRow(children: cells);
  }
}
