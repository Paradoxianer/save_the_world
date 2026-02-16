import 'package:flutter/material.dart';
import 'package:save_the_world_flutter_app/models/addtask.model.dart';
import 'package:save_the_world_flutter_app/models/addres.model.dart';
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
import 'package:save_the_world_flutter_app/models/setmin.model.dart';
import 'package:save_the_world_flutter_app/models/subtractres.model.dart';
import 'package:save_the_world_flutter_app/models/task.model.dart';
import 'package:save_the_world_flutter_app/models/time.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/wisdome.ressource.model.dart';

final List<Stage> introStages = [
  // STAGE 0: Der Ruf (Tutorial)
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
  
  // STAGE 1: Gemeinschaftsgruppe
  Stage(
    level: 1,
    member: 40,
    description: "Gemeinschaftsgruppe - Die Verantwortung wächst.",
    activeTasks: ["Bibellesen", "Beten", "Hausbesuch", "Schlafen", "Kasse führen"],
    allTasks: [
      Task(
        name: "Kasse führen",
        description: "Bringe Ordnung in die Finanzen. Schaltet passives Einkommen frei.",
        duration: 4000.0,
        cost: [Time(value: 2.0)],
        award: [Wisdom(value: 1.0)],
        modifier: [
          // AUTOMATION: Jede 15 Sek generiert der Schatzmeister nun automatisch Geld
          AutoExecuteModifier(
            intervalMs: 15000,
            modifiers: [
              MultiplyRes(targetResName: "Money", factorResName: "Member", multiplier: 0.1),
              MessageModifier(message: "AUTOMATION: Dein Schatzmeister hat die Kollekte verbucht."),
            ]
          ),
          MessageModifier(message: "DELEGATION: Du hast einen Schatzmeister ernannt! Er sammelt nun alle 15 Sek. automatisch Geld basierend auf deiner Mitgliederzahl."),
        ],
      ),
      Task(
        name: "Kollekte",
        description: "Manuelle Spendensammlung.",
        duration: 3000.0,
        cost: [Time(value: 1.0)],
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
  
  // STAGE 2 & 3 bleiben logisch gleich, können aber nun auch automatisiert werden...
];
