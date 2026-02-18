import 'package:flutter/material.dart';
import 'package:save_the_world_flutter_app/models/game.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/ressource.model.dart';
import 'package:save_the_world_flutter_app/models/task.model.dart';
import 'package:save_the_world_flutter_app/widgets/ressourcetable.item.dart';
import 'package:save_the_world_flutter_app/widgets/task.info.dart';
import 'package:save_the_world_flutter_app/widgets/wavy_task_painter.dart';

class TaskItem extends StatefulWidget {
  final Task task;

  TaskItem({required this.task}) : super(key: ObjectKey(task));

  @override
  TaskItemState createState() => TaskItemState();
}

class TaskItemState extends State<TaskItem> with SingleTickerProviderStateMixin {
  final List<Ressource> _listenedResources = [];
  late AnimationController _clickController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _updateListeners();
    widget.task.controller.addListener(_onAnimationTick);
    
    // CLICK FEEDBACK CONTROLLER: Very fast bounce
    _clickController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 60),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.92).animate(
      CurvedAnimation(parent: _clickController, curve: Curves.easeOutCubic),
    );
  }

  @override
  void didUpdateWidget(TaskItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.task != widget.task) {
      _removeListeners();
      _updateListeners();
      oldWidget.task.controller.removeListener(_onAnimationTick);
      widget.task.controller.addListener(_onAnimationTick);
    }
  }

  @override
  void dispose() {
    _removeListeners();
    widget.task.controller.removeListener(_onAnimationTick);
    _clickController.dispose();
    super.dispose();
  }

  void _onAnimationTick() {
    if (mounted) {
      setState(() {});
    }
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

  void _handleTap() async {
    if (_canAfford) {
      // VISUAL BOUNCE: Always play the full animation regardless of touch duration
      _clickController.forward().then((_) => _clickController.reverse());
      
      // RECORD THE CLICK IN GAME MODEL
      Game.getInstance().recordClick();
      
      // Start the task
      widget.task.start();
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isMilestone = widget.task.isMilestone;
    final bool canAfford = _canAfford;
    final bool isRunning = widget.task.controller.isAnimating || widget.task.controller.value > 0;
    
    final bool isReverse = widget.task.controller.status == AnimationStatus.reverse;
    final Color progressColor = isReverse 
        ? Colors.redAccent 
        : (isMilestone ? const Color(0xFFFFD700) : Theme.of(context).primaryColor);
    
    final FillDirection direction = isReverse ? FillDirection.rightToLeft : FillDirection.leftToRight;

    final double displayProgress = isReverse 
        ? (1.0 - widget.task.controller.value) 
        : widget.task.controller.value;

    return GestureDetector(
      // Only trigger logic on tap, animation is now handled in _handleTap
      onTap: canAfford ? _handleTap : null,
      onLongPress: () => showTaskInfo(context, widget.task),
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Opacity(
          opacity: (canAfford || isRunning) ? 1.0 : 0.6,
          child: Card(
            elevation: isMilestone ? 6 : 2, 
            margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
            clipBehavior: Clip.antiAlias,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
              side: BorderSide(
                color: isMilestone ? Colors.orange[800]! : Colors.black87, 
                width: 1.5, 
              ),
            ),
            child: Stack(
              children: [
                Positioned.fill(
                  child: CustomPaint(
                    painter: WavyTaskPainter(
                      progress: displayProgress,
                      color: progressColor,
                      direction: direction,
                    ),
                  ),
                ),
                
                Container(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        width: 70,
                        child: RessourceTable(ressourceList: widget.task.cost, size: 22.0, isGlobal: false),
                      ),
                      const SizedBox(width: 12),
                      
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                if (isMilestone) 
                                  const Padding(
                                    padding: EdgeInsets.only(right: 6.0),
                                    child: Icon(Icons.stars, color: Colors.orange, size: 24),
                                  ),
                                Expanded(
                                  child: Text(
                                    widget.task.name.toUpperCase(),
                                    style: TextStyle(
                                      fontWeight: FontWeight.w900, 
                                      fontSize: 14,
                                      letterSpacing: 0.5,
                                      color: isMilestone ? Colors.orange[900] : Colors.black87,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              widget.task.description,
                              style: TextStyle(
                                color: Colors.grey[900], 
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      
                      SizedBox(
                        width: 70,
                        child: RessourceTable(ressourceList: widget.task.award, size: 22.0, isGlobal: false),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
