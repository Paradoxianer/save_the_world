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
import 'package:save_the_world_flutter_app/models/subtractres.model.dart';
import 'package:save_the_world_flutter_app/models/removemodifier.model.dart';
import 'package:save_the_world_flutter_app/models/faith.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/member.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/money.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/publicity.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/time.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/wisdome.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/message.modifier.dart';
import 'package:save_the_world_flutter_app/stages.dart';
import 'package:save_the_world_flutter_app/data/stages/common_tasks.dart' as common;

class StageEditorScreen extends StatefulWidget {
  const StageEditorScreen({super.key});

  @override
  State<StageEditorScreen> createState() => _StageEditorScreenState();
}

class _StageEditorScreenState extends State<StageEditorScreen> {
  Stage? _currentStage;
  Task? _selectedTask;
  
  // EDITIERBARE LISTEN (Fix für Unmodifiable List Error)
  List<Task> _stageAllTasks = [];
  List<String> _stageActiveTasks = [];
  List<String> _stageRandomTasks = [];
  
  final List<Task> _libraryTasks = [];
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
    _loadLibrary();
    _loadStage(allStages.first);
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

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  void _loadLibrary() {
    setState(() {
      _libraryTasks.clear();
      _libraryTasks.addAll([
        common.baseSleep,
        common.baseFreeTime,
        common.baseBible,
        common.collectMoney,
        common.holySpiritWorking,
        common.someoneWantsToMarry,
        common.funeralGeneral,
      ]);
    });
  }

