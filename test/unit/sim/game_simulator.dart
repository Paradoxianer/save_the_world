import 'dart:math';

import 'package:save_the_world_flutter_app/models/autoexecute.model.dart';
import 'package:save_the_world_flutter_app/models/game.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/modifier.model.dart';
import 'package:save_the_world_flutter_app/models/task.model.dart';

/// Ein Balancing-Simulator mit virtueller Uhr statt echtem Flutter-Ticker.
///
/// WARUM NICHT die echten Task.start()/AnimationController-Mechanik nutzen?
/// In einem reinen `test()`-Block (ohne WidgetTester.pump()) feuert der an
/// SchedulerBinding gebundene Ticker nie von selbst - deshalb rufen auch die
/// bestehenden Bots (game_simulation_test.dart) Task.finished() direkt auf.
/// Dieser Simulator geht einen Schritt weiter: er modelliert echte Dauer,
/// Krisen-Fristen (timeToSolve) und Automatisierungs-Intervalle
/// (AutoExecuteModifier) über eine eigene Ereignis-Warteschlange mit
/// virtueller Zeit, statt alles synchron/instant zu behandeln.
///
/// Wiederverwendet werden die ECHTEN Game/Task/Modifier-Objekte und ihre
/// echte modify()-Logik (AddTask, RemoveTask, SetMax, MultiplyRes, ...) -
/// nur AutoExecuteModifier wird speziell behandelt, weil es intern einen
/// echten (wall-clock-gebundenen) Timer.periodic startet, den wir hier durch
/// unsere eigene virtuelle Wiederholung ersetzen.
class GameSimulator {
  final Game game;
  final Random? random;

  double nowMs = 0.0;
  int clicks = 0;
  final List<_SimEvent> _events = [];

  /// Tasknamen, die aktuell "laufen" (Kosten schon bezahlt, Ergebnis kommt
  /// erst bei Fertigstellung) - verhindert Doppelstart desselben Tasks,
  /// analog zu `controller.status != AnimationStatus.forward`.
  final Set<String> runningTaskNames = {};

  /// Tasknamen mit bereits geplantem Miss-Event, um Doppel-Planung zu
  /// vermeiden (siehe _reconcileTimeToSolve).
  final Set<String> _missScheduledFor = {};

  /// Tasknamen, für die eine Krisen-Frist unterdrückt werden soll, weil der
  /// Task schon gestartet wurde (entspricht controller.reset() in start()).
  final Set<String> _missSuppressedFor = {};

  final List<String> log = [];
  bool deadlock = false;
  String? deadlockReason;

  GameSimulator(this.game, {this.random});

  bool isRunning(Task t) => runningTaskNames.contains(t.name);

  bool canAfford(Task t) =>
      t.cost.every((c) => Game.ressources[c.name]?.canSubtract(c) ?? false);

  /// Initiale Bestückung einer Stage - analog zu Game.initStage(), aber ohne
  /// die echte Animation/Controller-Initialisierung anzustoßen.
  void seedActiveTasks(List<String> activeTaskNames) {
    for (final name in activeTaskNames) {
      final found = game.getTask(name);
      if (found == null) continue;
      if (found.once && game.completedOnceTasks.contains(found.name)) continue;
      if (Game.tasks.any((t) => t.name == found.name)) continue;
      game.addTask(found, needInit: false);
    }
    _reconcileTimeToSolve();
  }

  /// Nach jedem Ereignis: neu hinzugekommene Tasks mit timeToSolve brauchen
  /// ein virtuelles Miss-Event, das die echte init()-Kette (Ticker-basiert)
  /// hier nie bekommen hätte.
  void _reconcileTimeToSolve() {
    for (final t in List<Task>.from(Game.tasks)) {
      if (t.timeToSolve == double.infinity) continue;
      if (_missScheduledFor.contains(t.name)) continue;
      if (_missSuppressedFor.contains(t.name)) continue;
      _missScheduledFor.add(t.name);
      _schedule(nowMs + t.timeToSolve, () => _handleMiss(t));
    }
  }

  void _schedule(double dueMs, void Function() run) {
    _events.add(_SimEvent(dueMs, run));
  }

  void startTask(Task t) {
    if (isRunning(t) || !canAfford(t)) return;
    for (final c in t.cost) {
      Game.ressources[c.name]?.subtract(c);
    }
    clicks++;
    runningTaskNames.add(t.name);
    _missSuppressedFor.add(t.name); // "in Arbeit" - Frist zaehlt nicht mehr
    _missScheduledFor.remove(t.name);
    final duration = t.duration;
    _schedule(nowMs + duration, () => _handleComplete(t));
  }

  void _handleComplete(Task t) {
    runningTaskNames.remove(t.name);
    if (!Game.tasks.contains(t)) return; // zwischenzeitlich entfernt
    if (t.once) game.markOnceCompleted(t.name);

    for (final m in t.myModifier) {
      if (m is AutoExecuteModifier) {
        _scheduleAutomation(m.modifiers, m.intervalMs.toDouble());
      } else {
        m.modify();
      }
    }
    for (final a in t.award) {
      Game.ressources[a.name]?.add(a);
    }
    if (t.once) {
      game.removeTask(t);
    }
    _reconcileTimeToSolve();
  }

