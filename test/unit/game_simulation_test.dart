import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:save_the_world_flutter_app/models/game.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/task.model.dart';
import 'package:save_the_world_flutter_app/globals.dart';
import 'package:save_the_world_flutter_app/stages.dart';

void main() {
  const MethodChannel channel = MethodChannel('plugins.flutter.io/path_provider');
  TestWidgetsFlutterBinding.ensureInitialized();
  
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
    return "."; 
  });

  group('🤖 Smart Balancing & Logic Bot', () {
    late Game game;
    final StringBuffer report = StringBuffer();

    setUp(() {
      Game.mInstance = null;
      game = Game.getInstance();
      game.isLoading = false;
      Game.tasks.clear();
      report.clear();
    });

    void smartLog(String msg, {bool important = false}) {
      if (important) print("⭐ $msg");
      report.writeln(msg);
    }

    String getResourceStatus() {
      return Game.ressources.entries
          .where((e) => e.key != "Stage")
          .map((e) => "${e.key}: ${e.value.value.toStringAsFixed(1)}")
          .join(" | ");
    }

    test('Simulate playthrough and evaluate leadership efficiency', () {
      final List<int> thresholds = levels.keys.toList();
      
      smartLog("--- 🚀 STARTE KI-BALANCING SIMULATION ---", important: true);
      smartLog("Referenz: CHURCH_GROWTH_LOGIC.md");

      for (int currentStage = 0; currentStage < thresholds.length; currentStage++) {
        game.initStage(currentStage);
        
        int clicks = 0;
        int waitCycles = 0;
        final startTime = DateTime.now();
        Map<String, int> taskUsage = {};

        smartLog("\n>>> STAGE $currentStage: ${levels[thresholds[currentStage]]} <<<", important: true);

        int iterations = 0;
        const int maxIterations = 20000; 

        while (game.stage == currentStage && iterations < maxIterations) {
          iterations++;
          List<Task> available = Game.tasks.where((t) => t.enabled).toList();
          
          if (available.isEmpty) {
            waitCycles++;
            continue; 
          }

          Task? selectedTask = _decideNextTask(available);

          if (selectedTask != null) {
            taskUsage[selectedTask.name] = (taskUsage[selectedTask.name] ?? 0) + 1;
            
            if (selectedTask.isMilestone) {
                smartLog("  🏆 MILESTONE ERREICHT: ${selectedTask.name}");
            }
            
            selectedTask.execute();
            clicks++;
            game.levelListener();
          } else {
            waitCycles++;
          }
        }

        final duration = DateTime.now().difference(startTime);
        _logStageSummary(currentStage, clicks, waitCycles, taskUsage, report);

        if (iterations >= maxIterations) {
           smartLog("🛑 DEADLOCK in Stage $currentStage! Ressourcen: ${getResourceStatus()}", important: true);
           fail("Abbruch wegen Ineffizienz oder Ressourcen-Lock.");
        }
      }
      
      try {
        File('simulation_report.log').writeAsStringSync(report.toString());
      } catch (_) {}
    });
  });
}

/// Zentrale Entscheidungslogik des Bots (Simuliert einen erfahrenen Spieler)
Task? _decideNextTask(List<Task> available) {
  final currentTime = Game.ressources["Time"]?.value ?? 0.0;

  // PRIO 1: ÜBERLEBEN (Zeit-Management)
  if (currentTime < 8.0) {
    var survival = available.where((t) => t.name == "Schlafen" || t.name == "Freizeit").toList();
    survival.sort((a, b) => b.award.fold(0.0, (p, aw) => p + (aw.name == "Time" ? aw.value : 0))
        .compareTo(a.award.fold(0.0, (p, aw) => p + (aw.name == "Time" ? aw.value : 0))));
    
    for (var t in survival) {
      if (t.cost.every((c) => Game.ressources[c.name]!.canSubtract(c))) return t;
    }
  }

  // PRIO 2: STRATEGISCHES WACHSTUM (Milestones & Member)
  var growthTasks = available.where((t) => t.isMilestone || t.award.any((a) => a.name == "Member")).toList();
  if (growthTasks.isNotEmpty) {
    growthTasks.sort((a, b) {
      if (a.isMilestone != b.isMilestone) return a.isMilestone ? -1 : 1;
      double aMem = a.award.where((aw) => aw.name == "Member").fold(0, (p, aw) => p + aw.value);
      double bMem = b.award.where((aw) => aw.name == "Member").fold(0, (p, aw) => p + aw.value);
      return bMem.compareTo(aMem);
    });
    
    for (var t in growthTasks) {
      if (t.cost.every((c) => Game.ressources[c.name]!.canSubtract(c))) return t;
    }
  }

  // PRIO 3: REGENERATION
  for (var res in Game.ressources.entries) {
    if (res.value.value < res.value.max * 0.3) {
        var fixers = available.where((t) => t.award.any((a) => a.name == res.key)).toList();
        for (var t in fixers) {
          if (t.cost.every((c) => Game.ressources[c.name]!.canSubtract(c))) return t;
        }
    }
  }

  // PRIO 4: WARTUNG / FALLBACK
  for (var t in available) {
    if (t.cost.every((c) => Game.ressources[c.name]!.canSubtract(c))) return t;
  }

  return null;
}

void _logStageSummary(int stage, int clicks, int waits, Map<String, int> usage, StringBuffer report) {
  String mode = "UNBEKANNT";
  if (stage <= 3) mode = "MACHER (Clan)";
  else if (stage <= 10) mode = "LEITER (Gemeinde)";
  else mode = "STRATEGE (Bewegung)";

  final sortedTasks = usage.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
  final topTaskSummary = sortedTasks.isEmpty
      ? "N/A"
      : sortedTasks.take(3).map((e) => "${e.key}(${e.value})").join(', ');


  final log = """
📊 STAGE $stage ZUSAMMENFASSUNG:
   Modus:      $mode
   Klicks:     $clicks
   Wartezyklen: $waits
   Mitglieder: ${Game.ressources["Member"]?.value.toStringAsFixed(1)}
   Top Tasks:  $topTaskSummary
-----------------------------------""";
  
  print(log);
  report.writeln(log);
}

extension TaskExecutor on Task {
    void execute() {
        for (var cost in this.cost) {
            Game.ressources[cost.name]?.subtract(cost);
        }
        this.finished();
    }
}

extension ListUtils<T> on Iterable<T> {
  T? get firstOrNull => this.isEmpty ? null : first;
}
