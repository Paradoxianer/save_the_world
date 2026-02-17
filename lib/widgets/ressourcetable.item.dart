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
    _subscribeToResources();
    // Also listen to global changes like adding/removing tasks/resources
    Game.notifier.addListener(_refresh);
  }

  @override
  void didUpdateWidget(RessourceTable oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.ressourceList != widget.ressourceList) {
      _unsubscribeFromResources();
      _subscribeToResources();
    }
  }

  @override
  void dispose() {
    _unsubscribeFromResources();
    Game.notifier.removeListener(_refresh);
    super.dispose();
  }

  void _subscribeToResources() {
    for (var res in widget.ressourceList) {
      res.addListener(_refresh);
    }
  }

  void _unsubscribeFromResources() {
    for (var res in widget.ressourceList) {
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
        // Note: Using a key might be necessary if list order changes dynamically,
        // but for now, this is stable.
        cells.add(RessourceItem(widget.ressourceList[i], size: widget.size));
      } else {
        cells.add(const SizedBox.shrink());
      }
    }
    return TableRow(children: cells);
  }
}
