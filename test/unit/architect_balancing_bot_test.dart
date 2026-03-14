import 'package:flutter_test/flutter_test.dart';
import 'package:save_the_world_flutter_app/models/task.model.dart';
import 'package:save_the_world_flutter_app/models/addtask.model.dart';
import 'package:save_the_world_flutter_app/models/removetask.model.dart';
import 'package:save_the_world_flutter_app/globals.dart';
import 'package:save_the_world_flutter_app/stages.dart';

class TaskPlan {
  final Task task;
  int count = 0;
  TaskPlan(this.task);
}

class StrategicPlanner {
  final Map<String, double> balance = {};
  final Map<String, TaskPlan> executionPlan = {};
  final List<Task> allAvailable;
  final Set<String> unlocked;

  StrategicPlanner(this.allAvailable, List<String> active) 
      : unlocked = Set.from(active) {
    // Start-Ressourcen (Durchschnittlicher Spielstart)
    balance["Time"] = 24.0;
    balance["Faith"] = 100.0;
    balance["Member"] = 2.0;
    balance["Money"] = 20.0;
    balance["Wisdom"] = 10.0;
  }

  /// Kern-Logik: Fordere eine Ressource an. Der Planner berechnet die Kette.
  void require(String res, double amount) {
    if (amount <= 0 || res == "Stage") return;

    // 1. Prüfe aktuellen Bestand
    double current = balance[res] ?? 0;
    if (current >= amount) {
      balance[res] = current - amount;
      return;
    }

    // 2. Wir brauchen Produktion
    double stillNeeded = amount - current;
    Task producer = _findBestProducer(res);
    
    // Berechne Netto-Gewinn pro Klick
    double award = producer.award.firstWhere((a) => a.name == res).value;
    double costSameRes = producer.cost.where((c) => c.name == res).fold(0.0, (p, c) => p + c.value);
    double netGain = award - costSameRes;

    if (netGain <= 0) {
      print("⚠️ SACKGASSE: '${producer.name}' ist kein Netto-Produzent für $res!");
      return;
    }

    int clicks = (stillNeeded / netGain).ceil();

    // 3. Bevor dieser Task läuft, müssen wir SEINE Kosten decken (Rekursion!)
    for (var c in producer.cost) {
      if (c.name != res) { // Verhindere Zirkelbezug bei Zeitkosten für Zeitaufgaben
        require(c.name, c.value * clicks);
      }
    }

    // 4. Task ausführen und awards verbuchen
    _execute(producer, clicks);
    
    // Den ursprünglich angeforderten Betrag vom Konto abziehen (jetzt ist genug da)
    balance[res] = (balance[res] ?? 0) - amount;
  }

  void _execute(Task t, int count) {
    // Muss der Task erst freigeschaltet werden?
    if (!unlocked.contains(t.name)) {
      _unlock(t);
    }

    // Einmalige Tasks (Milestones)
    bool isOneTime = t.isMilestone || t.myModifier.any((m) => m is RemoveTask && m.nameOfTask == t.name);
    int actualCount = isOneTime ? 1 : count;

    if (!executionPlan.containsKey(t.name)) executionPlan[t.name] = TaskPlan(t);
    executionPlan[t.name]!.count += actualCount;

    // Ressourcen auf Konto buchen
    for (var a in t.award) balance[a.name] = (balance[a.name] ?? 0) + (a.value * actualCount);
    for (var c in t.cost) balance[c.name] = (balance[c.name] ?? 0) - (c.value * actualCount);

    // Modifier anwenden (Unlocks)
    for (var m in t.myModifier) {
      if (m is AddTask) unlocked.add(m.nameOfTask);
    }
  }

  void _unlock(Task target) {
    for (var t in allAvailable) {
      if (t.myModifier.any((m) => m is AddTask && m.nameOfTask == target.name)) {
        if (!unlocked.contains(t.name)) _unlock(t);
        _execute(t, 1);
        return;
      }
    }
  }

  Task _findBestProducer(String res) {
    var candidates = allAvailable.where((t) => t.award.any((a) => a.name == res)).toList();
    
    // Priorisiere Aufgaben, die bereits freigeschaltet sind oder einfacher freizuschalten sind
    candidates.sort((a, b) {
      double getNet(Task t) => t.award.firstWhere((aw) => aw.name == res).value - t.cost.where((c) => c.name == res).fold(0.0, (p, c) => p + c.value);
      return getNet(b).compareTo(getNet(a));
    });

    return candidates.first;
  }

  void printSummary() {
    print("\n📋 STRATEGISCHER WIRTSCHAFTSPLAN:");
    int totalClicks = 0;
    double totalTimeMs = 0;

    executionPlan.forEach((name, p) {
      print("  - [${p.count} x] $name");
      totalClicks += p.count;
      totalTimeMs += p.task.duration * p.count;
    });

    print("\n📈 PERFORMANCE-STATISTIK:");
    print("  - Klicks insgesamt: $totalClicks");
    print("  - Theoretische Zeit: ${(totalTimeMs / 1000 / 60).toStringAsFixed(1)} Min");
    
    print("\n🔋 ENDBILANZ (RESERVEN):");
    balance.forEach((res, val) {
      print("  - $res: ${val >= 0 ? "🟢" : "🔴"} ${val.toStringAsFixed(1)}");
    });
  }
}

void main() {
  group('🧠 Architect Balancing Bot V6 (Economy Solver)', () {
    
    test('Analyze Optimal Strategy: Stage 0', () {
      print("\n--- 🏗️ ARCHITECT BOT V6: STRATEGIC-ANALYSIS STAGE 0 ---");
      
      final stage = allStages[0];
      final planner = StrategicPlanner(stage.allTasks, stage.activeTasks);

      // ZIEL: 20 Mitglieder erreichen
      // Wir fordern die Mitglieder an - der Planner berechnet die gesamte Kette zurück bis Schlafen/Bibellesen
      planner.require("Member", 20.0);

      // Finaler Zeit-Check (Schlafen erzwingen falls im Minus)
      if (planner.balance["Time"]! < 0) {
        planner.require("Time", -planner.balance["Time"]!);
      }

      planner.printSummary();
    });
  });
}
