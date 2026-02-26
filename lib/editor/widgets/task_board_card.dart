import 'package:flutter/material.dart';
import 'package:save_the_world_flutter_app/models/task.model.dart';
import 'package:save_the_world_flutter_app/models/ressource.model.dart';
import 'package:save_the_world_flutter_app/models/modifier.model.dart';
import 'package:save_the_world_flutter_app/models/addtask.model.dart';
import 'package:save_the_world_flutter_app/models/removetask.model.dart';

class TaskBoardCard extends StatelessWidget {
  final Task task;
  final bool isPrimarySelection;
  final bool isSecondarySelection;
  final bool isProtected;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;
  final Widget? dragHandle;

  const TaskBoardCard({
    super.key,
    required this.task,
    this.isPrimarySelection = false,
    this.isSecondarySelection = false,
    this.isProtected = false,
    this.onTap,
    this.onDelete,
    this.dragHandle,
  });

  @override
  Widget build(BuildContext context) {
    final bool isMilestone = task.isMilestone;
    final bool isCrisis = task.timeToSolve != double.infinity;
    
    const Color selectionColor = Colors.cyanAccent;
    final Color syncColor = Colors.cyanAccent.withOpacity(0.15);
    const Color crisisColor = Colors.redAccent;

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
                    : (isCrisis ? crisisColor.withOpacity(0.6) : (isMilestone ? Colors.amber.withOpacity(0.6) : Colors.white10))),
            width: isPrimarySelection ? 2.0 : 1.0,
          ),
          boxShadow: isPrimarySelection 
              ? [BoxShadow(color: selectionColor.withOpacity(0.3), blurRadius: 12)] 
              : (isCrisis ? [BoxShadow(color: crisisColor.withOpacity(0.1), blurRadius: 4)] : []),
        ),
        child: _buildBody(isMilestone, isCrisis, crisisColor),
      ),
    );
  }

  Widget _buildBody(bool isMilestone, bool isCrisis, Color crisisColor) {
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(dragHandle != null ? 36 : 12, 12, 36, 12),
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
                        color: isPrimarySelection ? Colors.cyanAccent : (isCrisis ? crisisColor : (isMilestone ? Colors.amber : Colors.white))
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
        // Handle links
        if (dragHandle != null)
          Positioned(left: 4, top: 0, bottom: 0, child: dragHandle!),
        
        // Delete oben rechts
        if (onDelete != null && !isProtected)
          Positioned(
            right: 4, 
            top: 0, 
            bottom: 0,
            child: Center(
              child: IconButton(
                icon: const Icon(Icons.close, size: 16, color: Colors.white30),
                onPressed: onDelete,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ),
          ),
          
        if (isCrisis)
          Positioned(left: dragHandle != null ? 18 : 4, top: 12, child: Icon(Icons.warning_amber_rounded, size: 12, color: crisisColor)),
      ],
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
