import 'dart:convert';
import 'dart:math';

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
import 'package:save_the_world_flutter_app/stages.dart';

class Game {
  static Map<String, Ressource> ressources = new Map<String, Ressource>();
  static List<Task> tasks;
  static TestVSync tick;
  static ChangeNotifier notifier;
  static ChangeNotifier stagenNotifier;
  static Game mInstance;
  List<Task> allTasks;
  List<String> randomTasks;
  TickerFuture ticker;
  Duration saveCalled;
  Duration saveDuration;
  Duration randDuration;
  Duration randCalled;
  DataManager dataManager;
  int stage;

  Game({List<Task> tasksList, List<Task> allTasksList, this.stage}) {
    if (stage == null) stage = 0;
    print(stage);
    dataManager = new DataManager();
    notifier = new ChangeNotifier();
    stagenNotifier = new ChangeNotifier();
    tick = new TestVSync();
    if (tasks == null) tasks = new List<Task>();
    initRes();
    allTasks = allStages[stage].allTasks;
    saveDuration = new Duration(seconds: 5);
    saveCalled = new Duration(seconds: 0);
    randDuration = new Duration(seconds: 10);
    randCalled = new Duration(seconds: 0);
    tick.createTicker(updateGame).start();
    initStage(stage);
    initRes();
    ressources[Member().name].addListener(levelListener);
    loadState();
  }

  initRes() {
    ressources[Faith().name] = Faith(value: 100.0);
    ressources[Money().name] = Money(value: 20.0);
    ressources[Time().name] = Time(value: 24.0);
    ressources[Member().name] = Member(value: 2.0);
    ressources[Publicity().name] = Publicity(value: 1.0);
    ressources[Wisdom().name] = Wisdom(value: 10.0);
    ressources[Member().name].max = 20.0;
    ressources[Member().name].min = 2.0;
  }

  factory Game.fromJson(Map<String, dynamic> json) {
    var tList = json['tasks'] as List;
    var atList = json['allTasks'] as List;
    List<Task> tksList = tList.map((i) => Task.fromJson(i)).toList();
    List<Task> aTasksList = atList.map((i) => Task.fromJson(i)).toList();
    return Game(
        tasksList: tksList, allTasksList: aTasksList, stage: json['stage']);
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'tasks': json.encode(tasks),
      'alltasks': json.encode(allTasks),
      'stage': stage
    };
  }

  void addTask(Task task, {bool needInit = true}) {
    if (needInit) tasks.remove(task);
    tasks.insert(0, task);
    if (needInit) task.init();
    notifier.notifyListeners();
    task.goOnline();
  }

  void removeTask(Task task) {
    tasks.remove(task);
    notifier.notifyListeners();
  }

  Task getTask(String name) {
    Task found =
    allTasks.firstWhere((tsk) => tsk.name == name, orElse: () => null);
    if (found == null) {
      print("getTask - Error could not find name: " + name);
    }
    return found;
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
    return allStages[stage].allTasks;
    //return allTasks;
  }

  saveState() {
    //ToDo: save  and load randomList
    print("saveState");
    List<String> activeTasks = new List<String>();
    int tLength = tasks.length;
    for (int i = 0; i < tLength; i++) {
      activeTasks.add(tasks[i].name);
    }
    dataManager.writeJson("gameRes", json.encode(ressources));
    dataManager.writeJson("activeTasks", json.encode(activeTasks));
    dataManager.writeJson("allTasks", json.encode(allTasks));
    dataManager.writeJson("Game", stage.toString());
  }

  loadState() {
    print("loadState");
    dataManager.readData("gameRes").then(loadRes);
    dataManager.readData("allTasks").then(loadAllTasks);
    dataManager.readData("activeTasks").then(loadActiveTasks);
    dataManager.readData("Game").then(loadGame);
  }

  loadRes(String jsn) {
    if (jsn != null) {
      Map<String, dynamic> resMap = json.decode(jsn);
      List<String> ressourceNames = ressources.keys.toList();
      int rLength = ressourceNames.length;
      for (int i = 0; i < rLength; i++) {
        ressources[ressourceNames[i]]
            .setValue(resMap[ressourceNames[i]]['value']);
      }
    }
  }

  loadAllTasks(String jsn) {
    if (jsn != null) {
      final parsed = json.decode(jsn).cast<Map<String, dynamic>>();
      List<Task> tmpList =
      parsed.map<Task>((tmpJson) => Task.fromJson(tmpJson)).toList();
      if (tmpList != null) allTasks = tmpList;
      dataManager.readData("activeTasks").then(loadActiveTasks);
    }
  }

  loadActiveTasks(String jsn) {
    if (jsn != null) {
      Game tmpGame = Game.getInstance();
      List<String> tmpList = new List<String>.from(json.decode(jsn));
      Game.tasks.removeRange(0, Game.tasks.length);
      int tmpListLenght = tmpList.length;
      Task found;
      for (int i = (tmpListLenght - 1); i >= 0; i--) {
        found = tmpGame.getTask(tmpList[i]);
        if (found != null)
          tmpGame.addTask(found, needInit: false);
      }
    }
  }

  loadGame(String jsn) {
    stage = int.tryParse(jsn);
  }

  updateGame(Duration elapse) {
    Duration d1 = elapse - saveCalled;
    Duration d2 = elapse - randCalled;
    if (d1 > saveDuration) {
      saveState();
      saveCalled = elapse;
    }
    if (d2 > randDuration) {
      int rand = Random().nextInt(5);
      print(
          "its possible thats something will happen" + rand.toString() + "\n");
      if (rand == 1) {
        int lgth = allStages[stage].randomTasks.length;
        Task thisHappens =
        getTask(allStages[stage].randomTasks[Random().nextInt(lgth)]);
        if (thisHappens != null) {
          print("ohhh no this will happen:" + thisHappens.name + "\n");
          addTask(thisHappens);
        }
      }
      randCalled = elapse;
    }

  }

  levelListener() {
    double members = ressources[Member().name].value;
    int found;
    int levelLength = levels.length;
    List<int> levelList = levels.keys.toList();
    int i;
    for (i = 0; (i < levelLength && found == null); i++) {
      if ((levelList[i] + 1) > members.floor()) {
        found = i;
      }
    }

    if (found > stage) {
      stage = found;
      stagenNotifier.notifyListeners();
      //TODO: load the new levelists... and publish it. maybe show a nice Animation
      print("Ich bin stage: " +
          found.toString() +
          ". Das heißt ich bin eine: " +
          levels[levelList[found]]);
      ressources[Member().name].max = levelList[found].toDouble();
      initStage(found);
      saveState();
    }
  }

  initStage(int stg) {
    print("Game:initStage(" + stg.toString() + ");\n");
    allTasks = allStages[stg].allTasks;
    print(allTasks);
    int lgth = allStages[stg].activeTasks.length - 1;
    for (int i = lgth; i >= 0; i--) {
      if (allTasks != null) {
        Task found = getTask(allStages[stg].activeTasks[i]);
        if (found != null) {
          addTask(found);
        }
      }
    }
  }
}
