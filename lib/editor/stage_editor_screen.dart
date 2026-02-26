import 'package:flutter/material.dart';
import 'package:save_the_world_flutter_app/models/task.model.dart';
import 'package:save_the_world_flutter_app/models/stage.model.dart';
import 'package:save_the_world_flutter_app/models/ressource.model.dart';
import 'package:save_the_world_flutter_app/models/modifier.model.dart';
import 'package:save_the_world_flutter_app/stages.dart';
import 'package:save_the_world_flutter_app/data/stages/common_tasks.dart' as common;

// Specialized editor widgets (Existing & Refactored)
import 'package:save_the_world_flutter_app/editor/widgets/resource_editor_section.dart';
import 'package:save_the_world_flutter_app/editor/widgets/modifier_editor_section.dart';
import 'package:save_the_world_flutter_app/editor/widgets/task_editor_sections.dart';
import 'package:save_the_world_flutter_app/editor/widgets/visual_logic_board.dart';
import 'package:save_the_world_flutter_app/editor/utils/stage_export_utils.dart';

class StageEditorScreen extends StatefulWidget {
  const StageEditorScreen({super.key});

  @override
  State<StageEditorScreen> createState() => _StageEditorScreenState();
}

class _StageEditorScreenState extends State<StageEditorScreen> {
  Stage? _currentStage;
  Task? _selectedTask;
  
  List<Task> _stageAllTasks = [];
  List<String> _stageActiveTasks = [];
  List<String> _stageRandomTasks = [];
  List<Task> _libraryTasks = [];
  
  final List<String> _resourceTypes = ["Faith", "Member", "Money", "Publicity", "Time", "Wisdom"];

