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
    List<Modifier>? modifier,
    this.missed = const [],
    this.online = const [],
    double? controllerValue,
    String? controllerStatus,
  }) : super(myModifier: modifier) {
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
    // CRITICAL: Notify UI about completion immediately BEFORE modifiers run
    // to ensure SnackBar messages are triggered without delay
    modify(); 
    
    for (var a in award) {
      Game.ressources[a.name]?.add(a);
    }
    
    controller.reset();
  }

  void goOnline() {
    for (var o in online) {
      o.modify();
    }
  }
}
