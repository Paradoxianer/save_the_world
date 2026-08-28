import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:save_the_world_flutter_app/globals.dart';
import 'package:save_the_world_flutter_app/models/game.ressource.model.dart';
import 'package:save_the_world_flutter_app/stages.dart';

import 'sim/game_simulator.dart';
import 'sim/sim_policies.dart';

/// Goal-directed Balancing-Simulator (siehe Issue #80).
///
/// WICHTIGE ÄNDERUNG gegenüber der ursprünglichen Version: statt jede Stage
/// isoliert mit frisch geseedeten Ressourcen zu testen, spielt dieser Test
/// jetzt EINEN ZUSAMMENHÄNGENDEN Durchlauf von Stage 0 bis 32 - exakt wie ein
/// echter Spieler. Grund: das isolierte Seeding hat Tasks aus früheren
/// Stages nur in Game.tasks EINGEFÜGT, ohne sie je auszuführen. Manche Tasks
/// verwandeln sich aber erst beim ERSTEN AUSFÜHREN in ihre spätere Form
/// (Stage 0s "Bibellesen" entfernt sich selbst und wird zu "Stille Zeit" -
/// erst DANACH kann initStage() einer späteren Stage die eigene, bessere
/// "Bibellesen"-Definition nachladen). Ohne echtes Durchspielen blieb die
/// Stage-0-Variante (ohne Wisdom-Belohnung) für immer aktiv und blockierte
/// jede neuere Version - das sah wie ein Bot-Deadlock aus, war aber ein
/// Artefakt des Test-Aufbaus selbst.
///
/// Simuliert ZWEI durchgängige Läufe:
/// - "Normal": realistische Heuristik (SmartPolicy) + echte Zufalls-Krisen
///   (geseedet für Reproduzierbarkeit).
/// - "Optimal": dieselbe Heuristik, aber ohne Krisenbehandlung/Zufallsevents
///   (deterministischer Speedrun-Vergleichspunkt).
///
/// Liefert pro Stage: Klicks und virtuelle Spieldauer für beide Läufe - die
/// Rohdaten für die Balancing-Kurve aus Issue #80 ("jede Stage soll spürbar
/// länger/komplexer werden, ohne zu überfordern").
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('🎯 Goal-directed Balancing-Simulator (durchgängiger Playthrough)', () {
    test('Kontinuierlicher Normal- und Optimal-Lauf über alle Stages', () {
      final normal = _runContinuousPlaythrough(includeRandomEvents: true, random: Random(42));
      final optimal = _runContinuousPlaythrough(includeRandomEvents: false, random: null);

      final report = StringBuffer();
      final failures = <String>[];
      final stageCount = allStages.length;

      for (int i = 0; i < stageCount; i++) {
        final n = i < normal.length ? normal[i] : null;
        final o = i < optimal.length ? optimal[i] : null;
        final line = "Stage $i (${allStages[i].description}): "
            "Optimal=[${o?.toString() ?? "nicht erreicht (vorherige Stage deadlockte)"}]  "
            "Normal=[${n?.toString() ?? "nicht erreicht (vorherige Stage deadlockte)"}]";
        report.writeln(line);
        // ignore: avoid_print
        print(line);

        if (o != null && !o.reachedGoal) failures.add("Stage $i OPTIMAL: ${o.deadlockReason}");
        if (n != null && !n.reachedGoal) failures.add("Stage $i NORMAL: ${n.deadlockReason}");
      }

      // ignore: avoid_print
      print("\n=== ZUSAMMENFASSUNG ===\n$report");

      // Regressions-Schutz statt Alles-oder-Nichts: 33 Stages am Stück lösen
      // ist ein bewegliches Ziel (spätere Stages brauchen eigene Balancing-
      // Arbeit, kein reines Bot-Problem mehr). Diese Untergrenze dokumentiert
      // den aktuell erreichten Stand; wird bewusst nur erhöht, nie implizit
      // gesenkt.
      //
      // Optimal 15->23 (siehe Stage-15-Diagnose): zwei echte Bot-Bugs behoben.
      // (1) _pursueGoal reservierte nur die direkten Kosten des NÄCHSTEN
      // Kettenschritts, nicht die Ressourcen, an denen sein bester Erzeuger
      // selbst hängt - PRIO 5s "starte alles Leistbare" räumte Time/Wisdom
      // leer, bevor der Erzeuger je an der Reihe war, weil dutzende geerbte
      // WARTUNG-Aufgaben aus Stages 3-14 (die nie "aussterben") jede Runde
      // erneut um dieselbe knappe Time konkurrierten. (2) hardCapMs (3h) war
      // eine globale Uhr statt einer Pro-Stage-Notbremse - bei zusammen-
      // hängenden Mehrstage-Läufen lief nowMs über runStage()-Aufrufe hinweg
      // weiter, sodass spätere Stages quasi kein Budget mehr übrig hatten
      // (Stage 9-14 allein verbrauchten ~172 der 180 Minuten). Beides behoben;
      // Normal bleibt bei 11 (Stage 11: Häufung nie endender Alt-Krisen aus
      // Stages 4/8/9/10/11 erzeugt eine Mitglieder-Abwärtsspirale - sieht nach
      // einem Content-/Balancing-Thema aus, nicht nach einem Bot-Bug).
      final optimalReached = optimal.where((r) => r.reachedGoal).length;
      final normalReached = normal.where((r) => r.reachedGoal).length;
      const int minOptimalStages = 23;
      const int minNormalStages = 11;

      expect(optimalReached, greaterThanOrEqualTo(minOptimalStages),
          reason: "Optimal-Lauf erreicht nur $optimalReached Stages (erwartet mind. "
              "$minOptimalStages) - Regression?\n${failures.join("\n")}");
      expect(normalReached, greaterThanOrEqualTo(minNormalStages),
          reason: "Normal-Lauf erreicht nur $normalReached Stages (erwartet mind. "
              "$minNormalStages) - Regression?\n${failures.join("\n")}");
    });
  });
}

