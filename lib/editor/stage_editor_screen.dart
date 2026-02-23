import 'package:flutter/material.dart';
import 'package:save_the_world_flutter_app/models/task.model.dart';
import 'package:save_the_world_flutter_app/models/stage.model.dart';
import 'package:save_the_world_flutter_app/models/ressource.model.dart';
import 'package:save_the_world_flutter_app/models/modifier.model.dart';
import 'package:save_the_world_flutter_app/models/addtask.model.dart';
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

  @override
  void initState() {
    super.initState();
    _loadAllTaskNames();
    // Default: Starte mit Stage 0 oder einer leeren Stage
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
      _allExistingTaskNames.addAll(names.toList()..sort());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stage Architect'),
        actions: [
          IconButton(
            icon: const Icon(Icons.code),
            tooltip: 'Export to Dart',
            onPressed: _exportStage,
          ),
        ],
      ),
      body: Row(
        children: [
          // Sidebar: Liste der Tasks in der Stage
          Container(
            width: 300,
            decoration: const BoxDecoration(
              border: Border(right: BorderSide(color: Colors.white12)),
            ),
            child: _buildTaskSidebar(),
          ),
          // Hauptbereich: Task-Editor
          Expanded(
            child: _selectedTask == null
                ? const Center(child: Text('Wähle einen Task zum Editieren aus'))
                : _buildTaskEditor(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewTask,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildTaskSidebar() {
    if (_currentStage == null) return const Center(child: Text('Keine Stage geladen'));
    
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: DropdownButton<Stage>(
            isExpanded: true,
            value: _currentStage,
            items: allStages.map((s) => DropdownMenuItem(
              value: s,
              child: Text('Stage ${s.level}'),
            )).toList(),
            onChanged: (s) => setState(() {
              _currentStage = s;
              _selectedTask = null;
            }),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _currentStage!.allTasks.length,
            itemBuilder: (context, index) {
              final task = _currentStage!.allTasks[index];
              return ListTile(
                title: Text(task.name),
                subtitle: Text('${task.duration}ms'),
                selected: _selectedTask == task,
                onTap: () => setState(() => _selectedTask = task),
                trailing: task.isMilestone ? const Icon(Icons.star, color: Colors.amber) : null,
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTaskEditor() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Basis-Daten'),
          TextField(
            decoration: const InputDecoration(labelText: 'Name'),
            controller: TextEditingController(text: _selectedTask!.name),
            onChanged: (v) => _selectedTask!.name = v,
          ),
          TextField(
            decoration: const InputDecoration(labelText: 'Beschreibung'),
            maxLines: 2,
            controller: TextEditingController(text: _selectedTask!.description),
            onChanged: (v) => _selectedTask!.description = v,
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: const InputDecoration(labelText: 'Dauer (ms)'),
                  keyboardType: TextInputType.number,
                  controller: TextEditingController(text: _selectedTask!.duration.toString()),
                  onChanged: (v) => _selectedTask!.duration = double.tryParse(v) ?? 5000,
                ),
              ),
              const SizedBox(width: 16),
              Row(
                children: [
                  const Text('Milestone?'),
                  Switch(
                    value: _selectedTask!.isMilestone,
                    onChanged: (v) => setState(() => _selectedTask!.isMilestone = v),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 32),
          _buildSectionTitle('Modifier (Logik-Chaining)'),
          _buildModifierEditor(),
        ],
      ),
    );
  }

  Widget _buildModifierEditor() {
    return Column(
      children: [
        ...(_selectedTask!.myModifier ?? []).map((m) => _buildModifierTile(m)),
        TextButton.icon(
          onPressed: _showAddModifierDialog,
          icon: const Icon(Icons.add),
          label: const Text('Modifier hinzufügen'),
        ),
      ],
    );
  }

  Widget _buildModifierTile(Modifier m) {
    String summary = m.name;
    if (m is AddTask) summary = 'Add Task: ${m.nameOfTask}';
    
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        title: Text(summary),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.redAccent),
          onPressed: () => setState(() => _selectedTask!.myModifier?.remove(m)),
        ),
      ),
    );
  }

  void _showAddModifierDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Modifier hinzufügen'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('AddTask'),
              onTap: () {
                Navigator.pop(context);
                _showAddTaskSelector();
              },
            ),
            // Hier könnten weitere Modifier-Typen folgen
          ],
        ),
      ),
    );
  }

  void _showAddTaskSelector() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Task zum Hinzufügen wählen'),
        content: SizedBox(
          width: 400,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: _allExistingTaskNames.length,
            itemBuilder: (context, index) {
              final name = _allExistingTaskNames[index];
              return ListTile(
                title: Text(name),
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

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.amber),
      ),
    );
  }

  void _addNewTask() {
    setState(() {
      final newTask = Task(name: 'Neue Aufgabe', description: 'Beschreibung...', duration: 5000);
      _currentStage?.allTasks.add(newTask);
      _selectedTask = newTask;
    });
  }

  void _exportStage() {
    // Einfache Demo der Export-Logik
    final buffer = StringBuffer();
    buffer.writeln('final Stage exportedStage = Stage(');
    buffer.writeln('  level: ${_currentStage?.level},');
    buffer.writeln('  allTasks: [');
    for (var t in _currentStage?.allTasks ?? []) {
      buffer.writeln('    Task(');
      buffer.writeln('      name: "${t.name}",');
      buffer.writeln('      duration: ${t.duration},');
      buffer.writeln('      isMilestone: ${t.isMilestone},');
      buffer.writeln('    ),');
    }
    buffer.writeln('  ],');
    buffer.writeln(');');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Export (Dart Code)'),
        content: SingleChildScrollView(child: SelectableText(buffer.toString())),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK'))],
      ),
    );
  }
}
