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

final Stage stage30 = Stage(
  level: 30,
  member: 2560000000,
  description: "Weltkirche Level 2 - Geistliche Kraft in Zeiten der Bedrängnis.",
  activeTasks: [
    "Schlafen",
    "Bibellesen",
    "Dienst der Heilung",
    "Geistliche Rüstung anlegen"
  ],
  randomTasks: ["Globale Christenverfolgung (Krise)", "Der Heilige Geist möchte wirken"],
  allTasks: [
    baseBible,
    baseSleep,
    holySpiritWorking,
    Task(
      name: "Geistliche Rüstung anlegen",
      description: "BEFÄHIGUNG: Stärkt die innere Widerstandskraft der globalen Gemeinschaft.",
      duration: 100000.0,
      cost: [Faith(value: 100000.0), Wisdom(value: 50000.0)],
      award: [Faith(value: 50000.0)],
      modifier: [
        AddTask(task: "Standhaftigkeit in Verfolgung"),
        RemoveTask(task: "Geistliche Rüstung anlegen"),
      ],
    ),
    Task(
      name: "Standhaftigkeit in Verfolgung",
      description: "MEILENSTEIN: Zeugnis geben bis zum Äußersten (Limit 5.120.000.000).",
      duration: 600000.0,
      isMilestone: true,
      cost: [Faith(value: 500000.0), Wisdom(value: 500000.0), Time(value: 100.0)],
      award: [Member(value: 1.0)],
      modifier: [
        MessageModifier(message: "ZEUGNIS: Euer Glaube hat die Welt erschüttert. Limit 5,12 Mrd!"),
        SetMax(ressource: "Member", newMax: 5120000000.0),
        RemoveTask(task: "Standhaftigkeit in Verfolgung"),
        AddTask(task: "Märtyrer-Gedenken"),
      ],
    ),
    Task(
      name: "Märtyrer-Gedenken",
      description: "WARTUNG: Bewahrung des Erbes und geistliche Stärkung der Verfolgten.",
      duration: 80000.0,
      cost: [Time(value: 10.0), Faith(value: 20000.0)],
      award: [Faith(value: 50000.0), Wisdom(value: 10000.0)],
    ),
    Task(
      name: "Dienst der Heilung",
      description: "SYSTEM: Gott tut Wunder weltweit. Zieht Suchende an und generiert Glauben.",
      duration: 150000.0,
      cost: [Faith(value: 1000000.0), Time(value: 5.0)],
      modifier: [
        AutoExecuteModifier(
          intervalMs: 40000,
          modifiers: [
            MultiplyRes(targetResName: "Member", factorResName: "Faith", multiplier: 0.05),
            MessageModifier(message: "WUNDER: Heilungen ereignen sich auf allen Kontinenten."),
          ]
        ),
      ],
    ),
    Task(
      name: "Globale Christenverfolgung (Krise)",
      description: "KRISE: Ein weltweites Bündnis versucht die Kirche auszulöschen! Reagiere mit Sanftmut und Weisheit.",
      duration: 50000.0,
      timeToSolve: 150000.0,
      cost: [Faith(value: 200000.0), Wisdom(value: 100000.0)],
      modifier: [
        MessageModifier(message: "TREUE: Die Kirche ist aus der Krise gestärkt hervorgegangen."),
        RemoveTask(task: "Globale Christenverfolgung (Krise)"),
      ],
      missed: [
        SubtractRes(ressources: [Member(value: 100000000.0), Faith(value: 500000.0)]),
        MessageModifier(message: "KASKADE: Deine Zentren wurden zerschlagen! Die Kirche muss in den Untergrund."),
        RemoveTask(task: "Globale Christenverfolgung (Krise)"),
        AddTask(task: "Untergrund-Netzwerke aufbauen (Krise)"),
      ],
    ),
    Task(
      name: "Untergrund-Netzwerke aufbauen (Krise)",
      description: "FOLGE-KRISE: Repariere die zerschlagenen Strukturen im Verborgenen.",
      duration: 100000.0,
      cost: [Wisdom(value: 200000.0), Time(value: 50.0)],
      modifier: [
        MessageModifier(message: "WIEDERHERGESTELLT: Die Netzwerke im Untergrund funktionieren."),
        RemoveTask(task: "Untergrund-Netzwerke aufbauen (Krise)"),
      ],
      missed: [
        SubtractRes(ressources: [Member(value: 500000000.0)]),
        RemoveTask(task: "Untergrund-Netzwerke aufbauen (Krise)"),
        AddTask(task: "Untergrund-Netzwerke aufbauen (Krise)"),
      ],
    ),
  ],
);
