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

import 'sim/game_simulator.dart';
import 'sim/sim_policies.dart';

/// Goal-directed Balancing-Simulator (siehe Issue #80).
///
/// Simuliert pro Stage ZWEI Läufe:
/// - "Normal": realistische Heuristik-Prioritäten + echte Zufalls-Krisen
///   (geseedet für Reproduzierbarkeit).
/// - "Optimal": zielgerichtete Rückwärtssuche zum Gatekeeper, deterministisch,
///   OHNE Zufallskrisen (reiner Speedrun-Bestfall als fester Vergleichspunkt).
///
/// Liefert pro Stage: Klicks und virtuelle Spieldauer für beide Läufe - die
/// Rohdaten für die Balancing-Kurve aus Issue #80 ("jede Stage soll spürbar
/// länger/komplexer werden, ohne zu überfordern").
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('🎯 Goal-directed Balancing-Simulator', () {
    late Game game;

    setUp(() {
      Game.mInstance = null;
      game = Game.getInstance();
      game.isLoading = true;
      Game.tasks.clear();
      game.completedOnceTasks.clear();
    });

    test('Normal- und Optimal-Lauf pro Stage', () {
      final thresholds = levels.keys.toList();
      final report = StringBuffer();
      final failures = <String>[];

      for (int stageIndex = 0; stageIndex < allStages.length; stageIndex++) {
        final stage = allStages[stageIndex];
        final threshold = thresholds[stageIndex].toDouble();

        // --- OPTIMAL: frischer Zustand, deterministisch, kein Zufall ---
        Game.mInstance = null;
        game = Game.getInstance();
        game.isLoading = true;
        Game.tasks.clear();
        game.completedOnceTasks.clear();
        _seedResourcesForStage(stageIndex, thresholds);

        final optimalSim = GameSimulator(game);
        // Kumulativ wie Game.jumpToStage(): Tasks aus FRÜHEREN Stages (z.B.
        // "Vom Burnout erholen" ab Stage 2) bleiben in echten Spielverläufen
        // aktiv, weil Game.tasks nie zwischen Stufen geleert wird - nur beim
        // isolierten Pro-Stage-Test hier muss das manuell nachgebildet werden.
        for (int i = 0; i < stageIndex; i++) {
          game.allTasks = allStages[i].allTasks;
          optimalSim.seedActiveTasks(allStages[i].activeTasks);
        }
        game.allTasks = stage.allTasks;
        final optimalPolicy = OptimalPolicy();
        final optimalResult = optimalSim.runStage(
          stageIndex: stageIndex,
          activeTaskNames: stage.activeTasks,
          randomTaskNames: stage.randomTasks,
          memberThreshold: threshold,
          decide: optimalPolicy.call,
          includeRandomEvents: false,
        );

        // --- NORMAL: frischer Zustand, geseedeter Zufall ---
        Game.mInstance = null;
        game = Game.getInstance();
        game.isLoading = true;
        Game.tasks.clear();
        game.completedOnceTasks.clear();
        _seedResourcesForStage(stageIndex, thresholds);

        final normalSim = GameSimulator(game, random: Random(42));
        for (int i = 0; i < stageIndex; i++) {
          game.allTasks = allStages[i].allTasks;
          normalSim.seedActiveTasks(allStages[i].activeTasks);
        }
        game.allTasks = stage.allTasks;
        final normalPolicy = NormalPolicy();
        final normalResult = normalSim.runStage(
          stageIndex: stageIndex,
          activeTaskNames: stage.activeTasks,
          randomTaskNames: stage.randomTasks,
          memberThreshold: threshold,
          decide: normalPolicy.call,
          includeRandomEvents: true,
        );

        final line = "Stage $stageIndex (${stage.description}): "
            "Optimal=[$optimalResult]  Normal=[$normalResult]";
        report.writeln(line);
        // ignore: avoid_print
        print(line);

        if (!optimalResult.reachedGoal) {
          failures.add("Stage $stageIndex OPTIMAL: ${optimalResult.deadlockReason}");
        }
        if (!normalResult.reachedGoal) {
          failures.add("Stage $stageIndex NORMAL: ${normalResult.deadlockReason}");
        }
      }

      // ignore: avoid_print
      print("\n=== ZUSAMMENFASSUNG ===\n$report");

      expect(failures, isEmpty, reason: failures.join("\n"));
    });
  });
}

/// Startet eine Stage mit realistischen Ressourcenwerten, statt bei 0
/// anzufangen - entspricht dem Zustand direkt nach dem Aufstieg aus der
/// Vorstufe (Mitglieder knapp über der vorherigen Schwelle, Grundausstattung
/// an Zeit/Glaube/Geld wie beim Spielstart).
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
