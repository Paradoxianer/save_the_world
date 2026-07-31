import 'package:save_the_world_flutter_app/models/addtask.model.dart';
import 'package:save_the_world_flutter_app/models/game.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/task.model.dart';

import 'game_simulator.dart';

/// Ressourcen ohne echte Untergrenze im Spiel (Faith: min -1e18, Wisdom: min
/// -infinity) - Ressource.canSubtract() blockiert dort nie. Ein Bot, der sich
/// blind auf canSubtract() verlässt, verschuldet sich unbegrenzt: in der
/// Stage-4-Diagnose (siehe PR-Historie) endete Wisdom bei -810, weil teure
/// Krisen ("Streit in der Gemeinde": 50 Wisdom, "Problematische
/// Lehrerschaft": 80 Wisdom) immer wieder "leistbar" blieben, obwohl schon
/// tief im Minus. Diese Karte definiert bot-interne Komfort-Untergrenzen, die
/// zusätzlich zur echten Spielregel gelten - rein für die Bot-Entscheidung,
/// ändert nichts an den echten Spielregeln.
const Map<String, double> _softFloor = {
  "Faith": 0.0,
  "Wisdom": 0.0,
  // Time braucht eine Reserve, sonst rutscht der Bot unter 8 (die
  // Schlafen-Kosten) und ist auf das quälend langsame Freizeit (+1/20s)
  // angewiesen, um sich zurückzukämpfen - siehe Stage-2-Diagnose: 15711
  // Klicks, weil der Bot wiederholt in diese Freizeit-Sackgasse lief statt
  // rechtzeitig zu schlafen. Gilt NICHT für die Survival-Tasks selbst
  // (siehe _survivalTasks) - die dürfen die Reserve unterschreiten, sie
  // FÜLLEN sie ja gerade wieder auf.
  "Time": 8.0,
};

/// Aufgaben, die Zeit auffüllen statt kosten - von der Time-Untergrenze
/// ausgenommen, sonst könnte Schlafen (kostet 8 Zeit) nie starten, sobald
/// Zeit knapp wird.
const Set<String> _survivalTasks = {"Schlafen", "Freizeit", "Vom Burnout erholen"};

bool affordableWithSoftFloor(Task t) {
  for (final c in t.cost) {
    final res = Game.ressources[c.name];
    if (res == null || !res.canSubtract(c)) return false;
    final floor = _softFloor[c.name];
    if (floor != null && !_survivalTasks.contains(t.name) && (res.value - c.value) < floor) return false;
  }
  return true;
}

/// Baut den vollständigen AddTask-Freischaltungsgraphen einer Stage:
/// taskName -> Namen der Tasks, die dieser Task per AddTask (im Erfolgsfall)
/// freischaltet. Erfasst beliebig lange Ketten (nicht nur direkte 1-Hop-
/// Freischalter), damit z.B. Stage 5s "Koordinatoren ausbilden" -> "Fasten
/// und Beten" -> "Offizier berufen" korrekt erkannt wird.
Map<String, List<String>> buildUnlockGraph(List<Task> allTasks) {
  final graph = <String, List<String>>{};
  for (final t in allTasks) {
    final targets = t.myModifier.whereType<AddTask>().map((m) => m.nameOfTask).toList();
    if (targets.isNotEmpty) graph[t.name] = targets;
  }
  return graph;
}

/// Kürzeste Kette von einem der aktuell erreichbaren Startknoten zum Ziel via
/// Vorwärts-BFS. Gibt den NÄCHSTEN Tasknamen zurück, der JETZT gestartet
/// werden muss, um die Kette Richtung Ziel zu bewegen (oder null, wenn das
/// Ziel von hier aus nicht erreichbar ist).
String? nextStepToward(String goal, Set<String> reachableNow, Map<String, List<String>> graph) {
  if (reachableNow.contains(goal)) return goal;

  final visited = <String>{};
  final queue = <List<String>>[];
  for (final start in reachableNow) {
    queue.add([start]);
    visited.add(start);
  }
  while (queue.isNotEmpty) {
    final path = queue.removeAt(0);
    final last = path.last;
    if (last == goal) return path[0];
    for (final next in graph[last] ?? const []) {
      if (visited.contains(next)) continue;
      visited.add(next);
      queue.add([...path, next]);
    }
  }
  return null;
}

/// Ressourcen, die für den aktuellen Meilenstein noch fehlen (Kosten minus
/// aktueller Bestand) - PRIO 4/5/6 dürfen diese nicht für Nebensächlichkeiten
/// verpulvern. Siehe Stage-2-Diagnose: "Saal suchen" hat kein RemoveTask,
/// bleibt also nach getaner Arbeit (schon längst "Saal mieten" freigeschaltet)
/// dauerhaft aktiv und leistbar - der naive Catch-all hat es immer wieder neu
/// gestartet und dabei 50 Money verbrannt, kurz bevor die 200 für "Saal
/// mieten" erreicht waren. Ein sinnloser Wettlauf mit dem eigentlichen Ziel.
Set<String> _reservedResourcesFor(Task? milestone) {
  if (milestone == null) return {};
  final reserved = <String>{};
  for (final c in milestone.cost) {
    final res = Game.ressources[c.name];
    if (res != null && res.value < c.value) reserved.add(c.name);
  }
  return reserved;
}

