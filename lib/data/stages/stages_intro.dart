import 'package:flutter/material.dart';
import 'package:save_the_world_flutter_app/models/addtask.model.dart';
import 'package:save_the_world_flutter_app/models/addres.model.dart';
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
  // STAGE 0: Der Ruf (Tutorial) - Bleibt unverändert für Stabilität
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
    activeTasks: ["Bibellesen", "Beten", "Schlafen", "FSJler einstellen"],
    randomTasks: ["Rechnung nicht bezahlt"],
    allTasks: [
      Task(
        name: "Bibellesen",
        duration: 3000.0,
        cost: [Time(value: 1.0)],
        award: [Faith(value: 15.0)],
      ),
      Task(
        name: "Schlafen",
        duration: 8000.0,
        cost: [Time(value: 8.0)],
        award: [Time(value: 16.0)],
      ),
      Task(
        name: "FSJler einstellen",
        description: "Hilfe im Alltag. Schaltet 32-Stunden-Tag frei!",
        duration: 4000.0,
        cost: [Money(value: 50.0), Time(value: 5.0)],
        award: [Time(value: 1.0)],
        modifier: [
          MessageModifier(message: "UPGRADE: Der FSJler ist da! Dein Zeit-Maximum wurde auf 32h erhöht. Aber er will regelmäßig bezahlt werden!"),
          SetMax(ressource: "Time", newMax: 32.0),
          AddTask(task: "FSJler bezahlen"),
        ],
      ),
      Task(
        name: "FSJler bezahlen",
        description: "KRITISCH: Bezahle den FSJler, bevor er kündigt!",
        duration: 10000.0,
        timeToSolve: 60000.0, // Zeitlimit: 1 Minute
        cost: [Money(value: 36.0)],
        award: [Time(value: 8.0)],
        online: [
          MessageModifier(message: "WARNUNG: Ein zeitkritischer Task! Der rote Balken zeigt, wie lange du Zeit hast, ihn zu starten."),
        ],
        missed: [
          SetMax(ressource: "Time", newMax: 24.0),
          AddTask(task: "FSJler einstellen"),
          MessageModifier(message: "OH NEIN: Der FSJler hat gekündigt! Dein Zeit-Limit sinkt wieder auf 24h."),
        ],
      ),
      Task(
        name: "Rechnung nicht bezahlt",
        description: "KRITISCH: Bezahle sofort, um Mahngebühren zu vermeiden.",
        duration: 5000.0,
        timeToSolve: 45000.0,
        cost: [Money(value: 30.0)],
        online: [
          MessageModifier(message: "ALARM: Eine unbezahlte Rechnung! Erledige sie schnell."),
        ],
        missed: [
          SubtractRes(ressources: [Money(value: 50.0)]),
          AddTask(task: "Rechnung nicht bezahlt"),
          MessageModifier(message: "MAHNUNG: Du hast zu lange gewartet. 50 Geld wurden als Strafe abgezogen!"),
        ],
      ),
    ],
  ),
];
