import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:save_the_world_flutter_app/globals.dart';
import 'package:save_the_world_flutter_app/models/game.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/member.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/task.model.dart';

class GameController {
  Game game;
  static TestVSync tick;
  static ChangeNotifier notifier;
  static ChangeNotifier stageNotifier;
  TickerFuture ticker;
  Duration saveDuration;

  GameController(this.game) {
    notifier = new ChangeNotifier();
    stageNotifier = new ChangeNotifier();
    tick = new TestVSync();
    saveDuration = new Duration(seconds: 10);
    tick.createTicker(updateGame).start();
    Game.ressources[Member().name].addListener(levelListener);
  }

  void addTask(Task task, {bool needInit = true}) {
    //TODO: Maby check if the task is already running? bevore removing?
    if (needInit) Game.tasks.remove(task);
    Game.tasks.insert(0, task);
    if (needInit) task.init();
    notifier.notifyListeners();
  }

  void removeTask(Task task) {
    Game.tasks.remove(task);
    notifier.notifyListeners();
  }

  addListener(VoidCallback listener) {
    notifier.addListener(listener);
  }

  removeListener(VoidCallback listener) {
    notifier.removeListener(listener);
  }

  addStageListener(VoidCallback listener) {
    stageNotifier.addListener(listener);
  }

  updateGame(Duration elapse) {
    int rest = (elapse.inSeconds % saveDuration.inSeconds);
    if ((rest == 0) && (elapse.inSeconds > 0)) {
      game.saveState();
    }
  }

  levelListener() {
    double members = Game.ressources[Member().name].value;
    int maxMembers = 0;
    int found;
    int levelLength = levels.length;
    List<int> levelList = levels.keys.toList();
    int i;
    for (i = 0; (i < levelLength && found == null); i++) {
      if (levelList[i].toDouble() > members) {
        found = i;
      } else
        maxMembers = levelList[i];
    }
    if (found != game.stage) {
      game.stage = found;
      stageNotifier.notifyListeners();
      //TODO: load the new levelists... and publish it. maybe show a nice Animation
      print("Ich bin stage: " +
          found.toString() +
          ". Das heißt ich bin eine: " +
          levels[levelList[found]]);
    }
  }
}
