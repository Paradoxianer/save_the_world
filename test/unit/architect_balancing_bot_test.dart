import 'package:flutter_test/flutter_test.dart';
import 'package:save_the_world_flutter_app/models/task.model.dart';
import 'package:save_the_world_flutter_app/models/addtask.model.dart';
import 'package:save_the_world_flutter_app/models/removetask.model.dart';
import 'package:save_the_world_flutter_app/globals.dart';
import 'package:save_the_world_flutter_app/stages.dart';

class SimState {
  double time = 24.0;
  double faith = 100.0;
  double member = 2.0;
  double money = 20.0;
  double wisdom = 10.0;
  
  Map<String, int> log = {};
  Set<String> unlocked = {};
  Set<String> exhausted = {};

  double getRes(String name) {
    if (name == "Time") return time;
    if (name == "Faith") return faith;
    if (name == "Member") return member;
    if (name == "Money") return money;
    if (name == "Wisdom") return wisdom;
    return 0;
  }

  void addRes(String name, double val) {
    if (name == "Time") time += val;
    if (name == "Faith") faith += val;
    if (name == "Member") member += val;
    if (name == "Money") money += val;
    if (name == "Wisdom") wisdom += val;
  }

  double calcValue(dynamic res) {
    double v = res.value;
    if (res.multiplierResourceName != null && res.multiplierValue != null) {
      double factor = getRes(res.multiplierResourceName!);
      v = (res.value == 0) ? (factor * res.multiplierValue!) : (res.value * factor * res.multiplierValue!);
    }
    return v;
  }
}

void main() {
  group('🧠 Architect Balancing Bot V11 (Loop-Protected Solver)', () {
    
    test('Strategic Path Simulation: Stage 0', () {
      print("\n--- 🏗️ ARCHITECT BOT V11: CYCLE-PROTECTED ANALYSIS STAGE 0 ---");
      
      final stage = allStages[0];
      final state = SimState()..unlocked.addAll(stage.activeTasks);
      const double targetMembers = 20.0;

      int totalClicks = 0;
      double totalTimeMs = 0;

      print("START: Member: ${state.member}, Time: ${state.time}, Faith: ${state.faith}");

      int safetyIter = 0;
      while (state.member < targetMembers && safetyIter < 1000) {
        safetyIter++;
        
        Task? decision = _planNextAction(state, stage.allTasks, "Member", {});

        if (decision == null) {
          print("❌ DEADLOCK: Kein Pfad zum Ziel gefunden!");
          break;
        }

        _execute(state, decision);
        totalClicks++;
        totalTimeMs += decision.duration;

        if (decision.isMilestone) {
          print("🏆 MEILENSTEIN: ${decision.name} -> Member: ${state.member.toStringAsFixed(1)}");
        }
      }

      print("\n📋 DYNAMISCHER SCHLACHTPLAN:");
      state.log.forEach((name, count) => print("  - [${count} x] $name"));

      print("\n📈 PERFORMANCE-STATISTIK:");
      print("  - Klicks insgesamt: $totalClicks");
      print("  - Theoretische Zeit: ${(totalTimeMs / 1000 / 60).toStringAsFixed(1)} Min");
      print("  - Endbilanz: Member: ${state.member.toStringAsFixed(1)}, Time: ${state.time.toStringAsFixed(1)}, Faith: ${state.faith.toStringAsFixed(1)}");

      expect(state.member, greaterThanOrEqualTo(targetMembers));
    });
  });
}

Task? _planNextAction(SimState state, List<Task> allTasks, String goalRes, Set<String> resolving) {
  // Cycle Protection
  if (resolving.contains(goalRes)) return null;
  final currentResolving = {...resolving, goalRes};

  // 1. Priorität: Notfall-Ressourcen (Time kritisch?)
  if (goalRes != "Time" && state.time < 5.0) {
    return _planNextAction(state, allTasks, "Time", currentResolving);
  }

  // 2. Verfügbare Producer suchen
  var producers = allTasks.where((t) => 
    state.unlocked.contains(t.name) && 
    !state.exhausted.contains(t.name) &&
    t.award.any((a) => a.name == goalRes)
  ).toList();

  if (producers.isNotEmpty) {
    // Sortiere nach Netto-Gewinn
    producers.sort((a, b) {
      double getNet(Task t) {
        double award = t.award.where((aw) => aw.name == goalRes).fold(0.0, (p, aw) => p + state.calcValue(aw));
        double cost = t.cost.where((c) => c.name == goalRes).fold(0.0, (p, c) => p + state.calcValue(c));
        return award - cost;
      }
      return getNet(b).compareTo(getNet(a));
    });

    for (var best in producers) {
      // Prüfe Kosten
      String? missing;
      for (var cost in best.cost) {
        if (state.getRes(cost.name) < state.calcValue(cost)) {
          missing = cost.name;
          break;
        }
      }

      if (missing == null) return best; // Kann sofort ausgeführt werden
      
      // Versuche fehlende Ressource zu lösen
      var subTask = _planNextAction(state, allTasks, missing, currentResolving);
      if (subTask != null) return subTask;
    }
  }

  // 3. Keine aktiven Producer? Suche Pfad über Unlocks
  for (var t in allTasks) {
    if (state.unlocked.contains(t.name) && !state.exhausted.contains(t.name)) {
      if (_canEventuallyHelp(t.name, goalRes, allTasks, {})) {
        // Prüfe Kosten des Unlockers
        String? missing;
        for (var cost in t.cost) {
          if (state.getRes(cost.name) < state.calcValue(cost)) {
            missing = cost.name;
            break;
          }
        }
        if (missing == null) return t;
        var subTask = _planNextAction(state, allTasks, missing, currentResolving);
        if (subTask != null) return subTask;
      }
    }
  }

  return null;
}

bool _canEventuallyHelp(String taskName, String res, List<Task> allTasks, Set<String> visited) {
  if (visited.contains(taskName)) return false;
  final nextVisited = {...visited, taskName};

  var t = allTasks.firstWhere((t) => t.name == taskName, orElse: () => Task(name: "dummy"));
  if (t.name == "dummy") return false;
  if (t.award.any((a) => a.name == res)) return true;

  for (var m in t.myModifier) {
    if (m is AddTask) {
      if (_canEventuallyHelp(m.nameOfTask, res, allTasks, nextVisited)) return true;
    }
  }
  return false;
}

void _execute(SimState state, Task t) {
  for (var c in t.cost) state.addRes(c.name, -state.calcValue(c));
  for (var a in t.award) state.addRes(a.name, state.calcValue(a));

  for (var m in t.myModifier) {
    if (m is AddTask) state.unlocked.add(m.nameOfTask);
    if (m is RemoveTask) {
      state.unlocked.remove(m.nameOfTask);
      state.exhausted.add(m.nameOfTask);
    }
  }
  if (t.isMilestone) state.exhausted.add(t.name);
  state.log[t.name] = (state.log[t.name] ?? 0) + 1;
}
