import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:save_the_world_flutter_app/models/game.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/task.model.dart';
import 'package:save_the_world_flutter_app/models/ressource.model.dart';
import 'package:save_the_world_flutter_app/models/modifier.model.dart';
import 'package:save_the_world_flutter_app/models/addtask.model.dart';
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
  const MethodChannel channel = MethodChannel('plugins.flutter.io/path_provider');
  TestWidgetsFlutterBinding.ensureInitialized();
  
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
    return "."; 
  });

  group('🎯 Backwards Strategy Bot (The Architect)', () {
    late Game game;

    setUp(() {
      Game.mInstance = null;
      game = Game.getInstance();
      game.isLoading = false;
    });

    test('Analyze Stage 0 Strategy', () {
      print("\n--- 🧠 STRATEGIE-ANALYSE STAGE 0 ---");
      
      // Ziel: Erreiche 20 Members
      double targetMembers = 20.0;
      double currentMembers = 2.0; // Startwert
      double neededMembers = targetMembers - currentMembers;

      List<Task> allAvailableTasks = allStages[0].allTasks;
      
      // 1. Finde den effizientesten Weg für Members
      var memberTasks = allAvailableTasks.where((t) => t.award.any((a) => a.name == "Member")).toList();
      
      print("Ziel: +$neededMembers Mitglieder");
      
      for (var task in memberTasks) {
        double awardPerClick = task.award.firstWhere((a) => a.name == "Member").value;
        int clicksNeeded = (neededMembers / awardPerClick).ceil();
        
        print("\nOption: ${task.name}");
        print("  - Klicks benötigt: $clicksNeeded");
        
        // Berechne Gesamtkosten für diesen Pfad
        Map<String, double> cumulativeCosts = {};
        for (var cost in task.cost) {
          cumulativeCosts[cost.name] = (cumulativeCosts[cost.name] ?? 0) + (cost.value * clicksNeeded);
        }

        print("  - Gesamtkosten für $clicksNeeded Ausführungen:");
        cumulativeCosts.forEach((name, val) {
          print("    * $name: $val");
          
          // REKURSION: Wie decken wir diese Kosten?
          if (name != "Time") {
             _findBestProvider(name, val, allAvailableTasks, indent: "    ");
          }
        });
      }
    });

    test('Full Recursive Path Optimization Stage 0', () {
        print("\n--- 🚀 OPTIMALER PFAD RECHNER (STAGE 0) ---");
        
        final analysis = _calculateOptimalPath(
            targetRes: "Member", 
            targetAmount: 18.0, // 20 - 2 (start)
            availableTasks: allStages[0].allTasks
        );

        _printAnalysisReport(analysis);
    });
  });
}

void _findBestProvider(String resName, double amountNeeded, List<Task> tasks, {String indent = ""}) {
    var providers = tasks.where((t) => t.award.any((a) => a.name == resName)).toList();
    if (providers.isEmpty) {
        print("$indent ⚠️ KEIN PROVIDER FÜR $resName GEFUNDEN!");
        return;
    }

    // Sortiere nach Effizienz (Award pro Klick)
    providers.sort((a, b) {
        double valA = a.award.firstWhere((aw) => aw.name == resName).value;
        double valB = b.award.firstWhere((aw) => aw.name == resName).value;
        return valB.compareTo(valA);
    });

    var best = providers.first;
    double awardPerClick = best.award.firstWhere((a) => a.name == resName).value;
    int clicks = (amountNeeded / awardPerClick).ceil();

    print("$indent -> Beste Quelle: ${best.name}");
    print("$indent    Benötigt $clicks Klicks für $amountNeeded $resName");
    
    for (var cost in best.cost) {
        if (cost.name != "Time") {
            _findBestProvider(cost.name, cost.value * clicks, tasks, indent: "$indent  ");
        } else {
            print("$indent    Kosten: ${cost.value * clicks} Zeit");
        }
    }
}

Map<String, List<StepAnalysis>> _calculateOptimalPath({
    required String targetRes, 
    required double targetAmount, 
    required List<Task> availableTasks
}) {
    Map<String, List<StepAnalysis>> fullPlan = {};
    _recursiveSolve(targetRes, targetAmount, availableTasks, fullPlan, 0);
    return fullPlan;
}

void _recursiveSolve(String res, double amount, List<Task> tasks, Map<String, List<StepAnalysis>> plan, int depth) {
    if (res == "Time" || amount <= 0 || depth > 5) return;

    var providers = tasks.where((t) => t.award.any((a) => a.name == res)).toList();
    if (providers.isEmpty) return;

    // Einfachheitshalber nehmen wir den ersten (später: Dijkstra/A* Logik)
    var task = providers.first;
    double awardPerClick = task.award.firstWhere((a) => a.name == res).value;
    int clicks = (amount / awardPerClick).ceil();

    final step = StepAnalysis(
        task: task,
        count: clicks,
        totalCost: { for (var c in task.cost) c.name : c.value * clicks },
        totalAward: { for (var a in task.award) a.name : a.value * clicks }
    );

    plan[res] = (plan[res] ?? [])..add(step);

    for (var cost in task.cost) {
        _recursiveSolve(cost.name, cost.value * clicks, tasks, plan, depth + 1);
    }
}

void _printAnalysisReport(Map<String, List<StepAnalysis>> plan) {
    print("\n📋 STRATEGIE-REPORT:");
    double totalTime = 0;
    int totalClicks = 0;
    Map<String, double> totalRawCosts = {};

    plan.forEach((res, steps) {
        print("\n🔹 Fokus: $res");
        for (var step in steps) {
            print("  - Führe '${step.task.name}' ${step.count} mal aus.");
            totalClicks += step.count;
            totalTime += (step.task.duration * step.count) / 1000; // in Sekunden
            
            step.totalCost.forEach((name, val) {
                totalRawCosts[name] = (totalRawCosts[name] ?? 0) + val;
            });
        }
    });

    print("\n📈 STATISTIK:");
    print("  - Gesamtzahl Klicks: $totalClicks");
    print("  - Theoretische Zeit: ${totalTime.toStringAsFixed(1)}s");
    totalRawCosts.forEach((name, val) {
        print("  - Gesamtbedarf $name: ${val.toStringAsFixed(2)}");
    });
}
