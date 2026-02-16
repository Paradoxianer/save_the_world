import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:save_the_world_flutter_app/models/game.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/gameelement.model.dart';
import 'package:save_the_world_flutter_app/models/modifier.model.dart';
import 'package:save_the_world_flutter_app/models/ressource.model.dart';

class Task extends GameElement {
  double duration;
  double timeToSolve;

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
    List<Modifier>? modifier,
    this.missed = const [],
    this.online = const [],
    double? controllerValue,
    String? controllerStatus,
  }) : super(myModifier: modifier) {
    controller = AnimationController(
      duration: Duration(milliseconds: duration.toInt()),
      vsync: Game.tick,
    );

    if (controllerValue != null) {
      controller.value = controllerValue;
    }

    if (controllerStatus != null) {
      if (controllerStatus == "AnimationStatus.forward") {
        controller.forward().whenComplete(finished);
      } else if (controllerStatus == "AnimationStatus.reverse") {
        controller.reverse().whenComplete(miss);
      } else if (controllerStatus == "AnimationStatus.dismissed") {
        controller.reset();
      }
    }

    for (var c in cost) {
      c.willAdd = false;
    }
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
    debugPrint("[GAME_LOG] Task '$name' initialized.");
    int timeDuration = (timeToSolve != double.infinity) ? timeToSolve.toInt() : duration.toInt();
    controller.duration = Duration(milliseconds: timeDuration);
    controller.reset();
    if (timeToSolve != double.infinity) {
      controller.reverse(from: 0.99).whenComplete(miss);
    }
    goOnline();
  }

  void miss() {
    debugPrint("[GAME_LOG] Task '$name' MISSED (Failure).");
    for (var m in missed) {
      m.modify();
    }
  }

  void start() {
    if (controller.status != AnimationStatus.forward) {
      debugPrint("[GAME_LOG] Task '$name' STARTED (Duration: ${duration}ms).");
      controller.stop();
      controller.reset();
      controller.duration = Duration(milliseconds: duration.toInt());
      
      for (var c in cost) {
        debugPrint("[GAME_LOG] Task '$name' consuming cost: ${c.name} (${c.value}).");
        Game.ressources[c.name]?.subtract(c);
      }
      
      controller.forward().whenComplete(finished);
    }
  }

  void stop() {
    debugPrint("[GAME_LOG] Task '$name' STOPPED manually.");
    controller.stop();
  }

  void finished() {
    debugPrint("[GAME_LOG] Task '$name' FINISHED successfully.");
    
    // Lift limits first
    modify();
    
    for (var a in award) {
      debugPrint("[GAME_LOG] Task '$name' awarding: ${a.name} (+${a.value}).");
      Game.ressources[a.name]?.add(a);
    }

    controller.reset();
  }

  void goOnline() {
    for (var o in online) {
      o.modify();
    }
  }

  @override
  String toString() {
    return 'Task{name: $name, description: $description, duration: $duration, timeToSolve: $timeToSolve}';
  }
}
