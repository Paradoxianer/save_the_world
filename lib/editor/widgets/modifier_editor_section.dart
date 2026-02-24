import 'package:flutter/material.dart';
import 'package:save_the_world_flutter_app/models/modifier.model.dart';
import 'package:save_the_world_flutter_app/editor/widgets/modifier_list_widget.dart';
import 'package:save_the_world_flutter_app/models/autoexecute.model.dart';

class ModifierEditorSection extends StatelessWidget {
  final List<Modifier> onlineModifiers;
  final List<Modifier> finishedModifiers;
  final List<String> allTaskNames;
  final List<String> resourceTypes;
  final VoidCallback onUpdate;

  const ModifierEditorSection({
    super.key,
    required this.onlineModifiers,
    required this.finishedModifiers,
    required this.allTaskNames,
    required this.resourceTypes,
    required this.onUpdate,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ModifierListWidget(
          list: onlineModifiers,
          title: "ONLINE MODIFIER (AKTIVIERUNG)",
          accentColor: Colors.purpleAccent,
          allTaskNames: allTaskNames,
          resourceTypes: resourceTypes,
          onUpdate: (old, nm) {
            final i = onlineModifiers.indexOf(old);
            if (i >= 0) onlineModifiers[i] = nm;
            onUpdate();
          },
          onRemove: (m) {
            onlineModifiers.remove(m);
            onUpdate();
          },
          onAdd: (m) {
            onlineModifiers.add(m);
            onUpdate();
          },
          onOpenNested: () {}, // Meist nicht nötig für Online-Modifier
        ),
        const SizedBox(height: 32),
        ModifierListWidget(
          list: finishedModifiers,
          title: "FINISHED MODIFIER (ABSCHLUSS)",
          accentColor: Colors.blueAccent,
          allTaskNames: allTaskNames,
          resourceTypes: resourceTypes,
          onUpdate: (old, nm) {
            final i = finishedModifiers.indexOf(old);
            if (i >= 0) finishedModifiers[i] = nm;
            onUpdate();
          },
          onRemove: (m) {
            finishedModifiers.remove(m);
            onUpdate();
          },
          onAdd: (m) {
            finishedModifiers.add(m);
            onUpdate();
          },
          onOpenNested: () => _showAutoExecuteDialog(context),
        ),
      ],
    );
  }

  void _showAutoExecuteDialog(BuildContext context) {
    final autoMod = finishedModifiers.whereType<AutoExecuteModifier>().firstOrNull;
    if (autoMod == null) return;

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
                resourceTypes: resourceTypes,
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
    ).then((_) => onUpdate());
  }
}
