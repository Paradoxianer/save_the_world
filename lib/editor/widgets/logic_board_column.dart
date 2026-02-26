import 'package:flutter/material.dart';
import 'package:save_the_world_flutter_app/models/task.model.dart';
import 'package:save_the_world_flutter_app/editor/widgets/task_board_card.dart';

class LogicBoardColumn extends StatelessWidget {
  final String title;
  final List<String> taskNames;
  final List<Task> allStageTasks;
  final List<Task> libraryTasks;
  final Color color;
  final IconData icon;
  final bool isMaster;
  final bool isLibrary;
  final Task? selectedTask;
  final Function(String) onTaskSelected;
  final Function(String) onAccept;
  final Function(int, int) onReorder;
  final Function(String)? onDelete;
  final VoidCallback? onAdd;

  const LogicBoardColumn({
    super.key,
    required this.title,
    required this.taskNames,
    required this.allStageTasks,
    required this.libraryTasks,
    required this.color,
    required this.icon,
    this.isMaster = false,
    this.isLibrary = false,
    this.selectedTask,
    required this.onTaskSelected,
    required this.onAccept,
    required this.onReorder,
    this.onDelete,
    this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white10),
        ),
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: DragTarget<String>(
                onWillAccept: (data) => true,
                onAccept: onAccept,
                builder: (context, candidates, rejects) {
                  return ReorderableListView(
                    buildDefaultDragHandles: false,
                    onReorder: onReorder,
                    children: taskNames.map((name) {
                      final task = isLibrary 
                          ? libraryTasks.firstWhere((t) => t.name == name, orElse: () => Task(name: name))
                          : allStageTasks.firstWhere((t) => t.name == name, orElse: () => Task(name: name));
                      
                      return _buildDraggableItem(task!, name);
                    }).toList(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.amber),
          const SizedBox(width: 8),
          Expanded(child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 9))),
          if (onAdd != null)
            IconButton(
              icon: const Icon(Icons.add_box_outlined, size: 16, color: Colors.amber),
              onPressed: onAdd,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
        ],
      ),
    );
  }

  Widget _buildDraggableItem(Task task, String name) {
    final isSelected = selectedTask?.name == task.name;

    return ReorderableDragStartListener(
      key: ValueKey("${title}_$name"),
      index: taskNames.indexOf(name),
      child: LongPressDraggable<String>(
        data: name,
        feedback: Material(
          color: Colors.transparent,
          child: Opacity(
            opacity: 0.9,
            child: Container(
              width: 250,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 15, spreadRadius: 5, offset: const Offset(5, 5))
                ],
              ),
              child: TaskBoardCard(task: task, isPrimarySelection: true),
            ),
          ),
        ),
        child: TaskBoardCard(
          task: task,
          isPrimarySelection: isSelected,
          isSecondarySelection: !isSelected && selectedTask?.name == task.name,
          // FIX: isProtected entfernt, damit onDelete Button überall angezeigt werden kann, wo ein Callback existiert
          isProtected: false, 
          onTap: () => onTaskSelected(task.name),
          onDelete: onDelete != null ? () => onDelete!(name) : null,
          dragHandle: const Icon(Icons.drag_indicator, size: 20, color: Colors.white12),
        ),
      ),
    );
  }
}
