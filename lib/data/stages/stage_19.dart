import 'package:save_the_world_flutter_app/data/stages/common_tasks.dart';
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
import 'package:save_the_world_flutter_app/models/subtractres.model.dart';
import 'package:save_the_world_flutter_app/models/task.model.dart';
import 'package:save_the_world_flutter_app/models/time.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/wisdome.ressource.model.dart';

final Stage stage19 = Stage(
  level: 19,
  member: 1500000,
  description: "Globale Bewegung Level 3 - Mediale Macht und Multiplikation.",
  activeTasks: [ "Bibellesen", "Beten",
    "Schlafen",
    "Das Feuer am Brennen halten",
    "Kampagnen-Logistik planen",
    "Internationales Medienhaus gründen"
  ],
  randomTasks: ["Globaler PR-Shitstorm (Krise)", "Der Heilige Geist möchte wirken"],
  allTasks: [
    baseBible,
    basePrayer,
    baseSleep,
    holySpiritWorking,
    Task(
      name: "Das Feuer am Brennen halten",
      description: "WARTUNG: \"Den Geist löscht nicht aus\" (1. Thessalonicher 5,19) - inmitten von "
          "Sendeplänen und Reichweiten-Statistiken bewusst Raum für echte Anbetung und Gebet lassen, "
          "damit die Botschaft, die gesendet wird, noch von echtem Feuer getragen ist und nicht nur von "
          "Technik und Reichweite.",
      duration: 18000.0,
      cost: [Time(value: 6.0)],
      award: [Faith(value: 350.0)],
    ),
    Task(
      name: "Kampagnen-Logistik planen",
      description: "BEFÄHIGUNG: Schafft die technische Basis für weltweite Medienpräsenz.",
      duration: 40000.0,
      cost: [Money(value: 200000.0), Wisdom(value: 1000.0)],
      award: [Wisdom(value: 500.0)],
      modifier: [
        AddTask(task: "Weltweite Kampagne ausstrahlen"),
        RemoveTask(task: "Kampagnen-Logistik planen"),
      ],
    ),
    Task(
      name: "Weltweite Kampagne ausstrahlen",
      description: "SYSTEM: Millionen von Menschen erreichen das Evangelium über alle Kanäle - Reichweite "
          "wächst spürbar, aber Reichweite allein ist nicht dasselbe wie geistliche Tiefe. Die Produktion "
          "kostet Zeit, die dann für echte Begegnung mit Gott fehlt.",
      duration: 60000.0,
      cost: [Money(value: 1000000.0), Publicity(value: 5000.0), Time(value: 10.0)],
      award: [Member(value: 1.0), Publicity(value: 2000.0)],
      modifier: [
        AddTask(task: "Kampagnen-Logistik planen"),
      ]
    ),
    Task(
      name: "Internationales Medienhaus gründen",
      description: "MEILENSTEIN: Eigene Sendeanstalten zur Sicherung der globalen Botschaft (Limit "
          "2.500.000). Ein Mediennetzwerk dieser Größe entwickelt eine eigene Schwerkraft - Sendequoten "
          "und Formate drohen wichtiger zu werden als das, was eigentlich gesagt werden soll.",
      duration: 120000.0,
      isMilestone: true,
      cost: [Money(value: 9000000.0), Wisdom(value: 12000.0), Publicity(value: 8000.0), Faith(value: 4000.0)],
      award: [Member(value: 1.0)],
      modifier: [
        MessageModifier(message: "MEDIENMACHT: Ihr seid nun ein globaler Informationslieferant. Limit 2.500.000!"),
        SetMax(ressource: "Member", newMax: 2500000.0),
        AutoExecuteModifier(
          intervalMs: 12000,
          modifiers: [
            MultiplyRes(targetResName: "Publicity", factorResName: "Member", multiplier: 0.05),
            SubtractRes(ressources: [Faith(value: 600.0)]),
          ]
        ),
        RemoveTask(task: "Internationales Medienhaus gründen"),
        AddTask(task: "Mediale Reichweite sichern"),
      ],
    ),
    Task(
      name: "Mediale Reichweite sichern",
      description: "WARTUNG: Stetiger Betrieb des internationalen Mediennetzwerks.",
      duration: 50000.0,
      cost: [Time(value: 4.0), Money(value: 50000.0)],
      award: [Publicity(value: 1000.0), Wisdom(value: 500.0)],
    ),
    Task(
      name: "Globaler PR-Shitstorm (Krise)",
      description: "KRISE: Eine koordinierte Attacke gegen die Bewegung verbreitet sich rasend schnell!",
      duration: 15000.0,
      timeToSolve: 40000.0, // Sehr schnell
      cost: [Wisdom(value: 3000.0), Publicity(value: 15000.0)],
      award: [Wisdom(value: 1000.0)],
      modifier: [
        MessageModifier(message: "BERUHIGT: Souveräne Kommunikation hat den Sturm gestoppt."),
        RemoveTask(task: "Globaler PR-Shitstorm (Krise)"),
      ],
      missed: [
        SubtractRes(ressources: [Publicity(value: 50000.0), Member(value: 5000.0)]),
        MessageModifier(message: "KASKADE: Der Vertrauensverlust führt zum Rückzug wichtiger Geldgeber!"),
        RemoveTask(task: "Globaler PR-Shitstorm (Krise)"),
        AddTask(task: "Sponsoren-Rückzug (Krise)"),
      ],
    ),
    Task(
      name: "Sponsoren-Rückzug (Krise)",
      description: "FOLGE-KRISE: Wichtige Finanzquellen versiegen aufgrund des PR-Schadens.",
      duration: 30000.0,
      timeToSolve: 60000.0,
      cost: [Publicity(value: 20000.0), Money(value: 500000.0)],
      modifier: [
        MessageModifier(message: "GEKLÄRT: Das Vertrauen der Geldgeber wurde mühsam wiederhergestellt."),
        RemoveTask(task: "Sponsoren-Rückzug (Krise)"),
      ],
      missed: [
        SubtractRes(ressources: [Money(value: 2000000.0), Faith(value: 5000.0)]),
        RemoveTask(task: "Sponsoren-Rückzug (Krise)"),
        AddTask(task: "Sponsoren-Rückzug (Krise)"),
      ],
    ),
  ],
);
