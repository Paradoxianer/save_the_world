import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:save_the_world_flutter_app/globals.dart';
import 'package:save_the_world_flutter_app/models/game.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/task.model.dart';
import 'package:save_the_world_flutter_app/utils/number_formatter.dart';
import 'package:save_the_world_flutter_app/widgets/task.info.dart';
import 'package:save_the_world_flutter_app/stages.dart';
import 'package:save_the_world_flutter_app/widgets/comic_panel_dialog.dart';

class LevelList extends StatelessWidget {
  const LevelList({super.key});

  @override
  Widget build(BuildContext context) {
    final game = Game.getInstance();
    List<int> stageList = levels.keys.toList();
    
    return Container(
      color: const Color(0xFFF5F5F5),
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
        itemCount: levels.length,
        itemBuilder: (BuildContext context, int index) {
          final int memberThreshold = stageList[index];
          final String stageName = levels[memberThreshold] ?? "Unbekannt";
          
          final bool isCurrent = index == game.stage;
          final bool isPassed = index < game.stage;
          final bool isFuture = index > game.stage;
          
          final int? highscore = game.stageHighscores[index];

          return GestureDetector(
            onTap: (isPassed || isCurrent) ? () => _showLevelDetails(context, index, stageName) : null,
            onLongPress: kDebugMode ? () => _confirmStageJump(context, index, stageName) : null,
            child: Container(
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: isCurrent ? [
                  const BoxShadow(color: Colors.black26, offset: Offset(4, 4), blurRadius: 0),
                ] : null,
              ),
              child: Card(
                elevation: 0, // Handled by manual shadow
                clipBehavior: Clip.antiAlias,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(
                    color: isCurrent ? Colors.orange[800]! : Colors.black,
                    width: isCurrent ? 3.0 : 2.0,
                  ),
                ),
                color: isPassed ? Colors.green[50] : (isCurrent ? Colors.white : Colors.grey[200]),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: isPassed ? Colors.green : (isCurrent ? Colors.orange : Colors.grey),
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.black, width: 2.5),
                              boxShadow: const [BoxShadow(color: Colors.black12, offset: Offset(2, 2))],
                            ),
                            child: Center(
                              child: Text(
                                index.toString(),
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 20),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  stageName.toUpperCase(),
                                  style: TextStyle(
                                    fontWeight: FontWeight.w900,
                                    fontSize: 16,
                                    color: isFuture ? Colors.grey[600] : Colors.black87,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "Limit: ${NumberFormatter.format(memberThreshold.toDouble())} Mitglieder",
                                  style: TextStyle(
                                    fontSize: 12, 
                                    fontWeight: FontWeight.bold, 
                                    color: isFuture ? Colors.grey : Colors.black54
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Icon(
                            isPassed ? Icons.check_circle : (isCurrent ? Icons.play_circle_filled : Icons.lock),
                            color: isPassed ? Colors.green : (isCurrent ? Colors.orange : Colors.grey[400]),
                            size: 28,
                          ),
                        ],
                      ),
                      
                      if (highscore != null && (isPassed || isCurrent))
                        Padding(
                          padding: const EdgeInsets.only(top: 12.0),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.orange.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.orange.withOpacity(0.2)),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.emoji_events, size: 16, color: Colors.orange),
                                const SizedBox(width: 8),
                                Text(
                                  "BESTER SCORE: $highscore", 
                                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: Colors.orange)
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _confirmStageJump(BuildContext context, int index, String name) {
    context.showComicDialog(
      title: "Debug Jump",
      icon: Icons.bug_report,
      headerColor: Colors.redAccent,
      content: Text(
        "Möchtest du direkt zu Stufe $index ($name) springen?\n\nDies überschreibt deinen aktuellen Fortschritt!",
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            Game.getInstance().jumpToStage(index);
            Navigator.pop(context);
          }, 
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.redAccent,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: const BorderSide(color: Colors.black, width: 2),
            ),
          ),
          child: const Text("JUMP!", style: TextStyle(fontWeight: FontWeight.w900)),
        ),
        const SizedBox(height: 8),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("ABBRECHEN", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }

  void _showLevelDetails(BuildContext context, int stageIndex, String stageName) {
    if (stageIndex >= allStages.length) return;
    final List<Task> stageTasks = allStages[stageIndex].allTasks;

    context.showComicDialog(
      title: "Stufe $stageIndex Details",
      icon: Icons.list_alt,
      headerColor: Colors.blueAccent,
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "VERFÜGBARE AUFGABEN:",
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: Colors.grey, letterSpacing: 1),
            ),
            const SizedBox(height: 12),
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                itemCount: stageTasks.length,
                separatorBuilder: (context, i) => const Divider(height: 1),
                itemBuilder: (context, i) {
                  final tsk = stageTasks[i];
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    dense: true,
                    leading: Icon(
                      tsk.isMilestone ? Icons.stars : Icons.assignment, 
                      color: tsk.isMilestone ? Colors.amber[700] : Colors.blueAccent,
                      size: 20,
                    ),
                    title: Text(
                      tsk.name, 
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)
                    ),
                    trailing: const Icon(Icons.chevron_right, size: 16),
                    onTap: () => showTaskInfo(context, tsk),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () => Navigator.pop(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueAccent,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: const BorderSide(color: Colors.black, width: 2.5),
            ),
          ),
          child: const Text("ALLES KLAR!", style: TextStyle(fontWeight: FontWeight.w900)),
        ),
      ],
    );
  }
}
