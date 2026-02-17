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

final Stage stage28 = Stage(
  level: 28,
  member: 500000000,
  description: "Denomination Level 3 - Globales technologisches Zeugnis.",
  activeTasks: [
    "Bibellesen", 
    "Schlafen", 
    "Kollekte", 
    "AI-Seelsorge-Netzwerk", 
    "Globale Zählung vorbereiten"
  ],
  randomTasks: ["Satelliten-Hack (Krise)", "Der Heilige Geist möchte wirken"],
  allTasks: [
    baseBible,
    baseSleep,
    collectMoney,
    holySpiritWorking,
    Task(
      name: "AI-Seelsorge-Netzwerk",
      description: "DELEGATION: KI-gestützte Begleitung sichert die geistliche Qualität bei Milliarden von Gläubigen.",
      duration: 180000.0,
      cost: [Money(value: 2000000000.0), Wisdom(value: 200000.0)],
      modifier: [
        MessageModifier(message: "SYSTEM: Das Netzwerk ist online. Glaube und Weisheit generieren sich nun passiv."),
        AutoExecuteModifier(
          intervalMs: 30000,
          modifiers: [
            MultiplyRes(targetResName: "Faith", factorResName: "Member", multiplier: 0.0005),
            MultiplyRes(targetResName: "Wisdom", factorResName: "Member", multiplier: 0.0001),
          ]
        ),
        RemoveTask(task: "AI-Seelsorge-Netzwerk"),
      ],
    ),
    Task(
      name: "Globale Zählung vorbereiten",
      description: "BEFÄHIGUNG: Erfasst die Reichweite der Bewegung auf allen Kontinenten.",
      duration: 100000.0,
      cost: [Wisdom(value: 50000.0), Time(value: 50.0)],
      award: [Wisdom(value: 10000.0)],
      modifier: [
        AddTask(task: "Die erste Milliarden-Marke"),
        RemoveTask(task: "Globale Zählung vorbereiten"),
      ],
    ),
    Task(
      name: "Die erste Milliarden-Marke",
      description: "MEILENSTEIN: Jedes achte Lebewesen gehört zur Bewegung (Limit 1.280.000.000).",
      duration: 600000.0,
      isMilestone: true,
      cost: [Wisdom(value: 400000.0), Time(value: 200.0), Faith(value: 200000.0)],
      award: [Member(value: 1.0)],
      modifier: [
        MessageModifier(message: "HISTORISCH: Eine Milliarde Seelen! Das Ende der Weltphase rückt näher. Limit 1.280.000.000!"),
        SetMax(ressource: "Member", newMax: 1280000000.0),
        RemoveTask(task: "Die erste Milliarden-Marke"),
        AddTask(task: "Milliarden-Bewegung stabilisieren"),
      ],
    ),
    Task(
      name: "Milliarden-Bewegung stabilisieren",
      description: "WARTUNG: Koordination der globalen Massenbewegung.",
      duration: 80000.0,
      cost: [Time(value: 20.0), Wisdom(value: 20000.0)],
      award: [Faith(value: 10000.0), Publicity(value: 10000.0)],
    ),
    Task(
      name: "Satelliten-Hack (Krise)",
      description: "KRISE: Ein feindliches Regime versucht eure globale Kommunikations-Infrastruktur lahmzulegen!",
      duration: 40000.0,
      timeToSolve: 100000.0,
      cost: [Wisdom(value: 100000.0), Money(value: 500000000.0)],
      modifier: [
        MessageModifier(message: "ABGEWEHRT: Die Satelliten sind wieder unter eurer Kontrolle."),
        RemoveTask(task: "Satelliten-Hack (Krise)"),
      ],
      missed: [
        SubtractRes(ressources: [Publicity(value: 500000.0), Faith(value: 50000.0)]),
        MessageModifier(message: "KASKADE: Die Sabotage führt zu einem globalen Kommunikations-Blackout!"),
        RemoveTask(task: "Satelliten-Hack (Krise)"),
        AddTask(task: "Kommunikations-Blackout (Krise)"),
      ],
    ),
    Task(
      name: "Kommunikations-Blackout (Krise)",
      description: "FOLGE-KRISE: Die Verbindung zu Milliarden Mitgliedern ist unterbrochen. Repariere das Netzwerk.",
      duration: 60000.0,
      cost: [Wisdom(value: 200000.0), Money(value: 1000000000.0)],
      modifier: [
        MessageModifier(message: "WIEDER ONLINE: Das Signal ist weltweit wieder empfangbar."),
        RemoveTask(task: "Kommunikations-Blackout (Krise)"),
      ],
      missed: [
        SubtractRes(ressources: [Member(value: 10000000.0)]),
        RemoveTask(task: "Kommunikations-Blackout (Krise)"),
        AddTask(task: "Kommunikations-Blackout (Krise)"),
      ],
    ),
  ],
);
