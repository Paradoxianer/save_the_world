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
  // STAGE 0: Der Ruf (Tutorial für angehende Heilsarmeeoffiziere)
  Stage(
    level: 0,
    member: 20,
    description: "Hausgemeinde - Als Offizier fängst du klein an, aber mit großem Auftrag.",
    activeTasks: [
      "Bibellesen",
      "Schlafen", // Von Anfang an freigeschaltet für die Balance
    ],
    randomTasks: [],
    allTasks: [
      Task(
        name: "Bibellesen",
        description: "Dein täglicher Anker. Ohne das Wort Gottes fehlt deinem Dienst die Richtung.",
        duration: 3000.0,
        cost: [Time(value: 1.0)],
        award: [Faith(value: 15.0), Wisdom(value: 5.0)],
        modifier: [
          AddTask(task: "Beten"),
          MessageModifier(message: "Aus dem Wort wächst die Kraft. Als Offizier ist die Stille Zeit dein wichtigstes Fundament."),
        ],
      ),
      Task(
        name: "Beten",
        description: "Der Motor der Heilsarmee. Du bringst die Not der Stadt vor Gott.",
        duration: 4000.0,
        cost: [Time(value: 1.0)],
        award: [Faith(value: 10.0), Member(value: 0.1)],
        modifier: [
          AddTask(task: "Hausbesuch"),
          MessageModifier(message: "Das Gebet öffnet Türen. Du spürst, wie sich die ersten Menschen für den Glauben interessieren."),
        ],
      ),
      Task(
        name: "Hausbesuch",
        description: "Menschen fischen bedeutet, zu ihnen zu gehen. Jüngerschaft braucht Zeit.",
        duration: 6000.0,
        cost: [Time(value: 3.0), Faith(value: 5.0)],
        award: [Member(value: 1.5), Wisdom(value: 2.0)],
        modifier: [
          AddTask(task: "Essen in meiner Wohnung"),
          MessageModifier(message: "Beziehungen zu pflegen ist der Kern deiner Arbeit. Aber achte weise auf deine Zeit!"),
        ],
      ),
      Task(
        name: "Schlafen",
        description: "Wer ausbrennt, kann die Welt nicht retten. Schlaf ist Dienst am Nächsten.",
        duration: 8000.0,
        cost: [Time(value: 8.0)],
        award: [Time(value: 16.0)],
        modifier: [
          MessageModifier(message: "Gute Erholung! Deine Zeit ist eine kostbare Gabe Gottes. Nutze sie diszipliniert."),
        ],
      ),
      Task(
        name: "Essen in meiner Wohnung",
        description: "Ein einfacher Hauskreis in deinem Wohnzimmer. Die Keimzelle der Gemeinde.",
        duration: 10000.0,
        cost: [
          Time(value: 4.0), 
          Faith(value: 20.0),
          Member(value: 5.0), // Setzt voraus, dass man bereits 5 Leute durch Gebet/Besuche 'gesammelt' hat
        ],
        award: [Member(value: 15.0), Publicity(value: 2.0)],
        modifier: [
          MessageModifier(message: "Halleluja! Aus Einladungen werden Jünger. Deine kleine Herde ist bereit für den nächsten Schritt."),
        ],
      ),
    ],
  ),

  // STAGE 1: Gemeinschaftsgruppe
  Stage(
    level: 1,
    member: 40,
    description: "Gemeinschaftsgruppe - Die Verantwortung wächst.",
    activeTasks: ["Bibellesen", "Beten", "Hausbesuch", "Schlafen"],
    randomTasks: ["Kassendifferenz finden"],
    allTasks: [
      Task(
        name: "Kasse führen",
        description: "Spenden müssen treu verwaltet werden. Auch das gehört zum geistlichen Dienst.",
        duration: 4000.0,
        cost: [Time(value: 2.0)],
        award: [Money(value: 5.0)],
        modifier: [
          AddTask(task: "Gottesdienst vorbereiten"),
        ],
      ),
      // ... weitere Tasks ...
    ],
  ),
];
