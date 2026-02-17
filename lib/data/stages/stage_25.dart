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

final Stage stage25 = Stage(
  level: 25,
  member: 60000000,
  description: "Eine Bewegung Level 3 - Die globale Durchdringung beginnt.",
  activeTasks: [
    "Bibellesen", 
    "Schlafen", 
    "Kollekte", 
    "Globales Jüngerschafts-Netzwerk", 
    "Kontinentale Strategieplanung"
  ],
  randomTasks: ["Währungskrise (Krise)", "Der Heilige Geist möchte wirken"],
  allTasks: [
    baseBible,
    baseSleep,
    collectMoney,
    holySpiritWorking,
    Task(
      name: "Kollekte",
      duration: 3000.0,
      cost: [Time(value: 1.0)],
      modifier: [MultiplyRes(targetResName: "Money", factorResName: "Member", multiplier: 100.0)],
    ),
    Task(
      name: "Globales Jüngerschafts-Netzwerk",
      description: "DELEGATION: Dezentrale Strukturen zur Begleitung von Millionen Gläubigen weltweit.",
      duration: 150000.0,
      cost: [Wisdom(value: 20000.0), Money(value: 5000000.0)],
      modifier: [
        MessageModifier(message: "MULTIPLIKATION: Das Netzwerk wächst nun eigenständig durch Jüngerschaft."),
        AutoExecuteModifier(
          intervalMs: 40000,
          modifiers: [
            MultiplyRes(targetResName: "Member", factorResName: "Faith", multiplier: 0.02),
          ]
        ),
        RemoveTask(task: "Globales Jüngerschafts-Netzwerk"),
      ],
    ),
    Task(
      name: "Kontinentale Strategieplanung",
      description: "BEFÄHIGUNG: Erarbeitet die Vision für den Sprung auf 100 Millionen Mitglieder.",
      duration: 100000.0,
      cost: [Wisdom(value: 15000.0), Time(value: 50.0)],
      award: [Wisdom(value: 5000.0)],
      modifier: [
        AddTask(task: "Weltweite Allianz festigen"),
        RemoveTask(task: "Kontinentale Strategieplanung"),
      ],
    ),
    Task(
      name: "Weltweite Allianz festigen",
      description: "MEILENSTEIN: Offizieller Zusammenschluss aller kontinentalen Verbände (Limit 100.000.000).",
      duration: 250000.0,
      isMilestone: true,
      cost: [Money(value: 50000000.0), Wisdom(value: 100000.0), Publicity(value: 50000.0)],
      award: [Member(value: 1.0)],
      modifier: [
        MessageModifier(message: "DURCHBRUCH: Die globale Allianz ist unerschütterlich. Limit 100.000.000!"),
        SetMax(ressource: "Member", newMax: 100000000.0),
        RemoveTask(task: "Weltweite Allianz festigen"),
        AddTask(task: "Allianz operativ führen"),
      ],
    ),
    Task(
      name: "Allianz operativ führen",
      description: "WARTUNG: Tägliche Abstimmung der weltweiten Kirchenleitung.",
      duration: 60000.0,
      cost: [Time(value: 10.0), Wisdom(value: 10000.0)],
      award: [Faith(value: 2000.0), Publicity(value: 5000.0)],
    ),
    Task(
      name: "Währungskrise (Krise)",
      description: "KRISE: Instabile Märkte bedrohen die globalen Rücklagen der Allianz!",
      duration: 30000.0,
      timeToSolve: 80000.0,
      cost: [Wisdom(value: 20000.0), Money(value: 10000000.0)],
      modifier: [
        MessageModifier(message: "STABILISIERT: Kluge Umschichtungen haben den Staatsbankrott abgewendet."),
        RemoveTask(task: "Währungskrise (Krise)"),
      ],
      missed: [
        SubtractRes(ressources: [Money(value: 100000000.0), Publicity(value: 20000.0)]),
        MessageModifier(message: "FINANZKOLLAPS: Massive Verluste schränken die globale Handlungsfähigkeit ein!"),
        RemoveTask(task: "Währungskrise (Krise)"),
        AddTask(task: "Währungskrise (Krise)"),
      ],
    ),
  ],
);
