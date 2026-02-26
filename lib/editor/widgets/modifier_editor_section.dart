import 'package:flutter/material.dart';
import 'package:save_the_world_flutter_app/models/modifier.model.dart';
import 'package:save_the_world_flutter_app/editor/widgets/modifier_list_widget.dart';
import 'package:save_the_world_flutter_app/models/autoexecute.model.dart';
import 'package:save_the_world_flutter_app/editor/widgets/auto_execute_dialog.dart';

class ModifierEditorSection extends StatelessWidget {
  final String title;
  final List<Modifier> modifiers;
  final Color accentColor;
  final List<String> allTaskNames;
  final List<String> resourceTypes;
  final VoidCallback onUpdate;

  const ModifierEditorSection({
    super.key,
    required this.title,
    required this.modifiers,
    required this.accentColor,
    required this.allTaskNames,
    required this.resourceTypes,
    required this.onUpdate,
  });

  @override
  Widget build(BuildContext context) {
    return ModifierListWidget(
      list: modifiers,
      title: title,
      accentColor: accentColor,
      allTaskNames: allTaskNames,
      resourceTypes: resourceTypes,
      onUpdate: (old, nm) {
        final i = modifiers.indexOf(old);
        if (i >= 0) modifiers[i] = nm;
        onUpdate();
      },
      onRemove: (m) {
        modifiers.remove(m);
        onUpdate();
      },
      onAdd: (m) {
        modifiers.add(m);
        onUpdate();
      },
      onOpenNested: (m) {
        if (m is AutoExecuteModifier) {
          AutoExecuteDialog.show(context, m, allTaskNames, resourceTypes, onUpdate);
        }
      },
    );
  }
}
