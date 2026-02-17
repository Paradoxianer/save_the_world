import 'package:save_the_world_flutter_app/data/stages/common_tasks.dart';
import 'package:save_the_world_flutter_app/models/addtask.model.dart';
import 'package:save_the_world_flutter_app/models/faith.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/member.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/message.modifier.dart';
import 'package:save_the_world_flutter_app/models/money.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/publicity.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/removetask.model.dart';
import 'package:save_the_world_flutter_app/models/stage.model.dart';
import 'package:save_the_world_flutter_app/models/setmax.model.dart';
import 'package:save_the_world_flutter_app/models/subtractres.model.dart';
import 'package:save_the_world_flutter_app/models/task.model.dart';
import 'package:save_the_world_flutter_app/models/time.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/wisdome.ressource.model.dart';

final Stage stage29 = Stage(
  level: 29,
  member: 1280000000,
  description: "Weltkirche Level 1 - Finale globale Strukturen.",
  activeTasks: [
    "Schlafen",
    "Milliarden-Bewegung stabilisieren",
    "Verfassungs-Konvent einberufen"
  ],
  randomTasks: ["Globale Pandemie (Krise)", "Der Heilige Geist möchte wirken"],
  allTasks: [
    baseSleep,
    holySpiritWorking,
    Task(
      name: "Milliarden-Bewegung stabilisieren",
      description: "WARTUNG: Koordination der globalen Massenbewegung, um Chaos zu verhindern.",
      duration: 80000.0,
      cost: [Time(value: 10.0), Wisdom(value: 20000.0)],
      award: [Faith(value: 10000.0), Publicity(value: 10000.0)],
    ),
    Task(
      name: "Verfassungs-Konvent einberufen",
      description: "BEFÄHIGUNG: Einberufung aller globalen Leiter zur finalen Verfassungsgebung.",
      duration: 150000.0,
      cost: [Publicity(value: 200000.0), Wisdom(value: 50000.0)],
      award: [Wisdom(value: 10000.0)],
      modifier: [
        AddTask(task: "Weltweite Verfassung unterzeichnen"),
        RemoveTask(task: "Verfassungs-Konvent einberufen"),
      ],
    ),
    Task(
      name: "Weltweite Verfassung unterzeichnen",
      description: "MEILENSTEIN: Finale rechtliche und geistliche Einheit der Weltkirche (Limit 2.560.000.000).",
      duration: 800000.0,
      isMilestone: true,
      cost: [Money(value: 1000000000.0), Faith(value: 500000.0), Wisdom(value: 500000.0)],
      award: [Member(value: 1.0)],
      modifier: [
        MessageModifier(message: "GESCHAFFT: Die Weltkirche ist nun eine rechtlich geeinte Instanz. Limit 2,56 Mrd!"),
        SetMax(ressource: "Member", newMax: 2560000000.0),
        RemoveTask(task: "Weltweite Verfassung unterzeichnen"),
        AddTask(task: "Globale Einheit wahren"),
      ],
    ),
    Task(
      name: "Globale Einheit wahren",
      description: "WARTUNG: Tägliche diplomatische Arbeit zur Sicherung des globalen Friedens.",
      duration: 100000.0,
      cost: [Time(value: 20.0), Wisdom(value: 50000.0)],
      award: [Faith(value: 20000.0), Publicity(value: 20000.0)],
    ),
    Task(
      name: "Globale Pandemie (Krise)",
      description: "KRISE: Ein unbekanntes Virus legt die Welt lahm. Dein globales Netzwerk ist die letzte Hoffnung!",
      duration: 80000.0,
      timeToSolve: 200000.0,
      cost: [Money(value: 1000000000.0), Member(value: 1000000.0)],
      award: [Publicity(value: 200000.0)],
      modifier: [
        MessageModifier(message: "HELDENHAFT: Deine Bewegung hat Millionen Leben gerettet und die Welt stabilisiert."),
        RemoveTask(task: "Globale Pandemie (Krise)"),
      ],
      missed: [
        SubtractRes(ressources: [Member(value: 50000000.0), Faith(value: 100000.0)]),
        MessageModifier(message: "KASKADE: Die Pandemie hat zu einem globalen Wirtschafts-Kollaps geführt!"),
        RemoveTask(task: "Globale Pandemie (Krise)"),
        AddTask(task: "Globaler Wirtschafts-Kollaps (Krise)"),
      ],
    ),
    Task(
      name: "Globaler Wirtschafts-Kollaps (Krise)",
      description: "FOLGE-KRISE: Weltweite Armut und Hunger bedrohen die Stabilität.",
      duration: 100000.0,
      cost: [Money(value: 5000000000.0), Wisdom(value: 200000.0)],
      modifier: [
        MessageModifier(message: "GELÖST: Deine Bewegung hat die Weltwirtschaft wieder aufgebaut."),
        RemoveTask(task: "Globaler Wirtschafts-Kollaps (Krise)"),
      ],
      missed: [
        SubtractRes(ressources: [Member(value: 100000000.0)]),
        RemoveTask(task: "Globaler Wirtschafts-Kollaps (Krise)"),
        AddTask(task: "Globaler Wirtschafts-Kollaps (Krise)"),
      ],
    ),
  ],
);
