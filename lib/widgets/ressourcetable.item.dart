import 'package:flutter/material.dart';
import 'package:save_the_world_flutter_app/models/game.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/ressource.model.dart';
import 'package:save_the_world_flutter_app/widgets/ressource.item.dart';

class RessourceTable extends StatefulWidget {
  final List<Ressource> ressourceList;
  final int rows;
  final double size;
  final bool isGlobal; // Flag to indicate if this is the AppBar table

  const RessourceTable({
    super.key,
    required this.ressourceList,
    this.rows = 2,
    this.size = 20.0,
    this.isGlobal = false,
  });

  @override
  State<RessourceTable> createState() => _RessourceTableState();
}

class _RessourceTableState extends State<RessourceTable> {
  
  @override
  void initState() {
    super.initState();
    _subscribeToResources(widget.ressourceList);
    Game.notifier.addListener(_refresh);
  }

  @override
  void didUpdateWidget(RessourceTable oldWidget) {
    super.didUpdateWidget(oldWidget);
    _unsubscribeFromResources(oldWidget.ressourceList);
    _subscribeToResources(widget.ressourceList);
  }

  @override
  void dispose() {
    _unsubscribeFromResources(widget.ressourceList);
    Game.notifier.removeListener(_refresh);
    super.dispose();
  }

  void _subscribeToResources(List<Ressource> list) {
    for (var res in list) {
      res.addListener(_refresh);
    }
  }

  void _unsubscribeFromResources(List<Ressource> list) {
    for (var res in list) {
      res.removeListener(_refresh);
    }
  }

  void _refresh() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.ressourceList.isEmpty) return const SizedBox.shrink();

    final int columnCount = (widget.ressourceList.length / widget.rows).ceil();
    final List<TableRow> tableRows = [];

    for (var i = 0; i < widget.rows; i++) {
      tableRows.add(_buildRow(i, columnCount));
    }

    return Table(
      defaultColumnWidth: FixedColumnWidth(widget.size + 15.0),
      children: tableRows,
    );
  }

  TableRow _buildRow(int row, int columnCount) {
    final List<Widget> cells = [];
    final int start = row * columnCount;
    final int end = start + columnCount;

    for (var i = start; i < end; i++) {
      if (i < widget.ressourceList.length) {
        cells.add(
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 2.0),
            // PASS THE GLOBAL FLAG DOWN
            child: RessourceItem(widget.ressourceList[i], size: widget.size, isGlobal: widget.isGlobal),
          )
        );
      } else {
        cells.add(const SizedBox.shrink());
      }
    }
    return TableRow(children: cells);
  }
}