  late TextEditingController _nameController;
  late TextEditingController _descController;
  late TextEditingController _durationController;
  late TextEditingController _timeToSolveController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _descController = TextEditingController();
    _durationController = TextEditingController();
    _timeToSolveController = TextEditingController();
    _loadInitialLibrary();
    _loadStage(allStages.first);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    _durationController.dispose();
    _timeToSolveController.dispose();
    super.dispose();
  }

  void _loadInitialLibrary() {
    setState(() {
      _libraryTasks = [
        common.baseSleep, common.baseFreeTime, common.baseBible,
        common.collectMoney, common.holySpiritWorking,
        common.someoneWantsToMarry, common.funeralGeneral,
      ];
    });
  }

  void _loadStage(Stage stage) {
    setState(() {
      _currentStage = stage;
      _selectedTask = null;
      _stageAllTasks = List.from(stage.allTasks);
      _stageActiveTasks = List.from(stage.activeTasks);
      _stageRandomTasks = List.from(stage.randomTasks);
    });
  }

  void _selectTask(String taskName) {
    Task? t = _libraryTasks.cast<Task?>().firstWhere((task) => task?.name == taskName, orElse: () => null) ??
             _stageAllTasks.cast<Task?>().firstWhere((task) => task?.name == taskName, orElse: () => null);

    if (t == null) return;

    setState(() {
      _selectedTask = t;
      _nameController.text = t.name;
      _descController.text = t.description;
      _durationController.text = t.duration.toString();
      _timeToSolveController.text = t.timeToSolve == double.infinity ? "" : t.timeToSolve.toString();
    });
  }

  void _updateCurrentTask({
    String? name, String? description, double? duration,
    double? timeToSolve, bool? isMilestone,
    List<Ressource>? cost, List<Ressource>? award,
    List<Modifier>? modifier, List<Modifier>? online, List<Modifier>? missed,
  }) {
    if (_selectedTask == null) return;

    final newTask = Task(
      name: name ?? _selectedTask!.name,
      description: description ?? _selectedTask!.description,
      duration: duration ?? _selectedTask!.duration,
      timeToSolve: timeToSolve ?? _selectedTask!.timeToSolve,
      isMilestone: isMilestone ?? _selectedTask!.isMilestone,
      cost: cost ?? List.from(_selectedTask!.cost),
      award: award ?? List.from(_selectedTask!.award),
      modifier: modifier ?? List.from(_selectedTask!.myModifier),
      online: online ?? List.from(_selectedTask!.online ?? []),
      missed: missed ?? List.from(_selectedTask!.missed ?? []),
    );

    setState(() {
      final libIndex = _libraryTasks.indexWhere((t) => t.name == _selectedTask!.name);
      if (libIndex != -1) _libraryTasks[libIndex] = newTask;

      final stageIndex = _stageAllTasks.indexWhere((t) => t.name == _selectedTask!.name);
      if (stageIndex != -1) _stageAllTasks[stageIndex] = newTask;
      
      _selectedTask = newTask;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🛡️ Stage Architect V5.3 (UX Polish)'),
        actions: [
          IconButton(icon: const Icon(Icons.library_add_check), tooltip: 'Export Library', onPressed: () => _showExportDialog('Library Code', StageExportUtils.exportLibrary(_libraryTasks))),
          IconButton(icon: const Icon(Icons.code), tooltip: 'Export Stage', onPressed: () => _currentStage != null ? _showExportDialog('Stage Code', StageExportUtils.exportStage(_currentStage!, _stageActiveTasks, _stageRandomTasks, _stageAllTasks)) : null),
        ],
      ),
      body: Column(
        children: [
          _buildStageHeader(),
          Expanded(
            child: Row(
              children: [
                VisualLogicBoard(
                  libraryTasks: _libraryTasks, stageAllTasks: _stageAllTasks, stageActiveTasks: _stageActiveTasks, stageRandomTasks: _stageRandomTasks,
                  selectedTask: _selectedTask, onTaskSelected: _selectTask, onTaskChanged: () => setState(() {}),
                  onLibraryAccept: (data) => !_libraryTasks.any((t) => t.name == data) ? setState(() => _libraryTasks.add(_stageAllTasks.firstWhere((t) => t.name == data))) : null,
                  onLibraryReorder: (old, newI) => setState(() { if (newI > old) newI -= 1; _libraryTasks.insert(newI, _libraryTasks.removeAt(old)); }),
                  onLibraryAdd: _addNewLibraryTask,
                  onLibraryDelete: (name) => setState(() { _libraryTasks.removeWhere((t) => t.name == name); _stageAllTasks.removeWhere((t) => t.name == name); _stageActiveTasks.remove(name); _stageRandomTasks.remove(name); if (_selectedTask?.name == name) _selectedTask = null; }),
                  onActiveAccept: (data) => setState(() { if (!_stageActiveTasks.contains(data)) { _stageActiveTasks.add(data); _stageRandomTasks.remove(data); } }),
                  onActiveReorder: (old, newI) => setState(() { if (newI > old) newI -= 1; _stageActiveTasks.insert(newI, _stageActiveTasks.removeAt(old)); }),
                  onActiveDelete: (name) => setState(() => _stageActiveTasks.remove(name)),
                  onRandomAccept: (data) => setState(() { if (!_stageRandomTasks.contains(data)) { _stageRandomTasks.add(data); _stageActiveTasks.remove(data); } }),
                  onRandomReorder: (old, newI) => setState(() { if (newI > old) newI -= 1; _stageRandomTasks.insert(newI, _stageRandomTasks.removeAt(old)); }),
                  onRandomDelete: (name) => setState(() => _stageRandomTasks.remove(name)),
                  onAllTasksAccept: (data) => (_libraryTasks.any((t) => t.name == data) && !_stageAllTasks.any((t) => t.name == data)) ? setState(() => _stageAllTasks.add(_libraryTasks.firstWhere((t) => t.name == data))) : null,
                  onAllTasksReorder: (old, newI) => setState(() { if (newI > old) newI -= 1; _stageAllTasks.insert(newI, _stageAllTasks.removeAt(old)); }),
                  onAllTasksDelete: (name) => setState(() { _stageAllTasks.removeWhere((t) => t.name == name); _stageActiveTasks.remove(name); _stageRandomTasks.remove(name); if (_selectedTask?.name == name) _selectedTask = null; }),
                ),
                const VerticalDivider(width: 1),
                Expanded(child: _selectedTask == null ? const Center(child: Text("Wähle einen Task", style: TextStyle(color: Colors.white24))) : _buildTaskEditor()),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(onPressed: _addNewStageTask, backgroundColor: Colors.amber, child: const Icon(Icons.add, color: Colors.black)),
    );
  }

  Widget _buildTaskEditor() {
    final allTaskNames = {..._libraryTasks.map((e)=>e.name), ...(_stageAllTasks.map((e)=>e.name))}.toList()..sort();
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(title: 'TASK: ${_selectedTask!.name}'),
          EditorTextField(label: 'Name', controller: _nameController, onChanged: (v) => _updateCurrentTask(name: v)),
          const SizedBox(height: 16),
          EditorTextField(label: 'Beschreibung', controller: _descController, onChanged: (v) => _updateCurrentTask(description: v), maxLines: 2),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(child: EditorTextField(label: 'Basis-Dauer (ms)', controller: _durationController, onChanged: (v) => _updateCurrentTask(duration: double.tryParse(v) ?? 5000), isNumber: true)),
              const SizedBox(width: 32),
              const Text('Milestone?'),
              Switch(value: _selectedTask!.isMilestone, activeColor: Colors.amber, onChanged: (v) => _updateCurrentTask(isMilestone: v)),
            ],
          ),
          const SizedBox(height: 16),
          CrisisEditorSection(
            isCrisis: _selectedTask!.timeToSolve != double.infinity, timeToSolveController: _timeToSolveController,
            onToggle: (v) => setState(() { _updateCurrentTask(timeToSolve: v ? 10000.0 : double.infinity); _timeToSolveController.text = v ? "10000.0" : ""; }),
            onTimeChanged: (v) => _updateCurrentTask(timeToSolve: double.tryParse(v) ?? 10000.0),
          ),
          const Divider(height: 64),
          ResourceEditorSection(title: "KOSTEN (INPUT)", resources: _selectedTask!.cost, color: Colors.redAccent, onUpdate: () => _updateCurrentTask(cost: _selectedTask!.cost)),
          const SizedBox(height: 32),
          ResourceEditorSection(title: "BELOHNUNG (OUTPUT)", resources: _selectedTask!.award, color: Colors.greenAccent, onUpdate: () => _updateCurrentTask(award: _selectedTask!.award)),
          const Divider(height: 64),
          ModifierEditorSection(title: "ONLINE MODIFIER (START)", modifiers: _selectedTask!.online ?? [], accentColor: Colors.cyanAccent, allTaskNames: allTaskNames, resourceTypes: _resourceTypes, onUpdate: () => _updateCurrentTask()),
          const SizedBox(height: 32),
          ModifierEditorSection(title: "MODIFIER (FINISHED)", modifiers: _selectedTask!.myModifier, accentColor: Colors.amber, allTaskNames: allTaskNames, resourceTypes: _resourceTypes, onUpdate: () => _updateCurrentTask()),
          const SizedBox(height: 32),
          ModifierEditorSection(title: "MISSED MODIFIER (FAIL)", modifiers: _selectedTask!.missed ?? [], accentColor: Colors.redAccent, allTaskNames: allTaskNames, resourceTypes: _resourceTypes, onUpdate: () => _updateCurrentTask()),
          
          // UX Padding am Ende, damit der FAB nichts verdeckt
          const SizedBox(height: 120),
        ],
      ),
    );
  }

  void _showExportDialog(String title, String code) {
    showDialog(context: context, builder: (context) => AlertDialog(title: Text(title), content: SizedBox(width: 900, height: 700, child: SingleChildScrollView(child: SelectableText(code, style: const TextStyle(fontFamily: 'monospace', fontSize: 11)))), actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK'))]));
  }

  Widget _buildStageHeader() {
    return Container(padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12), color: Colors.black45, child: Row(children: [const Text("STAGE: ", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.amber)), const SizedBox(width: 12), DropdownButton<Stage>(value: _currentStage, dropdownColor: const Color(0xFF1E1E1E), items: allStages.map((s) => DropdownMenuItem(value: s, child: Text('Stage ${s.level} - ${s.description.split(" ").take(2).join(" ")}...'))).toList(), onChanged: (s) => _loadStage(s!))]));
  }

  void _addNewStageTask() { setState(() { final t = Task(name: 'New Stage Task ${_stageAllTasks.length}', description: '...', duration: 5000, cost: [], award: [], modifier: [], online: [], missed: []); _currentStage?.allTasks.add(t); _stageAllTasks.add(t); _selectTask(t.name); }); }
  void _addNewLibraryTask() { setState(() { final t = Task(name: 'Global Task ${_libraryTasks.length}', description: '...', duration: 5000, cost: [], award: [], modifier: [], online: [], missed: []); _libraryTasks.add(t); _selectTask(t.name); }); }
}
