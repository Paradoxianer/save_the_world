import 'package:flutter/material.dart';
import 'package:save_the_world_flutter_app/models/task.model.dart';
import 'package:save_the_world_flutter_app/models/stage.model.dart';
import 'package:save_the_world_flutter_app/models/ressource.model.dart';
import 'package:save_the_world_flutter_app/models/modifier.model.dart';
import 'package:save_the_world_flutter_app/models/addtask.model.dart';
import 'package:save_the_world_flutter_app/models/faith.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/member.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/money.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/publicity.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/time.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/wisdome.ressource.model.dart';
import 'package:save_the_world_flutter_app/stages.dart';

class StageEditorScreen extends StatefulWidget {
  const StageEditorScreen({super.key});

  @override
  State<StageEditorScreen> createState() => _StageEditorScreenState();
}

class _StageEditorScreenState extends State<StageEditorScreen> {
  Stage? _currentStage;
  Task? _selectedTask;
  final List<String> _allExistingTaskNames = [];
  final List<String> _resourceTypes = ["Faith", "Member", "Money", "Publicity", "Time", "Wisdom"];

  @override
  void initState() {
    super.initState();
    _loadAllTaskNames();
    _currentStage = allStages.isNotEmpty ? allStages.first : null;
  }

  void _loadAllTaskNames() {
    final names = <String>{};
    for (var stage in allStages) {
      for (var task in stage.allTasks) {
        names.add(task.name);
      }
    }
    setState(() {
      _allExistingTaskNames.clear();
      _allExistingTaskNames.addAll(names.toList()..sort());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🛡️ Stage Architect'),
        actions: [
          IconButton(
            icon: const Icon(Icons.code),
            tooltip: 'Export Stage to Dart',
            onPressed: _exportStage,
          ),
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
      width: 300,
      decoration: const BoxDecoration(border: Border(right: BorderSide(color: Colors.white12))),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButtonFormField<Stage>(
              decoration: const InputDecoration(labelText: 'Stage auswählen'),
              value: _currentStage,
              items: allStages.map((s) => DropdownMenuItem(value: s, child: Text('Stage ${s.level}'))).toList(),
              onChanged: (s) => setState(() { _currentStage = s; _selectedTask = null; }),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _currentStage?.allTasks.length ?? 0,
              itemBuilder: (context, index) {
                final task = _currentStage!.allTasks[index];
                return ListTile(
                  title: Text(task.name),
                  selected: _selectedTask == task,
                  onTap: () => setState(() => _selectedTask = task),
                  trailing: task.isMilestone ? const Icon(Icons.star, color: Colors.amber, size: 16) : null,
                );
              },
            ),
          ),
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
          _buildSectionHeader('Basis-Konfiguration'),
          _buildTextField('Task Name', _selectedTask!.name, (v) => setState(() => _selectedTask!.name = v)),
          const SizedBox(height: 16),
          _buildTextField('Beschreibung', _selectedTask!.description, (v) => _selectedTask!.description = v, maxLines: 2),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _buildTextField('Dauer (ms)', _selectedTask!.duration.toString(), (v) => _selectedTask!.duration = double.tryParse(v) ?? 5000, isNumber: true)),
              const SizedBox(width: 24),
              const Text('Goldene Aufgabe?'),
              Switch(value: _selectedTask!.isMilestone, onChanged: (v) => setState(() => _selectedTask!.isMilestone = v)),
            ],
          ),
          const Divider(height: 64),
          _buildResourceSection('Kosten (Cost)', _selectedTask!.cost),
          const SizedBox(height: 32),
          _buildResourceSection('Belohnungen (Award)', _selectedTask!.award),
          const Divider(height: 64),
          _buildSectionHeader('Modifier (Logic Chaining)'),
          _buildModifierList(),
        ],
      ),
    );
  }

  Widget _buildResourceSection(String title, List<Ressource> list) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildSectionHeader(title),
            ElevatedButton.icon(
              onPressed: () => _showAddResourceDialog(list),
              icon: const Icon(Icons.add_chart),
              label: const Text('Ressource hinzufügen'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: list.map((res) => _buildResourceCard(res, list)).toList(),
        ),
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
            _buildTextField('Basiswert', res.value.toString(), (v) => res.value = double.tryParse(v) ?? 0, isNumber: true),
            if (isMultiplied) ...[
              const SizedBox(height: 8),
              Text('Skaliert mit: ${res.multiplierResourceName}', style: const TextStyle(fontSize: 12, color: Colors.greenAccent)),
              _buildTextField('Faktor', res.multiplierValue.toString(), (v) => res.multiplierValue = double.tryParse(v) ?? 1.0, isNumber: true),
            ],
            TextButton(
              onPressed: () => _toggleMultiplier(res),
              child: Text(isMultiplied ? 'Abhängigkeit entfernen' : 'Abhängigkeit hinzufügen'),
            ),
          ],
        ),
      ),
    );
  }

  void _toggleMultiplier(Ressource res) {
    setState(() {
      if (res.multiplierResourceName == null) {
        res.multiplierResourceName = "Member";
        res.multiplierValue = 1.0;
      } else {
        res.multiplierResourceName = null;
        res.multiplierValue = null;
      }
    });
  }

  void _showAddResourceDialog(List<Ressource> list) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Ressourcentyp wählen'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: _resourceTypes.map((type) => ListTile(
            title: Text(type),
            onTap: () {
              setState(() => list.add(_createResourceInstance(type)));
              Navigator.pop(context);
            },
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

  Widget _buildModifierList() {
    return Column(
      children: [
        ...(_selectedTask!.myModifier ?? []).map((m) => Card(
          child: ListTile(
            title: Text(m is AddTask ? 'Add Task: ${m.nameOfTask}' : m.name),
            trailing: IconButton(icon: const Icon(Icons.delete), onPressed: () => setState(() => _selectedTask!.myModifier?.remove(m))),
          ),
        )),
        const SizedBox(height: 8),
        OutlinedButton.icon(onPressed: _showAddModifierDialog, icon: const Icon(Icons.add), label: const Text('Modifier hinzufügen')),
      ],
    );
  }

  void _showAddModifierDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Modifier wählen'),
        content: SizedBox(
          width: 400,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: _allExistingTaskNames.length,
            itemBuilder: (context, index) {
              final name = _allExistingTaskNames[index];
              return ListTile(
                title: Text('AddTask: $name'),
                onTap: () {
                  setState(() {
                    _selectedTask!.myModifier ??= [];
                    _selectedTask!.myModifier!.add(AddTask(task: name));
                  });
                  Navigator.pop(context);
                },
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, String initial, Function(String) onChanged, {bool isNumber = false, int maxLines = 1}) {
    return TextFormField(
      initialValue: initial,
      decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      maxLines: maxLines,
      onChanged: onChanged,
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(title, style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.amber, fontWeight: FontWeight.bold)),
    );
  }

  void _addNewTask() {
    setState(() {
      final t = Task(name: 'Neue Aufgabe', description: '...', duration: 5000);
      _currentStage?.allTasks.add(t);
      _selectedTask = t;
    });
  }

  void _exportStage() {
    final buffer = StringBuffer();
    buffer.writeln('final Stage exportedStage = Stage(');
    buffer.writeln('  level: ${_currentStage?.level},');
    buffer.writeln('  allTasks: [');
    for (var t in _currentStage?.allTasks ?? []) {
      buffer.writeln('    Task(');
      buffer.writeln('      name: "${t.name}",');
      buffer.writeln('      duration: ${t.duration},');
      buffer.writeln('      isMilestone: ${t.isMilestone},');
      buffer.writeln('      cost: [${_exportResources(t.cost)}],');
      buffer.writeln('      award: [${_exportResources(t.award)}],');
      buffer.writeln('      modifier: [${_exportModifiers(t.myModifier)}],');
      buffer.writeln('    ),');
    }
    buffer.writeln('  ],');
    buffer.writeln(');');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Export Dart Code'),
        content: SizedBox(width: 800, height: 600, child: SingleChildScrollView(child: SelectableText(buffer.toString()))),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close'))],
      ),
    );
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

  String _exportModifiers(List<Modifier>? list) {
    if (list == null) return '';
    return list.map((m) {
      if (m is AddTask) return 'AddTask(task: "${m.nameOfTask}")';
      return 'Modifier(name: "${m.name}")';
    }).join(', ');
  }
}
