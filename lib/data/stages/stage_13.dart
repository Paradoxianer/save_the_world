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
import 'package:save_the_world_flutter_app/data/stages/common_tasks.dart';

final Stage stage13 = Stage(
  level: 13,
  member: 20000,
  description: "Bewegung Level 2 - DNA-Transfer und internationale Identität.",
  activeTasks: [
    "Bibellesen", 
    "Schlafen", 
    "Kollekte", 
    "DNA-Transfer Workshop", 
    "Drehbuch schreiben"
  ],
  randomTasks: ["Theologische Grundsatzfrage (Krise)", "Der Heilige Geist möchte wirken"],
  allTasks: [
    baseBible,
    baseSleep,
    collectMoney,
    holySpiritWorking,
    Task(
      name: "DNA-Transfer Workshop",
      description: "Kernwerte in alle Regionen exportieren, um Einheit zu wahren.",
      duration: 25000.0,
      cost: [Time(value: 5.0), Wisdom(value: 500.0), Faith(value: 200.0)],
      award: [Faith(value: 300.0), Wisdom(value: 200.0)],
    ),
    Task(
      name: "Drehbuch schreiben",
      description: "BEFÄHIGUNG: Die Grundlage für eine mediale Reichweite legen.",
      duration: 15000.0,
      cost: [Wisdom(value: 200.0), Time(value: 4.0)],
      award: [Wisdom(value: 100.0)],
      modifier: [
        AddTask(task: "Fernsehsendung produzieren"),
        RemoveTask(task: "Drehbuch schreiben"),
      ],
    ),
    Task(
      name: "Fernsehsendung produzieren",
      description: "Das Evangelium über Massenmedien verbreiten.",
      duration: 30000.0,
      cost: [Money(value: 50000.0), Publicity(value: 500.0)],
      award: [Publicity(value: 1000.0), Member(value: 1.0)], // Pacing
      modifier: [
        AddTask(task: "Internationale Konferenz"),
      ]
    ),
    Task(
      name: "Internationale Konferenz",
      description: "MEILENSTEIN: Vernetzung über Landesgrenzen hinweg (Limit 50.000).",
      duration: 60000.0,
      isMilestone: true,
      cost: [Money(value: 200000.0), Publicity(value: 1000.0), Wisdom(value: 2000.0)],
      award: [Member(value: 1.0)],
      modifier: [
        MessageModifier(message: "DURCHBRUCH: Globale Einheit erreicht! Limit auf 50.000 erhöht."),
        SetMax(ressource: "Member", newMax: 50000.0),
        RemoveTask(task: "Internationale Konferenz"),
        AddTask(task: "Internationale Allianz pflegen"),
      ],
    ),
    Task(
      name: "Internationale Allianz pflegen",
      description: "WARTUNG: Unterstützung der weltweiten Partnernetzwerke.",
      duration: 30000.0,
      cost: [Time(value: 4.0), Wisdom(value: 500.0)],
      award: [Faith(value: 200.0), Publicity(value: 100.0)],
    ),
    Task(
      name: "Theologische Grundsatzfrage (Krise)",
      description: "KRISE: Eine DNA-Kontroverse gefährdet die Einheit der Bewegung!",
      duration: 20000.0,
      timeToSolve: 60000.0,
      cost: [Wisdom(value: 1000.0), Faith(value: 500.0)],
      award: [Wisdom(value: 200.0)],
      modifier: [
        MessageModifier(message: "GELÖST: Die Identität der Bewegung wurde erfolgreich verteidigt."),
        RemoveTask(task: "Theologische Grundsatzfrage (Krise)"),
      ],
      missed: [
        SubtractRes(ressources: [Member(value: 2000.0), Faith(value: 500.0)]),
        MessageModifier(message: "SPALTUNG: Ungeklärte Fragen führten zu regionalen Abspaltungen."),
        RemoveTask(task: "Theologische Grundsatzfrage (Krise)"),
        AddTask(task: "Theologische Grundsatzfrage (Krise)"),
      ],
    ),
  ],
);
