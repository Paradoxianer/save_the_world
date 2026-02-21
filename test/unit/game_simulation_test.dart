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

    void writeReportToFile() {
      final file = File('simulation_report.log');
      file.writeAsStringSync(report.toString());
      print("📝 Simulationsbericht geschrieben in: ${file.absolute.path}");
    }

    test('Simulate playthrough with Sustainable Time Management', () {
      final List<int> thresholds = levels.keys.toList();
      final Map<int, Map<String, dynamic>> stageStats = {};
      
      report.writeln("--- 🚀 STARTE NACHHALTIGE LOGIK-SIMULATION ---");
      report.writeln("Regel: Bot versucht nie unter 9h Zeit zu fallen (Schutz vor Erschöpfung).\n");

      try {
        for (int currentStage = 0; currentStage < thresholds.length; currentStage++) {
          int manualClicks = 0;
          double timeInSeconds = 0;
          
          game.initStage(currentStage);
          report.writeln("\n>>> BETRETE STAGE $currentStage (${levels[thresholds[currentStage]]})");

          while (game.stage == currentStage) {
            final currentTime = Game.ressources['Time']?.value ?? 0.0;
            List<Task> available = Game.tasks.where((t) => t.enabled).toList();
            
            if (available.isEmpty) {
              report.writeln("⚠️ Keine aktiven Aufgaben. Warte auf Chains...");
              timeInSeconds += 1.0;
              continue; 
            }

            // --- NACHHALTIGKEITS-LOGIK (Schlafen-Prio) ---
            Task? sleepTask;
            try {
              sleepTask = Game.tasks.firstWhere((t) => t.name.toLowerCase().contains("schlafen") && t.enabled);
            } catch (_) {
              sleepTask = null;
            }

            Task? selectedTask;

            // Wenn Zeit kritisch (< 9h), erzwinge Schlafen falls möglich
            if (currentTime < 9.0 && sleepTask != null) {
              bool canAffordSleep = true;
              for (var cost in sleepTask.cost) {
                if (!(Game.ressources[cost.name]?.canSubtract(cost) ?? false)) canAffordSleep = false;
              }
              if (canAffordSleep) {
                selectedTask = sleepTask;
                report.writeln("  [MODUS: REGENERATION] Zeit ist knapp ($currentTime h). Gehe schlafen...");
              }
            }

            // Falls kein Schlaf nötig/möglich, wähle nach Strategie
            if (selectedTask == null) {
              available.sort((a, b) {
                if (a.isMilestone != b.isMilestone) return a.isMilestone ? -1 : 1;
                double aMember = a.award.where((r) => r.name == "Member").fold(0.0, (p, r) => p + r.value);
                double bMember = b.award.where((r) => r.name == "Member").fold(0.0, (p, r) => p + r.value);
                return bMember.compareTo(aMember);
              });

              for (var task in available) {
                // Check: Würde dieser Task uns unter das Schlaf-Limit (8h Kosten) drücken?
                // Ausnahme: Der Task ist Schlafen selbst.
                double timeCost = task.cost.where((c) => c.name == "Time").fold(0.0, (p, c) => p + c.value);
                bool isSleep = task.name.toLowerCase().contains("schlafen");
                
                if (!isSleep && (currentTime - timeCost) < 8.0) {
                  continue; // Zu riskant, wir brauchen Puffer für Schlaf
                }

                bool canAfford = true;
                for (var cost in task.cost) {
                  if (!(Game.ressources[cost.name]?.canSubtract(cost) ?? false)) canAfford = false;
                }

                if (canAfford) {
                  selectedTask = task;
                  break;
                }
              }
            }

            // Ausführung des gewählten Tasks
            if (selectedTask != null) {
              for (var cost in selectedTask.cost) {
                Game.ressources[cost.name]?.subtract(cost);
              }
              timeInSeconds += (selectedTask.duration / 1000);
              manualClicks++;
              
              report.writeln("  [Click $manualClicks] Executed: ${selectedTask.name} (Time left: ${Game.ressources['Time']?.value}h)");
              
              selectedTask.finished(); 
              game.levelListener();
            } else {
              // Kein Task möglich (entweder Ressourcen-Mangel oder wir warten auf Puffer für Schlaf)
              timeInSeconds += 10.0; 
              if (timeInSeconds > 10000) { 
                 report.writeln("\n🛑 DEADLOCK DETECTED!");
                 report.writeln("Zeit: $currentTime h");
                 Game.ressources.forEach((name, res) => report.writeln("  - $name: ${res.value}"));
                 report.writeln("Tasks in Liste: ${Game.tasks.map((t)=>t.name).join(", ")}");
                 writeReportToFile();
                 fail("RESOURCE LOCK in Stage ${game.stage}. Check simulation_report.log");
              }
            }
          }

          stageStats[currentStage] = {'clicks': manualClicks, 'time': timeInSeconds};
          report.writeln("✅ Stage $currentStage erfolgreich beendet.");
        }
      } catch (e) {
        report.writeln("\n🔥 Simulation Error: $e");
        rethrow;
      } finally {
        writeReportToFile();
      }
    });
  });
}