  void _handleMiss(Task t) {
    _missScheduledFor.remove(t.name);
    if (_missSuppressedFor.contains(t.name)) return; // laengst gestartet
    if (!Game.tasks.contains(t)) return; // laengst anderweitig geloest
    for (final m in t.missed) {
      m.modify();
    }
    _reconcileTimeToSolve();
  }

  void _scheduleAutomation(List<Modifier> mods, double intervalMs) {
    if (intervalMs <= 0) return;
    void tick() {
      for (final m in mods) {
        m.modify();
      }
      _schedule(nowMs + intervalMs, tick);
    }

    _schedule(nowMs + intervalMs, tick);
  }

  /// Reale Zufalls-Logik aus Game.updateGame() nachgebildet, aber mit
  /// eigenem, optional geseedetem Random statt dart:math.Random() direkt -
  /// fuer reproduzierbare "normale" Laeufe. Wird fuer den "optimalen" Lauf
  /// gar nicht erst eingeplant (siehe GameSimulator.runStage).
  void _scheduleRandomRoll(List<String> randomTaskNames, int stageIndex) {
    const double randDurationMs = 10000.0;
    void roll() {
      final prob = stageIndex == 1 ? 15 : 5;
      final r = (random ?? Random()).nextInt(prob);
      if (r == 1 && randomTaskNames.isNotEmpty) {
        final pick = randomTaskNames[(random ?? Random()).nextInt(randomTaskNames.length)];
        final found = game.getTask(pick);
        if (found != null &&
            !(found.once && game.completedOnceTasks.contains(found.name)) &&
            !Game.tasks.any((t) => t.name == found.name)) {
          game.addTask(found, needInit: false);
          _reconcileTimeToSolve();
        }
      }
      _schedule(nowMs + randDurationMs, roll);
    }

    _schedule(nowMs + randDurationMs, roll);
  }

  /// Führt die Simulation für EINE Stage aus, bis das Ziel (Member-Schwelle
  /// überschritten) erreicht ist, ein Deadlock erkannt wird, oder die
  /// virtuelle Zeit-Obergrenze überschritten wird.
  ///
  /// [includeRandomEvents] steuert, ob Zufalls-Krisen mitsimuliert werden
  /// (an für den "normalen" Lauf, aus für den deterministischen "optimalen"
  /// Speedrun-Lauf).
  SimStageResult runStage({
    required int stageIndex,
    required List<String> activeTaskNames,
    required List<String> randomTaskNames,
    required double memberThreshold,
    required void Function(GameSimulator) decide,
    bool includeRandomEvents = true,
    double hardCapMs = 3 * 60 * 60 * 1000, // 3 virtuelle Stunden Notbremse
    int maxSteps = 200000,
    bool verbose = false,
  }) {
    seedActiveTasks(activeTaskNames);
    if (includeRandomEvents) {
      _scheduleRandomRoll(randomTaskNames, stageIndex);
    }

    int steps = 0;
    while (true) {
      final member = Game.ressources["Member"]?.value ?? 0;
      if (member > memberThreshold) {
        return SimStageResult(
          reachedGoal: true,
          durationMs: nowMs,
          clicks: clicks,
          finalMember: member,
        );
      }

      decide(this);

      if (_events.isEmpty) {
        deadlock = true;
        deadlockReason = "Keine offenen Ereignisse und keine startbare Aufgabe mehr - "
            "echter Stillstand bei ${_resSnapshot()}";
        break;
      }

      _events.sort((a, b) => a.dueMs.compareTo(b.dueMs));
      final ev = _events.removeAt(0);
      nowMs = ev.dueMs;
      if (verbose && steps < 150) {
        // ignore: avoid_print
        print("[$steps] t=${nowMs.toStringAsFixed(0)} running=$runningTaskNames "
            "active=${Game.tasks.map((t) => t.name).toList()} events=${_events.length} "
            "${_resSnapshot()}");
      }
      ev.run();

      steps++;
      if (steps > maxSteps) {
        deadlock = true;
        deadlockReason = "maxSteps ($maxSteps) erreicht ohne Zielerreichung - "
            "vermutlich Endlos-Automatisierung ohne echten Fortschritt.";
        break;
      }
      if (nowMs > hardCapMs) {
        deadlock = true;
        deadlockReason = "hardCapMs (${(hardCapMs / 3600000).toStringAsFixed(1)}h virtuelle Zeit) "
            "überschritten ohne Zielerreichung.";
        break;
      }
    }

    return SimStageResult(
      reachedGoal: false,
      durationMs: nowMs,
      clicks: clicks,
      finalMember: Game.ressources["Member"]?.value ?? 0,
      deadlockReason: deadlockReason,
    );
  }

  String _resSnapshot() {
    return Game.ressources.entries
        .where((e) => ["Time", "Faith", "Money", "Member", "Wisdom"].contains(e.key))
        .map((e) => "${e.key}: ${e.value.value.toStringAsFixed(1)}")
        .join(" | ");
  }
}

class _SimEvent {
  final double dueMs;
  final void Function() run;
  _SimEvent(this.dueMs, this.run);
}

class SimStageResult {
  final bool reachedGoal;
  final double durationMs;
  final int clicks;
  final double finalMember;
  final String? deadlockReason;

  SimStageResult({
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
        ? "OK: ${clicks} Klicks, ${min} virt. Min, Member=${finalMember.toStringAsFixed(1)}"
        : "DEADLOCK nach ${clicks} Klicks / ${min} virt. Min: $deadlockReason";
  }
}
