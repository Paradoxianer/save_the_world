import 'package:save_the_world_flutter_app/models/addtask.model.dart';
import 'package:save_the_world_flutter_app/models/game.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/task.model.dart';

import 'game_simulator.dart';

/// "Normaler" Spieler: nachvollziehbare Prioritäten (Überleben > Glaube nicht
/// vernachlässigen > Wachstum > Rest), aber KEINE Ketten-Rückwärtssuche und
/// KEIN Wissen über automatisierte Ressourcenquellen. Nutzt echte
/// Nebenläufigkeit (startet pro Entscheidungsrunde mehrere Tasks, wenn
/// leistbar), im Unterschied zum alten game_simulation_test.dart-Bot.
class NormalPolicy {
  bool _regeneratingTime = false;

  void call(GameSimulator sim) {
    final idle = Game.tasks.where((t) => t.enabled && !sim.isRunning(t)).toList();
    if (idle.isEmpty) return;

    final time = Game.ressources["Time"]?.value ?? 0.0;
    final faith = Game.ressources["Faith"]?.value ?? 0.0;
    final wisdom = Game.ressources["Wisdom"]?.value ?? 0.0;
    final memberRes = Game.ressources["Member"];
    final atMemberCap = memberRes != null && memberRes.value >= memberRes.max;

    // PRIO 1: Zeit - ohne Zeit geht gar nichts mehr.
    bool sleepStarted = false;
    if (time < 8.0 || (time < 16.0 && _regeneratingTime)) {
      _regeneratingTime = true;
      final survival = idle.where((t) => t.name == "Schlafen" || t.name == "Freizeit");
      for (final t in survival) {
        if (sim.canAfford(t)) {
          sim.startTask(t);
          sleepStarted = true;
        }
      }
      // WICHTIG: Wenn Schlafen (Kosten meist 8 Zeit) selbst nicht mehr
      // leistbar ist (z.B. Time=6) und die Stage kein billiges "Freizeit"
      // als Fallback hat, darf die Entscheidung NICHT hier abbrechen -
      // sonst haengt die Simulation fuer den Rest des Laufs bei "nichts tun",
      // ohne dass GameSimulator das je als echten Deadlock erkennt (der
      // Zufalls-Roll-Timer haelt die Event-Queue kuenstlich am Leben).
      // Stattdessen faellt die Entscheidung durch zu den anderen Prioritaeten,
      // damit zumindest guenstige Aufgaben weiterlaufen und ein echter
      // Stillstand (falls es wirklich keinen Ausweg gibt) sauber als
      // Deadlock sichtbar wird statt als stiller Bremsklotz.
      if (sleepStarted) return;
    } else {
      _regeneratingTime = false;
    }

    // PRIO 2: Glauben nicht ins Bodenlose fallen lassen (Faith/Wisdom haben
    // in diesem Spiel praktisch keine untere Schranke - siehe #78-Diskussion
    // -  ein "normaler" Spieler soll das aber trotzdem im Blick behalten).
    if (faith < 40.0 || wisdom < 20.0) {
      final spiritual = idle.where((t) =>
          t.award.any((a) => (faith < 40.0 && a.name == "Faith") || (wisdom < 20.0 && a.name == "Wisdom")));
      for (final t in spiritual) {
        if (sim.canAfford(t)) sim.startTask(t);
      }
    }

    // PRIO 3: Krisen (timeToSolve-Tasks) zuerst wegarbeiten, bevor sie
    // ablaufen - ein umsichtiger Spieler ignoriert tickende Uhren nicht.
    final crises = idle.where((t) => t.timeToSolve != double.infinity);
    for (final t in crises) {
      if (sim.canAfford(t)) sim.startTask(t);
    }

    // PRIO 4: Wachstum, wenn noch nicht am Mitglieder-Limit.
    if (!atMemberCap) {
      final growth = idle.where((t) => t.award.any((a) => a.name == "Member")).toList()
        ..sort((a, b) {
          final ma = a.award.where((x) => x.name == "Member").fold(0.0, (p, x) => p + x.value);
          final mb = b.award.where((x) => x.name == "Member").fold(0.0, (p, x) => p + x.value);
          return mb.compareTo(ma);
        });
      for (final t in growth) {
        if (sim.canAfford(t)) sim.startTask(t);
      }
    }

    // PRIO 5: Freischalter für noch nicht erreichte Meilensteine anstoßen.
    final unlockers = idle.where((t) => t.myModifier.any((m) =>
        m is AddTask &&
        !sim.game.completedOnceTasks.contains(m.nameOfTask) &&
        sim.game.allTasks.any((at) => at.name == m.nameOfTask && at.isMilestone)));
    for (final t in unlockers) {
      if (sim.canAfford(t)) sim.startTask(t);
    }

    // PRIO 6: Meilenstein selbst, falls schon verfügbar und leistbar.
    final milestones = idle.where((t) => t.isMilestone && !sim.game.completedOnceTasks.contains(t.name));
    for (final t in milestones) {
      if (sim.canAfford(t)) sim.startTask(t);
    }

    // PRIO 7: irgendwas Sinnvolles tun, damit nichts brachliegt.
    for (final t in idle) {
      if (sim.isRunning(t)) continue;
      if (sim.canAfford(t)) sim.startTask(t);
    }
  }
}

