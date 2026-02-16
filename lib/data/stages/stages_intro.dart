import 'package:flutter/material.dart';
import 'package:save_the_world_flutter_app/models/addres.model.dart';
import 'package:save_the_world_flutter_app/models/addtask.model.dart';
import 'package:save_the_world_flutter_app/models/faith.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/member.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/message.modifier.dart';
import 'package:save_the_world_flutter_app/models/modifier.model.dart';
import 'package:save_the_world_flutter_app/models/money.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/publicity.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/removetask.model.dart';
import 'package:save_the_world_flutter_app/models/ressource.model.dart';
import 'package:save_the_world_flutter_app/models/setmax.model.dart';
import 'package:save_the_world_flutter_app/models/stage.model.dart';
import 'package:save_the_world_flutter_app/models/subtractres.model.dart';
import 'package:save_the_world_flutter_app/models/task.model.dart';
import 'package:save_the_world_flutter_app/models/time.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/wisdome.ressource.model.dart';

final List<Stage> introStages = [
  // STAGE 0: Der Ruf (Absolut simples Onboarding)
  Stage(
    level: 0,
    member: 20,
    description: "Hausgemeinde - Als Offizier fängst du klein an, aber mit großem Auftrag.",
    activeTasks: ["Bibellesen", "Schlafen"],
    randomTasks: [],
    allTasks: [
      Task(
        name: "Bibellesen",
        description: "Dein täglicher Anker. Ohne das Wort Gottes fehlt deinem Dienst die Richtung.",
        duration: 3000.0,
        cost: [Time(value: 1.0)],
        award: [Faith(value: 15.0)], // Reduziert auf 1 Gewinn
        modifier: [
          AddTask(task: "Beten"),
          MessageModifier(message: "Wunderbar! 'Beten' wurde freigeschaltet. Es kostet Zeit, aber du gewinnst Glauben."),
        ],
      ),
      Task(
        name: "Beten",
        description: "Der Motor der Heilsarmee. Du bringst die Not der Stadt vor Gott.",
        duration: 4000.0,
        cost: [Time(value: 1.0)],
        award: [Faith(value: 10.0)], // Reduziert auf 1 Gewinn
        modifier: [
          AddTask(task: "Hausbesuch"),
          MessageModifier(message: "Das Gebet ist der Motor. Gott wendet dir die Herzen der Menschen zu. Jetzt sind 'Hausbesuche' möglich."),
        ],
      ),
      Task(
        name: "Hausbesuch",
        description: "Menschen fischen bedeutet, zu ihnen zu gehen. Jüngerschaft braucht Zeit.",
        duration: 6000.0,
        cost: [Time(value: 3.0)], // Vereinfacht
        award: [Member(value: 1.5)], 
        modifier: [
          AddTask(task: "Essen in meiner Wohnung"),
          MessageModifier(message: "Hausbesuche vertiefen die Gemeinschaft. Sammle 5 Personen, um sie zum 'Essen' einzuladen."),
        ],
      ),
      Task(
        name: "Schlafen",
        description: "Wer ausbrennt, kann die Welt nicht retten. Schlaf ist Dienst am Nächsten.",
        duration: 8000.0,
        cost: [Time(value: 8.0)],
        award: [Time(value: 16.0)],
        modifier: [
          MessageModifier(message: "Erholt! Deine Zeit ist wieder aufgeladen. Achte IMMER darauf, dass dir die Zeit nicht ausgeht!"),
        ],
      ),
      Task(
        name: "Essen in meiner Wohnung",
        description: "Die Keimzelle der Gemeinde. Dieses Event schaltet die nächste Stufe frei!",
        duration: 10000.0,
        cost: [
          Time(value: 4.0), 
          Member(value: 5.0),
        ],
        award: [Member(value: 15.0)],
        modifier: [
          SetMax(ressource: "Member", newMax: 40.0), // Aktiver Stufenaufstieg
          MessageModifier(message: "Fantastisch! Deine Herde wächst. Du hast die Gemeinschaftsgruppe erreicht!"),
        ],
      ),
    ],
  ),

  // STAGE 1: Gemeinschaftsgruppe (40)
  Stage(
    level: 1,
    member: 40,
    description: "Gemeinschaftsgruppe - Die Verantwortung wächst.",
    activeTasks: ["Bibellesen", "Beten", "Hausbesuch", "Schlafen", "Kasse führen"],
    randomTasks: ["Kassendifferenz finden"],
    allTasks: [
      Task(
        name: "Kasse führen",
        description: "Spenden treu verwalten. Ordnung ist ein geistlicher Dienst.",
        duration: 4000.0,
        cost: [Time(value: 2.0)],
        award: [Money(value: 5.0)],
        modifier: [
          AddTask(task: "Gottesdienst vorbereiten"),
          MessageModifier(message: "Wachstum bedeutet Verantwortung. Verwalte nun die Finanzen."),
        ],
      ),
      // ... restliche Tasks ...
    ],
  ),
  // STAGE 2... STAGE 3... (beibehalten wie vorher)
];
