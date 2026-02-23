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

enum TaskAvailability { start, random, chained }

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
        title: const Text('🛡️ Stage Architect V2.3'),
        actions: [
          IconButton(icon: const Icon(Icons.code), tooltip: 'Vollständiger Export', onPressed: _exportStage),
        ],
      ),
      body: Row(
        children: [
          _buildSidebar(),
          Expanded(
            child: _selectedTask == null
                ? const Center(child: Text('Wähle einen Task zum Editieren aus'))
                : _buildTaskEditor(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addNewTask,
        label: const Text('Neuer Task'),
        icon: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildSidebar() {
    return Container(
      width: 350,
      decoration: const BoxDecoration(border: Border(right: BorderSide(color: Colors.white12))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButtonFormField<Stage>(
              decoration: const InputDecoration(labelText: 'Stage'),
              value: _currentStage,
              items: allStages.map((s) => DropdownMenuItem(value: s, child: Text('Stage ${s.level}'))).toList(),
              onChanged: (s) => setState(() { _currentStage = s; _selectedTask = null; }),
            ),
          ),
          _buildSectionTab("TASKS IN STAGE"),
          Expanded(
            flex: 2,
            child: ListView.builder(
              itemCount: _currentStage?.allTasks.length ?? 0,
              itemBuilder: (context, index) {
                final task = _currentStage!.allTasks[index];
                final availability = _getAvailability(task.name);
                return ListTile(
                  dense: true,
                  title: Text(task.name),
                  subtitle: Text(availability.name.toUpperCase(), style: TextStyle(color: _getAvailabilityColor(availability), fontSize: 10)),
                  selected: _selectedTask == task,
                  onTap: () => _selectTask(task),
                );
              },
            ),
          ),
          const Divider(),
          _buildSectionTab("GLOBAL LIBRARY"),
          Expanded(
            flex: 1,
            child: ListView.builder(
              itemCount: _libraryTasks.length,
              itemBuilder: (context, index) {
                final task = _libraryTasks[index];
                return ListTile(
                  dense: true,
                  title: Text(task.name, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                  onTap: () => _importFromLibrary(task),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTab(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.amber, fontSize: 11)),
    );
  }

  Widget _buildTaskEditor() {
    final availability = _getAvailability(_selectedTask!.name);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildSectionHeader('Edit Task: ${_selectedTask!.name}'),
              _buildAvailabilitySelector(availability),
            ],
          ),
          _buildDraftTextField('Name', _nameController, (v) {
             _updateTaskNameRefs(_selectedTask!.name, v);
          }),
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
          _buildResourceSection('Kosten (Cost)', _selectedTask!.cost),
          const SizedBox(height: 32),
          _buildResourceSection('Belohnungen (Award)', _selectedTask!.award),
          const Divider(height: 64),
          _buildSectionHeader('Modifier (Logic Chaining)'),
          _buildModifierSection(),
        ],
      ),
    );
  }

  Widget _buildModifierSection() {
    return Column(
      children: [
        ...(_selectedTask!.myModifier ?? []).map((m) => _buildModifierEditorTile(m)),
        const SizedBox(height: 16),
        ElevatedButton.icon(
          onPressed: _showAddModifierDialog,
          icon: const Icon(Icons.add_box),
          label: const Text('Modifier hinzufügen'),
        ),
      ],
    );
  }

  Widget _buildModifierEditorTile(Modifier m) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(m.name, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.amber)),
                IconButton(icon: const Icon(Icons.delete, size: 18), onPressed: () => setState(() => _selectedTask!.myModifier?.remove(m))),
              ],
            ),
            _buildSpecificModifierInputs(m),
          ],
        ),
      ),
    );
  }

  Widget _buildSpecificModifierInputs(Modifier m) {
    if (m is AddTask) {
      return _buildTaskDropdown('Task zum Hinzufügen', m.nameOfTask, (v) {
        if (v != null) {
          final index = _selectedTask!.myModifier!.indexOf(m);
          _selectedTask!.myModifier![index] = AddTask(task: v);
          setState(() {});
        }
      });
    }
    if (m is RemoveTask) {
      return _buildTaskDropdown('Task zum Entfernen', m.nameOfTask, (v) {
        if (v != null) {
          final index = _selectedTask!.myModifier!.indexOf(m);
          _selectedTask!.myModifier![index] = RemoveTask(task: v);
          setState(() {});
        }
      });
    }
    if (m is SetMax) {
      return Row(
        children: [
          Expanded(child: _buildResourceDropdown('Ressource', m.workOn, (v) {
            if (v != null) {
              final index = _selectedTask!.myModifier!.indexOf(m);
              _selectedTask!.myModifier![index] = SetMax(ressource: v, newMax: m.newMax);
              setState(() {});
            }
          })),
          const SizedBox(width: 16),
          Expanded(child: _buildDraftTextField('Neu Max', TextEditingController(text: m.newMax.toString()), (v) {
             final index = _selectedTask!.myModifier!.indexOf(m);
             _selectedTask!.myModifier![index] = SetMax(ressource: m.workOn, newMax: double.tryParse(v) ?? 0);
          }, isNumber: true)),
        ],
      );
    }
    if (m is SetMin) {
      return Row(
        children: [
          Expanded(child: _buildResourceDropdown('Ressource', m.workOn, (v) {
            if (v != null) {
              final index = _selectedTask!.myModifier!.indexOf(m);
              _selectedTask!.myModifier![index] = SetMin(ressource: v, newMin: m.newMin);
              setState(() {});
            }
          })),
          const SizedBox(width: 16),
          Expanded(child: _buildDraftTextField('Neu Min', TextEditingController(text: m.newMin.toString()), (v) {
             final index = _selectedTask!.myModifier!.indexOf(m);
             _selectedTask!.myModifier![index] = SetMin(ressource: m.workOn, newMin: double.tryParse(v) ?? 0);
          }, isNumber: true)),
        ],
      );
    }
    if (m is AddToRandom) {
      return _buildTaskDropdown('Task für Random Pool', m.nameOfTask, (v) {
        if (v != null) {
          final index = _selectedTask!.myModifier!.indexOf(m);
          _selectedTask!.myModifier![index] = AddToRandom(task: v);
          setState(() {});
        }
      });
    }
    if (m is AutoExecuteModifier) {
      return Column(
        children: [
          _buildDraftTextField('Intervall (ms)', TextEditingController(text: m.intervalMs.toString()), (v) {
             final index = _selectedTask!.myModifier!.indexOf(m);
             _selectedTask!.myModifier![index] = AutoExecuteModifier(modifiers: m.modifiers, intervalMs: int.tryParse(v) ?? 5000);
          }, isNumber: true),
          const Text('Führt verschachtelte Modifier aus'),
        ],
      );
    }
    if (m is MessageModifier) {
      final ctrl = TextEditingController(text: m.message);
      return _buildDraftTextField('Nachricht', ctrl, (v) {
         // Wir mappen das hier einfach für den Export
      });
    }
    return Text(m.description);
  }

  Widget _buildTaskDropdown(String label, String current, Function(String?) onChanged) {
    final allNames = _libraryTasks.map((t) => t.name).toSet().toList()..sort();
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
      value: allNames.contains(current) ? current : null,
      items: allNames.map((n) => DropdownMenuItem(value: n, child: Text(n))).toList(),
      onChanged: onChanged,
    );
  }

  Widget _buildResourceDropdown(String label, String current, Function(String?) onChanged) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
      value: _resourceTypes.contains(current) ? current : null,
      items: _resourceTypes.map((n) => DropdownMenuItem(value: n, child: Text(n))).toList(),
      onChanged: onChanged,
    );
  }

  void _showAddModifierDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Modifier Typ wählen'),
        content: SizedBox(
          width: 300,
          child: ListView(
            shrinkWrap: true,
            children: [
              _modTypeTile('AddTask', () => AddTask(task: "")),
              _modTypeTile('RemoveTask', () => RemoveTask(task: "")),
              _modTypeTile('AddToRandom', () => AddToRandom(task: "")),
              _modTypeTile('SetMax', () => SetMax(ressource: "Member", newMax: 100)),
              _modTypeTile('SetMin', () => SetMin(ressource: "Member", newMin: 0)),
              _modTypeTile('AutoExecute', () => AutoExecuteModifier(modifiers: [], intervalMs: 5000)),
              _modTypeTile('Message', () => MessageModifier(message: "Info")),
              _modTypeTile('SubtractRes', () => SubtractRes(ressources: [])),
            ],
          ),
        ),
      ),
    );
  }

  Widget _modTypeTile(String label, Modifier Function() creator) {
    return ListTile(
      title: Text(label),
      onTap: () {
        setState(() => _selectedTask!.myModifier?.add(creator()));
        Navigator.pop(context);
      },
    );
  }

  Widget _buildAvailabilitySelector(TaskAvailability current) {
    return SegmentedButton<TaskAvailability>(
      segments: const [
        ButtonSegment(value: TaskAvailability.start, label: Text("Start")),
        ButtonSegment(value: TaskAvailability.random, label: Text("Random")),
        ButtonSegment(value: TaskAvailability.chained, label: Text("Chained")),
      ],
      selected: {current},
      onSelectionChanged: (Set<TaskAvailability> newSelection) {
        setState(() {
          final val = newSelection.first;
          _currentStage!.activeTasks.remove(_selectedTask!.name);
          _currentStage!.randomTasks.remove(_selectedTask!.name);
          if (val == TaskAvailability.start) _currentStage!.activeTasks.add(_selectedTask!.name);
          if (val == TaskAvailability.random) _currentStage!.randomTasks.add(_selectedTask!.name);
        });
      },
    );
  }

  TaskAvailability _getAvailability(String taskName) {
    if (_currentStage?.activeTasks.contains(taskName) ?? false) return TaskAvailability.start;
    if (_currentStage?.randomTasks.contains(taskName) ?? false) return TaskAvailability.random;
    return TaskAvailability.chained;
  }

  Color _getAvailabilityColor(TaskAvailability a) {
    switch (a) {
      case TaskAvailability.start: return Colors.green;
      case TaskAvailability.random: return Colors.orange;
      case TaskAvailability.chained: return Colors.blueGrey;
    }
  }

  void _importFromLibrary(Task t) {
    setState(() {
      _currentStage?.allTasks.add(t);
      _selectTask(t);
    });
  }

  void _updateTaskNameRefs(String oldName, String newName) {
    if (_currentStage == null) return;
    if (_currentStage!.activeTasks.contains(oldName)) {
      _currentStage!.activeTasks.remove(oldName);
      _currentStage!.activeTasks.add(newName);
    }
    if (_currentStage!.randomTasks.contains(oldName)) {
      _currentStage!.randomTasks.remove(oldName);
      _currentStage!.randomTasks.add(newName);
    }
  }

  Widget _buildResourceSection(String title, List<Ressource> list) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [_buildSectionHeader(title), ElevatedButton(onPressed: () => _showAddResourceDialog(list), child: const Text('Hinzufügen'))],
        ),
        const SizedBox(height: 8),
        Wrap(spacing: 12, runSpacing: 12, children: list.map((res) => _buildResourceCard(res, list)).toList()),
      ],
    );
  }

  Widget _buildResourceCard(Ressource res, List<Ressource> list) {
    final isMultiplied = res.multiplierResourceName != null;
    return Card(
      child: Container(
        padding: const EdgeInsets.all(12),
        width: 220,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(res.name, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.amber)),
                IconButton(icon: const Icon(Icons.close, size: 16), onPressed: () => setState(() => list.remove(res))),
              ],
            ),
            _buildDraftTextField('Basiswert', TextEditingController(text: res.value.toString()), (v) => res.value = double.tryParse(v) ?? 0, isNumber: true),
            if (isMultiplied) ...[
              const SizedBox(height: 8),
              _buildResourceDropdown('Skaliert mit', res.multiplierResourceName!, (v) => setState(() => res.multiplierResourceName = v)),
              _buildDraftTextField('Faktor', TextEditingController(text: res.multiplierValue.toString()), (v) => res.multiplierValue = double.tryParse(v) ?? 1.0, isNumber: true),
            ],
            TextButton(
              onPressed: () => setState(() {
                if (res.multiplierResourceName == null) { res.multiplierResourceName = "Member"; res.multiplierValue = 1.0; }
                else { res.multiplierResourceName = null; res.multiplierValue = null; }
              }),
              child: Text(isMultiplied ? 'Abhängigkeit weg' : 'Abhängigkeit +'),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddResourceDialog(List<Ressource> list) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Ressourcentyp'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: _resourceTypes.map((type) => ListTile(
            title: Text(type),
            onTap: () { setState(() => list.add(_createResourceInstance(type))); Navigator.pop(context); },
          )).toList(),
        ),
      ),
    );
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
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      maxLines: maxLines,
      onChanged: onChanged,
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(title, style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 18)),
    );
  }

  void _addNewTask() {
    final t = Task(name: 'Neue Aufgabe', description: '...', duration: 5000);
    _currentStage?.allTasks.add(t);
    _selectTask(t);
  }

  void _exportStage() {
    final buffer = StringBuffer();
    buffer.writeln('import \'package:save_the_world_flutter_app/models/addtask.model.dart\';');
    buffer.writeln('import \'package:save_the_world_flutter_app/models/removetask.model.dart\';');
    buffer.writeln('import \'package:save_the_world_flutter_app/models/AddToRandom.model.dart\';');
    buffer.writeln('import \'package:save_the_world_flutter_app/models/setmax.model.dart\';');
    buffer.writeln('import \'package:save_the_world_flutter_app/models/setmin.model.dart\';');
    buffer.writeln('import \'package:save_the_world_flutter_app/models/autoexecute.model.dart\';');
    buffer.writeln('import \'package:save_the_world_flutter_app/models/subtractres.model.dart\';');
    buffer.writeln('import \'package:save_the_world_flutter_app/models/message.modifier.dart\';');
    buffer.writeln('// ... weitere Ressourcen-Imports ...');
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
      if (t.myModifier.isNotEmpty) {
        buffer.writeln('      modifier: [${_exportModifiers(t.myModifier)}],');
      }
      buffer.writeln('    ),');
    }
    
    buffer.writeln('  ],');
    buffer.writeln(');');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Export Dart Code'),
        content: SizedBox(width: 900, height: 700, child: SingleChildScrollView(child: SelectableText(buffer.toString(), style: const TextStyle(fontFamily: 'monospace', fontSize: 12)))),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Fertig'))],
      ),
    );
  }

  String _formatStringList(List<String>? list) {
    if (list == null || list.isEmpty) return '[]';
    return '[${list.map((e) => '"$e"').join(', ')}]';
  }

  String _exportResources(List<Ressource> list) {
    return list.map((res) {
      String params = 'value: ${res.value}';
      if (res.multiplierResourceName != null) {
        params += ', multiplierResourceName: "${res.multiplierResourceName}", multiplierValue: ${res.multiplierValue}';
      }
      return '${res.name}($params)';
    }).join(', ');
  }

  String _exportModifiers(List<Modifier> list) {
    return list.map((m) {
      if (m is AddTask) return 'AddTask(task: "${m.nameOfTask}")';
      if (m is RemoveTask) return 'RemoveTask(task: "${m.nameOfTask}")';
      if (m is AddToRandom) return 'AddToRandom(task: "${m.nameOfTask}")';
      if (m is SetMax) return 'SetMax(ressource: "${m.workOn}", newMax: ${m.newMax})';
      if (m is SetMin) return 'SetMin(ressource: "${m.workOn}", newMin: ${m.newMin})';
      if (m is AutoExecuteModifier) return 'AutoExecuteModifier(modifiers: [], intervalMs: ${m.intervalMs})';
      if (m is MessageModifier) return 'MessageModifier(message: "${m.message}")';
      if (m is SubtractRes) return 'SubtractRes(ressources: [${_exportResources(m.ressources)}])';
      return '// Unknown Modifier: ${m.name}';
    }).join(', ');
  }
}
