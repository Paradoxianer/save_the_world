import 'package:flutter/material.dart';
import 'package:save_the_world_flutter_app/models/task.model.dart';
import 'package:save_the_world_flutter_app/widgets/modifiertable.item.dart';
import 'package:save_the_world_flutter_app/widgets/ressourcetable.item.dart';

void showTaskInfo(BuildContext context, Task tsk) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      final bool isMilestone = tsk.isMilestone;
      final Color themeColor = isMilestone ? Colors.amber[700]! : Colors.orange[800]!;

      return Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.black, width: 3), // Cartoon Border
            boxShadow: const [
              BoxShadow(color: Colors.black26, offset: Offset(6, 6), blurRadius: 0),
            ],
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // HEADER
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: themeColor,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                    border: const Border(bottom: BorderSide(color: Colors.black, width: 3)),
                  ),
                  child: Row(
                    children: [
                      if (isMilestone) const Icon(Icons.stars, color: Colors.white, size: 28),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          tsk.name.toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // DESCRIPTION
                      Text(
                        tsk.description,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // STATS SECTION
                      _buildInfoSection(
                        "DURCHFÜHRUNG",
                        [
                          _buildDataRow(Icons.timer, "Dauer", "${(tsk.duration / 1000).toStringAsFixed(1)}s"),
                          if (tsk.timeToSolve != double.infinity)
                            _buildDataRow(Icons.warning_amber_rounded, "Reaktionszeit", "${(tsk.timeToSolve / 1000).toStringAsFixed(1)}s", isWarning: true),
                        ],
                      ),

                      const SizedBox(height: 15),

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
                        const SizedBox(height: 15),
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

                // CLOSE BUTTON
                Padding(
                  padding: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: themeColor,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                        side: const BorderSide(color: Colors.black, width: 2),
                      ),
                      elevation: 4,
                    ),
                    child: const Text(
                      "ALLES KLAR!",
                      style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

Widget _buildInfoSection(String title, List<Widget> children) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title,
        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: Colors.grey[600], letterSpacing: 0.5),
      ),
      const SizedBox(height: 6),
      Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.black12, width: 1.5),
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
        Icon(icon, size: 18, color: isWarning ? Colors.red : Colors.black54),
        const SizedBox(width: 8),
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
        const Spacer(),
        Text(value, style: TextStyle(fontWeight: FontWeight.w900, fontSize: 14, color: isWarning ? Colors.red : Colors.black)),
      ],
    ),
  );
}

Widget _buildResourceRow(String label, List<dynamic> resources) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 70,
          child: Text("$label:", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
        ),
        Expanded(
          child: RessourceTable(
            ressourceList: resources.cast(), 
            size: 20,
            isGlobal: false, // Prevent floating feedback inside info dialog
          ),
        ),
      ],
    ),
  );
}

Widget _buildModifierRow(String label, List<dynamic> modifiers, {bool isWarning = false}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "$label:", 
          style: TextStyle(
            fontWeight: FontWeight.bold, 
            fontSize: 12, 
            color: isWarning ? Colors.red[800] : Colors.green[800]
          )
        ),
        const SizedBox(height: 4),
        ModifierTable(modifierList: modifiers.cast()),
      ],
    ),
  );
}
