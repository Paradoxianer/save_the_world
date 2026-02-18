import 'package:flutter/material.dart';
import 'package:save_the_world_flutter_app/models/game.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/ressource.model.dart';
import 'package:save_the_world_flutter_app/models/task.model.dart';
import 'package:save_the_world_flutter_app/widgets/ressourcetable.item.dart';
import 'package:save_the_world_flutter_app/widgets/task.info.dart';
import 'package:save_the_world_flutter_app/widgets/wavy_task_painter.dart';
import 'package:save_the_world_flutter_app/models/message.modifier.dart';
import 'package:save_the_world_flutter_app/models/addtask.model.dart';

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

  // ENHANCED: Now listens to cost AND dynamic award dependencies
  void _updateListeners() {
    // Listen to cost resources for afford-check
    for (var costRes in widget.task.cost) {
      final globalRes = Game.ressources[costRes.name];
      if (globalRes != null) {
        globalRes.addListener(_onResourceChanged);
        _listenedResources.add(globalRes);
      }
    }

    // Listen to multiplier resources for dynamic award display
    for (var awardRes in widget.task.award) {
      if (awardRes.multiplierResourceName != null) {
        final factorRes = Game.ressources[awardRes.multiplierResourceName!];
        // Ensure we don't add the same listener twice
        if (factorRes != null && !_listenedResources.contains(factorRes)) {
          factorRes.addListener(_onResourceChanged);
          _listenedResources.add(factorRes);
        }
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
    if (_canAfford && widget.task.enabled) {
      _clickController.forward().then((_) => _clickController.reverse());
      Game.getInstance().recordClick();
      widget.task.start();
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isMilestone = widget.task.isMilestone;
    final bool canAfford = _canAfford;
    final bool isEnabled = widget.task.enabled;
    final bool isRunning = widget.task.controller.isAnimating || widget.task.controller.value > 0;
    
    final bool isReverse = widget.task.controller.status == AnimationStatus.reverse;
    final Color progressColor = isReverse 
        ? Colors.redAccent 
        : (isMilestone ? const Color(0xFFFFD700) : Theme.of(context).primaryColor);
    
    final FillDirection direction = isReverse ? FillDirection.rightToLeft : FillDirection.leftToRight;

    final double displayProgress = isReverse 
        ? (1.0 - widget.task.controller.value) 
        : widget.task.controller.value;

    // Minimalistic Modifier Icons
    final bool hasMessage = widget.task.myModifier.any((m) => m is MessageModifier);
    final bool hasSpecialEffect = widget.task.myModifier.any((m) => m is AddTaskModifier || m.name != "MessageModifier");

    return GestureDetector(
      onTap: (canAfford && isEnabled) ? _handleTap : null,
      onLongPress: () => showTaskInfo(context, widget.task),
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Opacity(
          opacity: (isEnabled && (canAfford || isRunning)) ? 1.0 : 0.5,
          child: Card(
            elevation: isMilestone ? 6 : 2, 
            margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
            clipBehavior: Clip.antiAlias,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
              side: BorderSide(
                color: isMilestone ? Colors.orange[800]! : Colors.black87, 
                width: isMilestone ? 2.5 : 1.5, 
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
                                    child: Icon(Icons.stars, color: Colors.orange, size: 20),
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
                                if (hasMessage) 
                                  const Icon(Icons.chat_bubble_outline, size: 14, color: Colors.blueAccent),
                                if (hasSpecialEffect) 
                                  const Padding(
                                    padding: EdgeInsets.only(left: 4),
                                    child: Icon(Icons.auto_awesome, size: 14, color: Colors.purpleAccent),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              widget.task.description,
                              style: TextStyle(
                                color: isEnabled ? Colors.grey[900] : Colors.grey[600], 
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                fontStyle: isEnabled ? FontStyle.normal : FontStyle.italic,
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

                // LOCK OVERLAY
                if (!isEnabled)
                  Positioned.fill(
                    child: Container(
                      color: Colors.black.withOpacity(0.1),
                      child: const Center(
                        child: Icon(Icons.lock_outline, color: Colors.black54, size: 28),
                      ),
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
