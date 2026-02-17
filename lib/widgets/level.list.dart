import 'package:flutter/material.dart';
import 'package:save_the_world_flutter_app/globals.dart';
import 'package:save_the_world_flutter_app/models/game.ressource.model.dart';

class LevelList extends StatelessWidget {
  const LevelList({super.key});

  @override
  Widget build(BuildContext context) {
    final game = Game.getInstance();
    List<int> stageList = levels.keys.toList();
    
    return Container(
      color: const Color(0xFFF0F0F0), // Subtle light gray background
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 100), // Bottom padding for FAB/Snackbar
        itemCount: levels.length,
        itemBuilder: (BuildContext context, int index) {
          final int memberThreshold = stageList[index];
          final String stageName = levels[memberThreshold] ?? "Unbekannt";
          
          final bool isCurrent = index == game.stage;
          final bool isPassed = index < game.stage;
          final bool isFuture = index > game.stage;

          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: isCurrent ? [
                BoxShadow(color: Colors.orange.withOpacity(0.3), blurRadius: 8, spreadRadius: 2)
              ] : null,
            ),
            child: Card(
              elevation: isCurrent ? 4 : 1,
              clipBehavior: Clip.antiAlias,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(
                  color: isCurrent ? Colors.orange[800]! : Colors.black87,
                  width: isCurrent ? 3 : 1.5,
                ),
              ),
              color: isPassed ? Colors.green[50] : (isCurrent ? Colors.white : Colors.grey[200]),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    // LEVEL NUMBER BADGE
                    Container(
                      width: 50,
                      height: 50,
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
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    
                    // LEVEL INFO
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
                            "Benötigt: $memberThreshold Mitglieder",
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: isFuture ? Colors.grey[500] : Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // STATUS ICON
                    Icon(
                      isPassed ? Icons.check_circle : (isCurrent ? Icons.play_circle_filled : Icons.lock),
                      color: isPassed ? Colors.green : (isCurrent ? Colors.orange : Colors.grey[400]),
                      size: 28,
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
}
