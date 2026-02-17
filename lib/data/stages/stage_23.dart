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

final Stage stage23 = Stage(
  level: 23,
  member: 15000000,
  description: "Globale Bewegung Level 7 - Kulturelle Prägung durch Multiplikation.",
  activeTasks: [
    "Bibellesen", 
    "Schlafen", 
    "Kollekte", 
    "Globales Mentoring-Netzwerk", 
    "Globale Strategieklausur"
  ],
  randomTasks: ["Theologische Grundsatzfrage (Krise)", "Der Heilige Geist möchte wirken"],
  allTasks: [
    baseBible,
    baseSleep,
    collectMoney,
    holySpiritWorking,
    Task(
      name: "Kollekte",
      duration: 3000.0,
      cost: [Time(value: 1.0)],
      modifier: [MultiplyRes(targetResName: "Money", factorResName: "Member", multiplier: 45.0)],
    ),
    Task(
      name: "Globales Mentoring-Netzwerk",
      description: "DELEGATION: Sichert die geistliche Qualität durch dezentrale Leiterschaftsbegleitung.",
      duration: 150000.0,
      cost: [Wisdom(value: 25000.0), Faith(value: 10000.0)],
      modifier: [
        AutoExecuteModifier(
          intervalMs: 20000,
          modifiers: [
            MultiplyRes(targetResName: "Faith", factorResName: "Member", multiplier: 0.0002),
            MultiplyRes(targetResName: "Wisdom", factorResName: "Member", multiplier: 0.0003),
          ]
        ),
      ],
    ),
    Task(
      name: "Globale Strategieklausur",
      description: "BEFÄHIGUNG: Erarbeitet das moralische Fundament für den nächsten globalen Schritt.",
      duration: 100000.0,
      cost: [Wisdom(value: 10000.0), Time(value: 50.0)],
      award: [Wisdom(value: 5000.0)],
      modifier: [
        AddTask(task: "Vom Einfluss zur Prägung"),
        RemoveTask(task: "Globale Strategieklausur"),
      ],
    ),
    Task(
      name: "Vom Einfluss zur Prägung",
      description: "MEILENSTEIN: Die Bewegung wird zum moralischen Kompass der Weltgemeinschaft (Limit 30.000.000).",
      duration: 200000.0,
      isMilestone: true,
      cost: [Wisdom(value: 50000.0), Time(value: 100.0), Faith(value: 40000.0)],
      award: [Member(value: 1.0)],
      modifier: [
        MessageModifier(message: "GLOBAL: Eure Stimme prägt nun die Weltwerte. Limit 30.000.000!"),
        SetMax(ressource: "Member", newMax: 30000000.0),
        RemoveTask(task: "Vom Einfluss zur Prägung"),
        AddTask(task: "Globalen moralischen Kompass halten"),
      ],
    ),
    Task(
      name: "Globalen moralischen Kompass halten",
      description: "WARTUNG: Stetige Vertretung christlicher Werte in globalen Gremien.",
      duration: 60000.0,
      cost: [Time(value: 10.0), Wisdom(value: 5000.0)],
      award: [Faith(value: 1000.0), Publicity(value: 5000.0)],
    ),
    Task(
      name: "Theologische Grundsatzfrage (Krise)",
      description: "KRISE: Eine DNA-Kontroverse droht die globale Einheit zu spalten!",
      duration: 30000.0,
      timeToSolve: 80000.0,
      cost: [Wisdom(value: 10000.0), Faith(value: 5000.0)],
      modifier: [
        MessageModifier(message: "GEKLÄRT: Die geistliche Identität wurde erfolgreich bewahrt."),
        RemoveTask(task: "Theologische Grundsatzfrage (Krise)"),
      ],
      missed: [
        SubtractRes(ressources: [Member(value: 500000.0), Faith(value: 5000.0)]),
        MessageModifier(message: "SPALTUNG: Der ungelöste Konflikt hat Millionen von Mitgliedern gekostet."),
        RemoveTask(task: "Theologische Grundsatzfrage (Krise)"),
        AddTask(task: "Theologische Grundsatzfrage (Krise)"),
      ],
    ),
  ],
);