/// Ergebnis einer einzelnen Stage innerhalb eines durchgängigen Laufs -
/// Zeit/Klicks als DELTA seit Betreten der Stage, nicht kumulativ.
class _StageDelta {
  final bool reachedGoal;
  final double durationMs;
  final int clicks;
  final double finalMember;
  final String? deadlockReason;

  _StageDelta({
    required this.reachedGoal,
    required this.durationMs,
    required this.clicks,
    required this.finalMember,
    this.deadlockReason,
  });

  @override
  String toString() {
    final min = (durationMs / 60000).toStringAsFixed(1);
    return reachedGoal
        ? "OK: $clicks Klicks, $min virt. Min, Member=${finalMember.toStringAsFixed(1)}"
        : "DEADLOCK nach $clicks Klicks / $min virt. Min: $deadlockReason";
  }
}

/// Spielt einen kompletten, zusammenhängenden Durchlauf von Stage 0 bis zur
/// letzten Stage (oder bis zum ersten echten Deadlock) und gibt die
/// Pro-Stage-Deltas zurück. Bricht bei einem Deadlock ab, weil eine spätere
/// Stage ohne den Fortschritt der vorherigen ohnehin nicht aussagekräftig
/// getestet werden kann.
List<_StageDelta> _runContinuousPlaythrough({
  required bool includeRandomEvents,
  required Random? random,
}) {
  Game.mInstance = null;
  final game = Game.getInstance();
  game.isLoading = true;
  Game.tasks.clear();
  game.completedOnceTasks.clear();
  game.initRes(); // echter Spielstart: Faith 100, Money 20, Time 24, Member 2, Wisdom 10, Member.max 20

  final sim = GameSimulator(game, random: random);
  final policy = SmartPolicy(handleCrises: includeRandomEvents);
  final thresholds = levels.keys.toList();

  final results = <_StageDelta>[];
  double prevMs = 0;
  int prevClicks = 0;

  for (int stageIndex = 0; stageIndex < allStages.length; stageIndex++) {
    final stage = allStages[stageIndex];
    game.allTasks = stage.allTasks;

    final result = sim.runStage(
      stageIndex: stageIndex,
      activeTaskNames: stage.activeTasks,
      randomTaskNames: stage.randomTasks,
      memberThreshold: thresholds[stageIndex].toDouble(),
      decide: policy.call,
      includeRandomEvents: includeRandomEvents,
    );

    results.add(_StageDelta(
      reachedGoal: result.reachedGoal,
      durationMs: result.durationMs - prevMs,
      clicks: result.clicks - prevClicks,
      finalMember: result.finalMember,
      deadlockReason: result.deadlockReason,
    ));
    prevMs = result.durationMs;
    prevClicks = result.clicks;

    if (!result.reachedGoal) break; // spätere Stages ohne diesen Fortschritt nicht aussagekräftig
  }

  return results;
}
