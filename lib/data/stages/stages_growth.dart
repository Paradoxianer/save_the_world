import 'package:save_the_world_flutter_app/models/addtask.model.dart';
import 'package:save_the_world_flutter_app/models/autoexecute.model.dart';
import 'package:save_the_world_flutter_app/models/faith.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/member.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/message.modifier.dart';
import 'package:save_the_world_flutter_app/models/modifier.model.dart';
import 'package:save_the_world_flutter_app/models/money.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/multiplyres.model.dart';
import 'package:save_the_world_flutter_app/models/publicity.ressource.model.dart';
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
        description: "DELEGATION (START): Kostet viel Weisheit, bringt noch keine Zeit.",
        duration: 12000.0,
        cost: [Time(value: 6.0), Wisdom(value: 50.0)],
        award: [Wisdom(value: 60.0)], 
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
        cost: [Time(value: 10.0), Wisdom(value: 200.0), Faith(value: 50.0)],
        award: [Wisdom(value: 100.0)],
        modifier: [
          MessageModifier(message: "WACHSTUMSSCHWELLE: Du hast die erste Jüngerschafts-Ebene etabliert. Limit 400!"),
          SetMax(ressource: "Member", newMax: 400.0),
        ],
      ),
    ],
  ),

  // STAGE 5: Große Gemeinde (Max 400) - SAMY: Spezialisierung (Teams)
  Stage(
    level: 5,
    member: 400,
    description: "Große Gemeinde - Struktur wird lebensnotwendig.",
    activeTasks: ["Bibellesen", "Schlafen", "Gottesdienst-Teams", "Jemand möchte heiraten"],
    allTasks: [
      _growthBible,
      _growthSleep,
      Task(
        name: "Jemand möchte heiraten",
        description: "Zwei Mitglieder möchten heiraten (aus oldstages).",
        duration: 10000.0,
        cost: [Time(value: 1.0), Wisdom(value: 50.0)],
        award: [Publicity(value: 5.0), Faith(value: 20.0)],
        modifier: [AddTask(task: "Heiratsvorbereitung")],
      ),
      Task(
        name: "Gottesdienst-Teams",
        description: "DELEGATION (EFFEKT): Du gibst erste Aufgaben ab.",
        duration: 10000.0,
        cost: [Time(value: 4.0), Wisdom(value: 50.0)],
        award: [Time(value: 1.0)], 
        modifier: [AddTask(task: "Bereichsleiter einsetzen")],
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

  // STAGE 6: Sehr große Gemeinde (Max 600) - SAMY: Professionalität
  Stage(
    level: 6,
    member: 600,
    description: "Sehr große Gemeinde - Professionalität & erste Hauptamtliche.",
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
        cost: [Money(value: 2000.0), Wisdom(value: 100.0)],
        award: [Wisdom(value: 50.0)],
        modifier: [
          AutoExecuteModifier(
            intervalMs: 30000,
            modifiers: [
              MultiplyRes(targetResName: "Faith", factorResName: "Member", multiplier: 0.1),
            ]
          ),
          AddTask(task: "PR-Manager einsetzen"),
        ],
      ),
      Task(
        name: "PR-Manager einsetzen",
        description: "MEILENSTEIN: Professionelle Kommunikation (Limit 800).",
        duration: 25000.0,
        cost: [Money(value: 1000.0), Wisdom(value: 150.0)],
        award: [Publicity(value: 100.0)],
        modifier: [
          MessageModifier(message: "RELEVANZ: Die Stadt nimmt euch wahr. Limit 800!"),
          SetMax(ressource: "Member", newMax: 800.0),
        ],
      ),
    ],
  ),

  // STAGE 7: Fast eine MegaChurch (Max 800)
  Stage(
    level: 7,
    member: 800,
    description: "Fast eine MegaChurch - Fokus auf Stadtmission.",
    activeTasks: ["Bibellesen", "Schlafen", "Stadtmission"],
    allTasks: [
      _growthBible,
      _growthSleep,
      Task(
        name: "Stadtmission",
        description: "Präsenz in der Stadt zeigen (Wirtschaftsmission aus oldstages).",
        duration: 12000.0,
        cost: [Time(value: 5.0), Money(value: 500.0)],
        award: [Publicity(value: 150.0), Member(value: 20.0)],
      ),
      Task(
        name: "Campus-Modell planen",
        description: "MEILENSTEIN: Vorbereitung auf mehrere Standorte (Limit 1100).",
        duration: 30000.0,
        cost: [Time(value: 15.0), Wisdom(value: 500.0), Faith(value: 200.0)],
        award: [Wisdom(value: 100.0)],
        modifier: [
          MessageModifier(message: "SYSTEM: Das Campus-Modell steht. Limit 1100!"),
          SetMax(ressource: "Member", newMax: 1100.0),
        ],
      ),
    ],
  ),

  // STAGE 8: MegaChurch Level 1 (Max 1100)
  Stage(
    level: 8,
    member: 1100,
    description: "MegaChurch Level 1 - Eine neue Dimension der Leitung.",
    activeTasks: ["Bibellesen", "Schlafen", "Filialgemeinde gründen", "Vision-Casting"],
    allTasks: [
      _growthBible,
      _growthSleep,
      Task(
        name: "Vision-Casting",
        description: "Begeistere die Massen für die Zukunft.",
        duration: 15000.0,
        cost: [Time(value: 4.0), Faith(value: 300.0)],
        award: [Faith(value: 500.0), Publicity(value: 50.0)],
      ),
      Task(
        name: "Filialgemeinde gründen",
        description: "MEILENSTEIN: Erster Ableger in einer Nachbarstadt (Limit 1800).",
        duration: 35000.0,
        cost: [Money(value: 5000.0), Faith(value: 500.0), Member(value: 200.0)],
        award: [Publicity(value: 200.0), Time(value: 10.0)],
        modifier: [
          MessageModifier(message: "MULTIPLIKATION: Der erste Campus ist eröffnet! Limit 1800!"),
          SetMax(ressource: "Member", newMax: 1800.0),
        ],
      ),
    ],
  ),

  // STAGE 9: MegaChurch Level 2 (Max 1800) - SAMY: System-Management
  Stage(
    level: 9,
    member: 1800,
    description: "MegaChurch Level 2 - Management von Systemen statt Menschen.",
    activeTasks: ["Bibellesen", "Schlafen", "Kollekte", "Campus-Pastoren einsetzen"],
    allTasks: [
      _growthBible,
      _growthSleep,
      Task(
        name: "Kollekte",
        duration: 3000.0,
        cost: [Time(value: 1.0)],
        modifier: [MultiplyRes(targetResName: "Money", factorResName: "Member", multiplier: 2.0)],
      ),
      Task(
        name: "Campus-Pastoren einsetzen",
        description: "DELEGATION (EXPONENTIELL): Regionale Leiter übernehmen die Front.",
        duration: 25000.0,
        cost: [Wisdom(value: 400.0), Money(value: 3000.0)],
        award: [Time(value: 15.0)], // Signifikanter Zeitgewinn
        modifier: [
          AutoExecuteModifier(
            intervalMs: 20000,
            modifiers: [
              MultiplyRes(targetResName: "Member", factorResName: "Member", multiplier: 0.01),
              MessageModifier(message: "CAMPUS: Deine Campus-Pastoren gewinnen neue Mitglieder."),
            ]
          ),
          AddTask(task: "Leadership Summit"),
        ],
      ),
      Task(
        name: "Leadership Summit",
        description: "MEILENSTEIN: Vernetzung aller Leiter (Limit 2800).",
        duration: 30000.0,
        cost: [Money(value: 10000.0), Wisdom(value: 500.0), Member(value: 500.0)],
        award: [Wisdom(value: 300.0)],
        modifier: [
          MessageModifier(message: "NETWORK: Ein globaler Standard ist etabliert. Limit 2800!"),
          SetMax(ressource: "Member", newMax: 2800.0),
        ],
      ),
    ],
  ),

  // STAGE 10: Globale Bewegung (Max 2800) - SAMY: Multiplikation als Lebensstil
  Stage(
    level: 10,
    member: 2800,
    description: "Globale Bewegung - Multiplikation in die ganze Welt.",
    activeTasks: ["Bibellesen", "Kollekte", "Eigene App entwickeln"],
    allTasks: [
      _growthBible,
      _growthSleep,
      Task(
        name: "Kollekte",
        duration: 3000.0,
        cost: [Time(value: 1.0)],
        modifier: [MultiplyRes(targetResName: "Money", factorResName: "Member", multiplier: 3.0)],
      ),
      Task(
        name: "Eigene App entwickeln",
        description: "Digitale Begleitung für tausende Menschen.",
        duration: 40000.0,
        cost: [Money(value: 25000.0), Wisdom(value: 1000.0)],
        award: [Publicity(value: 500.0), Faith(value: 200.0)],
        modifier: [
          AutoExecuteModifier(
            intervalMs: 15000,
            modifiers: [
              MultiplyRes(targetResName: "Faith", factorResName: "Member", multiplier: 0.15),
            ]
          ),
        ],
      ),
      Task(
        name: "Internationale Vision",
        description: "MEILENSTEIN: Ausbruch aus den Landesgrenzen (Limit 4500).",
        duration: 50000.0,
        cost: [Money(value: 50000.0), Faith(value: 2000.0), Member(value: 1000.0)],
        award: [Publicity(value: 1000.0)],
        modifier: [
          MessageModifier(message: "GLOBAL: Die Welt wird euer Missionsfeld. Limit 4500!"),
          SetMax(ressource: "Member", newMax: 4500.0),
        ],
      ),
    ],
  ),
];
