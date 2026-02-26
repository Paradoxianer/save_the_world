import 'package:flutter/material.dart';
import 'package:save_the_world_flutter_app/models/task.model.dart';
import 'package:save_the_world_flutter_app/models/ressource.model.dart';
import 'package:save_the_world_flutter_app/models/modifier.model.dart';
import 'package:save_the_world_flutter_app/models/addtask.model.dart';
import 'package:save_the_world_flutter_app/models/removetask.model.dart';
import 'package:save_the_world_flutter_app/models/AddToRandom.model.dart';

class TaskBoardCard extends StatelessWidget {
  final Task task;
  final bool isPrimarySelection;   // Das exakt angeklickte Item
  final bool isSecondarySelection; // Ein Item mit gleichem Namen woanders
  final bool isProtected;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;
  final Function(String)? onMoveToStart;
  final Function(String)? onMoveToRandom;
  final Function(String)? onRemoveFromLists;

  const TaskBoardCard({
    super.key,
    required this.task,
    this.isPrimarySelection = false,
    this.isSecondarySelection = false,
    this.isProtected = false,
    this.onTap,
    this.onDelete,
    this.onMoveToStart,
    this.onMoveToRandom,
    this.onRemoveFromLists,
  });

  @override
  Widget build(BuildContext context) {
    final bool isMilestone = task.isMilestone;
    
    // Farbwahl: Blau/Indigo für Selektion statt Amber
    final Color selectionColor = Colors.cyanAccent;
    final Color syncColor = Colors.cyanAccent.withOpacity(0.15);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: isPrimarySelection 
              ? selectionColor.withOpacity(0.2) 
              : (isSecondarySelection 
                  ? syncColor 
                  : (isMilestone ? Colors.amber.withOpacity(0.08) : const Color(0xFF1E1E1E))),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isPrimarySelection 
                ? selectionColor 
                : (isSecondarySelection 
                    ? selectionColor.withOpacity(0.4)
                    : (isMilestone ? Colors.amber.withOpacity(0.6) : Colors.white10)),
            width: isPrimarySelection ? 2.0 : 1.0,
          ),
          boxShadow: isPrimarySelection 
              ? [BoxShadow(color: selectionColor.withOpacity(0.3), blurRadius: 12)] 
              : (isMilestone ? [BoxShadow(color: Colors.amber.withOpacity(0.1), blurRadius: 4)] : []),
        ),
        child: Column(
          children: [
            _buildHeader(isMilestone),
            if (isPrimarySelection && !isProtected) _buildActionToolbar(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(bool isMilestone) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 12, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _buildMiniResList(task.cost, Colors.redAccent),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      task.name, 
                      style: TextStyle(
                        fontWeight: FontWeight.bold, 
                        fontSize: 12, 
                        color: isPrimarySelection ? Colors.cyanAccent : (isMilestone ? Colors.amber : Colors.white)
                      ), 
                      overflow: TextOverflow.ellipsis
                    )
                  ),
                  const SizedBox(width: 8),
                  _buildMiniResList(task.award, Colors.greenAccent),
                ],
              ),
              if (task.myModifier.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Wrap(spacing: 4, children: task.myModifier.map((m) => _buildModBadge(m)).toList()),
                ),
            ],
          ),
        ),
        if (onDelete != null)
          Positioned(right: 0, top: 0, child: IconButton(icon: const Icon(Icons.close, size: 14, color: Colors.white24), onPressed: onDelete)),
      ],
    );
  }

  Widget _buildActionToolbar() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.black26, 
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(8))
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(icon: const Icon(Icons.play_circle_outline, size: 16, color: Colors.green), tooltip: 'Start Task', onPressed: () => onMoveToStart?.call(task.name)),
          IconButton(icon: const Icon(Icons.shuffle, size: 16, color: Colors.orange), tooltip: 'Random Event', onPressed: () => onMoveToRandom?.call(task.name)),
          IconButton(icon: const Icon(Icons.link_off, size: 16, color: Colors.grey), tooltip: 'Hidden/Chained', onPressed: () => onRemoveFromLists?.call(task.name)),
        ],
      ),
    );
  }

  Widget _buildMiniResList(List<Ressource> list, Color color) {
    return Row(mainAxisSize: MainAxisSize.min, children: list.map((r) => Icon(_getResIcon(r.name), size: 10, color: color)).toList());
  }

  Widget _buildModBadge(Modifier m) {
    String txt = m.name.substring(0, 3);
    if (m is AddTask) txt = "+ ${m.nameOfTask.split(" ").first}";
    if (m is RemoveTask) txt = "- ${m.nameOfTask.split(" ").first}";
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1), 
      decoration: BoxDecoration(color: Colors.black45, borderRadius: BorderRadius.circular(4)), 
      child: Text(txt, style: const TextStyle(fontSize: 8, color: Colors.blueGrey))
    );
  }

  IconData _getResIcon(String name) {
    switch (name) {
      case "Money": return Icons.attach_money;
      case "Faith": return Icons.auto_awesome;
      case "Member": return Icons.people;
      case "Time": return Icons.access_time;
      default: return Icons.help_outline;
    }
  }
}
