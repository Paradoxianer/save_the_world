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
      final index = _stageAllTasks.indexWhere((t) => t.name == _selectedTask!.name);
      if (index != -1) {
        _stageAllTasks[index] = newTask;
      }
      _selectedTask = newTask;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🛡️ Stage Architect V4.6 (Sync Patch)'),
        actions: [
          IconButton(icon: const Icon(Icons.code), tooltip: 'Vollständiger Export', onPressed: _exportStage),
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
          _buildDropColumn("LIBRARY", _libraryTasks.map((e) => e.name).toList(), Colors.blue.withOpacity(0.05), Icons.library_books, isLibrary: true),
          _buildDropColumn("START SETUP", _stageActiveTasks, Colors.green.withOpacity(0.05), Icons.play_circle_fill),
          _buildDropColumn("RANDOM EVENTS", _stageRandomTasks, Colors.orange.withOpacity(0.05), Icons.shuffle),
          _buildDropColumn("ALL STAGE TASKS", _stageAllTasks.map((e) => e.name).toList(), Colors.white.withOpacity(0.05), Icons.list, isMaster: true),
        ],
      ),
    );
  }

  Widget _buildDropColumn(String title, List<String> list, Color color, IconData icon, {bool isMaster = false, bool isLibrary = false}) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.white10)),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(children: [Icon(icon, size: 16, color: Colors.amber), const SizedBox(width: 8), Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 9))]),
            ),
            Expanded(
              child: DragTarget<String>(
                onAccept: (data) {
                  setState(() {
                    if (isLibrary) return;
                    if (isMaster) {
                       if (_libraryTasks.any((t) => t.name == data) && !_stageAllTasks.any((t) => t.name == data)) {
                          final template = _libraryTasks.firstWhere((t) => t.name == data);
                          _stageAllTasks.add(template);
                       }
                       return;
                    }
                    if (!list.contains(data)) {
                      list.add(data);
                      if (title == "START SETUP") _stageRandomTasks.remove(data);
                      if (title == "RANDOM EVENTS") _stageActiveTasks.remove(data);
                    }
                  });
                },
                builder: (context, candidates, rejects) {
                  return ReorderableListView(
                    buildDefaultDragHandles: false,
                    onReorder: (oldIndex, newIndex) { 
                      if (isLibrary) return;
                      setState(() { if (newIndex > oldIndex) newIndex -= 1; final item = list.removeAt(oldIndex); list.insert(newIndex, item); }); 
                    },
                    children: list.map((name) {
                      final task = isLibrary 
                          ? _libraryTasks.firstWhere((t) => t.name == name)
                          : _stageAllTasks.firstWhere((t) => t.name == name, orElse: () => Task(name: name));
                      return ReorderableDelayedDragStartListener(
                        index: list.indexOf(name),
                        key: ValueKey("${title}_$name"),
                        child: _buildTaskCard(task!, isMaster: isMaster || isLibrary, onDelete: (isMaster || isLibrary) ? null : () => setState(() => list.remove(name))),
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

  Widget _buildTaskCard(Task t, {bool isMaster = false, VoidCallback? onDelete}) {
    final isSelected = _selectedTask?.name == t.name;
    final isSameName = _selectedTask?.name == t.name;
    final isCrisis = t.timeToSolve != double.infinity;
    
    const Color selectionColor = Colors.cyanAccent;
    const Color milestoneColor = Colors.amber;
    const Color crisisColor = Colors.redAccent;

    return LongPressDraggable<String>(
      data: t.name,
      feedback: Material(
        color: Colors.transparent,
        child: Opacity(
          opacity: 0.9,
          child: Container(
            width: 250,
            decoration: BoxDecoration(
              color: const Color(0xFF2A2A2A),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: isCrisis ? crisisColor : (t.isMilestone ? milestoneColor : Colors.white24), width: 2),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 15, spreadRadius: 5, offset: const Offset(5, 5))],
            ),
            child: _buildCompactCard(t),
          ),
        ),
      ),
      child: GestureDetector(
        onTap: () => _selectTask(t.name),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: isSelected 
                ? selectionColor.withOpacity(0.2) 
                : (isSameName ? selectionColor.withOpacity(0.08) : (isCrisis ? crisisColor.withOpacity(0.05) : (t.isMilestone ? milestoneColor.withOpacity(0.05) : const Color(0xFF1E1E1E)))),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected 
                  ? selectionColor 
                  : (isSameName ? selectionColor.withOpacity(0.4) : (isCrisis ? crisisColor.withOpacity(0.6) : (t.isMilestone ? milestoneColor.withOpacity(0.5) : Colors.white10)))
            ),
            boxShadow: isSelected ? [BoxShadow(color: selectionColor.withOpacity(0.2), blurRadius: 8)] : null,
          ),
          child: Stack(
            children: [
              _buildCompactCard(t),
              if (onDelete != null)
                Positioned(right: 0, top: 0, child: IconButton(icon: const Icon(Icons.close, size: 14, color: Colors.white30), onPressed: onDelete)),
              Positioned(
                left: 4, 
                top: 12, 
                child: Icon(
                  isCrisis ? Icons.warning_amber_rounded : Icons.drag_indicator, 
                  size: 16, 
                  color: isSelected ? selectionColor : (isCrisis ? crisisColor : (t.isMilestone ? milestoneColor : Colors.white10))
                )
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCompactCard(Task t) {
    return Container(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _buildCompactMiniResList(t.cost ?? [], Colors.redAccent),
              const SizedBox(width: 8),
              Expanded(child: Text(t.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12), overflow: TextOverflow.ellipsis)),
              const SizedBox(width: 8),
              _buildCompactMiniResList(t.award ?? [], Colors.greenAccent),
            ],
          ),
          if ((t.myModifier?.isNotEmpty ?? false) || (t.online?.isNotEmpty ?? false) || (t.missed?.isNotEmpty ?? false))
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Wrap(
                spacing: 4, 
                runSpacing: 2, 
                children: [
                  ...(t.myModifier ?? []).map((m) => _buildCompactModTag(m, Colors.blueGrey)),
                  ...(t.online ?? []).map((m) => _buildCompactModTag(m, Colors.cyan.withOpacity(0.5))),
                  ...(t.missed ?? []).map((m) => _buildCompactModTag(m, Colors.redAccent.withOpacity(0.5))),
                ]
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCompactMiniResList(List<Ressource> list, Color color) {
    return Row(mainAxisSize: MainAxisSize.min, children: list.map((r) => Icon(_getResIcon(r.name), size: 10, color: color)).toList());
  }

  Widget _buildCompactModTag(Modifier m, Color color) {
    String txt = m.name.substring(0, 3);
    if (m is AddTask) txt = "+ ${m.nameOfTask.split(" ").first}";
    if (m is RemoveTask) txt = "- ${m.nameOfTask.split(" ").first}";
    if (m is AutoExecuteModifier) txt = "⚙️ Auto";
    return Container(padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1), decoration: BoxDecoration(color: Colors.black38, borderRadius: BorderRadius.circular(4)), child: Text(txt, style: TextStyle(fontSize: 8, color: color)));
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

  void _addNewTask() {
    setState(() {
      final t = Task(
        name: 'New Task ${_stageAllTasks.length}', 
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

  void _exportStage() {
    final buffer = StringBuffer();
    buffer.writeln('// --- AUTO-GENERATED STAGE EXPORT (V4.6) ---');
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

    showDialog(context: context, builder: (context) => AlertDialog(title: const Text('Export Dart Code'), content: SizedBox(width: 900, height: 700, child: SingleChildScrollView(child: SelectableText(buffer.toString(), style: const TextStyle(fontFamily: 'monospace', fontSize: 11)))), actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK'))]));
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
