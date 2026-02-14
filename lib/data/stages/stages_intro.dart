import 'package:flutter/material.dart';
import 'package:save_the_world_flutter_app/models/addres.model.dart';
import 'package:save_the_world_flutter_app/models/addtask.model.dart';
import 'package:save_the_world_flutter_app/models/faith.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/member.ressource.model.dart';
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
  // STAGE 0: Zen-Tutorial (Der Fokus auf das Wesentliche)
  Stage(
    level: 0,
    member: 20,
    description: "Hausgemeinde - Ruhe finden, Gott suchen.",
    activeTasks: [
      "Bibellesen", // Der absolute Startpunkt
    ],
    randomTasks: [], // Keine negativen Überraschungen im Tutorial!
    allTasks: [
      Task(
        name: "Bibellesen",
        description: "In der Stille auf Gottes Wort hören.",
        duration: 3000.0,
        cost: [Time(value: 1.0)],
        award: [Faith(value: 10.0), Wisdom(value: 5.0)],
        modifier: [
          AddTask(task: "Beten für andere"), // Erster Progress
        ],
      ),
      Task(
        name: "Beten für andere",
        description: "Die Anliegen deiner Mitmenschen vor Gott bringen.",
        duration: 4000.0,
        cost: [Time(value: 1.0)],
        award: [Faith(value: 5.0), Member(value: 0.2)],
        modifier: [
          AddTask(task: "Hausbesuch"), // Erstes soziales Element
        ],
      ),
      Task(
        name: "Hausbesuch",
        description: "Einfach mal vorbeischauen und zuhören.",
        duration: 6000.0,
        cost: [Time(value: 2.0), Faith(value: 10.0)],
        award: [Member(value: 0.5), Wisdom(value: 2.0)],
        modifier: [
          AddTask(task: "Schlafen"),
          AddTask(task: "Freizeit"),
        ],
      ),
      Task(
        name: "Schlafen",
        description: "Neue Kraft tanken für den nächsten Tag.",
        duration: 10000.0,
        cost: [Time(value: 8.0)],
        award: [Time(value: 16.0)],
      ),
      Task(
        name: "Freizeit",
        description: "Durchatmen und die Schöpfung genießen.",
        duration: 5000.0,
        cost: [],
        award: [Time(value: 1.0), Faith(value: 2.0)],
      ),
    ],
  ),

  // STAGE 1: Erste Gehversuche in der Organisation
  Stage(
    level: 1,
    member: 40,
    description: "Gemeinschaftsgruppe - Wir werden mehr.",
    activeTasks: ["Bibellesen", "Beten für andere", "Hausbesuch", "Schlafen", "Freizeit", "Kasse führen"],
    randomTasks: ["Kassendifferenz finden"],
    allTasks: [
      Task(
        name: "Kasse führen",
        description: "Die ersten Spenden wollen ordentlich verwaltet werden.",
        duration: 4000.0,
        cost: [Time(value: 2.0)],
        award: [Money(value: 1.0)], // Höherer Award für Motivation
        modifier: [
          AddTask(task: "Gottesdienst vorbereiten"),
        ],
      ),
      // ... hier folgen die anderen bekannten Tasks für Level 1 ...
    ],
  ),
];
