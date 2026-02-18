import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:save_the_world_flutter_app/globals.dart';
import 'package:save_the_world_flutter_app/models/game.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/task.model.dart';
import 'package:save_the_world_flutter_app/utils/number_formatter.dart';
import 'package:save_the_world_flutter_app/widgets/task.info.dart';
import 'package:save_the_world_flutter_app/stages.dart';

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
          
          // Get saved highscore for this stage
          final int? highscore = game.stageHighscores[index];

          return GestureDetector(
            onTap: (isPassed || isCurrent) ? () => _showLevelDetails(context, index, stageName) : null,
            onLongPress: kDebugMode ? () => _confirmStageJump(context, index, stageName) : null,
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              child: Card(
                elevation: isCurrent ? 4 : 1,
                clipBehavior: Clip.antiAlias,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(
                    color: isCurrent ? Colors.orange[800]! : (kDebugMode ? Colors.blue.withOpacity(0.3) : Colors.black87),
                    width: 1.5,
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
                            width: 45,
                            height: 45,
                            decoration: BoxDecoration(
                              color: isPassed ? Colors.green : (isCurrent ? Colors.orange : Colors.grey),
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.black87, width: 2),
                            ),
                            child: Center(
                              child: Text(
                                index.toString(),
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 18),
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
                                    fontSize: 15,
                                    color: isFuture ? Colors.grey[600] : Colors.black87,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "Limit: ${NumberFormatter.format(memberThreshold.toDouble())} Mitglieder",
                                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black54),
                                ),
                              ],
                            ),
                          ),
                          Icon(
                            isPassed ? Icons.check_circle : (isCurrent ? Icons.play_circle_filled : Icons.lock),
                            color: isPassed ? Colors.green : (isCurrent ? Colors.orange : Colors.grey[400]),
                            size: 24,
                          ),
                        ],
                      ),
                      
                      // STATISTICS AREA (Only for passed or current stages)
                      if (highscore != null && (isPassed || isCurrent))
                        Padding(
                          padding: const EdgeInsets.only(top: 12.0),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                _miniStat(Icons.emoji_events, "SCORE: $highscore", Colors.orange[700]!),
                                // Note: We could store and show time/clicks here too if we extend highscores map
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

  Widget _miniStat(IconData icon, String label, Color color) {
    return Row(
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 4),
        Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: color)),
      ],
    );
  }

  void _confirmStageJump(BuildContext context, int index, String name) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("DEBUG: Stage Jump"),
        content: Text("Möchtest du direkt zu Stufe $index ($name) springen?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("ABBRECHEN")),
          ElevatedButton(
            onPressed: () {
              Game.getInstance().jumpToStage(index);
              Navigator.pop(context);
            }, 
            child: const Text("JUMP!")
          ),
        ],
      ),
    );
  }

  void _showLevelDetails(BuildContext context, int stageIndex, String stageName) {
    if (stageIndex >= allStages.length) return;
    final List<Task> stageTasks = allStages[stageIndex].allTasks;

    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.black, width: 3),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Colors.blueAccent,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                  border: Border(bottom: BorderSide(color: Colors.black, width: 3)),
                ),
                child: Text(
                  "STUFE $stageIndex: $stageName".toUpperCase(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 16),
                ),
              ),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(16),
                  itemCount: stageTasks.length,
                  itemBuilder: (context, i) {
                    final tsk = stageTasks[i];
                    return ListTile(
                      dense: true,
                      leading: Icon(tsk.isMilestone ? Icons.stars : Icons.assignment, color: tsk.isMilestone ? Colors.orange : Colors.blue),
                      title: Text(tsk.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                      onTap: () => showTaskInfo(context, tsk),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black87,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text("ZURÜCK", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
