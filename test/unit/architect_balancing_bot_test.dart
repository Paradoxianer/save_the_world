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
  
  Map<String, int> stageLog = {};
  Set<String> unlocked = {};
  Set<String> exhausted = {};

  void resetStageLog() {
    stageLog.clear();
  }

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
  group('🧠 Architect Balancing Bot V12 (Full Campaign Solver)', () {
    
    test('Simulate All Stages and Generate Report', () {
      final StringBuffer report = StringBuffer();
      report.writeln("# 📊 SAVE THE WORLD - BALANCING REPORT");
      report.writeln("Generiert am: ${DateTime.now()}\n");
      report.writeln("| Stage | Name | Klicks | Zeit (Min) | End-Mitglieder | Status |");
      report.writeln("|-------|------|--------|------------|----------------|--------|");

      final state = SimState();
      final List<int> thresholds = levels.keys.toList();
      double totalGameMs = 0;
      int totalGameClicks = 0;

      for (int i = 0; i < allStages.length; i++) {
        final stage = allStages[i];
        final double target = thresholds[i].toDouble();
        state.unlocked.addAll(stage.activeTasks);
        state.resetStageLog();

        int stageClicks = 0;
        double stageMs = 0;
        bool deadlock = false;

        int safety = 0;
        while (state.member < target && safety < 2000) {
          safety++;
          Task? decision = _planNextAction(state, stage.allTasks, "Member", {});

          if (decision == null) {
            deadlock = true;
            break;
          }

          _execute(state, decision);
          stageClicks++;
          stageMs += decision.duration;
        }

        totalGameClicks += stageClicks;
        totalGameMs += stageMs;

        String status = deadlock ? "❌ DEADLOCK" : (safety >= 2000 ? "⚠️ TIMEOUT" : "✅ OK");
        report.writeln("| $i | ${levels[thresholds[i]]} | $stageClicks | ${(stageMs / 1000 / 60).toStringAsFixed(1)} | ${state.member.toStringAsFixed(0)} | $status |");
        
        if (deadlock) break;
      }

      report.writeln("\n## 📈 GESAMT-STATISTIK");
      report.writeln("- **Klicks insgesamt:** $totalGameClicks");
      report.writeln("- **Theoretische Spielzeit:** ${(totalGameMs / 1000 / 60 / 60).toStringAsFixed(1)} Stunden");
      
      // Datei schreiben
      final file = File('BALANCING_REPORT.md');
      file.writeAsStringSync(report.toString());
      
      print("\n✅ Simulation abgeschlossen! Report gespeichert in: ${file.absolute.path}");
    });
  });
}

Task? _planNextAction(SimState state, List<Task> allTasks, String goalRes, Set<String> resolving) {
  if (resolving.contains(goalRes)) return null;
  final currentResolving = {...resolving, goalRes};

  if (goalRes != "Time" && state.time < 5.0) {
    return _planNextAction(state, allTasks, "Time", currentResolving);
  }

  var producers = allTasks.where((t) => 
    state.unlocked.contains(t.name) && 
    !state.exhausted.contains(t.name) &&
    t.award.any((a) => a.name == goalRes)
  ).toList();

  if (producers.isNotEmpty) {
    producers.sort((a, b) {
      double getNet(Task t) {
        double award = t.award.where((aw) => aw.name == goalRes).fold(0.0, (p, aw) => p + state.calcValue(aw));
        double cost = t.cost.where((c) => c.name == goalRes).fold(0.0, (p, c) => p + state.calcValue(c));
        return award - cost;
      }
      return getNet(b).compareTo(getNet(a));
    });

    for (var best in producers) {
      String? missing;
      for (var cost in best.cost) {
        if (state.getRes(cost.name) < state.calcValue(cost)) {
          missing = cost.name;
          break;
        }
      }
      if (missing == null) return best;
      var subTask = _planNextAction(state, allTasks, missing, currentResolving);
      if (subTask != null) return subTask;
    }
  }

  for (var t in allTasks) {
    if (state.unlocked.contains(t.name) && !state.exhausted.contains(t.name)) {
      if (_canEventuallyHelp(t.name, goalRes, allTasks, {})) {
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
  state.stageLog[t.name] = (state.stageLog[t.name] ?? 0) + 1;
}
