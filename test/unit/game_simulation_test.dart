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

  group('🤖 Smart Balancing & Logic Bot (Church Growth Validation)', () {
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
      if (important) {
        print("⭐ $msg");
      }
      if (report.length < 5 * 1024 * 1024) { 
        report.writeln(msg);
      }
    }

    String getResourceStatus() {
      return Game.ressources.entries
          .where((e) => e.key != "Stage")
          .map((e) => "${e.key}: ${e.value.value.toStringAsFixed(1)}")
          .join(" | ");
    }

    void writeReportToFile() {
      try {
        final file = File('simulation_report.log');
        file.writeAsStringSync(report.toString());
      } catch (_) {}
    }

    test('Simulate playthrough with Hierarchical Strategy', () {
      final List<int> thresholds = levels.keys.toList();
      final Map<int, Map<String, dynamic>> stageStats = {};
      
      smartLog("--- 🚀 STARTE SMARTE SIMULATION (Hierarchische Strategie) ---", important: true);

      try {
        for (int currentStage = 0; currentStage < thresholds.length; currentStage++) {
          game.initStage(currentStage);
          smartLog("\n>>> BETRETE STAGE $currentStage (${levels[thresholds[currentStage]]})");
          smartLog("   [START] ${getResourceStatus()}", important: true);

          int iterations = 0;
          const int maxIterations = 15000;

          while (game.stage == currentStage && iterations < maxIterations) {
            iterations++;
            List<Task> available = Game.tasks.where((t) => t.enabled).toList();
            
            if (available.isEmpty) {
              iterations += 100; // Beschleunigt das Warten
              continue; 
            }

            Task? selectedTask;
            String choiceReason = "";

            // --- HIERARCHISCHE ENTSCHEIDUNGSLOGIK ---

            // PRIO 1: ÜBERLEBEN (Schlaf-Notfall)
            final currentTime = Game.ressources["Time"]?.value ?? 0.0;
            if (currentTime < 9.0) {
              try {
                final sleepTask = available.firstWhere((t) => t.name == "Schlafen");
                if (sleepTask.cost.every((c) => Game.ressources[c.name]!.canSubtract(c))) {
                  selectedTask = sleepTask;
                  choiceReason = "[PRIO 1: NOTFALL] Zeitkritisch, erzwinge Schlaf.";
                }
              } catch (_) {}
            }

            // PRIO 2: WACHSTUM (Member generieren)
            if (selectedTask == null) {
              var growthTasks = available.where((t) => t.award.any((a) => a.name == "Member")).toList();
              growthTasks.sort((a,b) => b.award.firstWhere((aw) => aw.name == "Member").value.compareTo(a.award.firstWhere((aw) => aw.name == "Member").value)); // Effektivster zuerst

              for(var task in growthTasks) {
                  if (task.cost.every((c) => Game.ressources[c.name]!.canSubtract(c))) {
                      selectedTask = task;
                      choiceReason = "[PRIO 2: WACHSTUM] Fokus auf neue Mitglieder.";
                      break;
                  }
              }
            }
            
            // PRIO 3: REGENERATION (Restliche Ressourcen auffüllen)
            if (selectedTask == null) {
                final criticalRes = Game.ressources.entries.where((e) => e.value.value < e.value.max * 0.25 && e.key != "Time").map((e) => e.key).toList();
                if (criticalRes.isNotEmpty) {
                    var generators = available.where((t) => t.award.any((a) => criticalRes.contains(a.name))).toList();
                    if(generators.isNotEmpty) {
                        selectedTask = generators.first;
                        choiceReason = "[PRIO 3: REGEN] Fülle ${criticalRes.join(", ")} auf.";
                    }
                }
            }

            // PRIO 4: WARTUNG (Günstigster Task, der noch geht)
            if (selectedTask == null) {
                available.sort((a,b) => a.cost.length.compareTo(b.cost.length));
                for(var task in available) {
                    if (task.cost.every((c) => Game.ressources[c.name]!.canSubtract(c))) {
                        selectedTask = task;
                        choiceReason = "[PRIO 4: WARTUNG] Günstigste Aufgabe.";
                        break;
                    }
                }
            }

            // AUSFÜHRUNG
            if (selectedTask != null) {
              if (selectedTask.isMilestone) {
                  smartLog("🚩 GOLDENER TASK: ${selectedTask.name} - ${choiceReason}", important: true);
              } else if (choiceReason.contains("PRIO 1")) {
                  smartLog("  ${choiceReason} -> ${selectedTask.name}", important: true);
              }

              selectedTask.execute();
              game.levelListener();

              if (game.stage != currentStage) {
                  smartLog("🚀 STUFENAUFSTIEG NACH ${game.stage}!", important: true);
                  smartLog("   Neue verfügbare Aufgaben: ${Game.tasks.map((t) => t.name).join(", ")}", important: true);
                  break; // Stage-Loop verlassen
              }
            } else {
              iterations += 100;
            }
          }

          if (iterations >= maxIterations) {
             smartLog("\n🛑 DEADLOCK IN STAGE $currentStage!", important: true);
             smartLog("   Ressourcen: ${getResourceStatus()}", important: true);
             smartLog("   Verfügbare Tasks: ${Game.tasks.where((t)=>t.enabled).map((t)=>t.name).join(", ")}", important: true);
             fail("Abbruch in Stage $currentStage.");
          }

          smartLog("✅ Stage $currentStage beendet. [ENDE] ${getResourceStatus()}", important: true);
        }
      } catch (e) {
        rethrow;
      } finally {
        writeReportToFile();
      }
    });
  });
}


extension TaskExecutor on Task {
    void execute() {
        for (var cost in this.cost) {
            Game.ressources[cost.name]?.subtract(cost);
        }
        this.finished();
    }
}