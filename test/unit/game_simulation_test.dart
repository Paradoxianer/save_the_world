import 'package:flutter_test/flutter_test.dart';
import 'package:save_the_world_flutter_app/models/game.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/task.model.dart';
import 'package:save_the_world_flutter_app/globals.dart';
import 'package:save_the_world_flutter_app/stages.dart';

void main() {
  // Mock für PathProvider, damit die Simulation nicht abstürzt
  TestWidgetsFlutterBinding.ensureInitialized();

  group('🤖 Headless Balancing Bot (Full Playthrough)', () {
    late Game game;

    setUp(() {
      Game.mInstance = null;
      game = Game.getInstance();
      game.isLoading = false;
      Game.tasks.clear();
    });

    test('Simulate complete game from Stage 0 to Stage 32', () {
      final List<int> thresholds = levels.keys.toList();
      final Map<int, Map<String, dynamic>> stats = {};
      
      print("\n--- 🚀 STARTE VOLLSTÄNDIGE SPIEL-SIMULATION ---");

      for (int currentTargetStage = 0; currentTargetStage < thresholds.length; currentTargetStage++) {
        int clicks = 0;
        double virtualTime = 0;
        Map<String, int> shortages = {};
        
        // Sicherstellen, dass die Stufe initialisiert ist
        game.initStage(game.stage);

        // Wir spielen, bis wir die nächste Stufe erreichen oder ein Limit überschreiten
        while (game.stage == currentTargetStage) {
          List<Task> available = Game.tasks.where((t) => t.enabled).toList();
          
          if (available.isEmpty) {
            fail("🛑 DEAD-END in Stufe ${game.stage}: Keine aktiven Aufgaben!");
          }

          // Strategie des Bots:
          // 1. Meilensteine haben absolute Priorität.
          // 2. Aufgaben, die Member bringen, sind zweitwichtig.
          // 3. Innerhalb dieser Gruppen: Günstigste Aufgaben zuerst.
          available.sort((a, b) {
            if (a.isMilestone != b.isMilestone) return a.isMilestone ? -1 : 1;
            double aMember = a.award.where((r) => r.name == "Member").fold(0.0, (p, r) => p + r.value);
            double bMember = b.award.where((r) => r.name == "Member").fold(0.0, (p, r) => p + r.value);
            if (aMember != bMember) return bMember.compareTo(aMember);
            return a.cost.length.compareTo(b.cost.length);
          });

          bool moved = false;
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
              // Simulation der Durchführung
              for (var cost in task.cost) {
                Game.ressources[cost.name]?.subtract(cost);
              }
              virtualTime += (task.duration / 1000);
              clicks++;
              
              task.finished(); // Awards & Modifier anwenden
              game.levelListener(); // Prüfen ob Stage-Up
              
              moved = true;
              break; // Nur einen Task pro "Tick"
            }
          }

          if (!moved) {
            // Wenn der Bot feststeckt, schauen wir, ob wir passiv Ressourcen regenerieren könnten
            // Da es aktuell keine passive Generierung ohne Ticks gibt, ist das ein harter Blocker.
            fail("🛑 RESOURCE LOCK in Stufe ${game.stage}: Kann mir nichts leisten. Engpässe: $shortages");
          }

          if (clicks > 10000) {
            fail("🛑 BALANCING ALARM: Stufe ${game.stage} braucht über 10.000 Klicks!");
          }
        }

        stats[currentTargetStage] = {
          'clicks': clicks,
          'time': virtualTime,
          'bottleneck': shortages.entries.isEmpty ? "None" : shortages.entries.reduce((a, b) => a.value > b.value ? a : b).key
        };
        
        print("✅ Stufe $currentTargetStage abgeschlossen: ${clicks} Klicks, ${virtualTime.toStringAsFixed(1)}s");
      }

      print("\n📊 FINALE BALANCING ANALYSE:");
      print("------------------------------------------------------------");
      print("STUFE | KLICKS | ZEIT (min) | HAUPT-ENGPASS");
      print("------------------------------------------------------------");
      stats.forEach((stg, data) {
        String s = stg.toString().padRight(5);
        String c = data['clicks'].toString().padRight(6);
        String t = (data['time'] / 60).toStringAsFixed(2).padRight(10);
        String b = data['bottleneck'];
        print("$s | $c | $t | $b");
      });
      print("------------------------------------------------------------");
    });
  });
}
