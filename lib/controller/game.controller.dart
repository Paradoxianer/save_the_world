import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:save_the_world_flutter_app/globals.dart';
import 'package:save_the_world_flutter_app/models/game.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/member.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/task.model.dart';

class GameController {
  final Game game;
  static late Ticker tick;
  static late ChangeNotifier notifier;
  static late ChangeNotifier stageNotifier;
  late TickerFuture ticker;
  late Duration saveDuration;

  GameController(this.game) {
    notifier = ChangeNotifier();
    stageNotifier = ChangeNotifier();
    
    // Using a proper TickerProvider for production instead of TestVSync
    tick = Ticker(updateGame);
    saveDuration = const Duration(seconds: 10);
    ticker = tick.start();
    
    Game.ressources[Member().name]?.addListener(levelListener);
  }

  void addTask(Task task, {bool needInit = true}) {
    if (needInit) Game.tasks?.remove(task);
    Game.tasks?.insert(0, task);
    if (needInit) task.init();
    notifier.notifyListeners();
  }

  void removeTask(Task task) {
    Game.tasks?.remove(task);
    notifier.notifyListeners();
  }

  void addListener(VoidCallback listener) {
    notifier.addListener(listener);
  }

  void removeListener(VoidCallback listener) {
    notifier.removeListener(listener);
  }

  void addStageListener(VoidCallback listener) {
    stageNotifier.addListener(listener);
  }

  void updateGame(Duration elapse) {
    int rest = (elapse.inSeconds % saveDuration.inSeconds);
    if ((rest == 0) && (elapse.inSeconds > 0)) {
      game.saveState();
    }
  }

  void levelListener() {
    final memberRes = Game.ressources[Member().name];
    if (memberRes == null) return;
    
    double members = memberRes.value;
    int? found;
    int levelLength = levels.length;
    List<int> levelList = levels.keys.toList();
    
    for (int i = 0; i < levelLength; i++) {
      if (levelList[i].toDouble() > members) {
        found = i;
        break;
      }
    }
    
    // Fallback if members exceed all defined levels
    found ??= levelLength - 1;

    if (found != game.stage) {
      game.stage = found;
      stageNotifier.notifyListeners();
      debugPrint("Ich bin stage: $found. Das heißt ich bin eine: ${levels[levelList[found]]}");
    }
  }
}
