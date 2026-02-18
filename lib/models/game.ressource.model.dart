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
import 'package:save_the_world_flutter_app/models/stage.ressource.model.dart';
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
  
  String? _snackbarMessage;
  String? get snackbarMessage => _snackbarMessage;
  set snackbarMessage(String? value) {
    _snackbarMessage = value;
    if (value != null) {
      notifier.notifyListeners();
    }
  }

  DateTime? _lastStartTime;
  Duration _accumulatedStageTime = Duration.zero;
  int _stageClicks = 0;
  
  Duration? lastStageDuration;
  int? lastStageClicks;
  int? lastStageScore;

  // Persistable scores per stage
  Map<int, int> stageHighscores = {};

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
    
    resumeStageTimer();
  }

  void resumeStageTimer() {
    _lastStartTime = DateTime.now();
  }

  void pauseStageTimer() {
    if (_lastStartTime != null) {
      final now = DateTime.now();
      _accumulatedStageTime += now.difference(_lastStartTime!);
      _lastStartTime = null;
    }
  }

  Duration get currentActiveStageTime {
    Duration total = _accumulatedStageTime;
    if (_lastStartTime != null) {
      total += DateTime.now().difference(_lastStartTime!);
    }
    return total;
  }

  void recordClick() {
    _stageClicks++;
    notifier.notifyListeners(); // Ensure statistics update
  }

  int get stageClicks => _stageClicks;

  void initRes() {
    ressources[Faith().name] = Faith(value: 100.0);
    ressources[Money().name] = Money(value: 20.0);
    ressources[Time().name] = Time(value: 24.0);
    ressources[Member().name] = Member(value: 2.0);
    ressources[Publicity().name] = Publicity(value: 1.0);
    ressources[Wisdom().name] = Wisdom(value: 10.0);
    ressources["Stage"] = StageRes(value: stage.toDouble());
    
    ressources[Member().name]?.max = 20.0;
    ressources[Member().name]?.min = 0.0;
  }

  void resetGame() {
    stage = 0;
    tasks.clear();
    initRes();
    initStage(0);
    _accumulatedStageTime = Duration.zero;
    _lastStartTime = DateTime.now();
    _stageClicks = 0;
    stageHighscores.clear();
    saveState();
    notifier.notifyListeners();
    stagenNotifier.notifyListeners();
  }

  int calculateScore(Duration duration, int clicks, int stgLevel) {
    if (duration.inSeconds == 0) return 0;
    
    // Basisscore: 1000 Punkte
    // Abzüge für Zeit (Level skaliert mit)
    // Abzüge für unnötige Klicks
    double timeFactor = (stgLevel + 1) * 60 / duration.inSeconds;
    double clickFactor = (stgLevel + 1) * 10 / max(1, clicks);
    
    int score = (500 * timeFactor + 500 * clickFactor).toInt();
    return min(1000, score);
  }

  void jumpToStage(int targetStage) {
    tasks.clear();
    initRes();
    stage = targetStage;
    ressources["Stage"]?.setValue(stage.toDouble());
    
    List<int> thresholds = levels.keys.toList();
    if (targetStage < thresholds.length) {
      double targetMembers = thresholds[targetStage].toDouble() - 1.0;
      ressources[Member().name]?.setValue(max(2.0, targetMembers));
      ressources[Member().name]?.max = thresholds[targetStage].toDouble();
    }

    for (int i = 0; i <= targetStage; i++) {
      initStage(i);
    }

    _accumulatedStageTime = Duration.zero;
    _lastStartTime = DateTime.now();
    _stageClicks = 0;

    saveState();
    notifier.notifyListeners();
    stagenNotifier.notifyListeners();
  }

  factory Game.fromJson(Map<String, dynamic> json) {
    var tList = json['tasks'] != null ? jsonDecode(json['tasks']) as List : [];
    var atList = json['alltasks'] != null ? jsonDecode(json['alltasks']) as List : [];
    return Game(tasksList: tList.map((i) => Task.fromJson(i)).toList(), allTasksList: atList.map((i) => Task.fromJson(i)).toList(), stage: json['stage'] as int?);
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'tasks': json.encode(tasks),
      'alltasks': json.encode(allTasks),
      'stage': stage,
      'accumulatedStageTime': _accumulatedStageTime.inMilliseconds,
      'stageClicks': _stageClicks,
      'stageHighscores': json.encode(stageHighscores),
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
    _snackbarMessage = null;
    notifier.notifyListeners();
  }

  Task? getTask(String name) {
    try {
      return allTasks.firstWhere((tsk) => tsk.name == name);
    } catch (e) {
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

  void saveState() {
    dataManager.writeJson("gameRes", json.encode(ressources));
    dataManager.writeJson("activeTasks", json.encode(tasks)); 
    dataManager.writeJson("allTasks", json.encode(allTasks));
    dataManager.writeJson("Game", json.encode({
      'stage': stage,
      'accumulatedStageTime': currentActiveStageTime.inMilliseconds,
      'stageClicks': _stageClicks,
      'stageHighscores': stageHighscores,
    }));
  }

  void loadState() {
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
          ressources[name]?.min = resMap[name]['min']?.toDouble() ?? ressources[name]!.min;
          ressources[name]?.max = resMap[name]['max']?.toDouble() ?? ressources[name]!.max;
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
      for (var taskData in tmpList) {
        Task restoredTask = Task.fromJson(taskData as Map<String, dynamic>);
        addTask(restoredTask, needInit: false);
      }
    }
  }

  void loadGame(String? jsn) {
    if (jsn != null) {
      try {
        final Map<String, dynamic> gameData = json.decode(jsn);
        stage = gameData['stage'] as int? ?? 0;
        _stageClicks = gameData['stageClicks'] as int? ?? 0;
        if (gameData['accumulatedStageTime'] != null) {
          _accumulatedStageTime = Duration(milliseconds: gameData['accumulatedStageTime']);
        }
        if (gameData['stageHighscores'] != null) {
          final Map<String, dynamic> scores = gameData['stageHighscores'];
          stageHighscores = scores.map((k, v) => MapEntry(int.parse(k), v as int));
        }
        _lastStartTime = DateTime.now();
      } catch (e) {
        stage = int.tryParse(jsn) ?? 0;
        _lastStartTime = DateTime.now();
      }
      ressources["Stage"]?.setValue(stage.toDouble());
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
      // BALANCING: Reduce crisis probability in Stage 1
      int prob = (stage == 1) ? 15 : 5; 
      int rand = Random().nextInt(prob);
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
      lastStageDuration = currentActiveStageTime;
      lastStageClicks = _stageClicks;
      lastStageScore = calculateScore(lastStageDuration!, lastStageClicks!, stage);
      
      // Save highscore if better
      if (lastStageScore! > (stageHighscores[stage] ?? 0)) {
        stageHighscores[stage] = lastStageScore!;
      }

      _accumulatedStageTime = Duration.zero;
      _lastStartTime = DateTime.now();
      _stageClicks = 0;
      stage = found;
      ressources["Stage"]?.setValue(stage.toDouble());
      stagenNotifier.notifyListeners();
      ressources[Member().name]?.max = levelList[found].toDouble();
      initStage(found);
      saveState();
    }
  }

  void initStage(int stg) {
    allTasks = allStages[stg].allTasks;
    for (var taskName in allStages[stg].activeTasks) {
      Task? found = getTask(taskName);
      if (found != null) {
        if (!tasks.any((t) => t.name == found.name)) {
          addTask(found);
        }
      }
    }
  }
}
