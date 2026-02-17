import 'package:save_the_world_flutter_app/models/addtask.model.dart';
import 'package:save_the_world_flutter_app/models/autoexecute.model.dart';
import 'package:save_the_world_flutter_app/models/faith.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/member.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/message.modifier.dart';
import 'package:save_the_world_flutter_app/models/money.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/multiplyres.model.dart';
import 'package:save_the_world_flutter_app/models/publicity.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/removetask.model.dart';
import 'package:save_the_world_flutter_app/models/stage.model.dart';
import 'package:save_the_world_flutter_app/models/setmax.model.dart';
import 'package:save_the_world_flutter_app/models/task.model.dart';
import 'package:save_the_world_flutter_app/models/time.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/wisdome.ressource.model.dart';
import 'package:save_the_world_flutter_app/data/stages/common_tasks.dart';

final Stage stage10 = Stage(
  level: 10,
  member: 2800,
  description: "Internationale Multiplikation und globale Reichweite.",
  activeTasks: [
    "Bibellesen", 
    "Schlafen", 
    "Leadership Summit", 
    "Internationale Vision",
    "Generalsekretär berufen"
  ],
  randomTasks: [
    "Der Heilige Geist möchte wirken", 
    "Beerdigung eines Generals",
    "Medien-Skandal" // Neue, schnellere Krise
  ],
  allTasks: [
    baseBible,
    baseSleep,
    collectMoney,
    someoneWantsToMarry,
    holySpiritWorking,
    weddingPhase1,
    weddingPhase2,
    actualWedding,
    funeralGeneral,
    Task(
      name: "Generalsekretär berufen",
      description: "DELEGATION: Ein erfahrener Administrator übernimmt die operativen Systeme.",
      duration: 15000.0,
      cost: [Money(value: 5000.0), Wisdom(value: 200.0)],
      modifier: [
        MessageModifier(message: "SYSTEM: Der Generalsekretär automatisiert nun die Kollekten-Einnahmen."),
        AutoExecuteModifier(
          intervalMs: 10000,
          modifiers: [
             MultiplyRes(targetResName: "Money", factorResName: "Member", multiplier: 0.1),
          ]
        ),
        RemoveTask(task: "Generalsekretär berufen"),
      ],
    ),
    Task(
      name: "Leadership Summit",
      description: "BEFÄHIGUNG: Ein globales Treffen zur Ausbildung neuer Visionäre.",
      duration: 25000.0,
      cost: [Money(value: 15000.0), Wisdom(value: 500.0), Faith(value: 200.0)],
      award: [Wisdom(value: 300.0), Publicity(value: 100.0)],
      modifier: [
        MessageModifier(message: "WACHSTUM: Tausende Leiter wurden weltweit inspiriert."),
      ],
    ),
    Task(
      name: "Internationale Vision",
      description: "MEILENSTEIN: Eröffnung der globalen Zentrale und strategische Ausrichtung (Limit 4500).",
      duration: 45000.0,
      isMilestone: true,
      cost: [Money(value: 40000.0), Faith(value: 1000.0), Wisdom(value: 500.0)],
      award: [Publicity(value: 500.0), Member(value: 1.0)],
      modifier: [
        MessageModifier(message: "GLOBAL: Die Vision trägt Früchte auf allen Kontinenten! Limit 4500."),
        SetMax(ressource: "Member", newMax: 4500.0),
        RemoveTask(task: "Internationale Vision"),
        AddTask(task: "Globalen Dienst aufrechterhalten"),
      ],
    ),
    Task(
      name: "Globalen Dienst aufrechterhalten",
      description: "WARTUNG: Sichere die Kontinuität der weltweiten Bewegung.",
      duration: 20000.0,
      cost: [Time(value: 4.0), Wisdom(value: 100.0)],
      award: [Faith(value: 50.0), Publicity(value: 20.0)],
    ),
    Task(
      name: "Medien-Skandal",
      description: "KRISE: Ein Missverständnis bedroht den globalen Ruf. Reagiere sofort!",
      duration: 10000.0,
      timeToSolve: 45000.0, // Schneller als bisherige Krisen
      cost: [Wisdom(value: 200.0), Publicity(value: 500.0)],
      award: [Wisdom(value: 50.0)],
      missed: [
        SubtractRes(ressources: [Publicity(value: 1000.0), Faith(value: 200.0)]),
        MessageModifier(message: "SCHADEN: Die Bewegung hat weltweit massiv an Vertrauen verloren."),
        AddTask(task: "Medien-Skandal"),
      ],
    ),
  ],
);
