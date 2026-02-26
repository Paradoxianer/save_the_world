import 'package:flutter/material.dart';
import 'package:save_the_world_flutter_app/models/task.model.dart';
import 'package:save_the_world_flutter_app/models/stage.model.dart';
import 'package:save_the_world_flutter_app/models/ressource.model.dart';
import 'package:save_the_world_flutter_app/models/modifier.model.dart';
import 'package:save_the_world_flutter_app/models/addtask.model.dart';
import 'package:save_the_world_flutter_app/models/removetask.model.dart';
import 'package:save_the_world_flutter_app/models/setmax.model.dart';
import 'package:save_the_world_flutter_app/models/setmin.model.dart';
import 'package:save_the_world_flutter_app/models/autoexecute.model.dart';
import 'package:save_the_world_flutter_app/models/AddToRandom.model.dart';
import 'package:save_the_world_flutter_app/models/message.modifier.dart';
import 'package:save_the_world_flutter_app/models/removemodifier.model.dart';
import 'package:save_the_world_flutter_app/stages.dart';
import 'package:save_the_world_flutter_app/data/stages/common_tasks.dart' as common;

// Specialized editor widgets
import 'package:save_the_world_flutter_app/editor/widgets/resource_editor_section.dart';
import 'package:save_the_world_flutter_app/editor/widgets/modifier_list_widget.dart';
import 'package:save_the_world_flutter_app/editor/widgets/logic_board_column.dart';

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
        common.baseSleep,
        common.baseFreeTime,
        common.baseBible,
        common.collectMoney,
        common.holySpiritWorking,
        common.someoneWantsToMarry,
        common.funeralGeneral,
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
    Task? t;
    if (_libraryTasks.any((task) => task.name == taskName)) {
      t = _libraryTasks.firstWhere((task) => task.name == taskName);
    } else if (_stageAllTasks.any((task) => task.name == taskName)) {
      t = _stageAllTasks.firstWhere((task) => task.name == taskName);
    }

    if (t == null) return;

    setState(() {
      _selectedTask = t;
      _nameController.text = t!.name;
      _descController.text = t!.description;
      _durationController.text = t!.duration.toString();
      _timeToSolveController.text = t!.timeToSolve == double.infinity ? "" : t!.timeToSolve.toString();
    });
  }

  void _updateCurrentTask({
    String? name,
    String? description,
    double? duration,
    double? timeToSolve,
    bool? isMilestone,
    List<Ressource>? cost,
    List<Ressource>? award,
    List<Modifier>? modifier,
    List<Modifier>? online,
    List<Modifier>? missed,
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
      modifier: modifier ?? List.from(_selectedTask!.myModifier ?? []),
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
        title: const Text('🛡️ Stage Architect V4.9.8 (Final Drag Fix)'),
        actions: [
          IconButton(icon: const Icon(Icons.library_add_check), tooltip: 'Export Common Tasks', onPressed: _exportLibrary),
          IconButton(icon: const Icon(Icons.code), tooltip: 'Export Stage', onPressed: _exportStage),
        ],
      ),
      body: Column(
        children: [
          _buildStageHeader(),
          Expanded(
            child: Row(
              children: [
                _buildVisualBoard(),
                const VerticalDivider(width: 1),
                Expanded(
                  child: _selectedTask == null
                      ? _buildEmptyState()
                      : _buildTaskEditor(),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewStageTask,
        backgroundColor: Colors.amber,
        child: const Icon(Icons.add, color: Colors.black),
      ),
    );
  }

  Widget _buildStageHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      color: Colors.black45,
      child: Row(
        children: [
          const Text("STAGE: ", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.amber)),
          const SizedBox(width: 12),
          DropdownButton<Stage>(
            value: _currentStage,
            dropdownColor: const Color(0xFF1E1E1E),
            items: allStages.map((s) => DropdownMenuItem(value: s, child: Text('Stage ${s.level} - ${s.description.split(" ").take(2).join(" ")}...'))).toList(),
            onChanged: (s) => _loadStage(s!),
          ),
        ],
      ),
    );
  }

  Widget _buildVisualBoard() {
    return Container(
      width: 1050,
      padding: const EdgeInsets.all(8),
      color: Colors.black12,
      child: Row(
        children: [
          LogicBoardColumn(
            title: "LIBRARY (GLOBAL)", 
            taskNames: _libraryTasks.map((e) => e.name).toList(), 
            allStageTasks: _stageAllTasks, 
            libraryTasks: _libraryTasks, 
            color: Colors.blue.withOpacity(0.05), 
            icon: Icons.library_books, 
            isLibrary: true,
            selectedTask: _selectedTask,
            onTaskSelected: _selectTask,
            onAccept: (data) {
               if (!_libraryTasks.any((t) => t.name == data)) {
                  final template = _stageAllTasks.firstWhere((t) => t.name == data);
                  setState(() => _libraryTasks.add(template));
               }
            },
            onReorder: (oldI, newI) => setState(() {
              if (newI > oldI) newI -= 1;
              final item = _libraryTasks.removeAt(oldI);
              _libraryTasks.insert(newI, item);
            }),
            onAdd: _addNewLibraryTask,
            onDelete: (name) => setState(() {
              _libraryTasks.removeWhere((t) => t.name == name);
              _stageAllTasks.removeWhere((t) => t.name == name);
              _stageActiveTasks.remove(name);
              _stageRandomTasks.remove(name);
              if (_selectedTask?.name == name) _selectedTask = null;
            }),
          ),
          LogicBoardColumn(
            title: "START SETUP", 
            taskNames: _stageActiveTasks, 
            allStageTasks: _stageAllTasks, 
            libraryTasks: _libraryTasks, 
            color: Colors.green.withOpacity(0.05), 
            icon: Icons.play_circle_fill,
            selectedTask: _selectedTask,
            onTaskSelected: _selectTask,
            onAccept: (data) => setState(() {
              if (!_stageActiveTasks.contains(data)) {
                _stageActiveTasks.add(data);
                _stageRandomTasks.remove(data);
              }
            }),
            onReorder: (oldI, newI) => setState(() {
              if (newI > oldI) newI -= 1;
              final item = _stageActiveTasks.removeAt(oldI);
              _stageActiveTasks.insert(newI, item);
            }),
            onDelete: (name) => setState(() => _stageActiveTasks.remove(name)),
          ),
          LogicBoardColumn(
            title: "RANDOM EVENTS", 
            taskNames: _stageRandomTasks, 
            allStageTasks: _stageAllTasks, 
            libraryTasks: _libraryTasks, 
            color: Colors.orange.withOpacity(0.05), 
            icon: Icons.shuffle,
            selectedTask: _selectedTask,
            onTaskSelected: _selectTask,
            onAccept: (data) => setState(() {
              if (!_stageRandomTasks.contains(data)) {
                _stageRandomTasks.add(data);
                _stageActiveTasks.remove(data);
              }
            }),
            onReorder: (oldI, newI) => setState(() {
              if (newI > oldI) newI -= 1;
              final item = _stageRandomTasks.removeAt(oldI);
              _stageRandomTasks.insert(newI, item);
            }),
            onDelete: (name) => setState(() => _stageRandomTasks.remove(name)),
          ),
          LogicBoardColumn(
            title: "ALL STAGE TASKS", 
            taskNames: _stageAllTasks.map((e) => e.name).toList(), 
            allStageTasks: _stageAllTasks, 
            libraryTasks: _libraryTasks, 
            color: Colors.white.withOpacity(0.05), 
            icon: Icons.list,
            isMaster: true,
            selectedTask: _selectedTask,
            onTaskSelected: _selectTask,
            onAccept: (data) {
               if (_libraryTasks.any((t) => t.name == data) && !_stageAllTasks.any((t) => t.name == data)) {
                  final template = _libraryTasks.firstWhere((t) => t.name == data);
                  setState(() => _stageAllTasks.add(template));
               }
            },
            onReorder: (oldI, newI) => setState(() {
              if (newI > oldI) newI -= 1;
              final item = _stageAllTasks.removeAt(oldI);
              _stageAllTasks.insert(newI, item);
            }),
            onDelete: (name) => setState(() {
              _stageAllTasks.removeWhere((t) => t.name == name);
              _stageActiveTasks.remove(name);
              _stageRandomTasks.remove(name);
              if (_selectedTask?.name == name) _selectedTask = null;
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(child: Text("Wähle einen Task wählen zum Editieren", style: TextStyle(color: Colors.white24)));
  }

  Widget _buildTaskEditor() {
    final isCrisis = _selectedTask!.timeToSolve != double.infinity;
    final allTaskNames = {..._libraryTasks.map((e)=>e.name), ...(_stageAllTasks.map((e)=>e.name))}.toList()..sort();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('TASK: ${_selectedTask!.name}'),
          _buildDraftTextField('Name', _nameController, (v) => _updateCurrentTask(name: v)),
          const SizedBox(height: 16),
          _buildDraftTextField('Beschreibung', _descController, (v) => _updateCurrentTask(description: v), maxLines: 2),
          
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(child: _buildDraftTextField('Basis-Dauer (ms)', _durationController, (v) => _updateCurrentTask(duration: double.tryParse(v) ?? 5000), isNumber: true)),
              const SizedBox(width: 32),
              const Text('Milestone?'),
              Switch(value: _selectedTask!.isMilestone, activeColor: Colors.amber, onChanged: (v) => _updateCurrentTask(isMilestone: v)),
            ],
          ),
          
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isCrisis ? Colors.red.withOpacity(0.05) : Colors.white.withOpacity(0.02),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: isCrisis ? Colors.redAccent.withOpacity(0.3) : Colors.white10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('KRISEN-MODUS (COUNTDOWN)', style: TextStyle(color: isCrisis ? Colors.redAccent : Colors.white38, fontWeight: FontWeight.bold, fontSize: 12)),
                    Switch(
                      value: isCrisis, 
                      activeColor: Colors.redAccent, 
                      onChanged: (v) => setState(() {
                        _updateCurrentTask(timeToSolve: v ? 10000.0 : double.infinity);
                        _timeToSolveController.text = v ? "10000.0" : "";
                      })
                    ),
                  ],
                ),
                if (isCrisis) ...[
                  const SizedBox(height: 12),
                  _buildDraftTextField('Zeit bis Fail (ms)', _timeToSolveController, (v) => _updateCurrentTask(timeToSolve: double.tryParse(v) ?? 10000.0), isNumber: true),
                ],
              ],
            ),
          ),

          const Divider(height: 64),
          
          ResourceEditorSection(
            title: "KOSTEN (INPUT)", 
            resources: _selectedTask!.cost, 
            color: Colors.redAccent, 
            onUpdate: () => _updateCurrentTask(cost: _selectedTask!.cost)
          ),
          const SizedBox(height: 32),
          ResourceEditorSection(
            title: "BELOHNUNG (OUTPUT)", 
            resources: _selectedTask!.award, 
            color: Colors.greenAccent, 
            onUpdate: () => _updateCurrentTask(award: _selectedTask!.award)
          ),
          
          const Divider(height: 64),
          
          ModifierListWidget(
            list: _selectedTask!.online ?? [],
            title: "ONLINE MODIFIER (ON START)",
            accentColor: Colors.cyanAccent,
            allTaskNames: allTaskNames,
            resourceTypes: _resourceTypes,
            onUpdate: (old, nm) {
              final list = List<Modifier>.from(_selectedTask!.online ?? []);
              final i = list.indexOf(old);
              if (i >= 0) list[i] = nm;
              _updateCurrentTask(online: list);
            },
            onAdd: (m) {
               final list = List<Modifier>.from(_selectedTask!.online ?? [])..add(m);
               _updateCurrentTask(online: list);
            },
            onRemove: (m) {
               final list = List<Modifier>.from(_selectedTask!.online ?? [])..remove(m);
               _updateCurrentTask(online: list);
            },
            onOpenNested: () => _showAutoExecuteDialog(context, _selectedTask!.online ?? []),
          ),
          
          const SizedBox(height: 32),
          
          ModifierListWidget(
            list: _selectedTask!.myModifier ?? [],
            title: "MODIFIER (ON FINISHED)",
            accentColor: Colors.amber,
            allTaskNames: allTaskNames,
            resourceTypes: _resourceTypes,
            onUpdate: (old, nm) {
              final list = List<Modifier>.from(_selectedTask!.myModifier ?? []);
              final i = list.indexOf(old);
              if (i >= 0) list[i] = nm;
              _updateCurrentTask(modifier: list);
            },
            onAdd: (m) {
               final list = List<Modifier>.from(_selectedTask!.myModifier ?? [])..add(m);
               _updateCurrentTask(modifier: list);
            },
            onRemove: (m) {
               final list = List<Modifier>.from(_selectedTask!.myModifier ?? [])..remove(m);
               _updateCurrentTask(modifier: list);
            },
            onOpenNested: () => _showAutoExecuteDialog(context, _selectedTask!.myModifier ?? []),
          ),
          
          const SizedBox(height: 32),
          
          ModifierListWidget(
            list: _selectedTask!.missed ?? [],
            title: "MISSED MODIFIER (ON FAIL)",
            accentColor: Colors.redAccent,
            allTaskNames: allTaskNames,
            resourceTypes: _resourceTypes,
            onUpdate: (old, nm) {
              final list = List<Modifier>.from(_selectedTask!.missed ?? []);
              final i = list.indexOf(old);
              if (i >= 0) list[i] = nm;
              _updateCurrentTask(missed: list);
            },
            onAdd: (m) {
               final list = List<Modifier>.from(_selectedTask!.missed ?? [])..add(m);
               _updateCurrentTask(missed: list);
            },
            onRemove: (m) {
               final list = List<Modifier>.from(_selectedTask!.missed ?? [])..remove(m);
               _updateCurrentTask(missed: list);
            },
            onOpenNested: () => _showAutoExecuteDialog(context, _selectedTask!.missed ?? []),
          ),
        ],
      ),
    );
  }

  void _showAutoExecuteDialog(BuildContext context, List<Modifier> parentList) {
    final autoMod = parentList.whereType<AutoExecuteModifier>().firstOrNull;
    if (autoMod == null) return;
    
    final allTaskNames = {..._libraryTasks.map((e)=>e.name), ...(_stageAllTasks.map((e)=>e.name))}.toList()..sort();

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('⚙️ AutoExecute: Unter-Modifier'),
          content: SizedBox(
            width: 550,
            child: SingleChildScrollView(
              child: ModifierListWidget(
                list: autoMod.modifiers,
                title: "UNTER-MODIFIER",
                accentColor: Colors.orangeAccent,
                allTaskNames: allTaskNames,
                resourceTypes: _resourceTypes,
                onUpdate: (old, nm) => setDialogState(() {
                  final i = autoMod.modifiers.indexOf(old);
                  if (i >= 0) autoMod.modifiers[i] = nm;
                }),
                onRemove: (m) => setDialogState(() => autoMod.modifiers.remove(m)),
                onAdd: (m) => setDialogState(() => autoMod.modifiers.add(m)),
                onOpenNested: () {}, 
              ),
            ),
          ),
          actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text("Fertig"))],
        ),
      ),
    ).then((_) => _updateCurrentTask());
  }

  Widget _buildDraftTextField(String label, TextEditingController controller, Function(String) onChanged, {bool isNumber = false, int maxLines = 1}) {
    return TextFormField(controller: controller, style: const TextStyle(fontSize: 12), decoration: InputDecoration(labelText: label, border: const OutlineInputBorder(), isDense: true), keyboardType: isNumber ? TextInputType.number : TextInputType.text, maxLines: maxLines, onChanged: onChanged);
  }

  Widget _buildSectionHeader(String title) {
    return Padding(padding: const EdgeInsets.only(bottom: 12), child: Text(title, style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 18)));
  }

  void _addNewStageTask() {
    setState(() {
      final t = Task(
        name: 'New Stage Task ${_stageAllTasks.length}', 
        description: '...', 
        duration: 5000, 
        cost: [], 
        award: [], 
        modifier: [],
        online: [],
        missed: [],
      );
      _currentStage?.allTasks.add(t);
      _stageAllTasks.add(t); 
      _selectTask(t.name);
    });
  }

  void _addNewLibraryTask() {
    setState(() {
      final t = Task(
        name: 'Global Task ${_libraryTasks.length}', 
        description: '...', 
        duration: 5000, 
        cost: [], 
        award: [], 
        modifier: [],
        online: [],
        missed: [],
      );
      _libraryTasks.add(t); 
      _selectTask(t.name);
    });
  }

  void _exportLibrary() {
    final buffer = StringBuffer();
    buffer.writeln('// --- LIBRARY EXPORT ---');
    for (var t in _libraryTasks) {
      buffer.writeln('final Task ${t.name.replaceAll(" ", "")} = Task(');
      buffer.writeln('  name: "${t.name}",');
      buffer.writeln('  description: "${t.description}",');
      buffer.writeln('  duration: ${t.duration},');
      buffer.writeln('  timeToSolve: ${t.timeToSolve},');
      buffer.writeln('  isMilestone: ${t.isMilestone},');
      buffer.writeln('  cost: [${_exportResources(t.cost)}],');
      buffer.writeln('  award: [${_exportResources(t.award)}],');
      if (t.myModifier.isNotEmpty) buffer.writeln('  modifier: [${_exportModifiers(t.myModifier)}],');
      if (t.online != null && t.online!.isNotEmpty) buffer.writeln('  online: [${_exportModifiers(t.online!)}],');
      if (t.missed != null && t.missed!.isNotEmpty) buffer.writeln('  missed: [${_exportModifiers(t.missed!)}],');
      buffer.writeln(');');
      buffer.writeln();
    }

    showDialog(context: context, builder: (context) => AlertDialog(title: const Text('Library Code'), content: SizedBox(width: 900, height: 700, child: SingleChildScrollView(child: SelectableText(buffer.toString(), style: const TextStyle(fontFamily: 'monospace', fontSize: 11)))), actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK'))]));
  }

  void _exportStage() {
    final buffer = StringBuffer();
    buffer.writeln('// --- STAGE EXPORT ---');
    buffer.writeln('final Stage stage${_currentStage?.level} = Stage(');
    buffer.writeln('  level: ${_currentStage?.level},');
    buffer.writeln('  description: "${_currentStage?.description}",');
    buffer.writeln('  activeTasks: ${_formatStringList(_stageActiveTasks)},');
    buffer.writeln('  randomTasks: ${_formatStringList(_stageRandomTasks)},');
    buffer.writeln('  allTasks: [');
    for (var t in _stageAllTasks) {
      buffer.writeln('    Task( ');
      buffer.writeln('      name: "${t.name}",');
      buffer.writeln('      description: "${t.description}",');
      buffer.writeln('      duration: ${t.duration},');
      buffer.writeln('      timeToSolve: ${t.timeToSolve},');
      buffer.writeln('      isMilestone: ${t.isMilestone},');
      buffer.writeln('      cost: [${_exportResources(t.cost)}],');
      buffer.writeln('      award: [${_exportResources(t.award)}],');
      if (t.myModifier != null && t.myModifier!.isNotEmpty) buffer.writeln('      modifier: [${_exportModifiers(t.myModifier!)}],');
      if (t.online != null && t.online!.isNotEmpty) buffer.writeln('      online: [${_exportModifiers(t.online!)}],');
      if (t.missed != null && t.missed!.isNotEmpty) buffer.writeln('      missed: [${_exportModifiers(t.missed!)}],');
      buffer.writeln('    ),');
    }
    buffer.writeln('  ],');
    buffer.writeln(');');

    showDialog(context: context, builder: (context) => AlertDialog(title: const Text('Stage Code'), content: SizedBox(width: 900, height: 700, child: SingleChildScrollView(child: SelectableText(buffer.toString(), style: const TextStyle(fontFamily: 'monospace', fontSize: 11)))), actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK'))]));
  }

  String _formatStringList(List<String>? l) => (l == null || l.isEmpty) ? '[]' : '[${l.map((e) => '"$e"').join(', ')}]';
  String _exportResources(List<Ressource> list) => list.map((res) => '${res.name}(value: ${res.value}${res.multiplierResourceName != null ? ', multiplierResourceName: "${res.multiplierResourceName}", multiplierValue: ${res.multiplierValue}' : ''})').join(', ');
  String _exportModifiers(List<Modifier> list) {
    return list.map((m) {
      final String taskName = (m is AddTask) ? m.nameOfTask : ((m is RemoveTask) ? m.nameOfTask : ((m is AddToRandom) ? m.nameOfTask : ""));
      if (m is AddTask) return 'AddTask(task: "$taskName")';
      if (m is RemoveTask) return 'RemoveTask(task: "$taskName")';
      if (m is AddToRandom) return 'AddToRandom(task: "$taskName")';
      if (m is SetMax) return 'SetMax(ressource: "${m.workOn}", newMax: ${m.newMax})';
      if (m is SetMin) return 'SetMin(ressource: "${m.workOn}", newMin: ${m.newMin})';
      if (m is MessageModifier) return 'MessageModifier(message: "${m.message}")';
      if (m is RemoveModifer) return 'RemoveModifer(nameOfTask: "$taskName", modifier: [])';
      if (m is AutoExecuteModifier) return 'AutoExecuteModifier(modifiers: [${_exportModifiers(m.modifiers)}], intervalMs: ${m.intervalMs})';
      return '// Unknown Modifier';
    }).join(', ');
  }
}
