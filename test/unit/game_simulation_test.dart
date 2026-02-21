import 'package:flutter_test/flutter_test.dart';
import 'package:save_the_world_flutter_app/models/game.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/task.model.dart';
import 'package:save_the_world_flutter_app/globals.dart';
import 'package:save_the_world_flutter_app/stages.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('🤖 Smart Balancing & Logic Bot (Church Growth Validation)', () {
    late Game game;

    setUp(() {
      Game.mInstance = null;
      game = Game.getInstance();
      game.isLoading = false;
      Game.tasks.clear();
    });

    test('Simulate playthrough and validate CHURCH_GROWTH_LOGIC.md principles', () {
      final List<int> thresholds = levels.keys.toList();
      final Map<int, Map<String, dynamic>> stageStats = {};
      
      print("\n--- 🚀 STARTE LOGIK-VALIDIERUNGS-SIMULATION ---");

      for (int currentStage = 0; currentStage < thresholds.length; currentStage++) {
        int manualClicks = 0;
        int autoExecutes = 0;
        double timeConsumed = 0;
        Set<String> finishedMilestones = {};
        
        game.initStage(currentStage);

        // Simulation der Ticks/Entscheidungen pro Stage
        while (game.stage == currentStage) {
          // 1. Logik-Check: Cleanup-Regel (CHURCH_GROWTH_LOGIC #3)
          // Meilensteine dürfen nicht doppelt in der Liste sein
          final milestoneNames = Game.tasks.where((t) => t.isMilestone).map((t) => t.name).toList();
          if (milestoneNames.length != milestoneNames.toSet().length) {
            fail("🛑 DUPLIKAT-FEHLER in Stage ${game.stage}: Meilenstein mehrfach vorhanden!");
          }

          // 2. Verfügbare Aufgaben filtern
          List<Task> available = Game.tasks.where((t) => t.enabled).toList();
          
          if (available.isEmpty) {
            // Check: Gibt es Aufgaben, die nur 'disabled' sind (Warten auf Vorbereitung)?
            bool waitingForChain = Game.tasks.any((t) => !t.enabled);
            if (!waitingForChain) {
              fail("🛑 DEAD-END in Stage ${game.stage}: Keine Aufgaben mehr verfügbar!");
            }
            // Simuliere Wartezeit/Vorbereitung (Auto-Enable Logik falls vorhanden)
            timeConsumed += 1.0;
            continue; 
          }

          // 3. Strategie (CHURCH_GROWTH_LOGIC #2: Macher vs. Leiter)
          // Bot priorisiert: 
          // a) Milestones (Progression)
          // b) Member-Tasks (Wachstum)
          // c) Ressourcen-Tasks (Maintenance)
          available.sort((a, b) {
            if (a.isMilestone != b.isMilestone) return a.isMilestone ? -1 : 1;
            double aMember = a.award.where((r) => r.name == "Member").fold(0.0, (p, r) => p + r.value);
            double bMember = b.award.where((r) => r.name == "Member").fold(0.0, (p, r) => p + r.value);
            return bMember.compareTo(aMember);
          });

          bool taskPerformed = false;
          for (var task in available) {
            // Kann sich der Bot den Task leisten?
            bool canAfford = true;
            for (var cost in task.cost) {
              final res = Game.ressources[cost.name];
              if (res == null || !res.canSubtract(cost)) {
                canAfford = false;
                break;
              }
            }

            if (canAfford) {
              // Ausführung
              for (var cost in task.cost) {
                Game.ressources[cost.name]?.subtract(cost);
              }
              
              timeConsumed += (task.duration / 1000);
              manualClicks++;
              
              if (task.isMilestone) {
                finishedMilestones.add(task.name);
              }

              task.finished(); 
              
              // 4. Logik-Check: Symmetrie (CHURCH_GROWTH_LOGIC #3)
              // Wenn ein Milestone fertig ist, muss er aus der aktiven Liste verschwinden
              if (task.isMilestone && Game.tasks.contains(task)) {
                 fail("🛑 SYMMETRIE-FEHLER in Stage ${game.stage}: Meilenstein '${task.name}' wurde nicht entfernt!");
              }

              game.levelListener();
              taskPerformed = true;
              break; 
            }
          }

          if (!taskPerformed) {
            // RESOURCE LOCK Check (CHURCH_GROWTH_LOGIC #2)
            // Wenn wir hier hängen, prüfen wir, ob wir passiv Ressourcen kriegen
            // In dieser Simulation addieren wir Zeit, um evtl. Auto-Execution abzuwarten
            timeConsumed += 5.0; 
            if (timeConsumed > 3600) { // 1 Stunde virtuelle Zeit pro Stage ist Limit
               fail("🛑 RESOURCE LOCK in Stage ${game.stage}: Keine bezahlbaren Aufgaben mehr nach 1h Simulation.");
            }
          }

          if (manualClicks > 5000) {
            fail("🛑 BALANCING ALARM: Stage ${game.stage} erfordert zu viel manuelle Arbeit (>5000 Klicks)!");
          }
        }

        // 5. Scoring-Check (CHURCH_GROWTH_LOGIC #5)
        // Ab Stage 11+ sollten Klicks abnehmen, da Delegation greifen muss
        if (currentStage >= 11 && manualClicks > 500) {
           print("⚠️ PERFORMANCE WARNUNG: Stage $currentStage hat hohe Klickrate ($manualClicks). Delegation-Prinzip prüfen!");
        }

        stageStats[currentStage] = {
          'clicks': manualClicks,
          'time': timeConsumed,
          'milestones': finishedMilestones.length
        };
        
        print("✅ Stage $currentStage validiert: $manualClicks Klicks, ${timeConsumed.toStringAsFixed(1)}s simuliert.");
      }

      print("\n📊 KIRCHENWACHSTUM - LOGIK ANALYSE:");
      print("------------------------------------------------------------");
      print("STUFE | KLICKS | DAUER (min) | STATUS");
      print("------------------------------------------------------------");
      stageStats.forEach((stg, data) {
        String s = stg.toString().padRight(5);
        String c = data['clicks'].toString().padRight(6);
        String t = (data['time'] / 60).toStringAsFixed(2).padRight(11);
        String status = data['clicks'] < 100 ? "🌟 Delegiert" : "🛠 Manuell";
        print("$s | $c | $t | $status");
      });
    });
  });
}
