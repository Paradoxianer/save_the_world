import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart'; // REQUIRED for kDebugMode
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

          return GestureDetector(
            onTap: (isPassed || isCurrent) ? () => _showLevelDetails(context, index, stageName) : null,
            // DEBUG CHEAT: Long press to jump to stage (only in Debug Mode)
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
                    width: isCurrent ? 3 : 1.5,
                  ),
                ),
                color: isPassed ? Colors.green[50] : (isCurrent ? Colors.white : Colors.grey[200]),
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
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
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 18,
                                ),
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
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: isFuture ? Colors.grey[500] : Colors.black54,
                                  ),
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
                    ),
                    // DEBUG VISUAL HINT
                    if (kDebugMode)
                      Positioned(
                        right: 0,
                        top: 0,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: const BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(8)),
                          ),
                          child: const Text("DEBUG", style: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold)),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _confirmStageJump(BuildContext context, int index, String name) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("DEBUG: Stage Jump"),
        content: Text("Möchtest du wirklich direkt zu Stufe $index ($name) springen? Alle permanenten Tasks der Vorstufen werden aktiviert."),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("ABBRECHEN")),
          ElevatedButton(
            onPressed: () {
              Game.getInstance().jumpToStage(index);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Jump zu Stufe $index erfolgreich!")),
              );
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
