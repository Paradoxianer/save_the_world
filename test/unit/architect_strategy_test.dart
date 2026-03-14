import 'package:flutter_test/flutter_test.dart';
import 'package:save_the_world_flutter_app/models/game.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/task.model.dart';
import 'package:save_the_world_flutter_app/models/ressource.model.dart';
import 'package:save_the_world_flutter_app/models/addtask.model.dart';
import 'package:save_the_world_flutter_app/globals.dart';
import 'package:save_the_world_flutter_app/stages.dart';

class PathStep {
  final Task task;
  final int executions;
  final Map<String, double> totalCost;
  final Map<String, double> totalAward;

  PathStep({
    required this.task,
    required this.executions,
    required this.totalCost,
    required this.totalAward,
  });
}

void main() {
  group('🧠 Architect Strategy Bot (Reverse Solver)', () {
    late Game game;

    setUp(() {
      Game.mInstance = null;
      game = Game.getInstance();
      game.isLoading = false;
    });

    test('Analyze Stage 0 Strategy (Backwards Calculation)', () {
      print("\n--- 🏗️ ARCHITECT ANALYSIS: STAGE 0 ---");
      
      const int targetStage = 0;
      final stage = allStages[targetStage];
      final targetMembers = levels.keys.first.toDouble(); // 20.0
      
      // 1. Was ist das Ziel?
      print("ZIEL: Erreiche $targetMembers Mitglieder");

      // 2. Finde Tasks, die Mitglieder bringen
      final memberTasks = stage.allTasks.where((t) => t.award.any((a) => a.name == "Member")).toList();
      
      for (var task in memberTasks) {
        final double awardPerClick = task.award.firstWhere((a) => a.name == "Member").value;
        final int clicksNeeded = (targetMembers / awardPerClick).ceil();
        
        print("\n📍 HAUPT-PFAD: '${task.name}'");
        print("   - Benötigte Ausführungen: $clicksNeeded");

        // 3. Berechne die Kosten für diesen Pfad
        Map<String, double> cumulativeCosts = {};
        for (var cost in task.cost) {
          cumulativeCosts[cost.name] = (cumulativeCosts[cost.name] ?? 0) + (cost.value * clicksNeeded);
        }

        print("   - Gesamtkosten für diesen Pfad:");
        cumulativeCosts.forEach((res, val) {
          print("     * $res: $val");
          
          // 4. Rückwärts: Wie decken wir diese Kosten?
          if (res != "Time" && res != "Member") {
            _analyzeSupportPath(res, val, stage.allTasks, indent: "     ");
          }
        });
      }
    });
  });
}

void _analyzeSupportPath(String resName, double amountNeeded, List<Task> availableTasks, {String indent = ""}) {
  final providers = availableTasks.where((t) => t.award.any((a) => a.name == resName)).toList();
  
  if (providers.isEmpty) {
    print("$indent ⚠️ KRITISCH: Keine Aufgabe generiert $resName!");
    return;
  }

  // Wähle die effizienteste Aufgabe (höchster Award pro Klick)
  providers.sort((a, b) {
    final valA = a.award.firstWhere((aw) => aw.name == resName).value;
    final valB = b.award.firstWhere((aw) => aw.name == resName).value;
    return valB.compareTo(valA);
  });

  final bestProvider = providers.first;
  final double awardPerClick = bestProvider.award.firstWhere((a) => a.name == resName).value;
  final int clicks = (amountNeeded / awardPerClick).ceil();

  print("$indent -> Beste Unterstützung: '${bestProvider.name}'");
  print("$indent    Benötigt $clicks Klicks für $amountNeeded $resName");

  // Rekursion für die Kosten des Unterstützers
  for (var cost in bestProvider.cost) {
    if (cost.name != "Time" && cost.name != "Member") {
       _analyzeSupportPath(cost.name, cost.value * clicks, availableTasks, indent: "$indent  ");
    }
  }
}
