import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:save_the_world_flutter_app/models/game.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/gameelement.model.dart';
import 'package:save_the_world_flutter_app/models/modifier.model.dart';
import 'package:save_the_world_flutter_app/models/ressource.model.dart';

class Task extends GameElement {
  double duration;
  double timeToSolve = double.infinity;

  List<Ressource> cost;
  List<Ressource> award;
  List<Modifier> missed;

  AnimationController controller;

  Task({String name, String description, this.cost, this.award, this.duration = 5000.0, this.timeToSolve = double
      .infinity, List<Modifier> modifier, List<
      Modifier> missed, double controllerValue, String controllerStatus})
      :
        super(name: name, description: description, myModifier: modifier) {
    if (myModifier == null) {
      myModifier = new List<Modifier>();
    }
    this.missed = missed;
    if (controller == null) {
      controller = new AnimationController(
          duration: Duration(milliseconds: duration.toInt()),
          vsync: Game.tick
      );
    }
    if (controllerValue != null)
      controller.value = controllerValue;
    init();
    if (controllerStatus != null) {
      switch (controllerStatus) {
        case "AnimationStatus.forward":
          controller.forward();
          break;
        case "AnimationStatus.reverse":
          controller.reverse();
          break;
        case "AnimationStatus.dismissed":
          controller.reset();
          break;
        case "AnimationStatus.completed":
          break;
      }
    }
  }

  factory Task.fromJson(Map<String, dynamic> jsn){
    print("Task.fromJson " + jsn.toString());
    List<Ressource> costList;
    List<Ressource> awardList;
    List<Modifier> missedList;
    List<Modifier> modifierList;
    if (jsn['cost'] != null) {
      var cList = json.decode(jsn['cost']) as List;
      costList = cList.map((i) => Ressource.fromJson(i)).toList();
    }
    if (jsn['award'] != null) {
      var aList = json.decode(jsn['award']) as List;
      awardList = aList.map((i) => Ressource.fromJson(i)).toList();
    }
    if (jsn['missed'] != null) {
      var miList = json.decode(jsn['missed']) as List;
      missedList = miList.map((i) => Modifier.fromJson(i)).toList();
    }
    if (jsn['modifier'] != null) {
      var moList = json.decode(jsn['modifier']) as List;
      modifierList = moList.map((i) => Modifier.fromJson(i)).toList();
    }
    return Task(
        name: jsn['name'],
        description: jsn['description'],
        cost: costList,
        award: awardList,
        duration: jsn['duration'],
        timeToSolve: jsn['timeToSolve'],
        modifier: modifierList,
        missed: missedList,
        controllerStatus: jsn['controllerStatus'],
        controllerValue: json.decode(jsn['controllerValue'])
    );
  }

  Map<String, dynamic> toJson() {
    String cStatus;
    double cValue;
    if (controller != null) {
      cStatus = controller.status.toString();
      cValue = controller.value;
    }

    return <String, dynamic>{
      'name': name,
      'description': description,
      'cost': json.encode(cost),
      'award': json.encode(award),
      'missed': json.encode(missed),
      'modifier': json.encode(myModifier),
      'controllerStatus': json.encode(cStatus),
      'controllerValue': json.encode(cValue)
    };
  }

  void init() {
    int timeDuration;
    if (timeToSolve != double.infinity)
      timeDuration = timeToSolve.toInt();
    else
      timeDuration = duration.toInt();
    controller.duration = Duration(milliseconds: timeDuration);
    controller.reset();
    if (timeToSolve != double.infinity) {
      controller.reverse(from: 0.99).whenComplete(miss);
    }
  }

  void miss() {
    if (missed != null) {
      int listSize = missed.length;
      for (int i = 0; i < listSize; i++) {
        missed[i].modify();
      }
    }
  }

  start() {
    if (controller.status != AnimationStatus.forward) {
      controller.stop(canceled: true);
      //we need to set the new duration
      controller.reset();
      controller.duration = new Duration(milliseconds: duration.toInt());
      if (cost != null) {
        int listSize = cost.length;
        for (int i = 0; i < listSize; i++) {
          Game.ressources[cost[i].name].subtract(cost[i]);
        }
      }
      controller.forward().whenComplete(finished);
    }
  }

  stop() {
    controller.stop(canceled: true);
  }

  finished() {
    if (award != null) {
      int listSize = award.length;
      for (int i = 0; i < listSize; i++) {
        Game.ressources[award[i].name].add(award[i]);
      }
    }
    modify();
    controller.reset();
  }


}