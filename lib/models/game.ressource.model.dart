import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
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

class GameTickerProvider implements TickerProvider {
  @override
  Ticker createTicker(TickerCallback onTick) => Ticker(onTick);
}

class Game {
  static Map<String, Ressource> ressources = {};
  static List<Task> tasks = [];
  static late ChangeNotifier notifier;
  static late ChangeNotifier stagenNotifier;
  static Game? mInstance;
  static final TickerProvider tick = GameTickerProvider();
  
  String? snackbarMessage;
  late List<Task> allTasks;
  late List<String> randomTasks;
  late Duration saveCalled;
  late Duration saveDuration;
  late Duration randDuration;
  late Duration randCalled;
  late DataManager dataManager;
  int stage;

  Game({List<Task>? tasksList, List<Task>? allTasksList, int? stage}) : stage = stage ?? 0 {
    dataManager = DataManager();
    notifier = ChangeNotifier();
    stagenNotifier = ChangeNotifier();
    
    // The game loop ticker
    tick.createTicker(updateGame).start();
    
    if (tasksList != null) tasks = tasksList;
    
    initRes();
    
    allTasks = allStages[this.stage].allTasks;
    randomTasks = allStages[this.stage].randomTasks;
    
    saveDuration = const Duration(seconds: 5);
    saveCalled = const Duration(seconds: 0);
    randDuration = const Duration(seconds: 10);
    randCalled = const Duration(seconds: 0);
    
    initStage(this.stage);
    ressources[Member().name]?.addListener(levelListener);
    loadState();
  }

  void initRes() {
    ressources[Faith().name] = Faith(value: 100.0);
    ressources[Money().name] = Money(value: 20.0);
    ressources[Time().name] = Time(value: 24.0);
    ressources[Member().name] = Member(value: 2.0);
    ressources[Publicity().name] = Publicity(value: 1.0);
    ressources[Wisdom().name] = Wisdom(value: 10.0);
    ressources[Member().name]?.max = 20.0;
    ressources[Member().name]?.min = 2.0;
  }

  factory Game.fromJson(Map<String, dynamic> json) {
    var tList = json['tasks'] != null ? jsonDecode(json['tasks']) as List : [];
    var atList = json['alltasks'] != null ? jsonDecode(json['alltasks']) as List : [];
    
    List<Task> tksList = tList.map((i) => Task.fromJson(i)).toList();
    List<Task> aTasksList = atList.map((i) => Task.fromJson(i)).toList();
    
    return Game(
        tasksList: tksList, 
        allTasksList: aTasksList, 
        stage: json['stage'] as int?
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
    if (needInit) tasks.removeWhere((t) => t.name == task.name);
    tasks.add(task);
    if (needInit) task.init();
    notifier.notifyListeners();
    task.goOnline();
  }

  void removeTask(Task task) {
    tasks.remove(task);
    snackbarMessage = null;
    notifier.notifyListeners();
  }

  Task? getTask(String name) {
    try {
      return allTasks.firstWhere((tsk) => tsk.name == name);
    } catch (e) {
      debugPrint("getTask - Error could not find name: $name");
      return null;
    }
  }

  static Game getInstance() {
    mInstance ??= Game();
    return mInstance!;
  }

  void addListener(VoidCallback listener) {
    notifier.addListener(listener);
  }

  void removeListener(VoidCallback listener) {
    notifier.removeListener(listener);
  }

  void addStageListener(VoidCallback listener) {
    stagenNotifier.addListener(listener);
  }

  List<Task> availableTasks() {
    return allStages[stage].allTasks;
  }

  void saveState() {
    debugPrint("saveState");
    List<String> activeTaskNames = tasks.map((t) => t.name).toList();
    
    dataManager.writeJson("gameRes", json.encode(ressources));
    dataManager.writeJson("activeTasks", json.encode(activeTaskNames));
    dataManager.writeJson("allTasks", json.encode(allTasks));
    dataManager.writeJson("Game", stage.toString());
  }

  void loadState() {
    debugPrint("loadState");
    dataManager.readData("gameRes").then((jsn) => loadRes(jsn));
    dataManager.readData("allTasks").then((jsn) => loadAllTasks(jsn));
    dataManager.readData("Game").then((jsn) => loadGame(jsn));
  }

  void loadRes(String? jsn) {
    if (jsn != null) {
      Map<String, dynamic> resMap = json.decode(jsn);
      for (var name in ressources.keys) {
        if (resMap.containsKey(name)) {
          ressources[name]?.setValue(resMap[name]['value']?.toDouble() ?? 0.0);
        }
      }
    }
  }

  void loadAllTasks(String? jsn) {
    if (jsn != null) {
      final List<dynamic> parsed = json.decode(jsn);
      allTasks = parsed.map<Task>((tmpJson) => Task.fromJson(tmpJson)).toList();
      dataManager.readData("activeTasks").then((val) => loadActiveTasks(val));
    }
  }

  void loadActiveTasks(String? jsn) {
    if (jsn != null) {
      List<dynamic> tmpList = json.decode(jsn);
      tasks.clear();
      for (var taskName in tmpList) {
        Task? found = getTask(taskName as String);
        if (found != null) {
          addTask(found, needInit: false);
        }
      }
    }
  }

  void loadGame(String? jsn) {
    if (jsn != null) {
      stage = int.tryParse(jsn) ?? 0;
    }
  }

  void updateGame(Duration elapse) {
    Duration d1 = elapse - saveCalled;
    Duration d2 = elapse - randCalled;
    
    if (d1 > saveDuration) {
      saveState();
      saveCalled = elapse;
    }
    
    if (d2 > randDuration) {
      int rand = Random().nextInt(5);
      debugPrint("its possible thats something will happen $rand\n");
      if (rand == 1) {
        List<String> currentRandomTasks = allStages[stage].randomTasks;
        if (currentRandomTasks.isNotEmpty) {
          String randomTaskName = currentRandomTasks[Random().nextInt(currentRandomTasks.length)];
          Task? thisHappens = getTask(randomTaskName);
          if (thisHappens != null) {
            snackbarMessage = "Achtung neue Aufgabe: ${thisHappens.name}";
            addTask(thisHappens);
          }
        }
      }
      randCalled = elapse;
    }
  }

  void levelListener() {
    final memberRes = ressources[Member().name];
    if (memberRes == null) return;
    
    double members = memberRes.value;
    int? found;
    int levelLength = levels.length;
    List<int> levelList = levels.keys.toList();
    
    for (int i = 0; i < levelLength; i++) {
      if ((levelList[i] + 1) > members.floor()) {
        found = i;
        break;
      }
    }

    if (found != null && found > stage) {
      stage = found;
      stagenNotifier.notifyListeners();
      debugPrint("Ich bin stage: $found. Das heißt ich bin eine: ${levels[levelList[found]]}");
      
      ressources[Member().name]?.max = levelList[found].toDouble();
      initStage(found);
      saveState();
    }
  }

  void initStage(int stg) {
    debugPrint("Game:initStage($stg);\n");
    allTasks = allStages[stg].allTasks;
    
    for (var taskName in allStages[stg].activeTasks) {
      Task? found = getTask(taskName);
      if (found != null) {
        addTask(found);
      }
    }
  }
}
