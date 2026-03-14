import 'dart:io';
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
  double publicity = 1.0;
  
  Map<String, int> stageStats = {};
  List<String> currentSequence = [];
  Set<String> unlocked = {};
  Set<String> exhausted = {};

  void resetForStage(Stage s) {
    stageStats.clear();
    currentSequence.clear();
    exhausted.clear();
    unlocked.clear();
    unlocked.addAll(s.activeTasks);
    if (time < 12.0) time = 12.0; // Survival-Buffer
  }

  double getRes(String name) {
    switch(name) {
      case "Time": return time;
      case "Faith": return faith;
      case "Member": return member;
      case "Money": return money;
      case "Wisdom": return wisdom;
      case "Publicity": return publicity;
      default: return 0;
    }
  }

  void addRes(String name, double val) {
    if (name == "Time") time += val;
    else if (name == "Faith") faith += val;
    else if (name == "Member") member += val;
    else if (name == "Money") money += val;
    else if (name == "Wisdom") wisdom += val;
    else if (name == "Publicity") publicity += val;
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
  group('🧠 Architect Balancing Bot V17 (Dynamic Path Solver)', () {
    
    test('Simulate Full Campaign and Log Sequences', () {
      final StringBuffer report = StringBuffer();
      final StringBuffer debugLog = StringBuffer();
      
      report.writeln("# 📊 SAVE THE WORLD - DEEP BALANCING REPORT");
      report.writeln("Generiert am: ${DateTime.now()}\n");
      report.writeln("| Stage | Name | Klicks | Zeit (Min) | Haupt-Engpass | Status |");
      report.writeln("|-------|------|--------|------------|---------------|--------|");

      final state = SimState();
      final List<int> thresholds = levels.keys.toList();

      for (int i = 0; i < allStages.length; i++) {
        final stage = allStages[i];
        final double target = (i < thresholds.length) ? thresholds[i].toDouble() : 7600000000.0;
        state.resetForStage(stage);
        
        debugLog.writeln("\n>>> ANALYSE STAGE $i: ${levels[target.toInt()] ?? 'Endgame'} (Ziel: $target Members)");

        int clicks = 0;
        double ms = 0;
        String bottleneck = "None";
        bool success = false;

        int safety = 0;
        while (state.member < target && safety < 5000) {
          safety++;
          
          // Intelligenz-Kern: Was ist die beste Aktion JETZT?
          Task? decision = _findOptimalNextStep(state, stage.allTasks, "Member", {});

          if (decision == null) {
            bottleneck = "No Logical Path";
            break;
          }

          // Ressourcen-Check vor Ausführung
          String? missing;
          for (var c in decision.cost) {
            if (state.getRes(c.name) < state.calcValue(c)) { missing = c.name; break; }
          }

          if (missing != null) {
            bottleneck = missing;
            // Rekursiv die fehlende Ressource priorisieren
            Task? recovery = _findOptimalNextStep(state, stage.allTasks, missing, {"Member"});
            if (recovery == null) break;
            decision = recovery;
          }

          _execute(state, decision);
          clicks++;
          ms += decision.duration;
          state.currentSequence.add(decision.name);
          
          if (clicks <= 50) {
            debugLog.writeln("  [$clicks] ${decision.name.padRight(20)} | Mem: ${state.member.toStringAsFixed(1)} | Time: ${state.time.toStringAsFixed(1)} | Faith: ${state.faith.toStringAsFixed(1)}");
          }
        }

        success = state.member >= target;
        String status = success ? "✅ OK" : (safety >= 5000 ? "⚠️ TIMEOUT" : "❌ DEADLOCK");
        report.writeln("| $i | ${levels[target.toInt()] ?? 'Endgame'} | $clicks | ${(ms / 1000 / 60).toStringAsFixed(1)} | $bottleneck | $status |");
        
        if (!success) {
          debugLog.writeln("❌ STAGE $i FAILED! Bottleneck: $bottleneck");
          state.member = target; state.time = 24; state.faith = 100; state.wisdom = 20; // Recovery für nächsten Test
        }

        report.writeln("\n> **Klick-Pfad Stage $i (Auszug):** ${state.currentSequence.take(20).join(' → ')} ...\n");
      }

      File('BALANCING_REPORT.md').writeAsStringSync(report.toString());
      File('DEBUG_STRATEGY.log').writeAsStringSync(debugLog.toString());
      print("\n✅ Analyse abgeschlossen! Report: BALANCING_REPORT.md | Log: DEBUG_STRATEGY.log");
    });
  });
}

