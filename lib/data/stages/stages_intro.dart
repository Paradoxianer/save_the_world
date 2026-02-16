import 'package:flutter/material.dart';
import 'package:save_the_world_flutter_app/models/addtask.model.dart';
import 'package:save_the_world_flutter_app/models/faith.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/member.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/message.modifier.dart';
import 'package:save_the_world_flutter_app/models/modifier.model.dart';
import 'package:save_the_world_flutter_app/models/money.ressource.model.dart';
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
          SetMin(ressource: "Member", newMin: 0.0), // FIX: Minimum auf 0 setzen für Tutorial-Flow
          AddTask(task: "Beten"),
          MessageModifier(message: "ANLEITUNG: Klicke auf 'Bibellesen', um Zeit gegen 'Glauben' zu tauschen. Du brauchst Glauben für weitere Aktionen."),
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
          MessageModifier(message: "ANLEITUNG: 'Beten' verbraucht deine gesammelten Glaubenspunkte, um neue Mitglieder zu gewinnen."),
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
          MessageModifier(message: "ANLEITUNG: Nutze Hausbesuche, um schnell auf 5 Mitglieder zu kommen. Das ist die Bedingung für das nächste Event."),
        ],
      ),
      Task(
        name: "Schlafen",
        description: "Regeneriert 'Zeit'. WICHTIG: Ohne Zeit-Punkte kannst du keine Aufgaben starten!",
        duration: 8000.0,
        cost: [Time(value: 8.0)],
        award: [Time(value: 16.0)],
        modifier: [
          MessageModifier(message: "ANLEITUNG: Deine Zeit ist begrenzt (Balken oben). Wenn sie leer ist, musst du 'Schlafen'."),
        ],
      ),
      Task(
        name: "Essen in meiner Wohnung",
        description: "MEILENSTEIN: Erhöht deine maximale Mitglieder-Kapazität auf 40.",
        duration: 10000.0,
        cost: [Time(value: 4.0), Member(value: 5.0)],
        award: [Member(value: 15.0)],
        modifier: [
          MessageModifier(message: "GLÜCKWUNSCH: Du hast das Limit erhöht! Dein Glasdach liegt nun bei 40 Mitgliedern. Du steigst in Stufe 1 auf."),
          SetMin(ressource: "Member", newMin: 1.0), // Ab jetzt gilt wieder ein Minimum (Kern-Gemeinde)
          SetMax(ressource: "Member", newMax: 40.0),
        ],
      ),
    ],
  ),
  
  // STAGE 1... (bleibt vorerst gleich)
  Stage(
    level: 1,
    member: 40,
    description: "Gemeinschaftsgruppe - Die Verantwortung wächst.",
    activeTasks: ["Bibellesen", "Beten", "Hausbesuch", "Schlafen", "Kasse führen"],
    allTasks: [
      Task(
        name: "Kasse führen",
        description: "Generiert 'Geld' für spätere Ausgaben (wie Miete).",
        duration: 4000.0,
        cost: [Time(value: 2.0)],
        award: [Money(value: 5.0)],
        modifier: [
          AddTask(task: "Gottesdienst vorbereiten"),
          MessageModifier(message: "MECHANIK: In dieser Stufe musst du anfangen, Geld für die Miete eines Saals zu sparen."),
        ],
      ),
      // ... restliche Tasks ...
    ],
  ),
];
