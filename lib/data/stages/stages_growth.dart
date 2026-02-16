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
  award: [Faith(value: 20.0), Wisdom(value: 10.0)],
);

final List<Stage> growthStages = [
  // STAGE 4: Kleine Gemeinde (Max 200) - SAMY: Jüngerschaft & Mentoring
  Stage(
    level: 4,
    member: 200,
    description: "Wachstum durch persönliche Begleitung.",
    activeTasks: ["Bibellesen", "Schlafen", "Mentoring", "Korps aufräumen"],
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
        name: "Korps aufräumen",
        description: "Immer schön Ordnung schaffen (Inspiration: oldstages).",
        duration: 20000.0,
        timeToSolve: 70000.0,
        cost: [Time(value: 1.0)],
        award: [Wisdom(value: 5.0)],
        missed: [AddTask(task: "Ein zwischenmenschliches Problem klären")],
        modifier: [AddTask(task: "Korps fegen und putzen")],
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

  // STAGE 5: Große Gemeinde (Max 400) - SAMY: Spezialisierung
  Stage(
    level: 5,
    member: 400,
    description: "Struktur wird lebensnotwendig.",
    activeTasks: ["Bibellesen", "Schlafen", "Gottesdienst-Teams", "Jemand möchte heiraten"],
    allTasks: [
      _growthBible,
      _growthSleep,
      Task(
        name: "Jemand möchte heiraten",
        description: "Ein Paar bittet um Trauung (Inspiration: oldstages).",
        duration: 10000.0,
        cost: [Time(value: 0.5), Faith(value: 50.0), Wisdom(value: 50.0)],
        modifier: [AddTask(task: "Heiratsvorbereitung 1")],
      ),
      Task(
        name: "Heiratsvorbereitung 1",
        description: "In einer Beziehung muss man richtig streiten und versöhnen lernen.",
        duration: 10000.0,
        cost: [Time(value: 1.5), Faith(value: 50.0), Wisdom(value: 50.0)],
        award: [Faith(value: 60.0), Wisdom(value: 60.0)],
        modifier: [AddTask(task: "Hochzeit")],
      ),
      Task(
        name: "Hochzeit",
        description: "Sie dürfen die Braut jetzt küssen!",
        duration: 10000.0,
        cost: [Time(value: 3.0), Faith(value: 50.0), Wisdom(value: 50.0)],
        award: [Member(value: 0.5), Faith(value: 70.0), Wisdom(value: 60.0), Money(value: 200.0)],
      ),
      Task(
        name: "Gottesdienst-Teams",
        description: "DELEGATION (EFFEKT): Du gibst erste Aufgaben ab.",
        duration: 10000.0,
        cost: [Time(value: 4.0), Wisdom(value: 100.0)],
        award: [Time(value: 1.0)], 
        modifier: [AddTask(task: "Bereichsleiter einsetzen")],
      ),
      Task(
        name: "Bereichsleiter einsetzen",
        description: "MEILENSTEIN: Spezialisierung ermöglicht Wachstum auf 600.",
        duration: 25000.0,
        cost: [Time(value: 12.0), Wisdom(value: 300.0), Member(value: 100.0)],
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
    description: "Professionalität & Stadtmission.",
    activeTasks: ["Bibellesen", "Einsatzwagen anschaffen", "Kollekte", "Kinderprogramm"],
    allTasks: [
      _growthSleep,
      Task(
        name: "Kinderprogramm",
        description: "Wie ein Hauskreis, nur viel anstrengender (Inspiration: oldstages).",
        duration: 8000.0,
        cost: [Time(value: 4.0), Money(value: 4.0), Faith(value: 10.0)],
        award: [Faith(value: 30.0), Member(value: 2.0)],
      ),
      Task(
        name: "Einsatzwagen anschaffen",
        description: "Eine alte Klapperkiste für den Kotti.",
        duration: 20000.0,
        cost: [Money(value: 600.0), Wisdom(value: 5.0)],
        modifier: [AddTask(task: "Für den Einsatzwagen einkaufen")],
      ),
      Task(
        name: "Für den Einsatzwagen einkaufen",
        duration: 3000.0,
        cost: [Time(value: 2.0), Money(value: 2.0)],
        award: [Publicity(value: 6.0)],
        modifier: [AddTask(task: "Mit dem Einsatzwagen raus")],
      ),
      Task(
        name: "Mit dem Einsatzwagen raus",
        duration: 6000.0,
        award: [Publicity(value: 20.0), Member(value: 1.0)],
      ),
      Task(
        name: "Hauptamtliche einstellen",
        description: "MEILENSTEIN: Vollzeitkräfte für die Front (Limit 800).",
        duration: 30000.0,
        cost: [Money(value: 3000.0), Wisdom(value: 200.0)],
        award: [Time(value: 5.0)],
        modifier: [
          MessageModifier(message: "Professionalität: Erste Pastoren sind angestellt. Limit 800!"),
          SetMax(ressource: "Member", newMax: 800.0),
        ],
      ),
    ],
  ),

  // STAGE 7: Fast eine MegaChurch (Max 800)
  Stage(
    level: 7,
    member: 800,
    description: "Fokus auf Relevanz & Geistesgaben.",
    activeTasks: ["Bibellesen", "Geistesgaben entdecken", "Pressearbeit"],
    allTasks: [
      _growthSleep,
      Task(
        name: "Geistesgaben entdecken",
        description: "Findet heraus, wie man sich am besten einbringen kann.",
        duration: 5000.0,
        cost: [Time(value: 5.0), Faith(value: 20.0)],
        award: [Faith(value: 40.0), Wisdom(value: 5.0)],
      ),
      Task(
        name: "Pressearbeit",
        description: "Du willst dich in Film und Fernsehen zeigen.",
        duration: 10000.0,
        cost: [Time(value: 1.0), Publicity(value: 15.0)],
        modifier: [AddTask(task: "Interview geben")],
      ),
      Task(
        name: "Interview geben",
        duration: 5000.0,
        award: [Publicity(value: 50.0)],
      ),
      Task(
        name: "Campus-Modell planen",
        description: "MEILENSTEIN: Vorbereitung auf Multi-Site (Limit 1100).",
        duration: 30000.0,
        cost: [Time(value: 15.0), Wisdom(value: 500.0)],
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
    description: "Leitung durch Vision.",
    activeTasks: ["Bibellesen", "Budget erstellen", "Filialgemeinde gründen"],
    allTasks: [
      _growthSleep,
      Task(
        name: "Budget erstellen",
        duration: 15000.0,
        cost: [Time(value: 4.0), Wisdom(value: 100.0)],
        award: [Money(value: 500.0)],
        modifier: [AddTask(task: "Budget verteidigen")],
      ),
      Task(
        name: "Filialgemeinde gründen",
        description: "MEILENSTEIN: Ableger in Nachbarstadt (Limit 1800).",
        duration: 35000.0,
        cost: [Money(value: 5000.0), Faith(value: 500.0)],
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
    description: "MegaChurch - Management von Systemen und Teams.",
    activeTasks: ["Bibellesen", "Schlafen", "Co-Pastor einstellen", "Sekretärin anstellen"],
    allTasks: [
      _growthBible,
      _growthSleep,
      Task(
        name: "Sekretärin anstellen",
        description: "Automatisiert die Verwaltung und Pressearbeit.",
        duration: 5000.0,
        cost: [Money(value: 1500.0), Wisdom(value: 100.0)],
        award: [Time(value: 2.0)],
        modifier: [
          AutoExecuteModifier(
            intervalMs: 30000,
            modifiers: [
              MultiplyRes(targetResName: "Publicity", factorResName: "Member", multiplier: 0.05),
              MessageModifier(message: "Sekretariat: Pressemitteilung wurde automatisch versendet."),
            ]
          ),
        ],
      ),
      Task(
        name: "Co-Pastor einstellen",
        description: "DELEGATION: Er hält nun automatisch Gottesdienste.",
        duration: 8000.0,
        cost: [Money(value: 3000.0), Wisdom(value: 300.0)],
        modifier: [
          AutoExecuteModifier(
            intervalMs: 45000,
            modifiers: [
              MultiplyRes(targetResName: "Faith", factorResName: "Member", multiplier: 0.1),
              MultiplyRes(targetResName: "Member", factorResName: "Member", multiplier: 0.01),
              MessageModifier(message: "Co-Pastor: Der Sonntagsgottesdienst lief fantastisch!"),
            ]
          ),
          SetMax(ressource: "Member", newMax: 2800.0),
        ],
      ),
    ],
  ),

  // STAGE 10: Globale Bewegung (Max 2800) - SAMY: Multiplikation
  Stage(
    level: 10,
    member: 2800,
    description: "Internationale Multiplikation und Reichweite.",
    activeTasks: ["Leadership Summit", "Internationale Vision", "Heilsarmeekongress"],
    allTasks: [
      _growthSleep,
      Task(
        name: "Heilsarmeekongress",
        description: "Tausende Menschen kommen zusammen (Inspiration: Tabelle).",
        duration: 20000.0,
        cost: [Money(value: 10000.0), Faith(value: 500.0), Wisdom(value: 200.0)],
        award: [Faith(value: 1000.0), Publicity(value: 500.0), Member(value: 100.0)],
      ),
      Task(
        name: "Internationale Vision",
        description: "MEILENSTEIN: Startet globale Phase (Limit 4500).",
        duration: 50000.0,
        cost: [Money(value: 50000.0), Faith(value: 2000.0)],
        award: [Publicity(value: 1000.0)],
        modifier: [
          MessageModifier(message: "GLOBAL: Ihr seid nun eine weltweite Bewegung! Limit 4500."),
          SetMax(ressource: "Member", newMax: 4500.0),
        ],
      ),
    ],
  ),
];