Task? _findOptimalNextStep(SimState state, List<Task> allTasks, String goalRes, Set<String> resolving) {
  if (resolving.contains(goalRes)) return null; // Cycle Protection
  final currentResolving = {...resolving, goalRes};

  // 1. Notfall: Zeit kritisch? (Unter 8h immer Schlafen/Freizeit suchen)
  if (goalRes != "Time" && state.time < 8.0) {
    var rec = _findOptimalNextStep(state, allTasks, "Time", currentResolving);
    if (rec != null) return rec;
  }

  // 2. Verfügbare Producer für das aktuelle Ziel suchen
  var producers = allTasks.where((t) => 
    state.unlocked.contains(t.name) && !state.exhausted.contains(t.name) && t.award.any((a) => a.name == goalRes)
  ).toList();

  if (producers.isNotEmpty) {
    // Sortiere nach Netto-Gewinn
    producers.sort((a, b) {
      double net(Task t) => t.award.where((aw) => aw.name == goalRes).fold(0.0, (p, aw) => p + state.calcValue(aw)) - 
                            t.cost.where((c) => c.name == goalRes).fold(0.0, (p, c) => p + state.calcValue(c));
      return net(b).compareTo(net(a));
    });

    for (var best in producers) {
      String? missing;
      for (var cost in best.cost) {
        if (state.getRes(cost.name) < state.calcValue(cost)) { missing = cost.name; break; }
      }
      if (missing == null) return best; // Sofort ausführbar!
      
      // Ressource fehlt -> Suche Unter-Lösung
      var sub = _findOptimalNextStep(state, allTasks, missing, currentResolving);
      if (sub != null) return sub;
    }
  }

  // 3. Kein Producer aktiv? Suche nach UNLOCKERN (Pfadsuche zum Ziel)
  for (var t in allTasks) {
    if (state.unlocked.contains(t.name) && !state.exhausted.contains(t.name)) {
      if (_canEventuallyUnlock(t, goalRes, allTasks, {})) {
        String? missing;
        for (var c in t.cost) {
          if (state.getRes(c.name) < state.calcValue(c)) { missing = c.name; break; }
        }
        if (missing == null) return t; // Unlocker ausführbar
        var sub = _findOptimalNextStep(state, allTasks, missing, currentResolving);
        if (sub != null) return sub;
      }
    }
  }

  // 4. Ultima Ratio: Zeit-Regeneration wenn Zeit das Ziel ist
  if (goalRes == "Time") {
    return allTasks.firstWhere((t) => t.name == "Schlafen" || t.name == "baseSleep", 
           orElse: () => allTasks.firstWhere((t) => t.name == "Freizeit" || t.name == "baseFreeTime",
           orElse: () => allTasks.firstWhere((t) => t.award.any((a) => a.name == "Time"))));
  }

  return null;
}

bool _canEventuallyUnlock(Task t, String res, List<Task> allTasks, Set<String> visited) {
  if (visited.contains(t.name)) return false;
  final nextVisited = {...visited, t.name};
  if (t.award.any((a) => a.name == res)) return true;
  for (var m in t.myModifier) {
    if (m is AddTask) {
      var next = allTasks.firstWhere((at) => at.name == m.nameOfTask, orElse: () => Task(name: "dummy"));
      if (_canEventuallyUnlock(next, res, allTasks, nextVisited)) return true;
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
  state.stageStats[t.name] = (state.stageStats[t.name] ?? 0) + 1;
}
