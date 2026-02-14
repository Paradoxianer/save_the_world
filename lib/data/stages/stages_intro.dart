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
  // STAGE 0: Tutorial (Sanfter Einstieg)
  Stage(
    level: 0,
    member: 20,
    description: "Hausgemeinde - Hier fängt alles an. Konzentriere dich auf das Wesentliche.",
    activeTasks: [
      "Bibellesen", // Nur eine Startaufgabe für den Fokus
    ],
    randomTasks: [
      "Ein zwischenmenschliches Problem klären",
    ],
    allTasks: [
      Task(
        name: "Bibellesen",
        description: "Zeit mit Gott verbringen. Erhöht deinen Glauben und deine Weisheit.",
        duration: 2000.0,
        cost: [Time(value: 1.0)],
        award: [Faith(value: 7.0), Wisdom(value: 3.0)],
        modifier: [
          AddTask(task: "Beten für andere"), // Schaltet die nächste Aufgabe frei
        ],
      ),
      Task(
        name: "Beten für andere",
        description: "Für die Nöte anderer einstehen. Zieht neue Mitglieder an.",
        cost: [Time(value: 1.0)],
        award: [Faith(value: 1.0), Member(value: 0.10)],
        modifier: [
          AddTask(task: "Seelsorge"),
        ],
      ),
      Task(
        name: "Seelsorge",
        description: "Pastor... ich hab da ein Problem",
        cost: [Time(value: 1.0), Wisdom(value: 3.0)],
        award: [Wisdom(value: 3.5), Member(value: 0.25)],
        modifier: [
          AddTask(task: "Kasse führen"),
        ],
      ),
      Task(
        name: "Kasse führen",
        description: "Die Finanzen im Blick behalten. Ordnung ist das halbe Leben.",
        duration: 4000.0,
        cost: [Time(value: 2.0)],
        award: [Money(value: 0.10)],
        modifier: [
          AddTask(task: "Gottesdienst vorbereiten"),
        ],
      ),
      Task(
        name: "Gottesdienst vorbereiten",
        description: "Die Predigt schreibt sich nicht von selbst.",
        duration: 8000.0,
        cost: [Time(value: 1.0), Faith(value: 100.0)],
        award: [Faith(value: 101.0)],
        modifier: [
          RemoveTask(task: "Gottesdienst vorbereiten"),
          AddTask(task: "Predigt schreiben")
        ],
      ),
      Task(
        name: "Predigt schreiben",
        description: "Worte finden, die Herzen berühren.",
        duration: 8000.0,
        cost: [Time(value: 6.0), Faith(value: 100.0)],
        award: [Member(value: 0.02), Faith(value: 60.0)],
        modifier: [
          RemoveTask(task: "Predigt schreiben"),
          AddTask(task: "Gottesdienst halten")
        ],
      ),
      Task(
        name: "Gottesdienst halten",
        description: "Gemeinsam Gott loben und feiern.",
        duration: 4000.0,
        cost: [Member(value: 2.0), Time(value: 2.5), Faith(value: 200.0)],
        award: [Faith(value: 260.0), Member(value: 2.5), Money(value: 20.0)],
        modifier: [
          RemoveTask(task: "Gottesdienst halten"),
          AddTask(task: "Gottesdienst vorbereiten")
        ],
      ),
      Task(
        name: "Ein zwischenmenschliches Problem klären",
        description: "Ein Gemeindemitglied ist sauer. Hier ist Fingerspitzengefühl gefragt.",
        duration: 6000.0,
        timeToSolve: 7000.0,
        cost: [Time(value: 3.0), Wisdom(value: 100.0)],
        award: [Member(value: 0.25), Wisdom(value: 101.0)],
        missed: [
          SubtractRes(ressources: [Member(value: 0.5)]),
          AddTask(task: "Ein zwischenmenschliches Problem klären")
        ],
      ),
      Task(
        name: "schlafen",
        description: "Regeneration ist wichtig für deine geistige Klarheit.",
        duration: 16000.0,
        cost: [Time(value: 8.0)],
        award: [Time(value: 16.0)],
      ),
      Task(
        name: "Freizeit",
        description: "Einfach mal die Seele baumeln lassen.",
        duration: 9000.0,
        cost: [Publicity(value: 0.1)],
        award: [Time(value: 0.3)],
      ),
    ],
  ),

  // STAGE 1: Gemeinschaftsgruppe
  Stage(
    level: 1,
    member: 40,
    description: "Gemeinschaftsgruppe - Die Beziehungen werden tiefer.",
    activeTasks: ["Bibellesen", "Beten für andere", "Seelsorge", "Kasse führen", "Gottesdienst vorbereiten", "schlafen", "Freizeit"],
    randomTasks: ["Rechnung nicht bezahlt", "Kassendifferenz finden"],
    allTasks: [
      // Hier kommen die restlichen Tasks für Stufe 1 aus dem Original...
    ]
  ),
  // STAGE 2 & 3 folgen hier analog...
];