/// True, wenn t bei resName in Summe mehr zurückgibt als kostet - solche
/// Aufgaben dürfen die Reservierung ignorieren, weil sie ihr sogar helfen.
bool _netPositiveFor(Task t, String resName) {
  final costAmt = t.cost.where((c) => c.name == resName).fold(0.0, (p, c) => p + c.value);
  final awardAmt = t.award.where((a) => a.name == resName).fold(0.0, (p, a) => p + a.value);
  return awardAmt > costAmt;
}

bool _respectsReservation(Task t, Set<String> reserved) {
  if (reserved.isEmpty) return true;
  return !t.cost.any((c) => reserved.contains(c.name) && !_netPositiveFor(t, c.name));
}

/// Versucht, den nächsten Schritt Richtung Ziel zu starten. Fehlt eine
/// Kosten-Ressource, wird gezielt der beste (soft-floor-leistbare) Erzeuger
/// dieser Ressource gestartet, statt einfach abzuwarten.
void _pursueGoal(GameSimulator sim, List<Task> idle, String goalName, Map<String, List<String>> graph) {
  final reachableNow = idle.map((t) => t.name).toSet();
  final nextName = nextStepToward(goalName, reachableNow, graph);
  if (nextName == null) return;

  final matches = idle.where((t) => t.name == nextName);
  for (final t in matches) {
    if (affordableWithSoftFloor(t)) {
      sim.startTask(t);
      continue;
    }
    // Nicht leistbar: fehlende Ressourcen gezielt auffüllen statt zu warten.
    for (final cost in t.cost) {
      final res = Game.ressources[cost.name];
      final floor = _softFloor[cost.name] ?? res?.min ?? 0.0;
      if (res == null || (res.value - cost.value) < floor) {
        // NUR echte Netto-Erzeuger dieser Ressource in Frage kommen lassen -
        // sonst kann ein Task mit hohem Brutto-Award, aber noch höheren
        // eigenen Kosten (z.B. "Offiziersarbeit koordinieren": kostet 100
        // Wisdom, bringt nur 50 zurück) als "Erzeuger" gewählt werden und
        // genau die Ressource weiter auffressen, die hier aufgebaut werden
        // soll (siehe Stage-7-Diagnose: Wisdom pendelte ewig unter 500).
        final generators = idle
            .where((g) => g.award.any((a) => a.name == cost.name) && _netPositiveFor(g, cost.name))
            .toList()
          ..sort((a, b) {
            final va = a.award.firstWhere((x) => x.name == cost.name).value;
            final vb = b.award.firstWhere((x) => x.name == cost.name).value;
            return vb.compareTo(va);
          });
        for (final g in generators) {
          if (affordableWithSoftFloor(g)) {
            sim.startTask(g);
            break;
          }
        }
      }
    }
  }
}

/// Einheitliche, ressourcen- und ketten-bewusste Spielpolitik. Ersetzt die
/// alte Aufteilung "Normal" (1-Hop-Freischalter-Erkennung, blinde
/// Krisen-Bezahlung) / "Optimal" (keine Krisen-Behandlung), die beide an der
/// Stage-4/5-Diagnose scheiterten: der Bot bezahlte Krisen unabhängig von der
/// Leistbarkeit (Wisdom-Verschuldung bis -810) und erkannte mehrstufige
/// Freischaltungsketten nicht, wodurch der eigentliche Meilenstein nie
/// gestartet wurde.
///
/// Prioritäten pro Entscheidungsrunde (mehrere parallel startbare Aufgaben
/// werden auch parallel gestartet, wie zuvor):
/// 1. Überleben (Zeit) - Schlafen, sonst Freizeit/Vom Burnout erholen.
/// 2. Krisen NUR lösen, wenn wirklich leistbar (soft floor) - sonst lieber
///    den (meist einmaligen) Verpasst-Preis zahlen als sich zu verschulden.
/// 3. Meilenstein-Kette per Graph-Rückwärtssuche (beliebig viele Hops).
/// 4. Mitgliederwachstum, falls noch nicht am Limit.
/// 5. Alles andere Sinnvolle (füllt u.a. Faith/Wisdom via Bibellesen/Beten
///    wieder auf, was PRIO 2/3 in einer späteren Runde wieder leistbar macht).
class SmartPolicy {
  bool _regeneratingTime = false;
  Map<String, List<String>>? _cachedGraph;
  List<Task>? _cachedGraphFor;

