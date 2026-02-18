import 'package:flutter/material.dart';
import 'package:save_the_world_flutter_app/models/task.model.dart';
import 'package:save_the_world_flutter_app/widgets/comic_panel_dialog.dart';
import 'package:save_the_world_flutter_app/widgets/modifiertable.item.dart';
import 'package:save_the_world_flutter_app/widgets/ressourcetable.item.dart';

void showTaskInfo(BuildContext context, Task tsk) {
  final bool isMilestone = tsk.isMilestone;
  final Color themeColor = isMilestone ? Colors.amber[700]! : Colors.orange[800]!;

  context.showComicDialog(
    title: tsk.name,
    icon: isMilestone ? Icons.stars : Icons.assignment,
    headerColor: themeColor,
    content: SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // DESCRIPTION
          Text(
            tsk.description,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 24),

          // STATS SECTION
          _buildInfoSection(
            "DURCHFÜHRUNG",
            [
              _buildDataRow(Icons.timer, "Dauer", "${(tsk.duration / 1000).toStringAsFixed(1)}s"),
              if (tsk.timeToSolve != double.infinity)
                _buildDataRow(Icons.warning_amber_rounded, "Reaktionszeit", "${(tsk.timeToSolve / 1000).toStringAsFixed(1)}s", isWarning: true),
            ],
          ),

          const SizedBox(height: 16),

          // RESOURCES SECTION
          _buildInfoSection(
            "EINFLUSS",
            [
              if (tsk.cost.isNotEmpty) _buildResourceRow("Kosten", tsk.cost),
              if (tsk.award.isNotEmpty) _buildResourceRow("Gewinn", tsk.award),
            ],
          ),

          // EFFECTS SECTION (Optional)
          if (tsk.missed.isNotEmpty || tsk.myModifier.isNotEmpty) ...[
            const SizedBox(height: 16),
            _buildInfoSection(
              "ERGEBNIS",
              [
                if (tsk.myModifier.isNotEmpty)
                  _buildModifierRow("Erfolgreich", tsk.myModifier),
                if (tsk.missed.isNotEmpty)
                  _buildModifierRow("Fehlgeschlagen", tsk.missed, isWarning: true),
              ],
            ),
          ],
        ],
      ),
    ),
    actions: [
      ElevatedButton(
        onPressed: () => Navigator.pop(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: themeColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: Colors.black, width: 2.5),
          ),
        ),
        child: const Text(
          "ALLES KLAR!",
          style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16, letterSpacing: 1),
        ),
      ),
    ],
  );
}

Widget _buildInfoSection(String title, List<Widget> children) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title,
        style: TextStyle(
          fontSize: 11, 
          fontWeight: FontWeight.w900, 
          color: Colors.grey[600], 
          letterSpacing: 0.8
        ),
      ),
      const SizedBox(height: 8),
      Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.black.withOpacity(0.1), width: 1.5),
        ),
        child: Column(children: children),
      ),
    ],
  );
}

Widget _buildDataRow(IconData icon, String label, String value, {bool isWarning = false}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      children: [
        Icon(icon, size: 20, color: isWarning ? Colors.red : Colors.black54),
        const SizedBox(width: 10),
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        const Spacer(),
        Text(
          value, 
          style: TextStyle(
            fontWeight: FontWeight.w900, 
            fontSize: 15, 
            color: isWarning ? Colors.red : Colors.black
          )
        ),
      ],
    ),
  );
}

Widget _buildResourceRow(String label, List<dynamic> resources) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 75,
          child: Text(
            "$label:", 
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black54)
          ),
        ),
        Expanded(
          child: RessourceTable(
            ressourceList: resources.cast(), 
            size: 22,
            isGlobal: false, 
          ),
        ),
      ],
    ),
  );
}

Widget _buildModifierRow(String label, List<dynamic> modifiers, {bool isWarning = false}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "$label:", 
          style: TextStyle(
            fontWeight: FontWeight.w900, 
            fontSize: 13, 
            color: isWarning ? Colors.red[800] : Colors.green[800]
          )
        ),
        const SizedBox(height: 8),
        ModifierTable(modifierList: modifiers.cast()),
      ],
    ),
  );
}
