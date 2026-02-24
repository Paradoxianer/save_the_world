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
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Icon(icon, size: 16, color: Colors.amber),
                  const SizedBox(width: 8),
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 9)),
                ],
              ),
            ),
            Expanded(
              child: DragTarget<String>(
                onAccept: onAccept,
                builder: (context, candidates, rejects) {
                  return ReorderableListView(
                    buildDefaultDragHandles: false,
                    onReorder: onReorder,
                    children: taskNames.map((name) {
                      final task = isLibrary 
                          ? libraryTasks.firstWhere((t) => t.name == name)
                          : allStageTasks.firstWhere((t) => t.name == name, orElse: () => Task(name: name));
                      
                      return ReorderableDragStartListener(
                        key: ValueKey("${title}_$name"),
                        index: taskNames.indexOf(name),
                        child: TaskBoardCard(
                          task: task!,
                          isSelected: selectedTask == task,
                          onTap: () => onTaskSelected(task.name),
                          onDelete: onDelete != null ? () => onDelete!(name) : null,
                        ),
                      );
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
}
