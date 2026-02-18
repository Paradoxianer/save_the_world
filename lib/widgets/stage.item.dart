import 'package:flutter/material.dart';
import 'package:save_the_world_flutter_app/globals.dart';
import 'package:save_the_world_flutter_app/models/game.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/member.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/task.model.dart';
import 'package:save_the_world_flutter_app/utils/number_formatter.dart';

class StageItem extends StatefulWidget {
  final double size;

  const StageItem({super.key, this.size = 30.0});

  @override
  State<StageItem> createState() => StageItemState();
}

class StageItemState extends State<StageItem> {
  late Game game;

  @override
  void initState() {
    super.initState();
    game = Game.getInstance();
    game.addStageListener(_refresh);
  }

  void _refresh() {
    if (mounted) {
      setState(() {});
    }
  }

  void _showStageDetails() {
    final List<int> thresholds = levels.keys.toList();
    final int currentThreshold = thresholds[game.stage];
    final int nextThreshold = (game.stage + 1 < thresholds.length) 
        ? thresholds[game.stage + 1] 
        : currentThreshold;
    
    final memberRes = Game.ressources[Member().name];
    final double currentMembers = memberRes?.value ?? 0.0;
    
    // Find active milestone tasks
    final List<Task> milestones = Game.tasks.where((t) => t.isMilestone).toList();

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
              // HEADER
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Colors.blueAccent,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                  border: Border(bottom: BorderSide(color: Colors.black, width: 3)),
                ),
                child: Column(
                  children: [
                    const Text(
                      "DEIN FORTSCHRITT",
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 14, letterSpacing: 1),
                    ),
                    Text(
                      "STUFE ${game.stage}".toUpperCase(),
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 24),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // MEMBER PROGRESS
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("${NumberFormatter.format(currentMembers)} Mitglieder", style: const TextStyle(fontWeight: FontWeight.bold)),
                        Text("Ziel: ${NumberFormatter.format(nextThreshold.toDouble())}", style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blueAccent)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: (currentMembers / nextThreshold.toDouble()).clamp(0.0, 1.0),
                        minHeight: 15,
                        backgroundColor: Colors.grey[200],
                        valueColor: const AlwaysStoppedAnimation<Color>(Colors.blueAccent),
                      ),
                    ),
                    
                    const SizedBox(height: 25),
                    
                    // MILESTONE SECTION
                    const Text("STRATEGISCHES ZIEL", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 12, color: Colors.grey)),
                    const SizedBox(height: 10),
                    if (milestones.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.amber[50],
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Colors.amber[700]!, width: 2),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.stars, color: Colors.orange, size: 30),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(milestones.first.name.toUpperCase(), style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14)),
                                  const Text("Erledige diesen Meilenstein für den nächsten Durchbruch!", style: TextStyle(fontSize: 11, fontStyle: FontStyle.italic)),
                                ],
                              ),
                            )
                          ],
                        ),
                      )
                    else
                      const Text("Kein aktiver Meilenstein. Wachse weiter!", style: TextStyle(fontWeight: FontWeight.bold, fontStyle: FontStyle.italic)),
                  ],
                ),
              ),

              // BUTTON
              Padding(
                padding: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black87,
                    minimumSize: const Size(double.infinity, 45),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text("ZURÜCK ZUM DIENST", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _showStageDetails,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.black.withOpacity(0.15), width: 1.5),
          boxShadow: const [
            BoxShadow(color: Colors.black12, offset: Offset(1.5, 1.5), blurRadius: 0, spreadRadius: 0),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Stack(
              alignment: Alignment.center,
              children: [
                Positioned(
                  top: 1.5,
                  left: 1.5,
                  child: Icon(Icons.account_balance, size: widget.size, color: Colors.black12),
                ),
                Icon(
                  Icons.account_balance, 
                  size: widget.size, 
                  color: Colors.blueAccent[700],
                ),
              ],
            ),
            const SizedBox(height: 2),
            Text(
              "LVL ${game.stage}",
              style: TextStyle(
                fontSize: widget.size * 0.45,
                fontWeight: FontWeight.w900,
                color: Colors.black87,
                letterSpacing: 0.5,
                shadows: const [
                  Shadow(color: Colors.black12, offset: Offset(1, 1), blurRadius: 1),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
