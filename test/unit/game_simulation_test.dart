import 'package:flutter_test/flutter_test.dart';
import 'package:save_the_world_flutter_app/models/game.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/task.model.dart';
import 'package:save_the_world_flutter_app/globals.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Headless Balancing Bot Simulation', () {
    late Game game;

    setUp(() {
      Game.mInstance = null;
      game = Game.getInstance();
      game.isLoading = false;
      Game.tasks.clear();
    });

    test('Simulation: Speedrun through all stages to verify balancing', () {
      final List<int> stageThresholds = levels.keys.toList();
      Map<int, Map<String, dynamic>> finalReport = {};
      
      print("\n🚀 STARTING GLOBAL SIMULATION...");

      for (int targetStage = 0; targetStage < stageThresholds.length; targetStage++) {
        int clicksInStage = 0;
        double timeInStage = 0;
        Map<String, int> shortages = {};

        while (game.stage == targetStage) {
          // 1. Hole alle verfügbaren Tasks
          List<Task> available = Game.tasks.where((t) => t.enabled).toList();
          
          if (available.isEmpty) {
            fail("🛑 DEAD-END in Stage ${game.stage}: No tasks enabled!");
          }

          // 2. Strategie: Priorisiere Milestones, dann Member
          available.sort((a, b) {
            if (a.isMilestone != b.isMilestone) return a.isMilestone ? -1 : 1;
            double aVal = a.award.where((r) => r.name == "Member").fold(0.0, (p, r) => p + r.value);
            double bVal = b.award.where((r) => r.name == "Member").fold(0.0, (p, r) => p + r.value);
            return bVal.compareTo(aVal);
          });

          // 3. Versuche einen Task auszuführen
          bool executed = false;
          for (var task in available) {
            bool canAfford = true;
            for (var cost in task.cost) {
              final res = Game.ressources[cost.name];
              if (res == null || !res.canSubtract(cost)) {
                canAfford = false;
                shortages[cost.name] = (shortages[cost.name] ?? 0) + 1;
                break;
              }
            }

            if (canAfford) {
              // Ausführen (Simulation ohne Animation)
              for (var cost in task.cost) {
                Game.ressources[cost.name]?.subtract(cost);
              }
              timeInStage += (task.duration / 1000);
              clicksInStage++;
              task.finished(); // Wendet Awards & Modifier an
              game.levelListener(); // Prüft Stage-Up
              executed = true;
              break;
            }
          }

          if (!executed) {
            fail("🛑 RESOURCE LOCK in Stage ${game.stage}: Cannot afford any task. Shortages: $shortages");
          }

          // Sicherheits-Abbruch für Endlosschleifen
          if (clicksInStage > 5000) {
            fail("🛑 BALANCING ERROR: Stage ${game.stage} takes more than 5000 clicks. Check thresholds!");
          }
        }

        finalReport[targetStage] = {
          'clicks': clicksInStage,
          'time': timeInStage,
          'main_bottleneck': shortages.entries.isEmpty ? "None" : shortages.entries.reduce((a, b) => a.value > b.value ? a : b).key
        };
      }

      // --- ERGEBNIS-BERICHT ---
      print("\n📊 BALANCING REPORT:");
      print("--------------------------------------------------");
      print("STAGE | CLICKS | TIME (s) | MAIN BOTTLENECK");
      print("--------------------------------------------------");
      finalReport.forEach((stg, data) {
        String s = stg.toString().padRight(5);
        String c = data['clicks'].toString().padRight(6);
        String t = data['time'].toStringAsFixed(1).padRight(8);
        String b = data['main_bottleneck'];
        print("$s | $c | $t | $b");
      });
      print("--------------------------------------------------");
    });
  });
}
