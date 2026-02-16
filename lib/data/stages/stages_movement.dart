import 'package:save_the_world_flutter_app/models/addtask.model.dart';
import 'package:save_the_world_flutter_app/models/autoexecute.model.dart';
import 'package:save_the_world_flutter_app/models/faith.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/member.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/message.modifier.dart';
import 'package:save_the_world_flutter_app/models/modifier.model.dart';
import 'package:save_the_world_flutter_app/models/money.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/multiplyres.model.dart';
import 'package:save_the_world_flutter_app/models/publicity.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/removetask.model.dart';
import 'package:save_the_world_flutter_app/models/ressource.model.dart';
import 'package:save_the_world_flutter_app/models/stage.model.dart';
import 'package:save_the_world_flutter_app/models/setmax.model.dart';
import 'package:save_the_world_flutter_app/models/subtractres.model.dart';
import 'package:save_the_world_flutter_app/models/task.model.dart';
import 'package:save_the_world_flutter_app/models/time.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/wisdome.ressource.model.dart';

// REUSABLE BASE TASKS
final _moveSleep = Task(
  name: "Schlafen",
  description: "Erholung für die Generäle der Bewegung.",
  duration: 8000.0,
  cost: [Time(value: 8.0)],
  award: [Time(value: 16.0)],
);

final _moveBible = Task(
  name: "Bibellesen",
  description: "Spirituelle Vision für globale Expansion.",
  duration: 3000.0,
  cost: [Time(value: 1.0)],
  award: [Faith(value: 50.0), Wisdom(value: 20.0)],
);

final List<Stage> movementStages = [
  // STAGE 11: Beeinflussende Kirche (Max 4500) - SAMY: DNA & Multiplikation
  Stage(
    level: 11,
    member: 4500,
    description: "Beeinflussende Kirche - Die DNA der Bewegung verbreitet sich.",
    activeTasks: ["Bibellesen", "Schlafen", "Pionier-Team aussenden", "Der Heilige Geist möchte wirken"],
    randomTasks: ["Streit in der Bewegung", "Kassendifferenz finden"],
    allTasks: [
      _moveBible,
      _moveSleep,
      Task(
        name: "Der Heilige Geist möchte wirken",
        description: "KRITISCH: Gib dem Wirken Gottes sofort Raum!",
        duration: 1000.0,
        timeToSolve: 10000.0, // Kurz reaktionszeit!
        award: [Faith(value: 100.0), Wisdom(value: 10.0)],
        online: [MessageModifier(message: "GEISTLICH: Der Heilige Geist klopft an. Reagiere sofort!")],
        missed: [
          SubtractRes(ressources: [Faith(value: 50.0)]),
          MessageModifier(message: "DÄMPFUNG: Das Wirken Gottes wurde ignoriert. Glauben sinkt."),
          AddTask(task: "Der Heilige Geist möchte wirken")
        ],
      ),
      Task(
        name: "Pionier-Team aussenden",
        description: "DELEGATION (EXP): Ein Team gründet eigenständig neue Werke.",
        duration: 45000.0,
        cost: [Member(value: 50.0), Faith(value: 200.0), Money(value: 5000.0)],
        award: [Publicity(value: 100.0)],
        modifier: [
          AutoExecuteModifier(
            intervalMs: 15000,
            modifiers: [
              MultiplyRes(targetResName: "Member", factorResName: "Member", multiplier: 0.02),
              MessageModifier(message: "PIONIERE: Dein Team hat neue Standorte erschlossen."),
            ]
          ),
          AddTask(task: "Regionale Leiter-Akademie"),
        ],
      ),
      Task(
        name: "Streit in der Bewegung",
        description: "GEFAHR: Die Einheit ist in Gefahr (Inspiration: oldstages).",
        duration: 15000.0,
        timeToSolve: 40000.0,
        cost: [Time(value: 10.0), Wisdom(value: 100.0), Faith(value: 50.0)],
        award: [Wisdom(value: 50.0)],
        online: [MessageModifier(message: "ALARM: Ein Konflikt bedroht die Einheit der Bewegung!")],
        missed: [
          SubtractRes(ressources: [Member(value: 100.0), Faith(value: 50.0)]),
          MessageModifier(message: "SPALTUNG: Der Streit hat die Bewegung geschwächt. 100 Mitglieder verloren."),
          AddTask(task: "Streit in der Bewegung"),
        ],
      ),
      Task(
        name: "Regionale Leiter-Akademie",
        description: "MEILENSTEIN: Ausbildung von Offizieren im großen Stil (Limit 10000).",
        duration: 60000.0,
        cost: [Money(value: 20000.0), Wisdom(value: 500.0), Member(value: 200.0)],
        award: [Wisdom(value: 200.0)],
        modifier: [
          MessageModifier(message: "BILDUNG: Die Akademie produziert Leiter am Fließband. Limit 10.000!"),
          SetMax(ressource: "Member", newMax: 10000.0),
        ],
      ),
    ],
  ),

  // STAGE 12: Eine Bewegung (Max 10000) - SAMY: System-Expansion
  Stage(
    level: 12,
    member: 10000,
    description: "Eine Bewegung - Expansion als System.",
    activeTasks: ["Bibellesen", "Schlafen", "Öffentlicher Kongress", "Kollekte"],
    allTasks: [
      _moveBible,
      _moveSleep,
      Task(
        name: "Kollekte",
        duration: 3000.0,
        cost: [Time(value: 1.0)],
        modifier: [MultiplyRes(targetResName: "Money", factorResName: "Member", multiplier: 5.0)],
      ),
      Task(
        name: "Kassendifferenz finden",
        description: "GEFAHR: Mist, die Kasse stimmt nicht (Inspiration: oldstages)!",
        duration: 10000.0,
        timeToSolve: 60000.0,
        cost: [Time(value: 5.0)],
        award: [Wisdom(value: 10.0)],
        online: [MessageModifier(message: "BUCHFÜHRUNG: Ein Fehler in der Kasse wurde entdeckt!")],
        missed: [
          SubtractRes(ressources: [Money(value: 1000.0)]),
          MessageModifier(message: "VERLUST: Die Differenz konnte nicht geklärt werden. 1000 Geld wurden abgeschrieben."),
          AddTask(task: "Kassendifferenz finden")
        ],
      ),
      Task(
        name: "Öffentlicher Kongress",
        description: "Großveranstaltung zur Mobilisierung der Massen.",
        duration: 25000.0,
        cost: [Money(value: 15000.0), Faith(value: 500.0)],
        award: [Publicity(value: 500.0), Member(value: 500.0)],
        modifier: [AddTask(task: "Kirchentag organisieren")],
      ),
      Task(
        name: "Kirchentag organisieren",
        description: "MEILENSTEIN: Nationale Präsenz und Vernetzung (Limit 20000).",
        duration: 50000.0,
        cost: [Money(value: 50000.0), Wisdom(value: 1000.0), Faith(value: 1000.0)],
        award: [Publicity(value: 2000.0)],
        modifier: [
          MessageModifier(message: "RELEVANZ: Ihr seid nun eine nationale Kraft! Limit 20.000!"),
          SetMax(ressource: "Member", newMax: 20000.0),
        ],
      ),
    ],
  ),
];
