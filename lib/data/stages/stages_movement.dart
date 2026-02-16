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
  award: [Faith(value: 100.0), Wisdom(value: 50.0)],
);

final List<Stage> movementStages = [
  // STAGE 11: Beeinflussende Kirche (Max 4500)
  Stage(
    level: 11,
    member: 4500,
    description: "Beeinflussende Kirche - DNA-Transfer in die Regionen.",
    activeTasks: ["Bibellesen", "Schlafen", "Pionier-Team aussenden", "Der Heilige Geist möchte wirken"],
    allTasks: [
      _moveBible,
      _moveSleep,
      Task(
        name: "Der Heilige Geist möchte wirken",
        description: "KRITISCH: Gottes Wirken hat Vorrang vor Strukturen.",
        duration: 1000.0,
        timeToSolve: 10000.0,
        award: [Faith(value: 200.0), Wisdom(value: 20.0)],
        online: [MessageModifier(message: "GEISTLICH: Eine geistliche Aufbruchsstimmung! Reagiere sofort.")],
        missed: [
          SubtractRes(ressources: [Faith(value: 100.0)]),
          MessageModifier(message: "DÄMPFUNG: Die Chance für einen Aufbruch wurde verpasst."),
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
            ]
          ),
          AddTask(task: "Regionale Leiter-Akademie"),
        ],
      ),
      Task(
        name: "Regionale Leiter-Akademie",
        description: "MEILENSTEIN: Systematische Ausbildung auf Führungsebene (Limit 10000).",
        duration: 60000.0,
        cost: [Money(value: 25000.0), Wisdom(value: 800.0), Member(value: 200.0)],
        modifier: [
          MessageModifier(message: "BILDUNG: Die Akademie sichert die Zukunft der Bewegung. Limit 10.000!"),
          SetMax(ressource: "Member", newMax: 10000.0),
        ],
      ),
    ],
  ),

  // STAGE 12: Eine Bewegung Level 1 (Max 10000)
  Stage(
    level: 12,
    member: 10000,
    description: "Eine Bewegung - Die Strukturen werden national relevant.",
    activeTasks: ["Bibellesen", "Schlafen", "Nationale Lobbyarbeit", "Kollekte"],
    allTasks: [
      _moveBible,
      _moveSleep,
      Task(
        name: "Kollekte",
        duration: 3000.0,
        cost: [Time(value: 1.0)],
        modifier: [MultiplyRes(targetResName: "Money", factorResName: "Member", multiplier: 6.0)],
      ),
      Task(
        name: "Nationale Lobbyarbeit",
        description: "Einflussnahme auf gesellschaftliche Werte.",
        duration: 20000.0,
        cost: [Money(value: 10000.0), Publicity(value: 100.0)],
        award: [Wisdom(value: 100.0), Publicity(value: 300.0)],
      ),
      Task(
        name: "Nationale Struktur etablieren",
        description: "MEILENSTEIN: Vernetzung aller Standorte (Limit 20000).",
        duration: 50000.0,
        cost: [Money(value: 100000.0), Wisdom(value: 1500.0)],
        modifier: [
          MessageModifier(message: "STRUKTUR: Ihr seid nun eine nationale Kraft! Limit 20.000!"),
          SetMax(ressource: "Member", newMax: 20000.0),
        ],
      ),
    ],
  ),

  // STAGE 13: Eine Bewegung Level 2 (Max 20000) - SAMY: DNA & Kulturelle Relevanz
  Stage(
    level: 13,
    member: 20000,
    description: "Eine Bewegung - Fokus auf DNA-Transfer und Identität.",
    activeTasks: ["Bibellesen", "Kollekte", "DNA-Transfer Workshop", "Fernsehsendung produzieren"],
    randomTasks: ["Theologische Grundsatzfrage (Krise)"],
    allTasks: [
      _moveBible,
      Task(
        name: "DNA-Transfer Workshop",
        description: "Kernwerte in alle Regionen exportieren.",
        duration: 25000.0,
        cost: [Time(value: 5.0), Wisdom(value: 500.0), Faith(value: 200.0)],
        award: [Faith(value: 300.0), Wisdom(value: 200.0)],
      ),
      Task(
        name: "Fernsehsendung produzieren",
        description: "Das Evangelium über Massenmedien verbreiten (Inspiration: oldstages).",
        duration: 30000.0,
        cost: [Money(value: 50000.0), Publicity(value: 500.0)],
        award: [Publicity(value: 1000.0), Member(value: 1000.0)],
      ),
      Task(
        name: "Theologische Grundsatzfrage (Krise)",
        description: "GEFAHR: Ein Konflikt über die DNA der Bewegung droht alles zu spalten.",
        duration: 20000.0,
        timeToSolve: 60000.0,
        cost: [Wisdom(value: 1000.0), Faith(value: 500.0)],
        online: [MessageModifier(message: "DNA-ALARM: Eine theologische Kontroverse gefährdet die Einheit!")],
        missed: [
          SubtractRes(ressources: [Member(value: 2000.0), Faith(value: 500.0)]),
          MessageModifier(message: "SPALTUNG: Wegen ungeklärter Grundsatzfragen haben sich ganze Regionen abgespalten."),
          AddTask(task: "Theologische Grundsatzfrage (Krise)")
        ],
      ),
      Task(
        name: "Internationale Konferenz",
        description: "MEILENSTEIN: Vernetzung über Landesgrenzen hinweg (Limit 50000).",
        duration: 60000.0,
        cost: [Money(value: 200000.0), Publicity(value: 1000.0), Wisdom(value: 2000.0)],
        modifier: [
          MessageModifier(message: "GLOBAL: Ihr seid nun bereit für den Kontinentalen Sprung! Limit 50.000."),
          SetMax(ressource: "Member", newMax: 50000.0),
        ],
      ),
    ],
  ),

  // STAGE 14: Eine Bewegung Level 3 (Max 50000) - SAMY: Massen-Mobilisierung
  Stage(
    level: 14,
    member: 50000,
    description: "Eine Bewegung - Die Massen mobilisieren.",
    activeTasks: ["Kollekte", "Soziale Brennpunkt-Offensive", "Krisen-Interventions-Team"],
    allTasks: [
      _moveSleep,
      Task(
        name: "Soziale Brennpunkt-Offensive",
        description: "Städte durch Taten der Nächstenliebe verändern (Inspiration: oldstages).",
        duration: 40000.0,
        cost: [Money(value: 150000.0), Member(value: 1000.0)],
        award: [Publicity(value: 5000.0), Faith(value: 1000.0)],
        modifier: [
          AutoExecuteModifier(
            intervalMs: 30000,
            modifiers: [
              MultiplyRes(targetResName: "Member", factorResName: "Member", multiplier: 0.01),
            ]
          ),
        ],
      ),
      Task(
        name: "Krisen-Interventions-Team",
        description: "Professionelle Hilfe bei Katastrophen weltweit.",
        duration: 35000.0,
        cost: [Money(value: 100000.0), Wisdom(value: 1000.0)],
        award: [Publicity(value: 8000.0), Member(value: 2000.0)],
      ),
      Task(
        name: "Globales Headquarter gründen",
        description: "MEILENSTEIN: Ein Kontrollzentrum für die Weltmission (Limit 100000).",
        duration: 80000.0,
        cost: [Money(value: 500000.0), Wisdom(value: 5000.0), Member(value: 5000.0)],
        modifier: [
          MessageModifier(message: "EXPANSION: Euer Headquarter leitet nun Millionen. Limit 100.000!"),
          SetMax(ressource: "Member", newMax: 100000.0),
        ],
      ),
    ],
  ),
];
