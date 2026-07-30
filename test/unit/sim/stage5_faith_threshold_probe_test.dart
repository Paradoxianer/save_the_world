import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:save_the_world_flutter_app/globals.dart';
import 'package:save_the_world_flutter_app/models/faith.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/game.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/member.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/money.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/publicity.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/stage.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/time.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/wisdome.ressource.model.dart';
import 'package:save_the_world_flutter_app/stages.dart';

import 'game_simulator.dart';
import 'sim_policies.dart';

/// Balancing-Probe für die Faith-Schwelle 400 aus Stage 5s "Fasten und
/// Beten" (AddToRandom -> "Der Heilige Geist möchte wirken"). Kein
/// Pass/Fail-Test im engeren Sinn, sondern ein Report: wie schnell erreicht
/// ein normaler bzw. optimaler Spieler 400 Glauben, und wie oft feuert das
/// Event danach im Rest der Stage?
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('Probe: Wie wirkt sich die 400er-Faith-Schwelle in Stage 5 aus?', () {
    const int stageIndex = 5;
    final thresholds = levels.keys.toList();
    final threshold = thresholds[stageIndex].toDouble();
    final stage = allStages[stageIndex];
    final report = StringBuffer();

    for (final label in ["NORMAL", "OPTIMAL"]) {
      Game.mInstance = null;
      final game = Game.getInstance();
      game.isLoading = true;
      Game.tasks.clear();
      game.completedOnceTasks.clear();
      _seedResourcesForStage(stageIndex, thresholds);

      final sim = GameSimulator(game, random: label == "NORMAL" ? Random(42) : null);
      for (int i = 0; i < stageIndex; i++) {
        game.allTasks = allStages[i].allTasks;
        sim.seedActiveTasks(allStages[i].activeTasks);
      }
      game.allTasks = stage.allTasks;

      final faithSamples = <MapEntry<double, double>>[];

      // Policies sind zustandsbehaftet (z.B. _regeneratingTime) - pro Lauf
      // frisch instanziieren.
      final normalPolicy = NormalPolicy();
      final optimalPolicy = OptimalPolicy();
      void decideStateful(GameSimulator s) {
        faithSamples.add(MapEntry(s.nowMs, Game.ressources["Faith"]?.value ?? 0.0));
        if (label == "NORMAL") {
          normalPolicy.call(s);
        } else {
          optimalPolicy.call(s);
        }
      }

      final result = sim.runStage(
        stageIndex: stageIndex,
        activeTaskNames: stage.activeTasks,
        randomTaskNames: stage.randomTasks,
        memberThreshold: threshold,
        decide: decideStateful,
        // Wie in goal_directed_simulation_test.dart: OPTIMAL ist ein reiner
        // deterministischer Speedrun ohne Zufallskrisen (die Policy kann sie
        // ohnehin nicht behandeln), NORMAL simuliert echtes Spielerlebnis
        // inkl. Krisen.
        includeRandomEvents: label == "NORMAL",
      );

      final firstAbove400 = faithSamples.firstWhere(
        (e) => e.value >= 400.0,
        orElse: () => const MapEntry(-1.0, -1.0),
      );
      final fires = sim.weightedEventFireLog["Der Heilige Geist möchte wirken"] ?? [];
      final maxFaith = faithSamples.isEmpty ? 0.0 : faithSamples.map((e) => e.value).reduce(max);

      final line = """
--- $label ---
Ergebnis: $result
Maximaler Glaube erreicht: ${maxFaith.toStringAsFixed(1)}
Glaube >= 400 zum ersten Mal bei: ${firstAbove400.key < 0 ? "nie" : "${(firstAbove400.key / 60000).toStringAsFixed(1)} virt. Min"}
"Der Heilige Geist möchte wirken" gefeuert: ${fires.length}x bei ${fires.map((t) => (t / 60000).toStringAsFixed(1)).toList()} (virt. Min)
Kette erledigt: Koordinatoren=${game.completedOnceTasks.contains("Koordinatoren ausbilden")} "
    "Offizier berufen=${game.completedOnceTasks.contains("Offizier berufen")}
Ressourcen am Ende: ${Game.ressources.entries.where((e) => ["Time", "Faith", "Money", "Wisdom", "Member"].contains(e.key)).map((e) => "${e.key}=${e.value.value.toStringAsFixed(1)}").join(", ")}
Noch aktive Tasks: ${Game.tasks.map((t) => t.name).toList()}
""";
      report.writeln(line);
      // ignore: avoid_print
      print(line);
    }

    // ignore: avoid_print
    print("\n=== ZUSAMMENFASSUNG ===\n$report");
  });
}

void _seedResourcesForStage(int stageIndex, List<int> thresholds) {
  Game.ressources[Faith().name] = Faith(value: 100.0);
  Game.ressources[Money().name] = Money(value: 20.0);
  Game.ressources[Time().name] = Time(value: 24.0);
  Game.ressources[Publicity().name] = Publicity(value: 1.0);
  Game.ressources[Wisdom().name] = Wisdom(value: 10.0);
  Game.ressources["Stage"] = StageRes(value: stageIndex.toDouble());

  final prevThreshold = stageIndex == 0 ? 2.0 : thresholds[stageIndex - 1].toDouble() + 1.0;
  Game.ressources[Member().name] = Member(value: prevThreshold);
  Game.ressources[Member().name]!.max = thresholds[stageIndex].toDouble();
  Game.ressources[Member().name]!.min = 0.0;
}
