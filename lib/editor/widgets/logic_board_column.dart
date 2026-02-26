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
  final VoidCallback? onExportLibrary;
  
  // Callbacks für die neuen Kontext-Aktionen
  final Function(String)? onMoveToStart;
  final Function(String)? onMoveToRandom;
  final Function(String)? onRemoveFromLists;

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
    this.onExportLibrary,
    this.onMoveToStart,
    this.onMoveToRandom,
    this.onRemoveFromLists,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: DragTarget<String>(
        onWillAccept: (data) => data != null,
        onAccept: onAccept,
        builder: (context, candidates, rejects) {
          return Container(
            margin: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: candidates.isNotEmpty ? color.withOpacity(0.2) : color,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: candidates.isNotEmpty ? Colors.amber : Colors.white10),
            ),
            child: Column(
              children: [
                _buildHeader(),
                Expanded(
                  child: ReorderableListView(
                    buildDefaultDragHandles: false,
                    onReorder: onReorder,
                    children: taskNames.map((name) {
                      final task = isLibrary 
                          ? libraryTasks.firstWhere((t) => t.name == name)
                          : allStageTasks.firstWhere((t) => t.name == name, orElse: () => Task(name: name));
                      
                      return _buildDraggableItem(task!, name);
                    }).toList(),
                  ),
                ),
              ],
            ),
          );
        },
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
          Expanded(child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 10))),
          if (isLibrary && onExportLibrary != null)
            IconButton(
              icon: const Icon(Icons.ios_share, size: 14, color: Colors.amber),
              onPressed: onExportLibrary,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
        ],
      ),
    );
  }

  Widget _buildDraggableItem(Task task, String name) {
    return Draggable<String>(
      key: ValueKey("${title}_$name"),
      data: name,
      feedback: Material(
        color: Colors.transparent,
        child: SizedBox(
          width: 250,
          child: TaskBoardCard(task: task, isSelected: true),
        ),
      ),
      childWhenDragging: Opacity(
        opacity: 0.3,
        child: TaskBoardCard(task: task),
      ),
      child: ReorderableDragStartListener(
        index: taskNames.indexOf(name),
        child: TaskBoardCard(
          task: task,
          isSelected: selectedTask == task,
          isProtected: isLibrary || isMaster,
          onTap: () => onTaskSelected(task.name),
          onDelete: onDelete != null ? () => onDelete!(name) : null,
          onMoveToStart: onMoveToStart,
          onMoveToRandom: onMoveToRandom,
          onRemoveFromLists: onRemoveFromLists,
        ),
      ),
    );
  }
}
