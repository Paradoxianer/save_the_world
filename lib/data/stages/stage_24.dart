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
import 'package:save_the_world_flutter_app/data/stages/common_tasks.dart';

final Stage stage24 = Stage(
  level: 24,
  member: 30000000,
  description: "Globaler Beeinflusser Level 1 - Die Geburt einer weltweiten Denomination.",
  activeTasks: [
    "Bibellesen", 
    "Schlafen", 
    "Kollekte", 
    "Regional-Präsidien einsetzen", 
    "Verfassungs-Entwurf"
  ],
  randomTasks: ["Theologische Grundsatzfrage (Krise)", "Finanzprüfung (Krise)", "Der Heilige Geist möchte wirken"],
  allTasks: [
    baseBible,
    baseSleep,
    collectMoney,
    holySpiritWorking,
    Task(
      name: "Kollekte",
      duration: 3000.0,
      cost: [Time(value: 1.0)],
      modifier: [MultiplyRes(targetResName: "Money", factorResName: "Member", multiplier: 60.0)],
    ),
    Task(
      name: "Regional-Präsidien einsetzen",
      description: "DELEGATION: Dezentrale Verwaltungseinheiten stabilisieren die globalen Finanzen passiv.",
      duration: 180000.0,
      cost: [Money(value: 25000000.0), Wisdom(value: 15000.0)],
      modifier: [
        MessageModifier(message: "BÜROKRATIE: Deine Präsidien arbeiten effizient. Kollekte nun automatisiert."),
        AutoExecuteModifier(
          intervalMs: 60000,
          modifiers: [
            MultiplyRes(targetResName: "Money", factorResName: "Member", multiplier: 15.0),
          ]
        ),
        RemoveTask(task: "Regional-Präsidien einsetzen"),
      ],
    ),
    Task(
      name: "Verfassungs-Entwurf",
      description: "BEFÄHIGUNG: Juristische Vorbereitung der globalen Satzung.",
      duration: 80000.0,
      cost: [Wisdom(value: 10000.0), Time(value: 20.0)],
      award: [Wisdom(value: 2000.0)],
      modifier: [
        AddTask(task: "Globale Satzung verabschieden"),
        RemoveTask(task: "Verfassungs-Entwurf"),
      ],
    ),
    Task(
      name: "Globale Satzung verabschieden",
      description: "MEILENSTEIN: Rechtliche Anerkennung als weltweite Konfession (Limit 60.000.000).",
      duration: 250000.0,
      isMilestone: true,
      cost: [Wisdom(value: 60000.0), Time(value: 100.0), Faith(value: 30000.0)],
      award: [Member(value: 1.0)],
      modifier: [
        MessageModifier(message: "ANERKENNUNG: Die Weltgemeinschaft akzeptiert eure Statuten. Limit 60.000.000!"),
        SetMax(ressource: "Member", newMax: 60000000.0),
        RemoveTask(task: "Globale Satzung verabschieden"),
        AddTask(task: "Satzung rechtlich wahren"),
      ],
    ),
    Task(
      name: "Satzung rechtlich wahren",
      description: "WARTUNG: Stetige juristische Begleitung der weltweiten Kirchenstruktur.",
      duration: 60000.0,
      cost: [Time(value: 10.0), Wisdom(value: 5000.0)],
      award: [Faith(value: 1000.0), Publicity(value: 2000.0)],
    ),
    Task(
      name: "Finanzprüfung (Krise)",
      description: "KRISE: Der Weltrat fordert absolute Transparenz über die globalen Konten!",
      duration: 40000.0,
      timeToSolve: 100000.0,
      cost: [Wisdom(value: 15000.0), Money(value: 5000000.0)],
      modifier: [
        MessageModifier(message: "BESTANDEN: Die Prüfung war erfolgreich. Die Integrität ist gewahrt."),
        RemoveTask(task: "Finanzprüfung (Krise)"),
      ],
      missed: [
        SubtractRes(ressources: [Money(value: 20000000.0), Publicity(value: 50000.0)]),
        MessageModifier(message: "KASKADE: Korruptionsverdacht führt zum Vermögensarrest!"),
        RemoveTask(task: "Finanzprüfung (Krise)"),
        AddTask(task: "Vermögensarrest (Krise)"),
      ],
    ),
    Task(
      name: "Vermögensarrest (Krise)",
      description: "FOLGE-KRISE: Deine Konten sind weltweit eingefroren. Repariere das Vertrauen.",
      duration: 60000.0,
      cost: [Wisdom(value: 30000.0), Publicity(value: 100000.0)],
      modifier: [
        MessageModifier(message: "BEHOBEN: Der Arrest wurde aufgehoben, aber der Schaden ist groß."),
        RemoveTask(task: "Vermögensarrest (Krise)"),
      ],
      missed: [
        SubtractRes(ressources: [Member(value: 1000000.0)]),
        RemoveTask(task: "Vermögensarrest (Krise)"),
        AddTask(task: "Vermögensarrest (Krise)"),
      ],
    ),
    Task(
      name: "Theologische Grundsatzfrage (Krise)",
      description: "KRISE: Ein Konflikt über die DNA der Bewegung droht alles zu spalten.",
      duration: 30000.0,
      timeToSolve: 80000.0,
      cost: [Wisdom(value: 10000.0), Faith(value: 10000.0)],
      modifier: [
        MessageModifier(message: "GELÖST: Die Identität der Bewegung wurde erfolgreich verteidigt."),
        RemoveTask(task: "Theologische Grundsatzfrage (Krise)"),
      ],
      missed: [
        SubtractRes(ressources: [Member(value: 2000000.0), Faith(value: 5000.0)]),
        MessageModifier(message: "SPALTUNG: Ungeklärte Fragen führten zu regionalen Abspaltungen."),
        RemoveTask(task: "Theologische Grundsatzfrage (Krise)"),
        AddTask(task: "Theologische Grundsatzfrage (Krise)"),
      ],
    ),
  ],
);
