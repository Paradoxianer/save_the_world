import 'package:flutter_test/flutter_test.dart';
import 'package:save_the_world_flutter_app/models/task.model.dart';
import 'package:save_the_world_flutter_app/models/addtask.model.dart';
import 'package:save_the_world_flutter_app/models/removetask.model.dart';
import 'package:save_the_world_flutter_app/globals.dart';
import 'package:save_the_world_flutter_app/stages.dart';

class GameState {
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
  group('🧠 Architect Balancing Bot V9 (Kausalitäts-Simulation)', () {
    
    test('Strategic Path Simulation: Stage 0', () {
      print("\n--- 🏗️ ARCHITECT BOT V9: KAUSAL-ANALYSE STAGE 0 ---");
      
      final stage = allStages[0];
      final state = GameState()..unlocked.addAll(stage.activeTasks);
      const double targetMembers = 20.0;

      int totalClicks = 0;
      double totalTimeMs = 0;

      print("START: Member: ${state.member}, Time: ${state.time}, Faith: ${state.faith}");

      int safetyIter = 0;
      while (state.member < targetMembers && safetyIter < 1000) {
        safetyIter++;
        
        // Strategie-Entscheidung: Welcher Task bringt uns dem Ziel näher?
        Task? decision = _planNextAction(state, stage.allTasks, "Member");

        if (decision == null) {
          print("❌ DEADLOCK: Kein Weg zum Ziel gefunden!");
          break;
        }

        // Führe den gewählten Task aus
        _execute(state, decision);
        totalClicks++;
        totalTimeMs += decision.duration;

        // Logging bei Meilensteinen oder wichtigen Fortschritten
        if (decision.isMilestone) {
          print("🏆 MEILENSTEIN: ${decision.name} -> Member: ${state.member.toStringAsFixed(1)}");
        }
      }

      print("\n📋 DYNAMISCHER SCHLACHTPLAN (Chronologisch):");
      state.log.forEach((name, count) => print("  - [${count} x] $name"));

      print("\n📈 PERFORMANCE-STATISTIK:");
      print("  - Klicks insgesamt: $totalClicks");
      print("  - Theoretische Zeit: ${(totalTimeMs / 1000 / 60).toStringAsFixed(1)} Min");
      print("  - Endbilanz: Member: ${state.member.toStringAsFixed(1)}, Time: ${state.time.toStringAsFixed(1)}, Faith: ${state.faith.toStringAsFixed(1)}");

      expect(state.member, greaterThanOrEqualTo(targetMembers));
    });
  });
}

Task? _planNextAction(GameState state, List<Task> allTasks, String goalRes) {
  // 1. Suche nach Tasks, die DIREKT das Ziel fördern
  var producers = allTasks.where((t) => 
    state.unlocked.contains(t.name) && 
    !state.exhausted.contains(t.name) &&
    t.award.any((a) => a.name == goalRes)
  ).toList();

  if (producers.isNotEmpty) {
    // Nimm den effizientesten
    producers.sort((a, b) {
      double yieldA = a.award.where((aw) => aw.name == goalRes).fold(0.0, (p, aw) => p + state.calcValue(aw));
      double yieldB = b.award.where((aw) => aw.name == goalRes).fold(0.0, (p, aw) => p + state.calcValue(aw));
      return yieldB.compareTo(yieldA);
    });

    Task best = producers.first;
    
    // Prüfe Ressourcen für diesen Task
    String? missing;
    for (var cost in best.cost) {
      if (state.getRes(cost.name) < state.calcValue(cost)) {
        missing = cost.name;
        break;
      }
    }

    if (missing == null) return best; // Alles da -> Klick!
    
    // Ressource fehlt -> Rekursiv besorgen
    return _planNextAction(state, allTasks, missing);
  }

  // 2. Wenn kein Producer verfügbar, suche nach UNLOCKERN (Modifier-Chain)
  // Wir suchen Tasks, die etwas freischalten, das uns zum goalRes führt
  for (var t in allTasks) {
    if (state.unlocked.contains(t.name) && !state.exhausted.contains(t.name)) {
      bool leadsToGoal = t.myModifier.any((m) => m is AddTask && _canEventuallyHelp(m.nameOfTask, goalRes, allTasks));
      if (leadsToGoal) {
        // Prüfe Ressourcen für den Unlocker
        String? missing;
        for (var cost in t.cost) {
          if (state.getRes(cost.name) < state.calcValue(cost)) {
            missing = cost.name;
            break;
          }
        }
        if (missing == null) return t;
        return _planNextAction(state, allTasks, missing);
      }
    }
  }

  // 3. Notfall-Check: Regeneration (wenn nichts anderes geht)
  if (state.time < 10.0) {
    return allTasks.firstWhere((t) => t.name == "Schlafen" || t.name == "baseSleep");
  }

  return null;
}

// Hilfsfunktion: Kann dieser Task (oder seine Nachfolger) jemals die Ressource liefern?
bool _canEventuallyHelp(String taskName, String res, List<Task> allTasks) {
  var t = allTasks.firstWhere((t) => t.name == taskName, orElse: () => Task(name: "dummy"));
  if (t.award.any((a) => a.name == res)) return true;
  // Rekursive Suche in den Modifiers des freigeschalteten Tasks
  return t.myModifier.any((m) => m is AddTask && _canEventuallyHelp(m.nameOfTask, res, allTasks));
}

void _execute(GameState state, Task t) {
  // Ressourcen anwenden
  for (var c in t.cost) state.addRes(c.name, -state.calcValue(c));
  for (var a in t.award) state.addRes(a.name, state.calcValue(a));

  // Modifier anwenden
  for (var m in t.myModifier) {
    if (m is AddTask) state.unlocked.add(m.nameOfTask);
    if (m is RemoveTask) {
      state.unlocked.remove(m.nameOfTask);
      state.exhausted.add(m.nameOfTask);
    }
  }
  
  // Meilensteine sind oft Einmal-Tasks
  if (t.isMilestone) state.exhausted.add(t.name);

  // Statistik führen
  state.log[t.name] = (state.log[t.name] ?? 0) + 1;
}
