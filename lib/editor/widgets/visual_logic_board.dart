import 'package:flutter/material.dart';
import 'package:save_the_world_flutter_app/models/task.model.dart';
import 'package:save_the_world_flutter_app/editor/widgets/logic_board_column.dart';

class VisualLogicBoard extends StatelessWidget {
  final List<Task> libraryTasks;
  final List<Task> stageAllTasks;
  final List<String> stageActiveTasks;
  final List<String> stageRandomTasks;
  final Task? selectedTask;
  final Function(String) onTaskSelected;
  final Function() onTaskChanged; // To trigger setState in parent if needed
  final Function(String) onLibraryAccept;
  final Function(int, int) onLibraryReorder;
  final Function() onLibraryAdd;
  final Function(String) onLibraryDelete;
  final Function(String) onActiveAccept;
  final Function(int, int) onActiveReorder;
  final Function(String) onActiveDelete;
  final Function(String) onRandomAccept;
  final Function(int, int) onRandomReorder;
  final Function(String) onRandomDelete;
  final Function(String) onAllTasksAccept;
  final Function(int, int) onAllTasksReorder;
  final Function(String) onAllTasksDelete;

  const VisualLogicBoard({
    super.key,
    required this.libraryTasks,
    required this.stageAllTasks,
    required this.stageActiveTasks,
    required this.stageRandomTasks,
    this.selectedTask,
    required this.onTaskSelected,
    required this.onTaskChanged,
    required this.onLibraryAccept,
    required this.onLibraryReorder,
    required this.onLibraryAdd,
    required this.onLibraryDelete,
    required this.onActiveAccept,
    required this.onActiveReorder,
    required this.onActiveDelete,
    required this.onRandomAccept,
    required this.onRandomReorder,
    required this.onRandomDelete,
    required this.onAllTasksAccept,
    required this.onAllTasksReorder,
    required this.onAllTasksDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1050,
      padding: const EdgeInsets.all(8),
      color: Colors.black12,
      child: Row(
        children: [
          LogicBoardColumn(
            title: "LIBRARY (GLOBAL)",
            taskNames: libraryTasks.map((e) => e.name).toList(),
            allStageTasks: stageAllTasks,
            libraryTasks: libraryTasks,
            color: Colors.blue.withOpacity(0.05),
            icon: Icons.library_books,
            isLibrary: true,
            selectedTask: selectedTask,
            onTaskSelected: onTaskSelected,
            onAccept: onLibraryAccept,
            onReorder: onLibraryReorder,
            onAdd: onLibraryAdd,
            onDelete: onLibraryDelete,
          ),
          LogicBoardColumn(
            title: "START SETUP",
            taskNames: stageActiveTasks,
            allStageTasks: stageAllTasks,
            libraryTasks: libraryTasks,
            color: Colors.green.withOpacity(0.05),
            icon: Icons.play_circle_fill,
            selectedTask: selectedTask,
            onTaskSelected: onTaskSelected,
            onAccept: onActiveAccept,
            onReorder: onActiveReorder,
            onDelete: onActiveDelete,
          ),
          LogicBoardColumn(
            title: "RANDOM EVENTS",
            taskNames: stageRandomTasks,
            allStageTasks: stageAllTasks,
            libraryTasks: libraryTasks,
            color: Colors.orange.withOpacity(0.05),
            icon: Icons.shuffle,
            selectedTask: selectedTask,
            onTaskSelected: onTaskSelected,
            onAccept: onRandomAccept,
            onReorder: onRandomReorder,
            onDelete: onRandomDelete,
          ),
          LogicBoardColumn(
            title: "ALL STAGE TASKS",
            taskNames: stageAllTasks.map((e) => e.name).toList(),
            allStageTasks: stageAllTasks,
            libraryTasks: libraryTasks,
            color: Colors.white.withOpacity(0.05),
            icon: Icons.list,
            isMaster: true,
            selectedTask: selectedTask,
            onTaskSelected: onTaskSelected,
            onAccept: onAllTasksAccept,
            onReorder: onAllTasksReorder,
            onDelete: onAllTasksDelete,
          ),
        ],
      ),
    );
  }
}
