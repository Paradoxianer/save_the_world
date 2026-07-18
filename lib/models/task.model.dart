import 'dart:convert';

import 'package:flutter/material.dart';
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
      
      for (var c in cost) {
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
