import 'package:flutter/material.dart';
import 'package:save_the_world_flutter_app/models/game.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/ressource.model.dart';
import 'package:save_the_world_flutter_app/models/task.model.dart';
import 'package:save_the_world_flutter_app/widgets/ressourcetable.item.dart';
import 'package:save_the_world_flutter_app/widgets/task.info.dart';

class TaskProgressIndicator extends StatefulWidget {
  final Task task;

  const TaskProgressIndicator({super.key, required this.task});

  @override
  TaskProgressIndicatorState createState() => TaskProgressIndicatorState();
}

class TaskProgressIndicatorState extends State<TaskProgressIndicator> {
  @override
  void initState() {
    super.initState();
    widget.task.controller.addListener(_onAnimationTick);
  }

  @override
  void didUpdateWidget(TaskProgressIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.task != widget.task) {
      oldWidget.task.controller.removeListener(_onAnimationTick);
      widget.task.controller.addListener(_onAnimationTick);
    }
  }

  @override
  void dispose() {
    widget.task.controller.removeListener(_onAnimationTick);
    super.dispose();
  }

  void _onAnimationTick() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    Color? backgroundColor;
    Color? valueColor;

    if (widget.task.controller.status == AnimationStatus.dismissed) {
      backgroundColor = Colors.transparent;
    } else if (widget.task.controller.status == AnimationStatus.reverse) {
      valueColor = Colors.redAccent;
    } else {
      valueColor = Theme.of(context).primaryColor;
    }

    return LinearProgressIndicator(
      value: widget.task.controller.value,
      backgroundColor: backgroundColor ?? Colors.grey[200],
      valueColor: valueColor != null ? AlwaysStoppedAnimation<Color>(valueColor) : null,
      minHeight: 4,
    );
  }
}

class TaskItem extends StatefulWidget {
  final Task task;

  TaskItem({required this.task}) : super(key: ObjectKey(task));

  @override
  TaskItemState createState() => TaskItemState();
}

class TaskItemState extends State<TaskItem> {
  final List<Ressource> _listenedResources = [];

  @override
  void initState() {
    super.initState();
    _updateListeners();
  }

  @override
  void didUpdateWidget(TaskItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.task != widget.task) {
      _removeListeners();
      _updateListeners();
    }
  }

  @override
  void dispose() {
    _removeListeners();
    super.dispose();
  }

  void _updateListeners() {
    for (var costRes in widget.task.cost) {
      final globalRes = Game.ressources[costRes.name];
      if (globalRes != null) {
        globalRes.addListener(_onResourceChanged);
        _listenedResources.add(globalRes);
      }
    }
  }

  void _removeListeners() {
    for (var res in _listenedResources) {
      res.removeListener(_onResourceChanged);
    }
    _listenedResources.clear();
  }

  void _onResourceChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  bool get _canAfford {
    for (var costRes in widget.task.cost) {
      final gameRes = Game.ressources[costRes.name];
      if (gameRes == null || !gameRes.canSubtract(costRes)) {
        return false;
      }
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final bool isMilestone = widget.task.isMilestone;
    final bool canAfford = _canAfford;
    final bool isRunning = widget.task.controller.isAnimating;

    return Opacity(
      opacity: (canAfford || isRunning) ? 1.0 : 0.6,
      child: Card(
        elevation: isMilestone ? 4 : 2,
        margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
          side: isMilestone 
            ? const BorderSide(color: Colors.amber, width: 2.0) 
            : (canAfford ? BorderSide.none : BorderSide(color: Colors.red.withOpacity(0.3))),
        ),
        child: Container(
          decoration: isMilestone ? BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.amber.withOpacity(0.05), Colors.white],
            ),
          ) : null,
          child: InkWell(
            onTap: canAfford ? _handleTap : null,
            onLongPress: () => showTaskInfo(context, widget.task),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(8.0, 12.0, 8.0, 12.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        width: 75,
                        child: RessourceTable(ressourceList: widget.task.cost, size: 24.0),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                if (isMilestone) 
                                  const Padding(
                                    padding: EdgeInsets.only(right: 4.0),
                                    child: Icon(Icons.star, color: Colors.amber, size: 16),
                                  ),
                                Expanded(
                                  child: Text(
                                    widget.task.name,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold, 
                                      fontSize: 15,
                                      color: isMilestone ? Colors.orange[900] : Colors.black,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 2),
                            Text(
                              widget.task.description,
                              style: TextStyle(color: Colors.grey[700], fontSize: 12),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      SizedBox(
                        width: 75,
                        child: RessourceTable(ressourceList: widget.task.award, size: 24.0),
                      ),
                    ],
                  ),
                ),
                TaskProgressIndicator(task: widget.task),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleTap() {
    if (_canAfford) {
      widget.task.start();
    }
  }
}
