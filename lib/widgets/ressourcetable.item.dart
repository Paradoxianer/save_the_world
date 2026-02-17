import 'package:flutter/material.dart';
import 'package:save_the_world_flutter_app/models/game.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/ressource.model.dart';
import 'package:save_the_world_flutter_app/widgets/ressource.item.dart';

class RessourceTable extends StatefulWidget {
  final List<Ressource> ressourceList;
  final int rows;
  final double size;

  const RessourceTable({
    super.key,
    required this.ressourceList,
    this.rows = 2,
    this.size = 20.0,
  });

  @override
  State<RessourceTable> createState() => _RessourceTableState();
}

class _RessourceTableState extends State<RessourceTable> {
  
  @override
  void initState() {
    super.initState();
    _subscribeToResources(widget.ressourceList);
    // Listen to global changes (like reset or major state changes)
    Game.notifier.addListener(_refresh);
  }

  @override
  void didUpdateWidget(RessourceTable oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Always resubscribe if the list content might have changed
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

    // Use a fixed layout logic or dynamic based on available width
    final int columnCount = (widget.ressourceList.length / widget.rows).ceil();
    final List<TableRow> tableRows = [];

    for (var i = 0; i < widget.rows; i++) {
      tableRows.add(_buildRow(i, columnCount));
    }

    return Table(
      // Ensure the table doesn't overflow
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
            child: RessourceItem(widget.ressourceList[i], size: widget.size),
          )
        );
      } else {
        cells.add(const SizedBox.shrink());
      }
    }
    return TableRow(children: cells);
  }
}