  void _selectTask(Task t) {
    setState(() {
      _selectedTask = t;
      _nameController.text = t.name;
      _descController.text = t.description;
      _durationController.text = t.duration.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🛡️ Stage Architect V3.7 (Logic Board)'),
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
            items: allStages.map((s) => DropdownMenuItem(value: s, child: Text('${s.level} - ${s.description.split(" ").take(3).join(" ")}...'))).toList(),
            onChanged: (s) => _loadStage(s!),
          ),
          const Spacer(),
          Text("${_stageAllTasks.length} Tasks insgesamt", style: const TextStyle(color: Colors.grey, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildVisualBoard() {
    return Container(
      width: 1100,
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
              child: Row(children: [Icon(icon, size: 16, color: Colors.amber), const SizedBox(width: 8), Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 10))]),
            ),
            Expanded(
              child: DragTarget<String>(
                onAccept: (data) {
                  setState(() {
                    if (isLibrary) return;
                    if (isMaster) {
                       // Import aus Library in die Stage
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
    final isSelected = _selectedTask == t;
    return LongPressDraggable<String>(
      data: t.name,
      feedback: Material(color: Colors.transparent, child: _buildCompactCard(t, width: 250, isDragging: true)),
      child: GestureDetector(
        onTap: () => _selectTask(t),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: isSelected ? Colors.amber.withOpacity(0.15) : const Color(0xFF1E1E1E),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: isSelected ? Colors.amber : Colors.white10),
          ),
          child: Stack(
            children: [
              _buildCompactCard(t),
              if (onDelete != null)
                Positioned(right: 0, top: 0, child: IconButton(icon: const Icon(Icons.close, size: 14, color: Colors.white30), onPressed: onDelete)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCompactCard(Task t, {double? width, bool isDragging = false}) {
    return Container(
      width: width, padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _buildMiniResList(t.cost, Colors.redAccent),
              const SizedBox(width: 8),
              Expanded(child: Text(t.name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: isDragging ? Colors.amber : Colors.white), overflow: TextOverflow.ellipsis)),
              const SizedBox(width: 8),
              _buildMiniResList(t.award, Colors.greenAccent),
            ],
          ),
          if (t.myModifier.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Wrap(spacing: 4, children: t.myModifier.map((m) => _buildModTag(m)).toList()),
            ),
        ],
      ),
    );
  }

  Widget _buildMiniResList(List<Ressource> list, Color color) {
    return Row(mainAxisSize: MainAxisSize.min, children: list.map((r) => Icon(_getResIcon(r.name), size: 10, color: color)).toList());
  }

  Widget _buildModTag(Modifier m) {
    String txt = m.name.substring(0, 3);
    if (m is AddTask) txt = "+ ${m.nameOfTask.split(" ").first}";
    if (m is RemoveTask) txt = "- ${m.nameOfTask.split(" ").first}";
    if (m is AutoExecuteModifier) txt = "⚙️ Auto";
    return Container(padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1), decoration: BoxDecoration(color: Colors.black38, borderRadius: BorderRadius.circular(4)), child: Text(txt, style: const TextStyle(fontSize: 8, color: Colors.blueGrey)));
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
    return const Center(child: Text("Task wählen zum Editieren", style: TextStyle(color: Colors.white24)));
  }

  Widget _buildTaskEditor() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('TASK: ${_selectedTask!.name}'),
          _buildDraftTextField('Name', _nameController, (v) => setState(() {})),
          const SizedBox(height: 16),
          _buildDraftTextField('Beschreibung', _descController, (v) {}, maxLines: 2),
          Row(
            children: [
              Expanded(child: _buildDraftTextField('Dauer (ms)', _durationController, (v) {}, isNumber: true)),
              const SizedBox(width: 16),
              const Text('Milestone?'),
              Switch(value: _selectedTask!.isMilestone, onChanged: (v) => setState(() => _selectedTask!.isMilestone = v)),
            ],
          ),
          const Divider(height: 64),
          _buildResEditorSection('KOSTEN (INPUT)', _selectedTask!.cost, Colors.redAccent),
          const SizedBox(height: 32),
          _buildResEditorSection('BELOHNUNG (OUTPUT)', _selectedTask!.award, Colors.greenAccent),
          const Divider(height: 64),
          _buildModifierSection(),
        ],
      ),
    );
  }

  Widget _buildResEditorSection(String title, List<Ressource> list, Color color) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(title, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 14)), IconButton(icon: const Icon(Icons.add_circle, color: Colors.amber), onPressed: () => _showAddResDialog(list))]),
      Wrap(spacing: 12, runSpacing: 12, children: list.map((res) => _buildResCard(res, list)).toList()),
    ]);
  }

  Widget _buildResCard(Ressource res, List<Ressource> list) {
    final hasMult = res.multiplierResourceName != null;
    return Card(
      color: Colors.white.withOpacity(0.03),
      child: Container(
        padding: const EdgeInsets.all(12),
        width: 200,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(res.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                IconButton(icon: const Icon(Icons.delete, size: 14), onPressed: () => setState(() => list.remove(res))),
              ],
            ),
            _buildDraftTextField('Wert', TextEditingController(text: res.value.toString()), (v) => res.value = double.tryParse(v) ?? 0, isNumber: true),
            if (hasMult) ...[
              const SizedBox(height: 8),
              _buildResourceDropdown(res.multiplierResourceName!, (v) => setState(() => res.multiplierResourceName = v)),
              _buildDraftTextField('Faktor', TextEditingController(text: res.multiplierValue.toString()), (v) => res.multiplierValue = double.tryParse(v) ?? 1.0, isNumber: true),
            ],
            TextButton(
              onPressed: () => setState(() {
                if (res.multiplierResourceName == null) { res.multiplierResourceName = "Member"; res.multiplierValue = 1.0; }
                else { res.multiplierResourceName = null; res.multiplierValue = null; }
              }),
              child: Text(hasMult ? 'Fix' : 'Abhängigkeit +', style: const TextStyle(fontSize: 10)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModifierSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("MODIFIER (CHAIN LOGIC)", style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold)),
            IconButton(icon: const Icon(Icons.add_box), onPressed: _showAddModDialog),
          ],
        ),
        const SizedBox(height: 12),
        ...(_selectedTask!.myModifier).map((m) => Card(
          margin: const EdgeInsets.symmetric(vertical: 4),
          child: ListTile(
            dense: true,
            title: Text(m.name, style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 11)),
            subtitle: _buildModInput(m),
            trailing: IconButton(icon: const Icon(Icons.delete, size: 16), onPressed: () => setState(() => _selectedTask!.myModifier.remove(m))),
          ),
        )),
      ],
    );
  }

  Widget _buildModInput(Modifier m) {
    final allTaskNames = {..._libraryTasks.map((e)=>e.name), ...(_stageAllTasks.map((e)=>e.name))}.toList()..sort();
    
    if (m is AddTask) return _buildSearchDropdown(allTaskNames, m.nameOfTask, (v) => _updateMod(m, AddTask(task: v!)));
    if (m is RemoveTask) return _buildSearchDropdown(allTaskNames, m.nameOfTask, (v) => _updateMod(m, RemoveTask(task: v!)));
    if (m is AddToRandom) return _buildSearchDropdown(allTaskNames, m.nameOfTask, (v) => _updateMod(m, AddToRandom(task: v!)));
    if (m is SetMax) return Row(children: [Expanded(child: _buildResourceDropdown(m.workOn, (v)=>_updateMod(m, SetMax(ressource: v!, newMax: m.newMax)))), const SizedBox(width: 8), Expanded(child: _buildDraftTextField('Neu Max', TextEditingController(text: m.newMax.toString()), (v)=>_updateMod(m, SetMax(ressource: m.workOn, newMax: double.tryParse(v)??0)), isNumber: true))]);
    if (m is SetMin) return Row(children: [Expanded(child: _buildResourceDropdown(m.workOn, (v)=>_updateMod(m, SetMin(ressource: v!, newMin: m.newMin)))), const SizedBox(width: 8), Expanded(child: _buildDraftTextField('Neu Min', TextEditingController(text: m.newMin.toString()), (v)=>_updateMod(m, SetMin(ressource: m.workOn, newMin: double.tryParse(v)??0)), isNumber: true))]);
    if (m is AutoExecuteModifier) return Row(children: [Expanded(child: _buildDraftTextField('Intervall (ms)', TextEditingController(text: m.intervalMs.toString()), (v) => _updateMod(m, AutoExecuteModifier(modifiers: m.modifiers, intervalMs: int.tryParse(v) ?? 5000)), isNumber: true)), const SizedBox(width: 8), const Text("Auto-Run", style: TextStyle(color: Colors.greenAccent, fontSize: 10))]);
    if (m is RemoveModifer) return _buildSearchDropdown(allTaskNames, m.nameOfTask ?? "", (v) => _updateMod(m, RemoveModifer(nameOfTask: v, modifier: m.mymodifer)));
    if (m is MessageModifier) return _buildDraftTextField('Text', TextEditingController(text: m.message), (v) => _updateMod(m, MessageModifier(message: v)));
    
    return Text(m.description, style: const TextStyle(fontSize: 10));
  }

  void _updateMod(Modifier old, Modifier newMod) {
    setState(() {
      final index = _selectedTask!.myModifier.indexOf(old);
      _selectedTask!.myModifier[index] = newMod;
    });
  }

  Widget _buildSearchDropdown(List<String> items, String current, Function(String?) onChanged) {
    return DropdownButtonFormField<String>(
      isDense: true,
      value: items.contains(current) ? current : null,
      decoration: const InputDecoration(isDense: true, contentPadding: EdgeInsets.all(8), border: OutlineInputBorder()),
      items: items.map((n) => DropdownMenuItem(value: n, child: Text(n, style: const TextStyle(fontSize: 11)))).toList(),
      onChanged: onChanged,
    );
  }

  Widget _buildResourceDropdown(String current, Function(String?) onChanged) {
    return DropdownButtonFormField<String>(
      isDense: true,
      value: _resourceTypes.contains(current) ? current : null,
      decoration: const InputDecoration(isDense: true, contentPadding: EdgeInsets.all(8), border: OutlineInputBorder()),
      items: _resourceTypes.map((n) => DropdownMenuItem(value: n, child: Text(n, style: const TextStyle(fontSize: 11)))).toList(),
      onChanged: onChanged,
    );
  }

  void _showAddModDialog() {
    showDialog(context: context, builder: (context) => AlertDialog(title: const Text('Modifier Typ'), content: Column(mainAxisSize: MainAxisSize.min, children: [
      ListTile(title: const Text('AddTask'), onTap: () { setState(() => _selectedTask!.myModifier.add(AddTask(task: ""))); Navigator.pop(context); }),
      ListTile(title: const Text('RemoveTask'), onTap: () { setState(() => _selectedTask!.myModifier.add(RemoveTask(task: ""))); Navigator.pop(context); }),
      ListTile(title: const Text('AddToRandom'), onTap: () { setState(() => _selectedTask!.myModifier.add(AddToRandom(task: ""))); Navigator.pop(context); }),
      ListTile(title: const Text('SetMax'), onTap: () { setState(() => _selectedTask!.myModifier.add(SetMax(ressource: "Member", newMax: 100))); Navigator.pop(context); }),
      ListTile(title: const Text('SetMin'), onTap: () { setState(() => _selectedTask!.myModifier.add(SetMin(ressource: "Member", newMin: 0))); Navigator.pop(context); }),
      ListTile(title: const Text('AutoExecute'), onTap: () { setState(() => _selectedTask!.myModifier.add(AutoExecuteModifier(modifiers: [], intervalMs: 5000))); Navigator.pop(context); }),
      ListTile(title: const Text('RemoveModifer'), onTap: () { setState(() => _selectedTask!.myModifier.add(RemoveModifer(nameOfTask: "", modifier: []))); Navigator.pop(context); }),
      ListTile(title: const Text('Message'), onTap: () { setState(() => _selectedTask!.myModifier.add(MessageModifier(message: ""))); Navigator.pop(context); }),
    ])));
  }

  void _showAddResDialog(List<Ressource> list) {
    showDialog(context: context, builder: (context) => AlertDialog(title: const Text('Ressourcentyp'), content: Column(mainAxisSize: MainAxisSize.min, children: _resourceTypes.map((type) => ListTile(title: Text(type), onTap: () { setState(() => list.add(_createResourceInstance(type))); Navigator.pop(context); })).toList())));
  }

  Ressource _createResourceInstance(String type) {
    switch (type) {
      case "Faith": return Faith(value: 0);
      case "Member": return Member(value: 0);
      case "Money": return Money(value: 0);
      case "Publicity": return Publicity(value: 0);
      case "Time": return Time(value: 0);
      case "Wisdom": return Wisdom(value: 0);
      default: return Ressource(name: type, value: 0);
    }
  }

  Widget _buildDraftTextField(String label, TextEditingController controller, Function(String) onChanged, {bool isNumber = false, int maxLines = 1}) {
    return TextFormField(controller: controller, style: const TextStyle(fontSize: 12), decoration: InputDecoration(labelText: label, border: const OutlineInputBorder(), isDense: true), keyboardType: isNumber ? TextInputType.number : TextInputType.text, maxLines: maxLines, onChanged: onChanged);
  }

  Widget _buildSectionHeader(String title) {
    return Padding(padding: const EdgeInsets.only(bottom: 12), child: Text(title, style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 18)));
  }

  void _addNewTask() {
    setState(() {
      final t = Task(name: 'New Task ${_stageAllTasks.length}', description: '...', duration: 5000);
      _stageAllTasks.add(t);
      _selectTask(t);
    });
  }

  void _exportStage() {
    final buffer = StringBuffer();
    buffer.writeln('// --- AUTO-GENERATED STAGE EXPORT (V3.7) ---');
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
      if (m is AddTask) return 'AddTask(task: "${m.nameOfTask}")';
      if (m is RemoveTask) return 'RemoveTask(task: "${m.nameOfTask}")';
      if (m is AddToRandom) return 'AddToRandom(task: "${m.nameOfTask}")';
      if (m is SetMax) return 'SetMax(ressource: "${m.workOn}", newMax: ${m.newMax})';
      if (m is SetMin) return 'SetMin(ressource: "${m.workOn}", newMin: ${m.newMin})';
      if (m is MessageModifier) return 'MessageModifier(message: "${m.message}")';
      if (m is RemoveModifer) return 'RemoveModifer(nameOfTask: "${m.nameOfTask}", modifier: [])';
      if (m is AutoExecuteModifier) return 'AutoExecuteModifier(modifiers: [], intervalMs: ${m.intervalMs})';
      return '// Unknown Modifier';
    }).join(', ');
  }
}
