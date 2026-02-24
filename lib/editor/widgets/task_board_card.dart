import 'package:flutter/material.dart';
import 'package:save_the_world_flutter_app/models/task.model.dart';
import 'package:save_the_world_flutter_app/models/ressource.model.dart';
import 'package:save_the_world_flutter_app/models/modifier.model.dart';
import 'package:save_the_world_flutter_app/models/addtask.model.dart';
import 'package:save_the_world_flutter_app/models/removetask.model.dart';
import 'package:save_the_world_flutter_app/models/autoexecute.model.dart';
import 'package:save_the_world_flutter_app/models/AddToRandom.model.dart';

class TaskBoardCard extends StatelessWidget {
  final Task task;
  final bool isSelected;
  final bool isDragging;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const TaskBoardCard({
    super.key,
    required this.task,
    this.isSelected = false,
    this.isDragging = false,
    this.onTap,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: isSelected ? Colors.amber.withOpacity(0.15) : (task.isMilestone ? Colors.amber.withOpacity(0.05) : const Color(0xFF1E1E1E)),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: isSelected ? Colors.amber : (task.isMilestone ? Colors.amber.withOpacity(0.5) : Colors.white10)),
        ),
        child: Stack(
          children: [
            _buildContent(),
            if (onDelete != null)
              Positioned(right: 0, top: 0, child: IconButton(icon: const Icon(Icons.close, size: 14, color: Colors.white30), onPressed: onDelete)),
            Positioned(left: 4, top: 12, child: Icon(Icons.drag_indicator, size: 16, color: task.isMilestone ? Colors.amber : Colors.white10)),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 12, 12, 12),
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
                    color: task.isMilestone ? Colors.amber : Colors.white,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              _buildMiniResList(task.award, Colors.greenAccent),
            ],
          ),
          if (task.myModifier.isNotEmpty || (task.online?.isNotEmpty ?? false))
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Wrap(
                spacing: 4,
                runSpacing: 2,
                children: [
                  ...task.myModifier.map((m) => _buildModBadge(m, Colors.blueGrey)),
                  ...(task.online ?? []).map((m) => _buildModBadge(m, Colors.purpleAccent.withOpacity(0.5))),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildMiniResList(List<Ressource> list, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: list.map((r) => Icon(_getResIcon(r.name), size: 10, color: color)).toList(),
    );
  }

  Widget _buildModBadge(Modifier m, Color color) {
    String txt = m.name.substring(0, 3);
    if (m is AddTask) txt = "+ ${m.nameOfTask.split(" ").first}";
    if (m is RemoveTask) txt = "- ${m.nameOfTask.split(" ").first}";
    if (m is AddToRandom) txt = "🎲 ${m.nameOfTask.split(" ").first}";
    if (m is AutoExecuteModifier) txt = "⚙️ Auto";
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
      decoration: BoxDecoration(color: Colors.black45, borderRadius: BorderRadius.circular(4)),
      child: Text(txt, style: TextStyle(fontSize: 8, color: color)),
    );
  }

  IconData _getResIcon(String name) {
    switch (name) {
      case "Money": return Icons.attach_money;
      case "Faith": return Icons.auto_awesome;
      case "Member": return Icons.people;
      case "Time": return Icons.access_time;
      case "Wisdom": return Icons.psychology;
      default: return Icons.help_outline;
    }
  }
}
