import 'package:save_the_world_flutter_app/models/addtask.model.dart';
import 'package:save_the_world_flutter_app/models/faith.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/member.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/message.modifier.dart';
import 'package:save_the_world_flutter_app/models/money.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/multiplyres.model.dart';
import 'package:save_the_world_flutter_app/models/publicity.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/ressource.model.dart';
import 'package:save_the_world_flutter_app/models/stage.model.dart';
import 'package:save_the_world_flutter_app/models/setmax.model.dart';
import 'package:save_the_world_flutter_app/models/setmin.model.dart';
import 'package:save_the_world_flutter_app/models/task.model.dart';
import 'package:save_the_world_flutter_app/models/time.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/wisdome.ressource.model.dart';

// REUSABLE BASE TASKS
final _baseSleep = Task(
  name: "Schlafen",
  description: "Regeneriert 'Zeit'. WICHTIG: Ohne Zeit-Punkte kannst du keine Aufgaben starten!",
  duration: 8000.0,
  cost: [Time(value: 8.0)],
  award: [Time(value: 16.0)],
  modifier: [MessageModifier(message: "ANLEITUNG: Deine Zeit ist begrenzt. Wenn sie leer ist, musst du 'Schlafen'."),],
);

final _baseBible = Task(
  name: "Bibellesen",
  description: "Zeit investieren, um 'Glauben' zu generieren.",
  duration: 3000.0,
  cost: [Time(value: 1.0)],
  award: [Faith(value: 15.0)],
  modifier: [AddTask(task: "Beten")],
);

