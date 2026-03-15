import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:save_the_world_flutter_app/models/task.model.dart';
import 'package:save_the_world_flutter_app/models/stage.model.dart';
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
  
  Map<String, int> stageTaskCounts = {};
  Map<String, int> resourcePressure = {};
  List<String> sequence = [];
  Set<String> unlocked = {};
  Set<String> exhausted = {};

  void resetForStage(Stage s) {
    stageTaskCounts.clear();
    resourcePressure.clear();
    sequence.clear();
    exhausted.clear();
    unlocked.clear();
    unlocked.addAll(s.activeTasks);
    if (time < 12.0) time = 12.0; 
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

  void logPressure(String res) {
    resourcePressure[res] = (resourcePressure[res] ?? 0) + 1;
  }

  String get fullStatusLine {
    return "Mem: ${member.toStringAsFixed(1).padLeft(6)} | "
           "Time: ${time.toStringAsFixed(1).padLeft(5)} | "
           "Faith: ${faith.toStringAsFixed(1).padLeft(6)} | "
           "Money: ${money.toStringAsFixed(1).padLeft(6)} | "
           "Wis: ${wisdom.toStringAsFixed(1).padLeft(5)} | "
           "Pub: ${publicity.toStringAsFixed(1).padLeft(5)}";
  }
}

void main() {
  group('🧠 Architect Balancing Bot V20 (Full Resource Diagnostics)', () {
    
    test('Simulate Campaign with Enhanced Logging', () {
      final StringBuffer report = StringBuffer();
      final StringBuffer debugLog = StringBuffer();
      
      report.writeln("# 📊 SAVE THE WORLD - DEEP BALANCING REPORT");
      report.writeln("Generiert am: ${DateTime.now()}\n");
      report.writeln("| Stage | Name | Klicks | Zeit (Min) | Top Engpass | Status |");
      report.writeln("|-------|------|--------|------------|-------------|--------|");

      final state = SimState();
      final List<int> thresholds = levels.keys.toList();

      for (int i = 0; i < allStages.length; i++) {
        final stage = allStages[i];
        final double target = (i < thresholds.length) ? thresholds[i].toDouble() : 7600000000.0;
        state.resetForStage(stage);
        
        debugLog.writeln("\n" + "="*110);
        debugLog.writeln(">>> START STAGE $i: ${levels[target.toInt()] ?? 'Endgame'} (Target: $target)");
        debugLog.writeln("="*110);
        debugLog.writeln(" Step | Task Name                | " + "Resources (Mem | Time | Faith | Money | Wis | Pub)");
        debugLog.writeln("-" * 110);

        int clicks = 0;
        double ms = 0;
        bool success = false;
        String finalBottleneck = "None";

        int safety = 0;
        while (state.member < target && safety < 5000) {
          safety++;
          
          Task? decision = _plan(state, stage.allTasks, "Member", {}, debugLog);

          if (decision == null) {
            finalBottleneck = "Broken Logic Chain";
            break;
          }

          String? missing;
          for (var c in decision.cost) {
            if (state.getRes(c.name) < state.calcValue(c)) { missing = c.name; break; }
          }

          if (missing != null) {
            state.logPressure(missing);
            Task? recovery = _plan(state, stage.allTasks, missing, {"Member"}, debugLog);
            if (recovery == null) {
              finalBottleneck = missing;
              break;
            }
            decision = recovery;
          }

          _execute(state, decision);
          clicks++;
          ms += decision.duration;
          state.sequence.add(decision.name);
          
          debugLog.writeln(" [${clicks.toString().padLeft(3)}] ${decision.name.padRight(25)} | ${state.fullStatusLine}");
        }

        success = state.member >= target;
        
        if (finalBottleneck == "None" && state.resourcePressure.isNotEmpty) {
          var sortedPressure = state.resourcePressure.entries.toList();
          sortedPressure.sort((a, b) => b.value.compareTo(a.value));
          finalBottleneck = sortedPressure.first.key;
        }

        report.writeln("| $i | ${levels[target.toInt()] ?? 'Endgame'} | $clicks | ${(ms / 1000 / 60).toStringAsFixed(1)} | $finalBottleneck | ${success ? '✅ OK' : '❌ FAIL'} |");
        report.writeln("\n> **Klick-Pfad Stage $i (Auszug):** ${state.sequence.take(15).join(' → ')} ...\n");

        if (!success) {
          debugLog.writeln("\n❌ STAGE $i FAILED! Last State: ${state.fullStatusLine}");
          state.member = target; state.time = 24; state.faith = 100; state.wisdom = 20; 
        } else {
          debugLog.writeln("\n✅ STAGE $i CLEARED! Final State: ${state.fullStatusLine}");
        }
      }

      File('BALANCING_REPORT.md').writeAsStringSync(report.toString());
      File('DEBUG_STRATEGY.log').writeAsStringSync(debugLog.toString());
      print("\n✅ Analyse abgeschlossen! Reports wurden aktualisiert.");
    });
  });
}

