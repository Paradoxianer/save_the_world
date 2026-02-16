import 'package:flutter/material.dart';
import 'package:save_the_world_flutter_app/models/game.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/ressource.model.dart';
import 'package:save_the_world_flutter_app/widgets/ressource.item.dart';

class RessourceTable extends StatefulWidget {
  final List<Ressource> ressourceList;
  final int rows = 2;
  final double size;

  const RessourceTable({
    super.key,
    required this.ressourceList,
    this.size = 20.0,
  });

  @override
  State<RessourceTable> createState() => _RessourceTableState();
}

class _RessourceTableState extends State<RessourceTable> {
  @override
  void initState() {
    super.initState();
    Game.notifier.addListener(_refresh);
  }

  @override
  void dispose() {
    Game.notifier.removeListener(_refresh);
    super.dispose();
  }

  void _refresh() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // We always use the passed list, but for the AppBar we might want to ensure 
    // we have the latest objects from Game.ressources if this is a global display.
    // However, the caller (main.dart) already passes Game.ressources.values.toList().
    
    if (widget.ressourceList.isEmpty) return const SizedBox.shrink();

    final int columnCount = (widget.ressourceList.length / widget.rows).ceil();
    final List<TableRow> tableRows = [];

    for (var i = 0; i < widget.rows; i++) {
      tableRows.add(_buildRow(i, columnCount));
    }

    return Table(
      defaultColumnWidth: FixedColumnWidth(widget.size + 5.0),
      children: tableRows,
    );
  }

  TableRow _buildRow(int row, int columnCount) {
    final List<Widget> cells = [];
    final int start = row * columnCount;
    final int end = start + columnCount;

    for (var i = start; i < end; i++) {
      if (i < widget.ressourceList.length) {
        cells.add(RessourceItem(widget.ressourceList[i], size: widget.size));
      } else {
        cells.add(const SizedBox.shrink());
      }
    }
    return TableRow(children: cells);
  }
}
