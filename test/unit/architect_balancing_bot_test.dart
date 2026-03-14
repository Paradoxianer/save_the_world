import 'package:flutter_test/flutter_test.dart';
import 'package:save_the_world_flutter_app/models/task.model.dart';
import 'package:save_the_world_flutter_app/globals.dart';
import 'package:save_the_world_flutter_app/stages.dart';

class StepAnalysis {
  final Task task;
  final int count;
  final Map<String, double> totalCost;
  final Map<String, double> totalAward;

  StepAnalysis({
    required this.task,
    required this.count,
    required this.totalCost,
    required this.totalAward,
  });
}

void main() {
  group('🧠 Architect Balancing Bot (Reverse Solver)', () {
    
    test('Strategic Backwards Analysis: Stage 0', () {
      print("\n--- 🏗️ ARCHITECT BOT: ANALYSIS STAGE 0 ---");
      
      final stage = allStages[0];
      const double startMembers = 2.0;
      const double targetMembers = 20.0;
      
      // 1. Finde den entscheidenden Meilenstein und berechne den Netto-Bedarf
      Task milestone = stage.allTasks.firstWhere((t) => t.isMilestone);
      double memberCostForMilestone = milestone.cost
          .where((c) => c.name == "Member")
          .fold(0, (p, c) => p + c.value);

      double totalNeededMembers = (targetMembers - startMembers) + memberCostForMilestone;

      print("Ziel: $targetMembers Mitglieder");
      print("Meilenstein-Kosten ('${milestone.name}'): $memberCostForMilestone Members");
      print("Gesamt-Wachstumsbedarf: $totalNeededMembers Members");

      // 2. Rekursives Lösen der Abhängigkeiten
      Map<String, int> totalExecutions = {};
      Map<String, double> accumulatedResources = {"Member": -totalNeededMembers};
      
      _solveRequirement("Member", totalNeededMembers, stage.allTasks, totalExecutions, accumulatedResources);

      print("\n📋 OPTIMALER SCHLACHTPLAN:");
      int totalClicks = 0;
      double totalTimeSeconds = 0;

      totalExecutions.forEach((taskName, count) {
        final task = stage.allTasks.firstWhere((t) => t.name == taskName);
        print("  - [$count x] ${task.name}");
        totalClicks += count;
        totalTimeSeconds += (task.duration * count) / 1000;
      });

      print("\n📈 STATISTIK STAGE 0:");
      print("  - Klicks insgesamt: $totalClicks");
      print("  - Theoretische Zeit: ${totalTimeSeconds.toStringAsFixed(1)}s");
      
      print("\n🔋 RESSOURCEN-ENPÄSSE (Nach Plan):");
      accumulatedResources.forEach((res, val) {
        if (val < 0) print("  - 🔴 $res: ${val.toStringAsFixed(2)} FEHLT NOCH!");
        else if (res != "Time") print("  - 🟢 $res: +${val.toStringAsFixed(2)} Überschuss");
      });
    });
  });
}

void _solveRequirement(String resName, double amount, List<Task> tasks, Map<String, int> executions, Map<String, double> balance) {
  if (resName == "Time" || amount <= 0) return;

  // Finde alle Provider für diese Ressource
  var providers = tasks.where((t) => t.award.any((a) => a.name == resName)).toList();
  if (providers.isEmpty) return;

  // Wähle den effizientesten (Award pro Klick)
  providers.sort((a, b) {
    double yA = a.award.firstWhere((aw) => aw.name == resName).value;
    double yB = b.award.firstWhere((aw) => aw.name == resName).value;
    return yB.compareTo(yA);
  });

  Task best = providers.first;
  double yieldPerClick = best.award.firstWhere((a) => a.name == resName).value;
  int clicks = (amount / yieldPerClick).ceil();

  executions[best.name] = (executions[best.name] ?? 0) + clicks;
  
  // Ressourcen-Impact verbuchen
  for (var a in best.award) {
    balance[a.name] = (balance[a.name] ?? 0) + (a.value * clicks);
  }
  for (var c in best.cost) {
    balance[c.name] = (balance[c.name] ?? 0) - (c.value * clicks);
    // REKURSION: Wenn Kosten entstehen, müssen diese auch wieder gedeckt werden
    if (balance[c.name]! < 0) {
      _solveRequirement(c.name, -balance[c.name]!, tasks, executions, balance);
    }
  }
}