final List<Stage> introStages = [
  // STAGE 0: Der Ruf (Tutorial) - Max 20 Member
  Stage(
    level: 0,
    member: 20,
    description: "Hausgemeinde - Alles beginnt im Kleinen.",
    activeTasks: ["Bibellesen", "Schlafen"],
    allTasks: [
      _baseBible,
      _baseSleep,
      Task(
        name: "Beten",
        description: "Wandelt 'Glauben' in erste 'Mitglieder' um.",
        duration: 4000.0,
        cost: [Time(value: 1.0), Faith(value: 5.0)],
        award: [Member(value: 1.0)], 
        modifier: [AddTask(task: "Hausbesuch")],
      ),
      Task(
        name: "Hausbesuch",
        description: "Zeitaufwendig, aber bringt viele neue Mitglieder.",
        duration: 6000.0,
        cost: [Time(value: 3.0)],
        award: [Member(value: 2.0)], 
        modifier: [AddTask(task: "Essen in meiner Wohnung")],
      ),
      Task(
        name: "Essen in meiner Wohnung",
        description: "MEILENSTEIN: Erhöht deine maximale Mitglieder-Kapazität auf 40.",
        duration: 10000.0,
        cost: [Time(value: 4.0), Member(value: 5.0)],
        award: [Member(value: 15.0)],
        modifier: [
          MessageModifier(message: "GLÜCKWUNSCH: Du hast das Limit erhöht! Deine Wohnung ist nun ein Treffpunkt. Stufe 1 freigeschaltet."),
          SetMin(ressource: "Member", newMin: 1.0), 
          SetMax(ressource: "Member", newMax: 40.0),
        ],
      ),
    ],
  ),
  
  // STAGE 1: Gemeinschaftsgruppe - Max 40 Member
  Stage(
    level: 1,
    member: 40,
    description: "Gemeinschaftsgruppe - Die Verantwortung wächst.",
    activeTasks: ["Bibellesen", "Beten", "Hausbesuch", "Schlafen", "Kasse führen"],
    allTasks: [
      _baseBible,
      _baseSleep,
      Task(
        name: "Beten",
        description: "Gemeinsames Gebet für Wachstum.",
        duration: 4000.0,
        cost: [Time(value: 1.0), Faith(value: 10.0)],
        award: [Member(value: 2.0)], 
      ),
      Task(
        name: "Hausbesuch",
        description: "Einzelseelsorge und Einladung.",
        duration: 6000.0,
        cost: [Time(value: 2.0)],
        award: [Member(value: 1.0)], 
      ),
      Task(
        name: "Kasse führen",
        description: "Bringe Ordnung in die Finanzen. Schaltet Kollekte frei.",
        duration: 4000.0,
        cost: [Time(value: 2.0)],
        award: [Wisdom(value: 1.0)],
        modifier: [AddTask(task: "Kollekte")],
      ),
      Task(
        name: "Kollekte",
        description: "Sammelt Spenden basierend auf der Mitgliederanzahl.",
        duration: 3000.0,
        cost: [Time(value: 1.0)],
        award: [], 
        modifier: [
          MultiplyRes(targetResName: "Money", factorResName: "Member", multiplier: 0.5),
        ],
      ),
      Task(
        name: "Hauskreis-Leiter schulen",
        description: "MEILENSTEIN: Delegation ermöglicht Wachstum auf 80 Personen.",
        duration: 12000.0,
        cost: [Time(value: 6.0), Faith(value: 50.0), Wisdom(value: 10.0)],
        award: [Wisdom(value: 5.0)],
        modifier: [
          MessageModifier(message: "DELEGATION: Du leitest nicht mehr alles allein. Das Glasdach steigt auf 80!"),
          SetMax(ressource: "Member", newMax: 80.0),
        ],
      ),
    ],
  ),

  // STAGE 2: Kleine Gemeinde - Max 80 Member
  Stage(
    level: 2,
    member: 80,
    description: "Kleine Gemeinde - Fokus auf Infrastruktur.",
    activeTasks: ["Bibellesen", "Schlafen", "Kollekte", "Gottesdienst in der Wohnung"],
    allTasks: [
      _baseBible,
      _baseSleep,
      Task(
        name: "Kollekte",
        description: "Sammelt Spenden basierend auf der Mitgliederanzahl.",
        duration: 3000.0,
        cost: [Time(value: 1.0)],
        modifier: [MultiplyRes(targetResName: "Money", factorResName: "Member", multiplier: 0.6)],
      ),
      Task(
        name: "Gottesdienst in der Wohnung",
        description: "Ein festliches Treffen für alle Mitglieder.",
        duration: 5000.0,
        cost: [Time(value: 4.0), Faith(value: 20.0)],
        award: [Member(value: 3.0), Faith(value: 10.0)],
        modifier: [AddTask(task: "Saal suchen")],
      ),
      Task(
        name: "Saal suchen",
        description: "Besichtige mögliche Räumlichkeiten.",
        duration: 7000.0,
        cost: [Time(value: 3.0), Money(value: 50.0)],
        award: [Publicity(value: 2.0)],
        modifier: [AddTask(task: "Saal mieten")],
      ),
      Task(
        name: "Saal mieten",
        description: "MEILENSTEIN: Der erste eigene Raum! Erhöht das Limit auf 140.",
        duration: 15000.0,
        cost: [Time(value: 2.0), Money(value: 200.0), Member(value: 30.0)],
        award: [Publicity(value: 10.0)],
        modifier: [
          MessageModifier(message: "STRUKTUR: Ein eigener Saal! Ihr seid nun eine mittlere Gemeinde (Limit 140)."),
          SetMax(ressource: "Member", newMax: 140.0),
        ],
      ),
    ],
  ),

  // STAGE 3: Mittlere Gemeinde - Max 140 Member
  Stage(
    level: 3,
    member: 140,
    description: "Mittlere Gemeinde - Vom Clan zur Organisation.",
    activeTasks: ["Kollekte", "Schlafen", "Öffentlicher Gottesdienst"],
    allTasks: [
      _baseBible,
      _baseSleep,
      Task(
        name: "Kollekte",
        description: "Sammelt Spenden basierend auf der Mitgliederanzahl.",
        duration: 3000.0,
        cost: [Time(value: 1.0)],
        modifier: [MultiplyRes(targetResName: "Money", factorResName: "Member", multiplier: 0.8)],
      ),
      Task(
        name: "Öffentlicher Gottesdienst",
        description: "Jeden Sonntag für die ganze Stadt geöffnet.",
        duration: 6000.0,
        cost: [Time(value: 5.0), Money(value: 20.0)],
        award: [Member(value: 5.0), Publicity(value: 5.0)],
        modifier: [
          MultiplyRes(targetResName: "Faith", factorResName: "Member", multiplier: 0.2),
        ],
      ),
      Task(
        name: "Korpsrat gründen",
        description: "MEILENSTEIN: Ein Leitungsteam für die Zukunft (Limit 200).",
        duration: 20000.0,
        cost: [Time(value: 8.0), Wisdom(value: 50.0), Member(value: 60.0)],
        award: [Wisdom(value: 20.0)],
        modifier: [
          MessageModifier(message: "ORGANISATION: Ein starkes Team trägt die Last. Willkommen in Stufe 4 (Limit 200)."),
          SetMax(ressource: "Member", newMax: 200.0),
        ],
      ),
    ],
  ),
];