/// "Optimaler" Spieler: zielgerichtete Rückwärtssuche zum aktuellen
/// Gatekeeper (Meilenstein) über den AddTask-Kettengraphen der Stage, plus
/// Erkennung passiver Automatisierung (AutoExecuteModifier) als
/// gleichwertige Mitglieder-Quelle. KEIN echter Pfad-Optimierer (kein
/// vollständiges Dijkstra über den Ressourcenzustand) - eine belastbare,
/// aber nicht mathematisch beweisbar minimale Heuristik. Läuft ohne
/// Zufallsereignisse (siehe GameSimulator.runStage(includeRandomEvents:
/// false)).
class OptimalPolicy {
  /// Wird pro Stage einmal aus stage.allTasks aufgebaut: taskName ->
  /// Namen der Tasks, die dieser Task per AddTask (im Erfolgsfall)
  /// freischaltet.
  Map<String, List<String>> _buildUnlockGraph(List<Task> allTasks) {
    final graph = <String, List<String>>{};
    for (final t in allTasks) {
      final targets = t.myModifier.whereType<AddTask>().map((m) => m.nameOfTask).toList();
      if (targets.isNotEmpty) graph[t.name] = targets;
    }
    return graph;
  }

  /// Kürzeste Kette von einem der aktuell erreichbaren Startknoten zum Ziel.
  /// Gibt den NÄCHSTEN Tasknamen auf dem Weg zurück (oder null).
  String? _nextStepToward(String goal, Set<String> reachableNow, Map<String, List<String>> graph) {
    if (reachableNow.contains(goal)) return goal;

    // Breitensuche RÜCKWÄRTS ist bei einem sehr kleinen Graphen pro Stage
    // nicht nötig - Vorwärts-BFS von jedem erreichbaren Startpunkt reicht.
    final visited = <String>{};
    final queue = <List<String>>[]; // Pfade
    for (final start in reachableNow) {
      queue.add([start]);
      visited.add(start);
    }
    while (queue.isNotEmpty) {
      final path = queue.removeAt(0);
      final last = path.last;
      // path[0] ist der aktuell erreichbare Startknoten selbst - das ist der
      // Task, der JETZT geklickt werden muss, um die Kette in Richtung Ziel
      // zu bewegen. (Bug: hier stand faelschlich path[1] - das ist ein Task,
      // der oft noch gar nicht aktiv ist und deshalb nie startbar war.)
      if (last == goal) return path[0];
      for (final next in graph[last] ?? const []) {
        if (visited.contains(next)) continue;
        visited.add(next);
        queue.add([...path, next]);
      }
    }
    return null;
  }

  void call(GameSimulator sim) {
    final idle = Game.tasks.where((t) => t.enabled && !sim.isRunning(t)).toList();
    if (idle.isEmpty) return;

    final time = Game.ressources["Time"]?.value ?? 0.0;

    // PRIO 1: Zeit - ohne Zeit läuft nichts, auch nicht optimal.
    if (time < 8.0) {
      final sleep = idle.where((t) => t.name == "Schlafen");
      for (final t in sleep) {
        if (sim.canAfford(t)) sim.startTask(t);
      }
      if (sleep.isNotEmpty) return;
    }

    final milestone = sim.game.allTasks
        .where((t) => t.isMilestone && !sim.game.completedOnceTasks.contains(t.name))
        .toList();

    if (milestone.isEmpty) {
      // Meilenstein dieser Stage schon erledigt (z.B. durch Automatisierung
      // laengst unterwegs zum Ziel) - nur noch Zeit/Ressourcen im Blick
      // behalten und ansonsten abwarten, bis das Ziel erreicht ist.
      _maintainOnly(sim, idle);
      return;
    }

    final graph = _buildUnlockGraph(sim.game.allTasks);
    final reachableNow = idle.map((t) => t.name).toSet();
    final nextName = _nextStepToward(milestone.first.name, reachableNow, graph);

    if (nextName != null) {
      final next = idle.where((t) => t.name == nextName);
      for (final t in next) {
        if (sim.canAfford(t)) {
          sim.startTask(t);
          return;
        }
        // Nicht leistbar: fehlende Ressourcen gezielt auffüllen.
        for (final cost in t.cost) {
          if (!(Game.ressources[cost.name]?.canSubtract(cost) ?? false)) {
            final generators = idle.where((g) => g.award.any((a) => a.name == cost.name)).toList()
              ..sort((a, b) {
                final va = a.award.firstWhere((x) => x.name == cost.name).value;
                final vb = b.award.firstWhere((x) => x.name == cost.name).value;
                return vb.compareTo(va);
              });
            for (final g in generators) {
              if (sim.canAfford(g)) {
                sim.startTask(g);
                break;
              }
            }
          }
        }
      }
    }

    _maintainOnly(sim, idle, skipIfBusy: true);
  }

  void _maintainOnly(GameSimulator sim, List<Task> idle, {bool skipIfBusy = false}) {
    if (skipIfBusy && sim.runningTaskNames.isNotEmpty) return;

    final time = Game.ressources["Time"]?.value ?? 0.0;
    if (time < 16.0) {
      final sleep = idle.where((t) => t.name == "Schlafen");
      for (final t in sleep) {
        if (sim.canAfford(t)) sim.startTask(t);
      }
    }

    final memberRes = Game.ressources["Member"];
    final atCap = memberRes != null && memberRes.value >= memberRes.max;
    if (!atCap) {
      final growth = idle.where((t) => t.award.any((a) => a.name == "Member")).toList()
        ..sort((a, b) {
          final ma = a.award.where((x) => x.name == "Member").fold(0.0, (p, x) => p + x.value);
          final mb = b.award.where((x) => x.name == "Member").fold(0.0, (p, x) => p + x.value);
          return mb.compareTo(ma);
        });
      for (final t in growth) {
        if (sim.canAfford(t)) {
          sim.startTask(t);
          return;
        }
      }
    }
  }
}
