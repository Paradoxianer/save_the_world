import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:save_the_world_flutter_app/models/autoexecute.model.dart';
import 'package:save_the_world_flutter_app/models/game.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/gameelement.model.dart';
import 'package:save_the_world_flutter_app/models/modifier.model.dart';
import 'package:save_the_world_flutter_app/models/ressource.model.dart';

class Task extends GameElement {
  double duration;
  double timeToSolve;
  bool isMilestone;
  bool enabled; // NEW: Activation system (#54)

  /// Einmal-Aufgaben (z.B. Gatekeeper/Meilensteine) verschwinden nach dem
  /// ersten Abschluss dauerhaft: Sie entfernen sich selbst aus der aktiven
  /// Liste und werden von AddTask, Random-Events und initStage nie wieder
  /// eingeblendet. Default: true für Meilensteine, sonst false.
  bool once;

  List<Ressource> cost;
  List<Ressource> award;
  List<Modifier> missed;
  List<Modifier> online;

  /// Optionaler, thematisch passender Text für den Moment, in dem diese
  /// (wiederkehrende) Krise wegen Verjährung nicht mehr zurückkehrt (siehe
  /// Game.addTask()). Ohne eigenen Text nutzt Game einen generischen
  /// Platzhalter mit dem Tasknamen - dieses Feld erlaubt es, für einzelne
  /// Krisen später einen individuelleren Abschlusssatz zu hinterlegen.
  String? resolutionMessage;

  /// Bewusstes Opt-in pro Aufgabe UND pro Ressource (siehe
  /// SmartPolicy._respectsReservation im Bot-Simulator): diese Aufgabe darf
  /// die genannten Ressourcen verbrauchen, auch wenn sie eigentlich für den
  /// aktuellen Meilenstein reserviert sind. Bewusst pro Ressource statt
  /// pauschal pro Aufgabe: Stage 16s "Strategische Sitzung einberufen" kostet
  /// sowohl Money (400.000, das für den 2-Mio-Meilenstein geschützt bleiben
  /// MUSS, sonst reinvestiert der Bot jeden Money-Zufluss sofort wieder in
  /// neue Sitzungen, statt auf die Meilenstein-Summe zu sparen) als auch
  /// Wisdom (nur 200, das aber sonst permanent für den 5000er-Meilenstein
  /// reserviert bliebe und die Aufgabe komplett blockieren würde). Nur
  /// {"Wisdom"} hier einzutragen löst genau dieses Dilemma.
  ///
  /// NICHT automatisch aus der Verpasst-Strafe einer Krise abgeleitet (z.B.
  /// "kostet bei Verpassen Member") - ein solcher automatischer Test hat sich
  /// in der Stage-5-Diagnose als zu grob erwiesen: "Ein zwischenmenschliches
  /// Problem klären" kostet bei Verpassen ebenfalls Member, aber ihr
  /// Löse-Preis (Wisdom 30) gegen den viel kleineren Meilenstein (Wisdom 200)
  /// sollte weiterhin geschützt bleiben. Nur bei bewusst gesetzten
  /// Einzelfällen wie Stage 11s "Vereinnahmt von der Politik" (Löse-Preis
  /// Wisdom 400 vs. Verpasst-Strafe Member -100, praktisch dauerhaft aktiv)
  /// überwiegt der Schaden klar genug - das ist eine bewusste
  /// Balancing-Entscheidung pro Aufgabe, keine allgemeine Regel.
  Set<String> bypassReservationResources;

  bool get bypassReservation => bypassReservationResources.isNotEmpty;

  /// Geometrische Kostensteigerung pro bereits aktivierter Automatisierungs-
  /// Stufe (siehe AutoExecuteModifier.activationCount): effektive Kosten =
  /// cost * costGrowth^Stufe. 1.0 = keine Steigerung (Default). Idle-Game-
  /// Standard gegen unbegrenztes Stapeln: Bei "Strategische Sitzung
  /// einberufen" (Stage 16) kostete jede weitere Sitzung gleich viel und
  /// brachte gleich viel - der Grenznutzen sank nie, der Bot aktivierte sie
  /// ~130-mal pro Stage, Money/Faith inflationierten auf 10^14. Mit 1.15
  /// amortisiert sich die 20. Sitzung in ~36 statt 2,5 Minuten - ein
  /// natürliches Gleichgewicht statt einer harten Obergrenze.
  double costGrowth;

  late AnimationController controller;

  Task({
    super.name,
    super.description,
    this.cost = const [],
    this.award = const [],
    this.duration = 5000.0,
    this.timeToSolve = double.infinity,
    this.isMilestone = false,
    this.enabled = true, // Default enabled
    bool? once,
    List<Modifier>? modifier,
    this.missed = const [],
    this.online = const [],
    this.resolutionMessage,
    this.bypassReservationResources = const {},
    this.costGrowth = 1.0,
    double? controllerValue,
    String? controllerStatus,
  })  : once = once ?? isMilestone,
        super(myModifier: modifier) {
    controller = AnimationController(
      vsync: Game.tick,
      duration: Duration(milliseconds: duration.toInt()),
    );

    if (controllerValue != null) {
      controller.value = controllerValue;
    }

    if (controllerStatus != null) {
      if (controllerStatus == "AnimationStatus.forward") {
        controller.forward().whenComplete(finished);
      } else if (controllerStatus == "AnimationStatus.reverse") {
        controller.reverse().whenComplete(miss);
      }
    }

    for (var c in cost) {
      c.willAdd = false;
    }
  }

