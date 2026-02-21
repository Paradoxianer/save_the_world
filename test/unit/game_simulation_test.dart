import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:save_the_world_flutter_app/models/game.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/task.model.dart';
import 'package:save_the_world_flutter_app/models/ressource.model.dart';
import 'package:save_the_world_flutter_app/models/addtask.model.dart';
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

    test('Simulate playthrough with STRIKT 4-PRIO LOGIC', () {
      final List<int> thresholds = levels.keys.toList();
      
      smartLog("--- 🚀 STARTE STRATEGISCHE SIMULATION (4-PRIO SYSTEM) ---", important: true);
      smartLog("1. Zeit | 2. Goldene Aufgabe | 3. Member | 4. Ressourcen im Plus halten");

      for (int currentStage = 0; currentStage < thresholds.length; currentStage++) {
        game.initStage(currentStage);
        
        int clicks = 0;
        int waitCycles = 0;
        final startTime = DateTime.now();
        Map<String, int> taskUsage = {};

        smartLog("\n>>> STAGE $currentStage: ${levels[thresholds[currentStage]]} <<<", important: true);

        int iterations = 0;
        const int maxIterations = 30000; 

        while (game.stage == currentStage && iterations < maxIterations) {
          iterations++;
          List<Task> available = Game.tasks.where((t) => t.enabled).toList();
          
          if (available.isEmpty) {
            waitCycles++;
            continue; 
          }

          Task? selectedTask = _decideNextTaskStrict(available, game);

          if (selectedTask != null) {
            taskUsage[selectedTask.name] = (taskUsage[selectedTask.name] ?? 0) + 1;
            
            if (selectedTask.isMilestone) {
                smartLog("  🏆 GOLDENE AUFGABE ERREICHT: ${selectedTask.name} (${_resString()})", important: true);
            }
            
            selectedTask.execute();
            clicks++;
            game.levelListener();
          } else {
            waitCycles++;
          }
        }

        _logStageSummary(currentStage, clicks, waitCycles, taskUsage, report);

        if (iterations >= maxIterations) {
           smartLog("🛑 DEADLOCK in Stage $currentStage!", important: true);
           smartLog("   Status: ${_resString()}");
           smartLog("   Top Tasks: ${taskUsage.entries.toList()..sort((a,b)=>b.value.compareTo(a.value))}");
           fail("Simulation abgebrochen: Bot steckt in Stage $currentStage fest.");
        }
      }
      
      try {
        File('simulation_report.log').writeAsStringSync(report.toString());
      } catch (_) {}
    });
  });
}

String _resString() {
  return Game.ressources.entries
      .where((e) => ["Time", "Faith", "Money", "Member"].contains(e.key))
      .map((e) => "${e.key}: ${e.value.value.toStringAsFixed(1)}")
      .join(" | ");
}

bool _isRegeneratingTime = false;

Task? _decideNextTaskStrict(List<Task> available, Game game) {
  final currentTime = Game.ressources["Time"]?.value ?? 0.0;
  final memberRes = Game.ressources["Member"];
  final isAtMemberLimit = memberRes != null && memberRes.value >= memberRes.max;

  // --- PRIO 1: ZEIT (Überleben) ---
  if (currentTime < 8.0 || (currentTime < 16.0 && _isRegeneratingTime)) {
    var survival = available.where((t) => t.name == "Schlafen" || t.name == "Freizeit").toList();
    if (survival.isNotEmpty) {
      _isRegeneratingTime = true;
      return survival.any((t) => t.name == "Schlafen") ? survival.firstWhere((t) => t.name == "Schlafen") : survival.first; 
    }
  }
  _isRegeneratingTime = false;

  // --- PRIO 2: GOLDENER PFAD (Meilensteine) ---
  Task? goldenGoal;
  var milestones = available.where((t) => t.isMilestone).toList();
  if (milestones.isNotEmpty) {
    goldenGoal = milestones.first;
  } else {
    // Suche Tasks, die Milestones freischalten (AddTask Modifier)
    // FIX: m.nameOfTask statt m.task
    var unlockers = available.where((t) => t.myModifier.any((m) => m is AddTask && 
        (game.allTasks.any((at) => at.name == m.nameOfTask && at.isMilestone)))).toList();
    if (unlockers.isNotEmpty) goldenGoal = unlockers.first;
  }

  if (goldenGoal != null) {
    if (goldenGoal.cost.every((c) => Game.ressources[c.name]!.canSubtract(c))) {
      return goldenGoal;
    }
    // Ressourcen für Golden Goal sammeln
    for (var cost in goldenGoal.cost) {
      if (!Game.ressources[cost.name]!.canSubtract(cost)) {
        var generators = available.where((t) => t.award.any((a) => a.name == cost.name)).toList();
        if (generators.isNotEmpty) {
          // Wähle den besten Ressourcen-Bringer für diese spezifische Not
          generators.sort((a, b) {
             var awardA = a.award.firstWhere((aw) => aw.name == cost.name).value;
             var awardB = b.award.firstWhere((aw) => aw.name == cost.name).value;
             return awardB.compareTo(awardA);
          });
          return generators.first;
        }
      }
    }
  }

  // --- PRIO 3: MEMBER GENERIEREN ---
  if (!isAtMemberLimit) {
    var growth = available.where((t) => t.award.any((a) => a.name == "Member")).toList();
    if (growth.isNotEmpty) {
      growth.sort((a, b) {
        double aMem = a.award.where((aw) => aw.name == "Member").fold(0, (p, aw) => p + aw.value);
        double bMem = b.award.where((aw) => aw.name == "Member").fold(0, (p, aw) => p + aw.value);
        return bMem.compareTo(aMem);
      });
      for (var t in growth) {
        if (t.cost.every((c) => Game.ressources[c.name]!.canSubtract(c))) return t;
      }
    }
  }

  // --- PRIO 4: RESSOURCEN IM PLUS HALTEN ---
  for (var res in Game.ressources.entries) {
    if (res.key != "Member" && res.key != "Time" && res.value.value < 1.0) { 
      var fixers = available.where((t) => t.award.any((a) => a.name == res.key)).toList();
      if (fixers.isNotEmpty) {
        for (var t in fixers) {
          if (t.cost.every((c) => Game.ressources[c.name]!.canSubtract(c))) return t;
        }
      }
    }
  }

  // Letzte Option: Irgendwas tun
  for (var t in available) {
    if (t.cost.every((c) => Game.ressources[c.name]!.canSubtract(c))) return t;
  }

  return null;
}

void _logStageSummary(int stage, int clicks, int waits, Map<String, int> usage, StringBuffer report) {
  String mode = (stage <= 3) ? "MACHER (Clan)" : (stage <= 10 ? "LEITER (Gemeinde)" : "STRATEGE (Bewegung)");
  final sortedTasks = usage.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
  
  final log = """
📊 STAGE $stage ZUSAMMENFASSUNG:
   Modus:      $mode
   Klicks:     $clicks
   Mitglieder: ${Game.ressources["Member"]?.value.toStringAsFixed(1)}
   Ressourcen: ${_resString()}
   Top Tasks:  ${sortedTasks.take(3).map((e) => "${e.key}(${e.value})").join(', ')}
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
