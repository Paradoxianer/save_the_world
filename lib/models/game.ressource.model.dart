import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:save_the_world_flutter_app/globals.dart';
import 'package:save_the_world_flutter_app/models/faith.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/member.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/money.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/publicity.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/ressource.model.dart';
import 'package:save_the_world_flutter_app/models/task.model.dart';
import 'package:save_the_world_flutter_app/models/time.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/wisdome.ressource.model.dart';

class Game {

  static Map<String,Ressource> ressources = new Map<String,Ressource>();
  static List<Task> tasks;
  static TestVSync tick;
  static ChangeNotifier notifier;
  static Game mInstance;
  List<Task> allTasks;
  TickerFuture ticker;
  Duration updateDuration;
  int stage;

  Game({List<Task> tasksList, List<Task> allTasksList, this.stage}) {
    notifier = new ChangeNotifier();
    tick = new TestVSync();
    if (tasks == null)
      tasks = testTasks;
    else
      tasks = tasks;
    initRes();
    if (allTasksList == null) {
      allTasks = new List<Task>();
      allTasks.addAll(testTasks);
      allTasks.addAll(onHoldTaks);
    }
    else
      allTasks = allTasksList;
    updateDuration = new Duration(seconds: 5);
    tick.createTicker(updateGame);
  }

  initRes() {
    ressources[Faith().name] = Faith(value: 100.0);
    ressources[Money().name] = Money(value: 10.0);
    ressources[Time().name] = Time(value: 24.0);
    ressources[Member().name] = Member(value: 2.0);
    ressources[Publicity().name] = Publicity(value: 1.0);
    ressources[Wisdom().name] = Wisdom(value: 10.0);
  }

  factory Game.fromJson(Map<String, dynamic> json){
    var tList = json['tasks'] as List;
    var atList = json['allTasks'] as List;
    List<Task> tksList = tList.map((i) => Task.fromJson(i)).toList();
    List<Task> aTasksList = atList.map((i) => Task.fromJson(i)).toList();
    return Game(
        tasksList: tksList,
        allTasksList: aTasksList,
        stage: json['stage']
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'tasks': json.encode(tasks),
      'alltasks': json.encode(allTasks),
      'stage': stage
    };
  }

  void addTask(Task task) {
    //TODO: Maby check if the task is already running? bevore removing?
    tasks.remove(task);
    tasks.insert(0, task);
    task.init();
    notifier.notifyListeners();
  }

  void removeTask(Task task) {
    tasks.remove(task);
    notifier.notifyListeners();
  }

  static Game getInstance() {
    if (mInstance == null) {
      mInstance = new Game();
    }
    // Return MySingleton new Instance
    return mInstance;
  }

  addListener(VoidCallback listener) {
    notifier.addListener(listener);
  }

  removeListener(VoidCallback listener) {
    notifier.removeListener(listener);
  }

  List<Task> availableTasks() {
    return allTasks;
  }

  updateGame(Duration elapse) {
  }
}
