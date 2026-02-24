import 'package:flutter/material.dart';
import 'package:save_the_world_flutter_app/models/task.model.dart';
import 'package:save_the_world_flutter_app/models/stage.model.dart';
import 'package:save_the_world_flutter_app/models/ressource.model.dart';
import 'package:save_the_world_flutter_app/models/modifier.model.dart';
import 'package:save_the_world_flutter_app/stages.dart';
import 'package:save_the_world_flutter_app/data/stages/common_tasks.dart' as common;
import 'package:save_the_world_flutter_app/editor/widgets/logic_board_column.dart';
import 'package:save_the_world_flutter_app/editor/widgets/resource_editor_section.dart';
import 'package:save_the_world_flutter_app/editor/widgets/modifier_editor_section.dart';

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

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _descController = TextEditingController();
    _durationController = TextEditingController();
    _loadInitialLibrary();
    _loadStage(allStages.first);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    _durationController.dispose();
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
    Task t;
    if (_libraryTasks.any((task) => task.name == taskName)) {
      t = _libraryTasks.firstWhere((task) => task.name == taskName);
    } else {
      t = _stageAllTasks.firstWhere((task) => task.name == taskName);
    }

    setState(() {
      _selectedTask = t;
      // Task-Attribute sicherstellen (Integrität)
      _selectedTask!.online ??= [];
      _selectedTask!.missed ??= [];
      
      _nameController.text = t.name;
      _descController.text = t.description;
      _durationController.text = t.duration.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🛡️ Stage Architect V4.5'),
        actions: [
          IconButton(icon: const Icon(Icons.code), tooltip: 'Export Stage', onPressed: _exportStage),
        ],
      ),
      body: Column(
        children: [
          _buildStageHeader(),
          Expanded(
            child: Row(
              children: [
                _buildVisualDashboard(),
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
        onPressed: _addNewTask,
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
            items: allStages.map((s) => DropdownMenuItem(value: s, child: Text('Stage ${s.level} - ${s.description.split(" ").take(3).join(" ")}...'))).toList(),
            onChanged: (s) => _loadStage(s!),
          ),
        ],
      ),
    );
  }

  Widget _buildVisualDashboard() {
    return Container(
      width: 1150,
      padding: const EdgeInsets.all(8),
      color: Colors.black12,
      child: Row(
        children: [
          LogicBoardColumn(
            title: "LIBRARY",
            taskNames: _libraryTasks.map((e) => e.name).toList(),
            allStageTasks: _stageAllTasks,
            libraryTasks: _libraryTasks,
            color: Colors.blue.withOpacity(0.05),
            icon: Icons.library_books,
            isLibrary: true,
            selectedTask: _selectedTask,
            onTaskSelected: _selectTask,
            onAccept: (data) => _handleDrop("LIBRARY", data),
            onReorder: (o, n) {},
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
            onAccept: (data) => _handleDrop("START SETUP", data),
            onReorder: (o, n) => setState(() { if (n > o) n -= 1; _stageActiveTasks.insert(n, _stageActiveTasks.removeAt(o)); }),
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
            onAccept: (data) => _handleDrop("RANDOM EVENTS", data),
            onReorder: (o, n) => setState(() { if (n > o) n -= 1; _stageRandomTasks.insert(n, _stageRandomTasks.removeAt(o)); }),
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
            onAccept: (data) => _handleDrop("ALL STAGE TASKS", data),
            onReorder: (o, n) => setState(() { if (n > o) n -= 1; _stageAllTasks.insert(n, _stageAllTasks.removeAt(o)); }),
          ),
        ],
      ),
    );
  }

  void _handleDrop(String targetTitle, String data) {
    setState(() {
      if (targetTitle == "LIBRARY") {
        if (!_libraryTasks.any((t) => t.name == data)) {
          _libraryTasks.add(_stageAllTasks.firstWhere((t) => t.name == data));
        }
      } else if (targetTitle == "ALL STAGE TASKS") {
        if (_libraryTasks.any((t) => t.name == data) && !_stageAllTasks.any((t) => t.name == data)) {
          _stageAllTasks.add(_libraryTasks.firstWhere((t) => t.name == data));
        }
      } else {
        final list = targetTitle == "START SETUP" ? _stageActiveTasks : _stageRandomTasks;
        final other = targetTitle == "START SETUP" ? _stageRandomTasks : _stageActiveTasks;
        if (!list.contains(data)) {
          list.add(data);
          other.remove(data);
        }
      }
    });
  }

  Widget _buildEmptyState() {
    return const Center(child: Text("Task wählen zum Editieren", style: TextStyle(color: Colors.white24)));
  }

  Widget _buildTaskEditor() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('STRATEGIE-DETAILS'),
          _buildDraftTextField('Name', _nameController, (v) => setState(() {})),
          const SizedBox(height: 16),
          _buildDraftTextField('Beschreibung', _descController, (v) {}, maxLines: 2),
          Row(
            children: [
              Expanded(child: _buildDraftTextField('Dauer (ms)', _durationController, (v) {}, isNumber: true)),
              const SizedBox(width: 16),
              const Text('Milestone?'),
              Switch(value: _selectedTask!.isMilestone, activeColor: Colors.amber, onChanged: (v) => setState(() => _selectedTask!.isMilestone = v)),
            ],
          ),
          const Divider(height: 64),
          ResourceEditorSection(title: "INPUT / KOSTEN", resources: _selectedTask!.cost, color: Colors.redAccent, onUpdate: () => setState(() {})),
          const SizedBox(height: 32),
          ResourceEditorSection(title: "OUTPUT / BELOHNUNG", resources: _selectedTask!.award, color: Colors.greenAccent, onUpdate: () => setState(() {})),
          const Divider(height: 64),
          ModifierEditorSection(
            onlineModifiers: _selectedTask!.online ?? [], 
            finishedModifiers: _selectedTask!.myModifier, 
            allTaskNames: _getAllTaskNames(), 
            resourceTypes: _resourceTypes, 
            onUpdate: () => setState(() {})
          ),
        ],
      ),
    );
  }

  List<String> _getAllTaskNames() {
    return {..._libraryTasks.map((e)=>e.name), ...(_stageAllTasks.map((e)=>e.name))}.toList()..sort();
  }

  Widget _buildDraftTextField(String label, TextEditingController controller, Function(String) onChanged, {bool isNumber = false, int maxLines = 1}) {
    return TextFormField(controller: controller, style: const TextStyle(fontSize: 12), decoration: InputDecoration(labelText: label, border: const OutlineInputBorder(), isDense: true), keyboardType: isNumber ? TextInputType.number : TextInputType.text, maxLines: maxLines, onChanged: onChanged);
  }

  Widget _buildSectionHeader(String title) {
    return Padding(padding: const EdgeInsets.only(bottom: 12), child: Text(title, style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 18)));
  }

  void _addNewTask() {
    setState(() {
      final t = Task(name: 'New Task ${_stageAllTasks.length}', description: '...', duration: 5000, cost: [], award: [], modifier: [], online: []);
      _stageAllTasks.add(t);
      _selectTask(t.name);
    });
  }

  void _exportLibrary() {
    final buffer = StringBuffer();
    buffer.writeln('// --- COMMON TASKS DART CODE ---');
    for (var t in _libraryTasks) {
      buffer.writeln('final Task ${t.name.replaceAll(" ", "")} = Task(');
      buffer.writeln('  name: "${t.name}",');
      buffer.writeln('  description: "${t.description}",');
      buffer.writeln('  duration: ${t.duration},');
      buffer.writeln('  cost: [${_exportResources(t.cost)}],');
      buffer.writeln('  award: [${_exportResources(t.award)}],');
      buffer.writeln(');');
      buffer.writeln('');
    }
    _showCodeDialog('Library Export', buffer.toString());
  }

  void _exportStage() {
    final buffer = StringBuffer();
    buffer.writeln('// --- STAGE EXPORT V4.5 ---');
    buffer.writeln('final Stage stage${_currentStage?.level} = Stage(');
    buffer.writeln('  level: ${_currentStage?.level},');
    buffer.writeln('  description: "${_currentStage?.description}",');
    buffer.writeln('  activeTasks: ${_formatStringList(_stageActiveTasks)},');
    buffer.writeln('  randomTasks: ${_formatStringList(_stageRandomTasks)},');
    buffer.writeln('  allTasks: [');
    for (var t in _stageAllTasks) {
      buffer.writeln('    Task(');
      buffer.writeln('      name: "${t == _selectedTask ? _nameController.text : t.name}",');
      buffer.writeln('      description: "${t == _selectedTask ? _descController.text : t.description}",');
      buffer.writeln('      duration: ${t == _selectedTask ? _durationController.text : t.duration},');
      buffer.writeln('      isMilestone: ${t.isMilestone},');
      buffer.writeln('      cost: [${_exportResources(t.cost)}],');
      buffer.writeln('      award: [${_exportResources(t.award)}],');
      if (t.myModifier.isNotEmpty) buffer.writeln('      modifier: [${_exportModifiers(t.myModifier)}],');
      if (t.online?.isNotEmpty ?? false) buffer.writeln('      online: [${_exportModifiers(t.online!)}],');
      buffer.writeln('    ),');
    }
    buffer.writeln('  ],');
    buffer.writeln(');');
    _showCodeDialog('Stage Export', buffer.toString());
  }

  void _showCodeDialog(String title, String code) {
    showDialog(context: context, builder: (context) => AlertDialog(title: Text(title), content: SizedBox(width: 900, height: 700, child: SingleChildScrollView(child: SelectableText(code, style: const TextStyle(fontFamily: 'monospace', fontSize: 11)))), actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK'))]));
  }

  String _formatStringList(List<String>? l) => (l == null || l.isEmpty) ? '[]' : '[${l.map((e) => '"$e"').join(', ')}]';
  String _exportResources(List<Ressource> list) => list.map((res) => '${res.name}(value: ${res.value}${res.multiplierResourceName != null ? ', multiplierResourceName: "${res.multiplierResourceName}", multiplierValue: ${res.multiplierValue}' : ''})').join(', ');
  String _exportModifiers(List<Modifier> list) {
    return list.map((m) {
      // Mapping für Export - achtet auf Typo-Integrität (RemoveModifer)
      String name = m.name;
      if (name == "RemoveModifer") name = "RemoveModifer"; 
      // ... (hier die restliche Export-Mapping Logik aus V4.4)
      return '// Modifier: $name';
    }).join(', ');
  }
}
