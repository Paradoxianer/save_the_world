import 'package:flutter/material.dart';
import 'package:save_the_world_flutter_app/models/modifier.model.dart';
import 'package:save_the_world_flutter_app/models/autoexecute.model.dart';
import 'package:save_the_world_flutter_app/editor/widgets/modifier_list_widget.dart';

class AutoExecuteDialog extends StatelessWidget {
  final AutoExecuteModifier autoMod;
  final List<String> allTaskNames;
  final List<String> resourceTypes;
  final VoidCallback onUpdate;
  final int depth;

  const AutoExecuteDialog({
    super.key,
    required this.autoMod,
    required this.allTaskNames,
    required this.resourceTypes,
    required this.onUpdate,
    this.depth = 1,
  });

  static Future<void> show(
    BuildContext context, 
    AutoExecuteModifier autoMod, 
    List<String> allTaskNames, 
    List<String> resourceTypes,
    VoidCallback onUpdate, {
    int depth = 1,
  }) {
    return showDialog(
      context: context,
      builder: (context) => AutoExecuteDialog(
        autoMod: autoMod,
        allTaskNames: allTaskNames,
        resourceTypes: resourceTypes,
        onUpdate: onUpdate,
        depth: depth,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (context, setDialogState) => AlertDialog(
        title: Text('⚙️ AutoExecute: Unter-Modifier (Ebene $depth)'),
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
              onOpenNested: (m) {
                if (m is AutoExecuteModifier) {
                  AutoExecuteDialog.show(
                    context, 
                    m, 
                    allTaskNames, 
                    resourceTypes, 
                    () {
                      setDialogState(() {});
                      onUpdate();
                    },
                    depth: depth + 1,
                  );
                }
              },
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
