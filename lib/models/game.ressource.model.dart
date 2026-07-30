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
import 'package:save_the_world_flutter_app/models/weighted_random_event.model.dart';
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
  
  /// Der Taktgeber für alle Animationen und Timer im Spiel.
  /// Nicht final, damit er in Tests durch einen MockTickerProvider ersetzt werden kann.
  static TickerProvider tick = GameTickerProvider();
  
  Ticker? _ticker;

  String? _snackbarMessage;
  String? get snackbarMessage => _snackbarMessage;
  set snackbarMessage(String? value) {
    _snackbarMessage = value;
    if (value != null) {
      notifier.notifyListeners();
    }
  }

  bool isLoading = true;

  DateTime? _lastStartTime;
  Duration _accumulatedStageTime = Duration.zero;
  int _stageClicks = 0;
  
  Duration? lastStageDuration;
  int? lastStageClicks;
  int? lastStageScore;

  Map<int, int> stageHighscores = {};
  Map<int, int> stageBestTimesMs = {};
  Map<int, int> stageBestClicks = {};

  /// Namen aller abgeschlossenen Einmal-Aufgaben (Task.once == true).
  /// Zentrale Sperre: addTask() blendet diese Tasks nie wieder ein -
  /// egal ob AddTask-Modifier, Random-Event oder initStage sie anfordert.
  final Set<String> completedOnceTasks = {};

  /// Ressourcenabhängige Zufallsevents (siehe AddToRandom), taskName ->
  /// Gewichtungs-Konfiguration. Stage-scoped, wird bei jedem initStage()
  /// geleert - genau wie randomTasks nur zur Laufzeit durch Task-Modifier
  /// befüllt, nicht Teil der statischen Stage-Definition.
  final Map<String, WeightedRandomEvent> weightedRandomEvents = {};

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
    
    _ticker = tick.createTicker(updateGame);
    _ticker!.start();
    
    if (tasksList != null) tasks = tasksList;
    
    initRes();
    
    allTasks = allStages[this.stage].allTasks;

    saveDuration = const Duration(seconds: 5);
    saveCalled = const Duration(seconds: 0);
    randDuration = const Duration(seconds: 10);
    randCalled = const Duration(seconds: 0);
    
    initStage(this.stage);
    ressources[Member().name]?.addListener(levelListener);
    loadState();
    
    resumeStageTimer();
  }

  void dispose() {
    if (_ticker != null) {
      if (_ticker!.isActive) {
        _ticker!.stop();
      }
      _ticker!.dispose();
      _ticker = null;
    }
    ressources[Member().name]?.removeListener(levelListener);
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
    notifier.notifyListeners();
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
    isLoading = true;
    stage = 0;
    tasks.clear();
    completedOnceTasks.clear();
    initRes();
    initStage(0);
    _accumulatedStageTime = Duration.zero;
    _lastStartTime = DateTime.now();
    _stageClicks = 0;
    stageHighscores.clear();
    stageBestTimesMs.clear();
    stageBestClicks.clear();
    saveState();
    
    isLoading = false;
    notifier.notifyListeners();
    stagenNotifier.notifyListeners();
  }

  int calculateScore(Duration duration, int clicks, int stgLevel) {
    if (duration.inSeconds == 0) return 0;
    double timeFactor = (stgLevel + 1) * 60 / duration.inSeconds;
    double clickFactor = (stgLevel + 1) * 10 / max(1, clicks);
    int score = (500 * timeFactor + 500 * clickFactor).toInt();
    return min(1000, score);
  }

  void jumpToStage(int targetStage) {
    isLoading = true;
    tasks.clear();
    completedOnceTasks.clear();
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
    isLoading = false;
    notifier.notifyListeners();
    stagenNotifier.notifyListeners();
  }

  factory Game.fromJson(Map<String, dynamic> json) {
    var tList = json['tasks'] != null ? jsonDecode(json['tasks']) as List : [];
    var atList = json['alltasks'] != null ? jsonDecode(json['alltasks']) as List : [];
    
    return Game(
      tasksList: tList.map((i) => Task.fromJson(i)).toList(), 
      allTasksList: atList.map((i) => Task.fromJson(i)).toList(), 
      stage: json['stage'] as int?
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'tasks': json.encode(tasks.map((t) => t.toJson()).toList()),
      'alltasks': json.encode(allTasks.map((t) => t.toJson()).toList()),
      'stage': stage,
      'accumulatedStageTime': _accumulatedStageTime.inMilliseconds,
      'stageClicks': _stageClicks,
      'stageHighscores': json.encode(stageHighscores.map((k, v) => MapEntry(k.toString(), v))),
      'completedOnceTasks': completedOnceTasks.toList(),
    };
  }

  void addTask(Task task, {bool needInit = true}) {
    // Einmal-Aufgaben, die bereits erledigt wurden, kommen nie wieder ins Spiel.
    if (task.once && completedOnceTasks.contains(task.name)) {
      debugPrint("addTask: '${task.name}' ist eine erledigte Einmal-Aufgabe. Skipping.");
      return;
    }
    if (needInit) tasks.removeWhere((t) => t.name == task.name);
    tasks.add(task);
    if (needInit) task.init();
    notifier.notifyListeners();
    task.goOnline();
  }

  void markOnceCompleted(String taskName) {
    completedOnceTasks.add(taskName);
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

  static void resetInstance() {
    mInstance?.dispose();
    mInstance = null;
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
    Map<String, dynamic> resJson = ressources.map((key, value) => MapEntry(key, value.toJson()));
    dataManager.writeJson("gameRes", json.encode(resJson));

    dataManager.writeJson("activeTasks", json.encode(tasks.map((t) => t.toJson()).toList())); 
    dataManager.writeJson("allTasks", json.encode(allTasks.map((t) => t.toJson()).toList()));
    dataManager.writeJson("Game", json.encode({
      'stage': stage,
      'accumulatedStageTime': currentActiveStageTime.inMilliseconds,
      'stageClicks': _stageClicks,
      'stageHighscores': stageHighscores.map((k, v) => MapEntry(k.toString(), v)),
      'completedOnceTasks': completedOnceTasks.toList(),
    }));
  }

  void loadState() async {
    isLoading = true;
    final resJsn = await dataManager.readData("gameRes");
    loadRes(resJsn);
    
    final allTasksJsn = await dataManager.readData("allTasks");
    await loadAllTasks(allTasksJsn);
    
    final gameJsn = await dataManager.readData("Game");
    loadGame(gameJsn);
    
    isLoading = false;
    notifier.notifyListeners();
    stagenNotifier.notifyListeners();
  }

  void loadRes(String? jsn) {
    if (jsn != null) {
      Map<String, dynamic> resMap = json.decode(jsn);
      for (var name in ressources.keys) {
        if (resMap.containsKey(name)) {
          double val = Ressource.parseJsonDouble(resMap[name]['value'], 0.0);
          ressources[name]?.setValue(val);
          ressources[name]?.min = Ressource.parseJsonDouble(resMap[name]['min'], ressources[name]!.min);
          ressources[name]?.max = Ressource.parseJsonDouble(resMap[name]['max'], ressources[name]!.max);
        }
      }
    }
  }

  Future<void> loadAllTasks(String? jsn) async {
    if (jsn != null) {
      final List<dynamic> parsed = json.decode(jsn);
      allTasks = parsed.map<Task>((tmpJson) => Task.fromJson(tmpJson)).toList();
      final activeTasksJsn = await dataManager.readData("activeTasks");
      loadActiveTasks(activeTasksJsn);
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
        if (gameData['completedOnceTasks'] != null) {
          final List<dynamic> completed = gameData['completedOnceTasks'];
          completedOnceTasks
            ..clear()
            ..addAll(completed.cast<String>());
        }
        
        ressources["Stage"]?.setValue(stage.toDouble());
        _lastStartTime = DateTime.now();
      } catch (e) {
        stage = int.tryParse(jsn) ?? 0;
        ressources["Stage"]?.setValue(stage.toDouble());
        _lastStartTime = DateTime.now();
      }
    }
  }

  void updateGame(Duration elapse) {
    if (isLoading) return;
    
    Duration d1 = elapse - saveCalled;
    Duration d2 = elapse - randCalled;
    if (d1 > saveDuration) {
      saveState();
      saveCalled = elapse;
    }
    if (d2 > randDuration) {
      int prob = (stage == 1) ? 15 : 5; 
      int rand = Random().nextInt(prob);
      if (rand == 1) {
        // Instanz-Liste statt allStages[stage].randomTasks: AddToRandom
        // (z.B. "Fasten und Beten") haengt Tasks zur Laufzeit hier an - die
        // statische Stage-Definition bekommt davon nie etwas mit.
        List<String> currentRandomTasks = randomTasks;
        if (currentRandomTasks.isNotEmpty) {
          String randomTaskName = currentRandomTasks[Random().nextInt(currentRandomTasks.length)];
          Task? thisHappens = getTask(randomTaskName);
          if (thisHappens != null) {
            snackbarMessage = "Achtung neue Aufgabe: ${thisHappens.name}";
            addTask(thisHappens);
          }
        }
      }

      // Ressourcengewichtete Events (siehe AddToRandom): eigener Roll pro
      // Event statt Gleichverteilung ueber den Pool - die Chance ergibt sich
      // direkt aus dem aktuellen Ressourcenwert relativ zur Schwelle.
      for (final entry in weightedRandomEvents.entries) {
        if (tasks.any((t) => t.name == entry.key)) continue;
        final double resVal = ressources[entry.value.resourceName]?.value ?? 0.0;
        final double chance = (resVal / entry.value.threshold).clamp(0.0, 1.0);
        if (Random().nextDouble() < chance) {
          Task? thisHappens = getTask(entry.key);
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
    if (isLoading) return;

    final memberRes = ressources[Member().name];
    if (memberRes == null) return;
    double members = memberRes.value;
    // BUGFIX: Nach vielen kleinen Belohnungen (0.5, 0.75, 0.9, ...) akkumulieren
    // Gleitkomma-Rundungsfehler. Der Spieler sieht z.B. "21" (gerundet für die
    // Anzeige), members ist intern aber 20.999999999999996 - members.floor()
    // ergäbe dann fälschlich 20 und der Stufenaufstieg würde nie auslösen.
    // Epsilon VOR dem floor() gleicht das aus, ohne echte Zwischenwerte wie
    // 20.5 zu verfälschen (20.5 + Epsilon floort weiterhin zu 20).
    final int memberFloor = (members + 1e-6).floor();
    int? found;
    int levelLength = levels.length;
    List<int> levelList = levels.keys.toList();
    for (int i = 0; i < levelLength; i++) {
      if ((levelList[i] + 1) > memberFloor) {
        found = i;
        break;
      }
    }
    if (found != null && found > stage) {
      lastStageDuration = currentActiveStageTime;
      lastStageClicks = _stageClicks;
      lastStageScore = calculateScore(lastStageDuration!, lastStageClicks!, stage);
      
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
    // Kopie statt Referenz: AddToRandom darf zur Laufzeit ergaenzen, ohne
    // die statische Stage-Definition selbst zu veraendern.
    randomTasks = List<String>.from(allStages[stg].randomTasks);
    weightedRandomEvents.clear();
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
