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
  List<Ressource> require;
  List<Task> missed;

  AnimationController controller;

  Task(
      {String name, String description, this.cost, this.award, this.require, this.duration = 5000.0, this.timeToSolve = double
          .infinity, List<Modifier> modifer, List<Modifier>missed = null}) :
        super(name : name, description : description, myModifier : modifer){
    if (myModifier==null){
      myModifier = new List<Modifier>();
    }
    int timeDuration;
    if (timeToSolve != double.infinity)
      timeDuration = timeToSolve.toInt();
    else
      timeDuration = duration.toInt();
    controller = new AnimationController(
        duration: Duration(milliseconds: timeDuration),
        vsync: Game.tick
    );
    //  controller.addListener(listen);
    if (timeToSolve != double.infinity) {
      controller.reverse(from: 0.99).whenComplete(miss);
    }
  }

  void miss() {
    print("ohhh was ganz schlimmes ist passiert!!!");
    if (missed != null) {
      int listSize = missed.length;
      for (int i = 0; i < listSize; i++) {
        missed[i].modify();
      }
    }
    Game.getInstance().removeTask(this);
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

  listen() {
    switch (controller.status) {
      case AnimationStatus.dismissed:
      //we need to check if its from reset or from reverse
        miss();
        break;
      case AnimationStatus.forward:
        break;
      case AnimationStatus.completed:
        finished();
        break;
      case AnimationStatus.reverse:
        break;
    }
  }
}