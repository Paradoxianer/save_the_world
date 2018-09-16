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

  Game(){
    notifier = new ChangeNotifier();
    tick = new TestVSync();
    ressources[Faith().name] = Faith(value: 100.0);
    ressources[Money().name]=Money(value: 10.0);
    ressources[Time().name]=Time(value: 24.0);
    ressources[Member().name] = Member(value: 2.0);
    ressources[Publicity().name]=Publicity(value: 1.0);
    ressources[Wisdome().name]=Wisdome(value: 10.0);
    tasks = testTasks;
    allTasks = new List<Task>();
    allTasks.addAll(testTasks);
    allTasks.addAll(onHoldTaks);
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
}
