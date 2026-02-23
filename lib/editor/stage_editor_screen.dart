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

class StageEditorScreen extends StatefulWidget {
  const StageEditorScreen({super.key});

  @override
  State<StageEditorScreen> createState() => _StageEditorScreenState();
}

class _StageEditorScreenState extends State<StageEditorScreen> {
  Stage? _currentStage;
  Task? _selectedTask;
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
    _currentStage = allStages.isNotEmpty ? allStages.first : null;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  void _loadLibrary() {
    final allTasks = <Task>[];
    for (var stage in allStages) {
      allTasks.addAll(stage.allTasks);
    }
    setState(() {
      _libraryTasks.clear();
      _libraryTasks.addAll(allTasks);
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
        title: const Text('🛡️ Stage Architect V3.0 (Visual Logic)'),
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
          const Text("STAGE LEVEL: ", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.amber)),
          const SizedBox(width: 12),
          DropdownButton<Stage>(
            value: _currentStage,
            dropdownColor: const Color(0xFF1E1E1E),
            items: allStages.map((s) => DropdownMenuItem(value: s, child: Text('${s.level} - ${s.description.split(" ").take(2).join(" ")}...'))).toList(),
            onChanged: (s) => setState(() { _currentStage = s; _selectedTask = null; }),
          ),
          const Spacer(),
          Text("${_currentStage?.allTasks.length ?? 0} Tasks insgesamt", style: const TextStyle(color: Colors.grey, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildVisualBoard() {
    return Container(
      width: 900,
      padding: const EdgeInsets.all(8),
      color: Colors.black12,
      child: Row(
        children: [
          _buildDropColumn("START SETUP", _currentStage?.activeTasks ?? [], Colors.green.withOpacity(0.05), Icons.play_circle_fill),
          _buildDropColumn("RANDOM EVENTS", _currentStage?.randomTasks ?? [], Colors.orange.withOpacity(0.05), Icons.shuffle),
          _buildDropColumn("ALL STAGE TASKS", _currentStage?.allTasks.map((e) => e.name).toList() ?? [], Colors.white.withOpacity(0.05), Icons.list, isMaster: true),
        ],
      ),
    );
  }

  Widget _buildDropColumn(String title, List<String> list, Color color, IconData icon, {bool isMaster = false}) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.white10)),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Icon(icon, size: 16, color: Colors.amber),
                  const SizedBox(width: 8),
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11, letterSpacing: 1.2)),
                ],
              ),
            ),
            Expanded(
              child: DragTarget<String>(
                onAccept: (data) {
                  setState(() {
                    if (!list.contains(data)) {
                      list.add(data);
                      if (title == "START SETUP") _currentStage?.randomTasks.remove(data);
                      if (title == "RANDOM EVENTS") _currentStage?.activeTasks.remove(data);
                    }
                  });
                },
                builder: (context, candidates, rejects) {
                  return ReorderableListView(
                    buildDefaultDragHandles: false,
                    onReorder: (oldIndex, newIndex) {
                      setState(() {
                        if (newIndex > oldIndex) newIndex -= 1;
                        final item = list.removeAt(oldIndex);
                        list.insert(newIndex, item);
                      });
                    },
                    children: list.map((name) {
                      final task = _currentStage?.allTasks.firstWhere((t) => t.name == name, orElse: () => Task(name: name));
                      return ReorderableDelayedDragStartListener(
                        index: list.indexOf(name),
                        key: ValueKey("${title}_$name"),
                        child: _buildTaskCard(task!, isMaster: isMaster, onDeleteFromList: isMaster ? null : () => setState(() => list.remove(name))),
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

  Widget _buildTaskCard(Task t, {bool isMaster = false, VoidCallback? onDeleteFromList}) {
    final isSelected = _selectedTask == t;
    return LongPressDraggable<String>(
      data: t.name,
      feedback: Material(color: Colors.transparent, child: _buildGameLikeCard(t, width: 280, isDragging: true)),
      child: GestureDetector(
        onTap: () => _selectTask(t),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: isSelected ? Colors.amber.withOpacity(0.15) : const Color(0xFF1E1E1E),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: isSelected ? Colors.amber : Colors.white10),
            boxShadow: isSelected ? [BoxShadow(color: Colors.amber.withOpacity(0.2), blurRadius: 8)] : [],
          ),
          child: Stack(
            children: [
              _buildGameLikeCard(t),
              if (onDeleteFromList != null)
                Positioned(right: 0, top: 0, child: IconButton(icon: const Icon(Icons.close, size: 14, color: Colors.white30), onPressed: onDeleteFromList)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGameLikeCard(Task t, {double? width, bool isDragging = false}) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _buildMiniResList(t.cost, Colors.redAccent),
              const SizedBox(width: 8),
              Expanded(child: Text(t.name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: isDragging ? Colors.amber : Colors.white))),
              const SizedBox(width: 8),
              _buildMiniResList(t.award, Colors.greenAccent),
            ],
          ),
          const SizedBox(height: 6),
          if (t.myModifier.isNotEmpty)
            Wrap(
              spacing: 4,
              runSpacing: 2,
              children: t.myModifier.map((m) => _buildMiniModifierTag(m)).toList(),
            ),
        ],
      ),
    );
  }

  Widget _buildMiniResList(List<Ressource> list, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: list.map((r) => Padding(
        padding: const EdgeInsets.only(right: 2),
        child: Icon(_getResIcon(r.name), size: 12, color: color.withOpacity(0.8)),
      )).toList(),
    );
  }

  Widget _buildMiniModifierTag(Modifier m) {
    String sign = "";
    String target = "";
    if (m is AddTask) { sign = "+"; target = m.nameOfTask; }
    if (m is RemoveTask) { sign = "-"; target = m.nameOfTask; }
    if (m is AddToRandom) { sign = "🎲"; target = m.nameOfTask; }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
      decoration: BoxDecoration(color: Colors.black38, borderRadius: BorderRadius.circular(4)),
      child: Text("$sign ${target.split(" ").take(1).join()}", style: const TextStyle(fontSize: 9, color: Colors.blueGrey)),
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

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.auto_fix_high, size: 64, color: Colors.white10),
          SizedBox(height: 16),
          Text("Wähle einen Task links aus,\num ihn hier strategisch zu verfeinern.", textAlign: TextAlign.center, style: TextStyle(color: Colors.white30)),
        ],
      ),
    );
  }

  Widget _buildTaskEditor() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('TASK-DETAILS'),
          _buildDraftTextField('Task Name', _nameController, (v) => setState(() {})),
          const SizedBox(height: 16),
          _buildDraftTextField('Beschreibung', _descController, (v) {}, maxLines: 2),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _buildDraftTextField('Dauer (ms)', _durationController, (v) {}, isNumber: true)),
              const SizedBox(width: 24),
              const Text('Meilenstein?'),
              Switch(value: _selectedTask!.isMilestone, onChanged: (v) => setState(() => _selectedTask!.isMilestone = v)),
            ],
          ),
          const Divider(height: 64),
          _buildResourceEditor('KOSTEN (INPUT)', _selectedTask!.cost, Colors.redAccent),
          const SizedBox(height: 32),
          _buildResourceEditor('BELOHNUNG (OUTPUT)', _selectedTask!.award, Colors.greenAccent),
          const Divider(height: 64),
          _buildModifierEditor(),
        ],
      ),
    );
  }

  Widget _buildResourceEditor(String title, List<Ressource> list, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 14)),
            IconButton(icon: const Icon(Icons.add_circle, color: Colors.amber), onPressed: () => _showAddResourceDialog(list)),
          ],
        ),
        Wrap(
          spacing: 12, runSpacing: 12,
          children: list.map((res) => _buildResourceDetailCard(res, list)).toList(),
        ),
      ],
    );
  }

  Widget _buildResourceDetailCard(Ressource res, List<Ressource> list) {
    final isMultiplied = res.multiplierResourceName != null;
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
            if (isMultiplied) ...[
              const SizedBox(height: 8),
              _buildResourceDropdown('Faktor von', res.multiplierResourceName!, (v) => setState(() => res.multiplierResourceName = v)),
              _buildDraftTextField('Multiplikator', TextEditingController(text: res.multiplierValue.toString()), (v) => res.multiplierValue = double.tryParse(v) ?? 1.0, isNumber: true),
            ],
            TextButton(
              onPressed: () => setState(() {
                if (res.multiplierResourceName == null) { res.multiplierResourceName = "Member"; res.multiplierValue = 1.0; }
                else { res.multiplierResourceName = null; res.multiplierValue = null; }
              }),
              child: Text(isMultiplied ? 'Fixer Wert' : 'Abhängigkeit +', style: const TextStyle(fontSize: 10)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModifierEditor() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("MODIFIER (CHAIN LOGIC)", style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold)),
            ElevatedButton.icon(onPressed: _showAddModifierDialog, icon: const Icon(Icons.add), label: const Text("Hinzufügen")),
          ],
        ),
        const SizedBox(height: 12),
        ...(_selectedTask!.myModifier).map((m) => Card(
          margin: const EdgeInsets.symmetric(vertical: 4),
          child: ListTile(
            dense: true,
            title: Text(m.name, style: const TextStyle(color: Colors.amber, fontSize: 12)),
            subtitle: _buildSpecificModifierInputs(m),
            trailing: IconButton(icon: const Icon(Icons.delete, size: 16), onPressed: () => setState(() => _selectedTask!.myModifier.remove(m))),
          ),
        )),
      ],
    );
  }

  Widget _buildSpecificModifierInputs(Modifier m) {
    final allTaskNames = _libraryTasks.map((t) => t.name).toSet().toList()..sort();
    
    if (m is AddTask) return _buildSearchDropdown(allTaskNames, m.nameOfTask, (v) { _updateMod(m, AddTask(task: v!)); });
    if (m is RemoveTask) return _buildSearchDropdown(allTaskNames, m.nameOfTask, (v) { _updateMod(m, RemoveTask(task: v!)); });
    if (m is AddToRandom) return _buildSearchDropdown(allTaskNames, m.nameOfTask, (v) { _updateMod(m, AddToRandom(task: v!)); });
    if (m is SetMax) return Row(children: [Expanded(child: _buildResourceDropdown(m.workOn, (v)=>_updateMod(m, SetMax(ressource: v!, newMax: m.newMax)))), const SizedBox(width: 8), Expanded(child: _buildDraftTextField('Neu Max', TextEditingController(text: m.newMax.toString()), (v)=>_updateMod(m, SetMax(ressource: m.workOn, newMax: double.tryParse(v)??0)), isNumber: true))]);
    if (m is SetMin) return Row(children: [Expanded(child: _buildResourceDropdown(m.workOn, (v)=>_updateMod(m, SetMin(ressource: v!, newMin: m.newMin)))), const SizedBox(width: 8), Expanded(child: _buildDraftTextField('Neu Min', TextEditingController(text: m.newMin.toString()), (v)=>_updateMod(m, SetMin(ressource: m.workOn, newMin: double.tryParse(v)??0)), isNumber: true))]);
    if (m is MessageModifier) return _buildDraftTextField('Text', TextEditingController(text: m.message), (v) => _updateMod(m, MessageModifier(message: v)));
    if (m is RemoveModifer) return _buildSearchDropdown(allTaskNames, m.nameOfTask ?? "", (v) => _updateMod(m, RemoveModifer(nameOfTask: v, modifier: m.mymodifer)));
    
    return Text(m.description, style: const TextStyle(fontSize: 10, color: Colors.grey));
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

  void _showAddModifierDialog() {
    showDialog(context: context, builder: (context) => AlertDialog(title: const Text('Modifier Typ'), content: Column(mainAxisSize: MainAxisSize.min, children: [
      ListTile(title: const Text('AddTask'), onTap: () { setState(() => _selectedTask!.myModifier.add(AddTask(task: ""))); Navigator.pop(context); }),
      ListTile(title: const Text('RemoveTask'), onTap: () { setState(() => _selectedTask!.myModifier.add(RemoveTask(task: ""))); Navigator.pop(context); }),
      ListTile(title: const Text('AddToRandom'), onTap: () { setState(() => _selectedTask!.myModifier.add(AddToRandom(task: ""))); Navigator.pop(context); }),
      ListTile(title: const Text('SetMax'), onTap: () { setState(() => _selectedTask!.myModifier.add(SetMax(ressource: "Member", newMax: 100))); Navigator.pop(context); }),
      ListTile(title: const Text('SetMin'), onTap: () { setState(() => _selectedTask!.myModifier.add(SetMin(ressource: "Member", newMin: 0))); Navigator.pop(context); }),
      ListTile(title: const Text('Message'), onTap: () { setState(() => _selectedTask!.myModifier.add(MessageModifier(message: ""))); Navigator.pop(context); }),
      ListTile(title: const Text('RemoveModifer'), onTap: () { setState(() => _selectedTask!.myModifier.add(RemoveModifer(nameOfTask: "", modifier: []))); Navigator.pop(context); }),
    ])));
  }

  void _showAddResourceDialog(List<Ressource> list) {
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
      final t = Task(name: 'New Task ${_currentStage?.allTasks.length}', description: '...', duration: 5000);
      _currentStage?.allTasks.add(t);
      _selectTask(t);
    });
  }

  void _exportStage() {
    final buffer = StringBuffer();
    buffer.writeln('// --- AUTO-GENERATED STAGE EXPORT (V3.0) ---');
    buffer.writeln('import \'package:save_the_world_flutter_app/models/addtask.model.dart\';');
    buffer.writeln('import \'package:save_the_world_flutter_app/models/removetask.model.dart\';');
    buffer.writeln('import \'package:save_the_world_flutter_app/models/AddToRandom.model.dart\';');
    buffer.writeln('import \'package:save_the_world_flutter_app/models/setmax.model.dart\';');
    buffer.writeln('import \'package:save_the_world_flutter_app/models/setmin.model.dart\';');
    buffer.writeln('import \'package:save_the_world_flutter_app/models/message.modifier.dart\';');
    buffer.writeln('import \'package:save_the_world_flutter_app/models/removemodifier.model.dart\';');
    buffer.writeln('import \'package:save_the_world_flutter_app/models/stage.model.dart\';');
    buffer.writeln('import \'package:save_the_world_flutter_app/models/task.model.dart\';');
    buffer.writeln('import \'package:save_the_world_flutter_app/models/ressource.model.dart\';');
    buffer.writeln('import \'package:save_the_world_flutter_app/models/faith.ressource.model.dart\';');
    buffer.writeln('import \'package:save_the_world_flutter_app/models/member.ressource.model.dart\';');
    buffer.writeln('import \'package:save_the_world_flutter_app/models/money.ressource.model.dart\';');
    buffer.writeln('import \'package:save_the_world_flutter_app/models/publicity.ressource.model.dart\';');
    buffer.writeln('import \'package:save_the_world_flutter_app/models/time.ressource.model.dart\';');
    buffer.writeln('import \'package:save_the_world_flutter_app/models/wisdome.ressource.model.dart\';');
    buffer.writeln('');
    buffer.writeln('final Stage stage${_currentStage?.level} = Stage(');
    buffer.writeln('  level: ${_currentStage?.level},');
    buffer.writeln('  description: "${_currentStage?.description}",');
    buffer.writeln('  activeTasks: ${_formatStringList(_currentStage?.activeTasks)},');
    buffer.writeln('  randomTasks: ${_formatStringList(_currentStage?.randomTasks)},');
    buffer.writeln('  allTasks: [');
    for (var t in _currentStage?.allTasks ?? []) {
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

    showDialog(context: context, builder: (context) => AlertDialog(title: const Text('Export Dart Code'), content: SizedBox(width: 900, height: 700, child: SingleChildScrollView(child: SelectableText(buffer.toString(), style: const TextStyle(fontFamily: 'monospace', fontSize: 12)))), actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK'))]));
  }

  String _formatStringList(List<String>? list) { return (list == null || list.isEmpty) ? '[]' : '[${list.map((e) => '"$e"').join(', ')}]'; }
  String _exportResources(List<Ressource> list) { return list.map((res) => '${res.name}(value: ${res.value}${res.multiplierResourceName != null ? ', multiplierResourceName: "${res.multiplierResourceName}", multiplierValue: ${res.multiplierValue}' : ''})').join(', '); }
  String _exportModifiers(List<Modifier> list) {
    return list.map((m) {
      if (m is AddTask) return 'AddTask(task: "${m.nameOfTask}")';
      if (m is RemoveTask) return 'RemoveTask(task: "${m.nameOfTask}")';
      if (m is AddToRandom) return 'AddToRandom(task: "${m.nameOfTask}")';
      if (m is SetMax) return 'SetMax(ressource: "${m.workOn}", newMax: ${m.newMax})';
      if (m is SetMin) return 'SetMin(ressource: "${m.workOn}", newMin: ${m.newMin})';
      if (m is MessageModifier) return 'MessageModifier(message: "${m.message}")';
      if (m is RemoveModifer) return 'RemoveModifer(nameOfTask: "${m.nameOfTask}", modifier: [])';
      return '// Unknown Modifier';
    }).join(', ');
  }
}
