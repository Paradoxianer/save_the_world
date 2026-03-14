import 'package:flutter_test/flutter_test.dart';
import 'package:save_the_world_flutter_app/models/task.model.dart';
import 'package:save_the_world_flutter_app/globals.dart';
import 'package:save_the_world_flutter_app/stages.dart';

class TaskRequirement {
  final Task task;
  int executions;
  Map<String, double> cumulativeCost = {};
  Map<String, double> cumulativeAward = {};

  TaskRequirement(this.task, this.executions) {
    for (var c in task.cost) {
      cumulativeCost[c.name] = c.value * executions;
    }
    for (var a in task.award) {
      cumulativeAward[a.name] = a.value * executions;
    }
  }
}

void main() {
  group('🎯 Architect Strategy Bot (Reverse Solver)', () {
    
    test('Calculate Optimal Strategy for Stage 0', () {
      print("\n--- 🧠 ARCHITECT BOT: STRATEGIE-ANALYSE STAGE 0 ---");
      
      final stage = allStages[0];
      final double targetMembers = 20.0;
      final double startMembers = 2.0;
      double neededMembers = targetMembers - startMembers;

      // 1. Finde den Meilenstein und seine Zusatzkosten
      Task? milestone = stage.allTasks.firstWhere((t) => t.isMilestone);
      double milestoneMemberCost = milestone.cost.where((c) => c.name == "Member").fold(0, (p, c) => p + c.value);
      
      // Wir müssen also insgesamt (Target + Kosten für Meilenstein) generieren
      double totalMemberToGenerate = neededMembers + milestoneMemberCost;
      
      print("Ziel-Mitglieder: $targetMembers");
      print("Meilenstein-Kosten: $milestoneMemberCost Members");
      print("Gesamtbedarf zu generieren: $totalMemberToGenerate Members");

      // 2. Analysiere Aufgaben, die Members bringen
      var growthTasks = stage.allTasks.where((t) => t.award.any((a) => a.name == "Member")).toList();
      
      // Wir nehmen für die Analyse den effizientesten Task (Award pro Klick)
      growthTasks.sort((a, b) => b.award.firstWhere((aw) => aw.name == "Member").value
          .compareTo(a.award.firstWhere((aw) => aw.name == "Member").value));
      
      Task primaryTask = growthTasks.first;
      double awardPerExecution = primaryTask.award.firstWhere((a) => a.name == "Member").value;
      int primaryExecutions = (totalMemberToGenerate / awardPerExecution).ceil();

      var mainRequirement = TaskRequirement(primaryTask, primaryExecutions);

      // 3. Rückwärts-Rechnung: Was brauchen wir für den Haupt-Pfad?
      print("\n📋 OPTIMALER SCHLACHTPLAN:");
      print("1. Haupt-Quelle: '${primaryTask.name}'");
      print("   -> $primaryExecutions Klicks benötigt");
      
      Map<String, double> totalMissing = {};
      mainRequirement.cumulativeCost.forEach((res, val) {
        if (res != "Time") {
          totalMissing[res] = (totalMissing[res] ?? 0) + val;
        }
      });

      // 4. Decke die fehlenden Ressourcen
      totalMissing.forEach((res, amount) {
        var providers = stage.allTasks.where((t) => t.award.any((a) => a.name == res)).toList();
        if (providers.isNotEmpty) {
          Task provider = providers.first;
          double yieldPerClick = provider.award.firstWhere((a) => a.name == res).value;
          int providerClicks = (amount / yieldPerClick).ceil();
          print("2. Ressource '$res' decken: '${provider.name}'");
          print("   -> $providerClicks Klicks benötigt (generiert ${providerClicks * yieldPerClick} $res)");
        }
      });

      // 5. Zeit & Klicks Statistik
      int totalClicks = primaryExecutions;
      // Einfache Schätzung der Support-Klicks
      totalMissing.forEach((res, amount) {
          var providers = stage.allTasks.where((t) => t.award.any((a) => a.name == res)).toList();
          if (providers.isNotEmpty) {
             totalClicks += (amount / providers.first.award.firstWhere((a) => a.name == res).value).ceil();
          }
      });

      print("\n📈 STATISTIK FÜR STAGE 0:");
      print("   - Klicks insgesamt: ~$totalClicks");
      print("   - Engpässe identifiziert: ${totalMissing.keys.join(", ")}");
      print("   - Strategie-Fokus: 'Maximale Expansion'");
    });

    test('Analyze All Stages for Deadlocks', () {
      print("\n--- 🔍 GLOBAL DEADLOCK CHECK ---");
      for (var stage in allStages) {
        bool hasGrowth = stage.allTasks.any((t) => t.award.any((a) => a.name == "Member"));
        bool hasTimeRes = stage.allTasks.any((t) => t.award.any((a) => a.name == "Time"));
        
        if (!hasGrowth) print("⚠️ Stage ${stage.level}: Keine Member-Generierung möglich!");
        if (!hasTimeRes) print("⚠️ Stage ${stage.level}: Keine Zeit-Regeneration möglich!");
      }
    });
  });
}
