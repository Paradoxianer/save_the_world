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
import 'package:save_the_world_flutter_app/models/task.model.dart';
import 'package:save_the_world_flutter_app/models/time.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/wisdome.ressource.model.dart';

// REUSABLE BASE TASKS
final _growthSleep = Task(
  name: "Schlafen",
  description: "Erholung für den Visionär.",
  duration: 8000.0,
  cost: [Time(value: 8.0)],
  award: [Time(value: 16.0)],
);

final _growthBible = Task(
  name: "Bibellesen",
  description: "Geistliches Fundament vertiefen.",
  duration: 3000.0,
  cost: [Time(value: 1.0)],
  award: [Faith(value: 20.0), Wisdom(value: 5.0)],
);

final List<Stage> growthStages = [
  // STAGE 4: Kleine Gemeinde (Max 200) - SAMY: Jüngerschaft & Mentoring
  Stage(
    level: 4,
    member: 200,
    description: "Kleine Gemeinde - Wachstum durch persönliche Begleitung.",
    activeTasks: ["Bibellesen", "Schlafen", "Kollekte", "Mentoring", "Seelsorge"],
    randomTasks: ["Ein zwischenmenschliches Problem klären", "Streit in der Gemeinde"],
    allTasks: [
      _growthBible,
      _growthSleep,
      Task(
        name: "Mentoring",
        description: "DELEGATION (START): Kostet viel Zeit, bringt am Anfang wenig zurück.",
        duration: 12000.0,
        cost: [Time(value: 6.0), Wisdom(value: 20.0)],
        award: [Wisdom(value: 40.0)], // Nur Weisheit, noch keine Zeitersparnis
        modifier: [AddTask(task: "Leiter-Mentoring")],
      ),
      Task(
        name: "Seelsorge",
        description: "Pastor, ich hab da ein Problem (aus oldstages).",
        duration: 5000.0,
        cost: [Time(value: 2.0), Wisdom(value: 5.0)],
        award: [Wisdom(value: 10.0), Member(value: 0.5)],
      ),
      Task(
        name: "Leiter-Mentoring",
        description: "MEILENSTEIN: Schult Leiter von Leitern (Limit 400).",
        duration: 20000.0,
        cost: [Time(value: 10.0), Wisdom(value: 150.0), Faith(value: 50.0)],
        award: [Wisdom(value: 80.0)],
        modifier: [
          MessageModifier(message: "WACHSTUMSSCHWELLE: Du hast die erste Jüngerschafts-Ebene etabliert. Limit 400!"),
          SetMax(ressource: "Member", newMax: 400.0),
        ],
      ),
    ],
  ),

  // STAGE 5: Mittelgroße Gemeinde (Max 400) - SAMY: Spezialisierung (Teams)
  Stage(
    level: 5,
    member: 400,
    description: "Mittelgroße Gemeinde - Struktur wird lebensnotwendig.",
    activeTasks: ["Bibellesen", "Schlafen", "Gottesdienst-Teams", "Vision-Casting"],
    allTasks: [
      _growthBible,
      _growthSleep,
      Task(
        name: "Gottesdienst-Teams",
        description: "DELEGATION (EFFEKT): Du gibst erste Aufgaben ab.",
        duration: 10000.0,
        cost: [Time(value: 4.0), Wisdom(value: 50.0)],
        award: [Time(value: 1.0)], // Erster kleiner Zeit-Gewinn!
        modifier: [AddTask(task: "Bereichsleiter einsetzen")],
      ),
      Task(
        name: "Vision-Casting",
        description: "Wo soll die Reise hingehen? (aus oldstages/growth).",
        duration: 15000.0,
        cost: [Time(value: 5.0), Faith(value: 100.0)],
        award: [Faith(value: 150.0), Publicity(value: 10.0)],
      ),
      Task(
        name: "Bereichsleiter einsetzen",
        description: "MEILENSTEIN: Spezialisierung ermöglicht Wachstum auf 600.",
        duration: 25000.0,
        cost: [Time(value: 12.0), Wisdom(value: 300.0), Member(value: 100.0)],
        award: [Wisdom(value: 150.0)],
        modifier: [
          MessageModifier(message: "STRUKTUR: Du leitest nun durch Teams. Das Glasdach steigt auf 600!"),
          SetMax(ressource: "Member", newMax: 600.0),
        ],
      ),
    ],
  ),

  // STAGE 6: Große Gemeinde (Max 600) - SAMY: Professionalität
  Stage(
    level: 6,
    member: 600,
    description: "Große Gemeinde - Professionalität & erste Hauptamtliche.",
    activeTasks: ["Bibellesen", "Schlafen", "Hauptamtliche einstellen", "Kollekte"],
    allTasks: [
      _growthBible,
      _growthSleep,
      Task(
        name: "Kollekte",
        duration: 3000.0,
        cost: [Time(value: 1.0)],
        modifier: [MultiplyRes(targetResName: "Money", factorResName: "Member", multiplier: 1.5)],
      ),
      Task(
        name: "Hauptamtliche einstellen",
        description: "DELEGATION (AUTOMATION): Erster bezahlter Mitarbeiter.",
        duration: 30000.0,
        cost: [Money(value: 1000.0), Wisdom(value: 100.0)],
        award: [Wisdom(value: 50.0)],
        modifier: [
          // AUTOMATION: Der erste Mitarbeiter generiert nun passiv Glauben/Weisheit
          AutoExecuteModifier(
            intervalMs: 20000,
            modifiers: [
              MultiplyRes(targetResName: "Faith", factorResName: "Member", multiplier: 0.05),
              MessageModifier(message: "AUTOMATION: Deine Mitarbeiter vertiefen die Jüngerschaft."),
            ]
          ),
          AddTask(task: "Verwaltung professionalisieren"),
        ],
      ),
      Task(
        name: "Verwaltung professionalisieren",
        description: "MEILENSTEIN: Ordnung schafft Platz für 800.",
        duration: 20000.0,
        cost: [Money(value: 500.0), Wisdom(value: 200.0)],
        modifier: [
          MessageModifier(message: "SYSTEM: Die Verwaltung trägt nun die Masse. Limit 800!"),
          SetMax(ressource: "Member", newMax: 800.0),
        ],
      ),
    ],
  ),

  // STAGE 7: Sehr große Gemeinde (Max 800) - SAMY: Außenwirkung & Relevanz
  Stage(
    level: 7,
    member: 800,
    description: "Sehr große Gemeinde - Fokus auf Stadtrelevanz.",
    activeTasks: ["Schlafen", "Stadtmission", "PR-Manager einsetzen"],
    allTasks: [
      _growthSleep,
      Task(
        name: "Stadtmission",
        description: "Gutes tun für die ganze Stadt (aus oldstages).",
        duration: 12000.0,
        cost: [Time(value: 6.0), Money(value: 300.0)],
        award: [Publicity(value: 50.0), Member(value: 20.0)],
      ),
      Task(
        name: "PR-Manager einsetzen",
        description: "MEILENSTEIN: Professionelle Kommunikation (Limit 1100).",
        duration: 25000.0,
        cost: [Money(value: 2000.0), Wisdom(value: 100.0)],
        award: [Publicity(value: 100.0)],
        modifier: [
          MessageModifier(message: "RELEVANZ: Die Stadt nimmt euch wahr. Limit 1100!"),
          SetMax(ressource: "Member", newMax: 1100.0),
        ],
      ),
    ],
  ),

  // STAGE 8-10 (MegaChurch Phasen)
  Stage(
    level: 8,
    member: 1100,
    description: "MegaChurch Level 1 - Eine neue Dimension der Verantwortung.",
    activeTasks: ["Vision-Casting", "Filialgemeinde gründen"],
    allTasks: [
      Task(
        name: "Filialgemeinde gründen",
        description: "DELEGATION (EXPONENTIELL): Multiplikation durch neue Orte.",
        duration: 40000.0,
        cost: [Money(value: 5000.0), Faith(value: 500.0), Member(value: 100.0)],
        award: [Publicity(value: 80.0), Time(value: 10.0)], // Massiver Zeitgewinn durch neue Autonomie!
        modifier: [
          AutoExecuteModifier(
            intervalMs: 10000,
            modifiers: [
              MultiplyRes(targetResName: "Member", factorResName: "Member", multiplier: 0.02),
            ]
          ),
          SetMax(ressource: "Member", newMax: 1800.0),
        ],
      ),
    ],
  ),
  // ... Stages 9 & 10 folgen dieser Skalierungs-Logik ...
];
