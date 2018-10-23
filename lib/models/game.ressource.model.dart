import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:save_the_world_flutter_app/data_manager.dart';
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
  static ChangeNotifier stagenNotifier;
  static Game mInstance;
  List<Task> allTasks;
  TickerFuture ticker;
  Duration saveDuration;
  DataManager dataManager;
  int stage;

  Game({List<Task> tasksList, List<Task> allTasksList, this.stage}) {
    dataManager = new DataManager();
    notifier = new ChangeNotifier();
    stagenNotifier = new ChangeNotifier();
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
    saveDuration = new Duration(seconds: 10);
    tick.createTicker(updateGame).start();
    loadState();
    ressources[Member().name].addListener(levelListener);
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

  void addTask(Task task, {bool needInit = true}) {
    //TODO: Maby check if the task is already running? bevore removing?
    if (needInit)
      tasks.remove(task);
    tasks.insert(0, task);
    if (needInit)
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

  addStageListener(VoidCallback listener) {
    stagenNotifier.addListener(listener);
  }

  List<Task> availableTasks() {
    return allTasks;
  }

  saveState() {
    print("saveState");
    List<String> activeTasks = new List<String>();
    int tLength = tasks.length;
    for (int i = 0; i < tLength; i++) {
      activeTasks.add(tasks[i].name);
    }
    dataManager.writeJson("gameRes", json.encode(ressources));
    dataManager.writeJson("activeTasks", json.encode(activeTasks));
    dataManager.writeJson("allTasks", json.encode(allTasks));
  }

  loadState() {
    print("loadState");
    dataManager.readData("gameRes").then(loadRes);
    dataManager.readData("allTasks").then(loadAllTasks);
  }

  loadRes(String jsn) {
    if (jsn != null) {
      print("loadRes" + jsn);
      Map<String, dynamic> resMap = json.decode(jsn);
      List<String> ressourceNames = ressources.keys.toList();
      int rLength = ressourceNames.length;
      for (int i = 0; i < rLength; i++) {
        ressources[ressourceNames[i]].setValue(
            resMap[ressourceNames[i]]['value']);
      }
    }
  }

  loadAllTasks(String jsn) {
    if (jsn != null) {
      print("loadAllTasks" + jsn);
      final parsed = json.decode(jsn).cast<Map<String, dynamic>>();
      List<Task> tmpList = parsed.map<Task>((tmpJson) => Task.fromJson(tmpJson))
          .toList();
      print("allTasks loaded");
      if (tmpList != null)
        allTasks = tmpList;
      print("now we should read all active Tasks");
      dataManager.readData("activeTasks").then(loadActiveTasks);
    }
  }

  loadActiveTasks(String jsn) {
    if (jsn != null) {
      print("loadActiveTasks" + jsn);
      List<String>tmpList = new List<String>.from(json.decode(jsn));
      Game.tasks.removeRange(0, Game.tasks.length);
      int tmpListLenght = tmpList.length;
      Task found;
      for (int i = (tmpListLenght - 1); i >= 0; i--) {
        print("tmpList[" + i.toString() + "]=" + tmpList[i] + "\n");
        found = Game.getInstance().availableTasks().firstWhere((tsk) =>
        tsk.name == tmpList[i]);
        if (found != null)
          Game.getInstance().addTask(found, needInit: false);
      }
    }
  }

  updateGame(Duration elapse) {
    int rest = (elapse.inSeconds % saveDuration.inSeconds);
    if ((rest == 0) && (elapse.inSeconds > 0)) {
      saveState();
    }

  }

  levelListener() {
    double members = ressources[Member().name].value;
    int maxMembers = 0;
    int found;
    int levelLength = stages.length;
    List<int> levelList = stages.keys.toList();
    int i;
    for (i = 0; (i < levelLength && found == null); i++) {
      if (levelList[i].toDouble() > members) {
        found = i;
      }
      else
        maxMembers = levelList[i];
    }
    if (found != stage) {
      stage = found;
      stagenNotifier.notifyListeners();
      //TODO: load the new levelists... and publish it. maybe show a nice Animation
      print(
          "Ich bin stage: " + found.toString() + ". Das heißt ich bin eine: " +
              stages[levelList[found]]);
    }
  }

  mainView() {
    print("MainView pressed");
  }
}