Task? _plan(SimState state, List<Task> all, String goalRes, Set<String> resolving, StringBuffer log) {
  if (resolving.contains(goalRes)) return null;
  final currentResolving = {...resolving, goalRes};

  if (goalRes != "Time" && state.time < 8.0) {
    return _plan(state, all, "Time", currentResolving, log);
  }

  var producers = all.where((t) => state.unlocked.contains(t.name) && !state.exhausted.contains(t.name) && t.award.any((a) => a.name == goalRes)).toList();
  if (producers.isNotEmpty) {
    producers.sort((a, b) {
      double net(Task t) => t.award.where((aw) => aw.name == goalRes).fold(0.0, (p, aw) => p + state.calcValue(aw)) - 
                            t.cost.where((c) => c.name == goalRes).fold(0.0, (p, c) => p + state.calcValue(c));
      return net(b).compareTo(net(a));
    });

    for (var t in producers) {
      String? missing;
      for (var c in t.cost) {
        if (state.getRes(c.name) < state.calcValue(c)) { missing = c.name; break; }
      }
      if (missing == null) return t;
      var sub = _plan(state, all, missing, currentResolving, log);
      if (sub != null) return sub;
    }
  }

  for (var t in all) {
    if (state.unlocked.contains(t.name) && !state.exhausted.contains(t.name)) {
      if (_canLeadTo(t, goalRes, all, {})) {
        String? missing;
        for (var c in t.cost) {
          if (state.getRes(c.name) < state.calcValue(c)) { missing = c.name; break; }
        }
        if (missing == null) return t;
        var sub = _plan(state, all, missing, currentResolving, log);
        if (sub != null) return sub;
      }
    }
  }

  if (goalRes == "Time") {
    return all.firstWhere((t) => t.name == "Schlafen" || t.name == "baseSleep", 
           orElse: () => all.firstWhere((t) => t.name == "Freizeit" || t.name == "baseFreeTime",
           orElse: () => all.firstWhere((t) => t.award.any((a) => a.name == "Time"), orElse: () => null)));
  }
  return null;
}

bool _canLeadTo(Task t, String res, List<Task> all, Set<String> visited) {
  if (visited.contains(t.name)) return false;
  final nextVisited = {...visited, t.name};
  if (t.award.any((a) => a.name == res)) return true;
  for (var m in t.myModifier) {
    if (m is AddTask) {
      var next = all.firstWhere((at) => at.name == m.nameOfTask, orElse: () => Task(name: "dummy"));
      if (_canLeadTo(next, res, all, nextVisited)) return true;
    }
  }
  return false;
}

void _execute(SimState state, Task t) {
  for (var c in t.cost) state.addRes(c.name, -state.calcValue(c));
  for (var a in t.award) state.addRes(a.name, state.calcValue(a));
  for (var m in t.myModifier) {
    if (m is AddTask) state.unlocked.add(m.nameOfTask);
    if (m is RemoveTask) { state.unlocked.remove(m.nameOfTask); state.exhausted.add(m.nameOfTask); }
  }
  if (t.isMilestone) state.exhausted.add(t.name);
  state.stageTaskCounts[t.name] = (state.stageTaskCounts[t.name] ?? 0) + 1;
}
