import 'package:flutter/material.dart';
import 'package:save_the_world_flutter_app/models/addtask.model.dart';
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
import 'package:save_the_world_flutter_app/models/setmin.model.dart';
import 'package:save_the_world_flutter_app/models/subtractres.model.dart';
import 'package:save_the_world_flutter_app/models/task.model.dart';
import 'package:save_the_world_flutter_app/models/time.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/wisdome.ressource.model.dart';

final List<Stage> introStages = [
  // STAGE 0: Der Ruf (Mechanik-Tutorial)
  Stage(
    level: 0,
    member: 20,
    description: "Hausgemeinde - Lerne die Grundlagen der Ressourcenverwaltung.",
    activeTasks: ["Bibellesen", "Schlafen"],
    allTasks: [
      Task(
        name: "Bibellesen",
        description: "Zeit investieren, um 'Glauben' (Ressource) zu generieren.",
        duration: 3000.0,
        cost: [Time(value: 1.0)],
        award: [Faith(value: 15.0)],
        modifier: [
          AddTask(task: "Beten"),
          MessageModifier(message: "BASICS: Aufgaben kosten links angezeigte Ressourcen (hier 1x Zeit) und bringen rechts Belohnungen (hier Glauben)."),
        ],
      ),
      Task(
        name: "Beten",
        description: "Wandelt 'Glauben' in erste 'Mitglieder' um.",
        duration: 4000.0,
        cost: [Time(value: 1.0), Faith(value: 5.0)],
        award: [Member(value: 1.0)], 
        modifier: [
          AddTask(task: "Hausbesuch"),
          MessageModifier(message: "ACHTUNG: 'Beten' benötigt Zeit UND Glauben. Hast du von einer Ressource zu wenig, wird die Karte blass und lässt sich nicht starten!"),
        ],
      ),
      Task(
        name: "Hausbesuch",
        description: "Zeitaufwendig, aber bringt viele neue Mitglieder.",
        duration: 6000.0,
        cost: [Time(value: 3.0)],
        award: [Member(value: 2.0)], 
        modifier: [
          AddTask(task: "Essen in meiner Wohnung"),
          MessageModifier(message: "STRATEGIE: Manche Aufgaben brauchen viel Zeit. Behalte den blauen Zeit-Balken oben im Auge!"),
        ],
      ),
      Task(
        name: "Schlafen",
        description: "Regeneriert 'Zeit'. WICHTIG: Ohne Zeit-Punkte kannst du keine Aufgaben starten!",
        duration: 8000.0,
        cost: [Time(value: 8.0)],
        award: [Time(value: 16.0)],
        modifier: [
          MessageModifier(message: "REGENERATION: Wenn dir die Zeit ausgeht, ist 'Schlafen' deine wichtigste Aufgabe."),
        ],
      ),
      Task(
        name: "Essen in meiner Wohnung",
        description: "MEILENSTEIN: Erhöht deine maximale Mitglieder-Kapazität auf 40.",
        duration: 10000.0,
        cost: [Time(value: 4.0), Member(value: 5.0)],
        award: [Member(value: 15.0)],
        modifier: [
          MessageModifier(message: "GLÜCKWUNSCH: Du hast das Limit erhöht! Dein neues Maximum liegt nun bei 40 Mitgliedern. Wenn du über 20 kommst steigst in die Stufe 1 auf."),
          SetMin(ressource: "Member", newMin: 1.0), 
          SetMax(ressource: "Member", newMax: 40.0),
        ],
      ),
    ],
  ),
  
  // STAGE 1: Gemeinschaftsgruppe (Max 40)
  Stage(
    level: 1,
    member: 40,
    description: "Gemeinschaftsgruppe - Die Verantwortung wächst.",
    activeTasks: ["Bibellesen", "Beten", "Hausbesuch", "Schlafen", "Kasse führen"],
    allTasks: [
      Task(
        name: "Kasse führen",
        description: "Bringe Ordnung in die Finanzen, um die Gemeinde zu organisieren.",
        duration: 4000.0,
        cost: [Time(value: 2.0)],
        award: [Wisdom(value: 1.0)],
        modifier: [
          AddTask(task: "Kollekte"),
          MessageModifier(message: "ORGANISATION: Eine gute Buchführung ist die Basis für finanzielle Stabilität. Du kannst jetzt Kollekten einsammeln."),
        ],
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

  // STAGE 2: Kleine Gemeinde (Max 80)
  Stage(
    level: 2,
    member: 80,
    description: "Kleine Gemeinde - Es wird eng im Wohnzimmer.",
    activeTasks: ["Bibellesen", "Schlafen", "Kollekte", "Gottesdienst in der Wohnung"],
    allTasks: [
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
        description: "Besichtige mögliche Räumlichkeiten für die wachsende Gemeinde.",
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

  // STAGE 3: Mittlere Gemeinde (Max 140)
  Stage(
    level: 3,
    member: 140,
    description: "Mittlere Gemeinde - Vom Clan zur Organisation.",
    activeTasks: ["Kollekte", "Schlafen", "Öffentlicher Gottesdienst"],
    allTasks: [
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
