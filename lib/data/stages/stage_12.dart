import 'package:save_the_world_flutter_app/models/addtask.model.dart';
import 'package:save_the_world_flutter_app/models/message.modifier.dart';
import 'package:save_the_world_flutter_app/models/money.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/multiplyres.model.dart';
import 'package:save_the_world_flutter_app/models/publicity.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/stage.model.dart';
import 'package:save_the_world_flutter_app/models/setmax.model.dart';
import 'package:save_the_world_flutter_app/models/subtractres.model.dart';
import 'package:save_the_world_flutter_app/models/task.model.dart';
import 'package:save_the_world_flutter_app/models/time.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/wisdome.ressource.model.dart';
import 'package:save_the_world_flutter_app/data/stages/common_tasks.dart';

final Stage stage12 = Stage(
  level: 12,
  member: 10000,
  description: "Eine Bewegung Level 1 - Nationale Relevanz.",
  activeTasks: ["Bibellesen", "Schlafen", "Kollekte", "Nationale Lobbyarbeit"],
  randomTasks: ["Kassendifferenz finden", "Der Heilige Geist möchte wirken", "Jemand möchte heiraten"],
  allTasks: [
    baseBible,
    baseSleep,
    collectMoney,
    holySpiritWorking,
    someoneWantsToMarry,
    weddingPhase1,
    weddingPhase2,
    actualWedding,
    Task(
      name: "Kollekte",
      duration: 3000.0,
      cost: [Time(value: 1.0)],
      modifier: [MultiplyRes(targetResName: "Money", factorResName: "Member", multiplier: 6.0)],
    ),
    Task(
      name: "Nationale Lobbyarbeit",
      description: "Einflussnahme auf gesellschaftliche Werte durch Publicity.",
      duration: 20000.0,
      cost: [Money(value: 10000.0), Publicity(value: 100.0)],
      award: [Wisdom(value: 100.0), Publicity(value: 300.0)],
    ),
    Task(
      name: "Kassendifferenz finden",
      description: "GEFAHR: Die nationale Kasse stimmt nicht (Inspiration: oldstages).",
      duration: 10000.0,
      timeToSolve: 60000.0,
      cost: [Time(value: 5.0)],
      award: [Wisdom(value: 10.0)],
      online: [MessageModifier(message: "BUCHFÜHRUNG: Ein Fehler in der Zentralkasse wurde entdeckt!")],
      missed: [
        SubtractRes(ressources: [Money(value: 1000.0)]),
        MessageModifier(message: "VERLUST: 1000 Geld mussten abgeschrieben werden."),
        AddTask(task: "Kassendifferenz finden")
      ],
    ),
    Task(
      name: "Nationale Struktur etablieren",
      description: "MEILENSTEIN: Vernetzung aller Standorte (Limit 20000).",
      duration: 50000.0,
      cost: [Money(value: 100000.0), Wisdom(value: 1500.0)],
      modifier: [
        MessageModifier(message: "STRUKTUR: Ihr seid nun eine nationale Kraft! Limit 20.000!"),
        SetMax(ressource: "Member", newMax: 20000.0),
      ],
    ),
  ],
);
