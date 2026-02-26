import 'package:flutter/material.dart';
import 'package:save_the_world_flutter_app/models/modifier.model.dart';
import 'package:save_the_world_flutter_app/models/autoexecute.model.dart';
import 'package:save_the_world_flutter_app/editor/widgets/modifier_list_widget.dart';

class AutoExecuteDialog extends StatelessWidget {
  final AutoExecuteModifier autoMod;
  final List<String> allTaskNames;
  final List<String> resourceTypes;
  final VoidCallback onUpdate;

  const AutoExecuteDialog({
    super.key,
    required this.autoMod,
    required this.allTaskNames,
    required this.resourceTypes,
    required this.onUpdate,
  });

  static Future<void> show(
    BuildContext context, 
    AutoExecuteModifier autoMod, 
    List<String> allTaskNames, 
    List<String> resourceTypes,
    VoidCallback onUpdate,
  ) {
    return showDialog(
      context: context,
      builder: (context) => AutoExecuteDialog(
        autoMod: autoMod,
        allTaskNames: allTaskNames,
        resourceTypes: resourceTypes,
        onUpdate: onUpdate,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
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
                onUpdate();
              }),
              onRemove: (m) => setDialogState(() {
                autoMod.modifiers.remove(m);
                onUpdate();
              }),
              onAdd: (m) => setDialogState(() {
                autoMod.modifiers.add(m);
                onUpdate();
              }),
              onOpenNested: () {}, // No deeper nesting supported for now to keep it simple
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Fertig"),
          ),
        ],
      ),
    );
  }
}