  // ECHTER FIX: Ressourcen sauber freigeben
  void dispose() {
    controller.dispose();
  }

  /// Aktuell zu zahlende Kosten inkl. costGrowth (siehe dort). Ohne
  /// Steigerung oder vor der ersten Aktivierung identisch mit [cost].
  List<Ressource> get effectiveCost {
    if (costGrowth == 1.0) return cost;
    final level = myModifier.whereType<AutoExecuteModifier>().fold<int>(0, (p, m) => max(p, m.activationCount));
    if (level == 0) return cost;
    final factor = pow(costGrowth, level).toDouble();
    return cost
        .map((c) => Ressource(
              name: c.name,
              description: c.description,
              icon: c.icon,
              value: c.value * factor,
              min: c.min,
              max: c.max,
            )..willAdd = false)
        .toList();
  }

  factory Task.fromJson(Map<String, dynamic> jsn) {
    List<Ressource> deserializeResources(dynamic data) {
      if (data == null) return [];
      final List<dynamic> list = (data is String) ? json.decode(data) : data;
      return list.map((i) => Ressource.fromJson(i as Map<String, dynamic>)).toList();
    }

    List<Modifier> deserializeModifiers(dynamic data) {
      if (data == null) return [];
      final List<dynamic> list = (data is String) ? json.decode(data) : data;
      return list.map((i) => Modifier.fromJson(i as Map<String, dynamic>)).toList();
    }

    return Task(
      name: jsn['name'] as String? ?? "Unknown",
      description: jsn['description'] as String? ?? "",
      duration: (jsn['duration'] as num?)?.toDouble() ?? 5000.0,
      timeToSolve: jsn['timeToSolve'] != null ? (double.tryParse(jsn['timeToSolve'].toString()) ?? double.infinity) : double.infinity,
      isMilestone: jsn['isMilestone'] as bool? ?? false,
      enabled: jsn['enabled'] as bool? ?? true,
      once: jsn['once'] as bool?,
      cost: deserializeResources(jsn['cost']),
      award: deserializeResources(jsn['award']),
      modifier: deserializeModifiers(jsn['modifier']),
      missed: deserializeModifiers(jsn['missed']),
      online: deserializeModifiers(jsn['online']),
      resolutionMessage: jsn['resolutionMessage'] as String?,
      bypassReservationResources: jsn['bypassReservationResources'] != null
          ? Set<String>.from(jsn['bypassReservationResources'] as List)
          : const {},
      costGrowth: (jsn['costGrowth'] as num?)?.toDouble() ?? 1.0,
      controllerStatus: jsn['controllerStatus'] != null ? json.decode(jsn['controllerStatus'].toString()) as String? : null,
      controllerValue: jsn['controllerValue'] != null ? (json.decode(jsn['controllerValue'].toString()) as num?)?.toDouble() : null,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'duration': duration,
      'timeToSolve': timeToSolve.toString(),
      'isMilestone': isMilestone,
      'enabled': enabled,
      'once': once,
      'cost': json.encode(cost),
      'award': json.encode(award),
      'missed': json.encode(missed),
      'modifier': json.encode(myModifier),
      'online': json.encode(online),
      'resolutionMessage': resolutionMessage,
      'bypassReservationResources': bypassReservationResources.toList(),
      'costGrowth': costGrowth,
      'controllerStatus': json.encode(controller.status.toString()),
      'controllerValue': json.encode(controller.value),
    };
  }

  void init() {
    int timeDuration = (timeToSolve != double.infinity) ? timeToSolve.toInt() : duration.toInt();
    controller.duration = Duration(milliseconds: timeDuration);
    controller.reset();
    if (timeToSolve != double.infinity) {
      controller.reverse(from: 0.99).whenComplete(miss);
    }
    goOnline();
  }

  void miss() {
    for (var m in missed) {
      m.modify();
    }
  }

  void start() {
    if (!enabled) return; // Logic check: Don't start if disabled

    if (controller.status != AnimationStatus.forward) {
      controller.stop();
      controller.reset();
      controller.duration = Duration(milliseconds: duration.toInt());

      for (var c in effectiveCost) {
        Game.ressources[c.name]?.subtract(c);
      }
      
      controller.forward().whenComplete(finished);
    }
  }

  void stop() {
    controller.stop();
  }

  void finished() {
    // Einmal-Aufgaben VOR den Modifiern als erledigt markieren, damit auch
    // eine Chain, die diesen Task selbst wieder hinzufügen will, blockiert wird.
    if (once) {
      Game.getInstance().markOnceCompleted(name);
    }

    modify();

    for (var a in award) {
      Game.ressources[a.name]?.add(a);
    }

    controller.reset();

    // Einmal-Aufgaben räumen sich selbst auf - kein RemoveTask-Modifier nötig.
    if (once) {
      Game.getInstance().removeTask(this);
    }
  }

  void goOnline() {
    for (var o in online) {
      o.modify();
    }
  }
}
