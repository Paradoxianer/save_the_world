import 'package:flutter/material.dart';
import 'package:save_the_world_flutter_app/models/game.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/task.model.dart';
import 'package:save_the_world_flutter_app/models/setmax.model.dart';
import 'package:save_the_world_flutter_app/models/setmin.model.dart';
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

class TaskItem extends StatelessWidget {
  final Task task;

  TaskItem({required this.task}) : super(key: ObjectKey(task));

  @override
  Widget build(BuildContext context) {
    // Check if this task is a gatekeeper (contains SetMax or SetMin)
    final bool isGatekeeper = task.myModifier.any((m) => m is SetMax || m is SetMin);
    
    return Card(
      elevation: isGatekeeper ? 4 : 2,
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      clipBehavior: Clip.antiAlias,
      // Gold border for gatekeeper tasks
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
        side: isGatekeeper 
          ? const BorderSide(color: Colors.amber, width: 2.0) 
          : BorderSide.none,
      ),
      child: Container(
        // Subtle gold shimmer for gatekeeper tasks
        decoration: isGatekeeper ? BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.amber.withOpacity(0.05), Colors.white],
          ),
        ) : null,
        child: InkWell(
          onTap: _handleTap,
          onLongPress: () => showTaskInfo(context, task),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 12.0, 8.0, 12.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    // Left side: Costs
                    SizedBox(
                      width: 75,
                      child: RessourceTable(ressourceList: task.cost, size: 24.0),
                    ),
                    
                    const SizedBox(width: 8),
                    
                    // Center: Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              if (isGatekeeper) 
                                const Padding(
                                  padding: EdgeInsets.only(right: 4.0),
                                  child: Icon(Icons.star, color: Colors.amber, size: 16),
                                ),
                              Expanded(
                                child: Text(
                                  task.name,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold, 
                                    fontSize: 15,
                                    color: isGatekeeper ? Colors.orange[900] : Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            task.description,
                            style: TextStyle(color: Colors.grey[700], fontSize: 12),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (isGatekeeper)
                            const Padding(
                              padding: EdgeInsets.only(top: 4.0),
                              child: Text(
                                "MEILENSTEIN: Erhöht Kapazität",
                                style: TextStyle(
                                  color: Colors.amber, 
                                  fontWeight: FontWeight.bold, 
                                  fontSize: 10
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(width: 8),
                    
                    // Right side: Awards
                    SizedBox(
                      width: 75,
                      child: RessourceTable(ressourceList: task.award, size: 24.0),
                    ),
                  ],
                ),
              ),
              // Progress Bar at the very bottom, stretching full width
              TaskProgressIndicator(task: task),
            ],
          ),
        ),
      ),
    );
  }

  void _handleTap() {
    bool canDo = true;
    for (var costRes in task.cost) {
      final gameRes = Game.ressources[costRes.name];
      if (gameRes == null || !gameRes.canSubtract(costRes)) {
        canDo = false;
        break;
      }
    }

    if (canDo) {
      task.start();
    } else {
      debugPrint("Not enough resources to start task: ${task.name}");
    }
  }
}