  /// Behandelt Zufallskrisen wie ein "normaler" Spieler - kann für den
  /// deterministischen Speedrun-Vergleichslauf abgeschaltet werden (dort
  /// laufen wegen includeRandomEvents:false ohnehin keine Krisen).
  final bool handleCrises;

  SmartPolicy({this.handleCrises = true});

  Map<String, List<String>> _graphFor(GameSimulator sim) {
    if (!identical(_cachedGraphFor, sim.game.allTasks)) {
      _cachedGraph = buildUnlockGraph(sim.game.allTasks);
      _cachedGraphFor = sim.game.allTasks;
    }
    return _cachedGraph!;
  }

  void call(GameSimulator sim) {
    final idle = Game.tasks.where((t) => t.enabled && !sim.isRunning(t)).toList();
    if (idle.isEmpty) return;

    final time = Game.ressources["Time"]?.value ?? 0.0;
    final memberRes = Game.ressources["Member"];
    final atMemberCap = memberRes != null && memberRes.value >= memberRes.max;

    // PRIO 1: Zeit - ohne Zeit läuft nichts, auch nicht optimal.
    if (time < 8.0 || (time < 16.0 && _regeneratingTime)) {
      _regeneratingTime = true;
      bool started = false;
      for (final name in ["Schlafen", "Freizeit", "Vom Burnout erholen"]) {
        for (final t in idle.where((x) => x.name == name)) {
          if (affordableWithSoftFloor(t)) {
            sim.startTask(t);
            started = true;
          }
        }
      }
      if (started) return;
    } else {
      _regeneratingTime = false;
    }

    // PRIO 2: Meilenstein-Kette zuerst, beliebig viele Hops. WICHTIG: vor
    // den Krisen - sonst kannibalisieren wiederkehrende Krisen genau die
    // Ressource (z.B. Wisdom), die für den Meilenstein in großer Menge
    // gespart werden muss, bevor sie je die nötige Summe erreicht (siehe
    // Stage-4-Diagnose: Wisdom blieb dauerhaft nahe der Komfort-Untergrenze
    // hängen, weil Krisen sie sofort wieder abgriffen).
    final milestone =
        sim.game.allTasks.where((t) => t.isMilestone && !sim.game.completedOnceTasks.contains(t.name)).toList();
    final milestoneTask = milestone.isNotEmpty ? milestone.first : null;
    if (milestoneTask != null) {
      _pursueGoal(sim, idle, milestoneTask.name, _graphFor(sim));
    }
    final reserved = _reservedResourcesFor(milestoneTask);

    // PRIO 3: Krisen - nur lösen, wenn wirklich leistbar (die Meilenstein-
    // Verfolgung oben hat schon zugegriffen, falls die Ressource knapp war)
    // UND ohne die für den Meilenstein reservierten Ressourcen anzugreifen.
    if (handleCrises) {
      for (final t in idle.where((x) => x.timeToSolve != double.infinity)) {
        if (_respectsReservation(t, reserved) && affordableWithSoftFloor(t)) sim.startTask(t);
      }
    }

    // PRIO 4: Mitgliederwachstum, falls noch nicht am Limit.
    if (!atMemberCap) {
      final growth = idle.where((t) => t.award.any((a) => a.name == "Member")).toList()
        ..sort((a, b) {
          final ma = a.award.where((x) => x.name == "Member").fold(0.0, (p, x) => p + x.value);
          final mb = b.award.where((x) => x.name == "Member").fold(0.0, (p, x) => p + x.value);
          return mb.compareTo(ma);
        });
      for (final t in growth) {
        if (_respectsReservation(t, reserved) && affordableWithSoftFloor(t)) sim.startTask(t);
      }
    }

    // PRIO 5: alles andere Sinnvolle, damit nichts brachliegt - füllt u.a.
    // Faith/Wisdom via Bibellesen/Beten wieder auf. Respektiert dieselbe
    // Reservierung, sonst verpuffen Meilenstein-Ersparnisse hier.
    for (final t in idle) {
      if (sim.isRunning(t)) continue;
      if (_respectsReservation(t, reserved) && affordableWithSoftFloor(t)) sim.startTask(t);
    }
  }
}

/// Alte Namen bleiben als dünne Aliase erhalten, damit bestehende Aufrufer
/// (goal_directed_simulation_test.dart) unverändert bleiben können: "Normal"
/// simuliert echtes Spielerlebnis inkl. Krisen, "Optimal" ist der
/// deterministische Speedrun-Vergleichslauf ohne Krisenbehandlung (der ohne
/// includeRandomEvents:false ohnehin keine Krisen sehen sollte).
class NormalPolicy extends SmartPolicy {
  NormalPolicy() : super(handleCrises: true);
}

class OptimalPolicy extends SmartPolicy {
  OptimalPolicy() : super(handleCrises: false);
}
