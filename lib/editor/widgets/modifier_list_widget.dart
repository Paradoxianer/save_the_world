import 'package:flutter/material.dart';
import 'package:save_the_world_flutter_app/models/modifier.model.dart';
import 'package:save_the_world_flutter_app/models/addtask.model.dart';
import 'package:save_the_world_flutter_app/models/removetask.model.dart';
import 'package:save_the_world_flutter_app/models/addtorandom.model.dart';
import 'package:save_the_world_flutter_app/models/setmax.model.dart';
import 'package:save_the_world_flutter_app/models/setmin.model.dart';
import 'package:save_the_world_flutter_app/models/message.modifier.dart';
import 'package:save_the_world_flutter_app/models/autoexecute.model.dart';
import 'package:save_the_world_flutter_app/models/removemodifier.model.dart';
import 'package:save_the_world_flutter_app/models/subtractres.model.dart';
import 'package:save_the_world_flutter_app/models/ressource.model.dart';
import 'package:save_the_world_flutter_app/editor/widgets/resource_editor_section.dart';

class ModifierListWidget extends StatelessWidget {
  final List<Modifier> list;
  final String title;
  final Color accentColor;
  final List<String> allTaskNames;
  final List<String> resourceTypes;
  final Function(Modifier old, Modifier newMod) onUpdate;
  final Function(Modifier m) onRemove;
  final Function(Modifier m) onAdd;
  final Function(Modifier m) onOpenNested;

