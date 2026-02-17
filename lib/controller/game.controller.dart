import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:save_the_world_flutter_app/models/game.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/task.model.dart';

class GameController with WidgetsBindingObserver {
  final Game game;
  static late Ticker tick;
  static late ChangeNotifier notifier;
  
  // Note: static stageNotifier removed to avoid confusion with Game.stagenNotifier
  
  late TickerFuture ticker;
  late Duration saveDuration;

  GameController(this.game) {
    notifier = ChangeNotifier();
    
    tick = Ticker(updateGame);
    saveDuration = const Duration(seconds: 10);
    ticker = tick.start();
    
    // REDUNDANT: Member listener removed. 
    // The Game model now handles stage progression and statistics internally.
    
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        game.resumeStageTimer();
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
        game.pauseStageTimer();
        break;
    }
  }
  
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    tick.dispose();
  }

  void addTask(Task task, {bool needInit = true}) {
    if (needInit) Game.tasks.removeWhere((t) => t.name == task.name);
    Game.tasks.add(task);
    if (needInit) task.init();
    notifier.notifyListeners();
  }

  void removeTask(Task task) {
    Game.tasks.remove(task);
    notifier.notifyListeners();
  }

  void addListener(VoidCallback listener) {
    notifier.addListener(listener);
  }

  void removeListener(VoidCallback listener) {
    notifier.removeListener(listener);
  }

  void updateGame(Duration elapse) {
    int rest = (elapse.inSeconds % saveDuration.inSeconds);
    if ((rest == 0) && (elapse.inSeconds > 0)) {
      game.saveState();
    }
  }
}