  const ModifierListWidget({
    super.key,
    required this.list,
    required this.title,
    required this.accentColor,
    required this.allTaskNames,
    required this.resourceTypes,
    required this.onUpdate,
    required this.onRemove,
    required this.onAdd,
    required this.onOpenNested,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: TextStyle(color: accentColor, fontWeight: FontWeight.bold)),
            IconButton(
              icon: const Icon(Icons.add_box, color: Colors.amber),
              onPressed: () => _showAddDialog(context),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ...list.map((m) => Card(
          margin: const EdgeInsets.symmetric(vertical: 4),
          child: ListTile(
            dense: true,
            title: Text(m.name, style: TextStyle(color: accentColor, fontWeight: FontWeight.bold, fontSize: 11)),
            subtitle: _buildInputs(context, m),
            trailing: IconButton(
              icon: const Icon(Icons.delete, size: 16),
              onPressed: () => onRemove(m),
            ),
          ),
        )),
      ],
    );
  }

  Widget _buildInputs(BuildContext context, Modifier m) {
    if (m is AddTask) return _buildTaskDropdown(m.nameOfTask, (v) => onUpdate(m, AddTask(task: v!)));
    if (m is RemoveTask) return _buildTaskDropdown(m.nameOfTask, (v) => onUpdate(m, RemoveTask(task: v!)));
    if (m is AddToRandom) return _buildTaskDropdown(m.nameOfTask, (v) => onUpdate(m, AddToRandom(task: v!)));
    if (m is SetMax) {
      return Row(children: [
        Expanded(child: _buildResDropdown(m.workOn, (v) => onUpdate(m, SetMax(ressource: v!, newMax: m.newMax)))),
        const SizedBox(width: 8),
        Expanded(child: _buildNumberField(m.newMax.toString(), (v) => onUpdate(m, SetMax(ressource: m.workOn, newMax: double.tryParse(v) ?? 0)))),
      ]);
    }
    if (m is SetMin) {
      return Row(children: [
        Expanded(child: _buildResDropdown(m.workOn, (v) => onUpdate(m, SetMin(ressource: v!, newMin: m.newMin)))),
        const SizedBox(width: 8),
        Expanded(child: _buildNumberField(m.newMin.toString(), (v) => onUpdate(m, SetMin(ressource: m.workOn, newMin: double.tryParse(v) ?? 0)))),
      ]);
    }
    if (m is MessageModifier) {
      return _buildTextField(m.message, (v) => onUpdate(m, MessageModifier(message: v)));
    }
    if (m is AutoExecuteModifier) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildNumberField(m.intervalMs.toString(), (v) => onUpdate(m, AutoExecuteModifier(modifiers: m.modifiers, intervalMs: int.tryParse(v) ?? 5000))),
          TextButton.icon(onPressed: () => onOpenNested(m), icon: const Icon(Icons.edit_note, size: 14), label: const Text("Unter-Modifier verwalten", style: TextStyle(fontSize: 10))),
        ],
      );
    }
    if (m is RemoveModifer) return _buildTaskDropdown(m.nameOfTask ?? "", (v) => onUpdate(m, RemoveModifer(nameOfTask: v, modifier: m.mymodifer)));
    if (m is SubtractRes) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("${m.ressources.length} Ressourcen definiert", style: const TextStyle(fontSize: 10)),
          TextButton.icon(
            onPressed: () => _showSubtractResEditor(context, m), 
            icon: const Icon(Icons.edit, size: 14), 
            label: const Text("Ressourcen bearbeiten", style: TextStyle(fontSize: 10))
          ),
        ],
      );
    }

    return Text(m.description, style: const TextStyle(fontSize: 10));
  }

  void _showSubtractResEditor(BuildContext context, SubtractRes m) {
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text("SubtractRes Editor"),
          content: SizedBox(
            width: 500,
            child: SingleChildScrollView(
              child: ResourceEditorSection(
                title: "ABZUZIEHENDE RESSOURCEN", 
                resources: m.ressources, 
                color: Colors.redAccent, 
                onUpdate: () {
                  setDialogState(() {}); // Triggert Rebuild des Dialogs
                  onUpdate(m, m); // Benachrichtigt den Hauptscreen
                }
              ),
            ),
          ),
          actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text("Fertig"))],
        ),
      ),
    );
  }

  Widget _buildTaskDropdown(String current, Function(String?) onChanged) {
    return DropdownButtonFormField<String>(
      isDense: true,
      value: allTaskNames.contains(current) ? current : null,
      decoration: const InputDecoration(isDense: true, contentPadding: EdgeInsets.all(8), border: OutlineInputBorder()),
      items: allTaskNames.map((n) => DropdownMenuItem(value: n, child: Text(n, style: const TextStyle(fontSize: 11)))).toList(),
      onChanged: onChanged,
    );
  }

  Widget _buildResDropdown(String current, Function(String?) onChanged) {
    return DropdownButtonFormField<String>(
      isDense: true,
      value: resourceTypes.contains(current) ? current : null,
      decoration: const InputDecoration(isDense: true, contentPadding: EdgeInsets.all(8), border: OutlineInputBorder()),
      items: resourceTypes.map((n) => DropdownMenuItem(value: n, child: Text(n, style: const TextStyle(fontSize: 11)))).toList(),
      onChanged: onChanged,
    );
  }

  Widget _buildNumberField(String initial, Function(String) onChanged) {
    return TextFormField(
      initialValue: initial,
      keyboardType: TextInputType.number,
      style: const TextStyle(fontSize: 11),
      decoration: const InputDecoration(isDense: true, border: OutlineInputBorder()),
      onChanged: onChanged,
    );
  }

  Widget _buildTextField(String initial, Function(String) onChanged) {
    return TextFormField(
      initialValue: initial,
      style: const TextStyle(fontSize: 11),
      decoration: const InputDecoration(isDense: true, border: OutlineInputBorder()),
      onChanged: onChanged,
    );
  }

  void _showAddDialog(BuildContext context) {
    showDialog(context: context, builder: (context) => AlertDialog(
      title: const Text("Modifier Typ wählen"),
      content: SizedBox(
        width: 300,
        child: ListView(
          shrinkWrap: true,
          children: [
            _typeTile(context, "AddTask", () => AddTask(task: "")),
            _typeTile(context, "RemoveTask", () => RemoveTask(task: "")),
            _typeTile(context, "AddToRandom", () => AddToRandom(task: "")),
            _typeTile(context, "SetMax", () => SetMax(ressource: "Member", newMax: 100)),
            _typeTile(context, "SetMin", () => SetMin(ressource: "Member", newMin: 0)),
            _typeTile(context, "SubtractRes", () => SubtractRes(ressources: [])),
            _typeTile(context, "Message", () => MessageModifier(message: "")),
            _typeTile(context, "AutoExecute", () => AutoExecuteModifier(modifiers: [], intervalMs: 5000)),
            _typeTile(context, "RemoveModifer", () => RemoveModifer(nameOfTask: "", modifier: [])),
          ],
        ),
      ),
    ));
  }

  Widget _typeTile(BuildContext context, String label, Modifier Function() creator) {
    return ListTile(title: Text(label), onTap: () { onAdd(creator()); Navigator.pop(context); });
  }
}
