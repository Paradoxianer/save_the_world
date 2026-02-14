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
import 'package:save_the_world_flutter_app/models/subtractres.model.dart';
import 'package:save_the_world_flutter_app/models/task.model.dart';
import 'package:save_the_world_flutter_app/models/time.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/wisdome.ressource.model.dart';

final List<Stage> introStages = [
  // STAGE 0: Der Ruf (Tutorial)
  Stage(
    level: 0,
    member: 20,
    description: "Hausgemeinde - Als Offizier fängst du klein an, aber mit großem Auftrag.",
    activeTasks: ["Bibellesen", "Schlafen"],
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
          MessageModifier(message: "Das Gebet ist der Motor. Gott wendet dir die Herzen der Menschen zu und schenkt dir erste Weggefährten."),
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
          MessageModifier(message: "Hausbesuche vertiefen die Gemeinschaft. Sie sind der Schlüssel, um die nächste Stufe freizuschalten."),
        ],
      ),
      Task(
        name: "Schlafen",
        description: "Wer ausbrennt, kann die Welt nicht retten. Schlaf ist Dienst am Nächsten.",
        duration: 8000.0,
        cost: [Time(value: 8.0)],
        award: [Time(value: 16.0)],
        modifier: [
          MessageModifier(message: "Erholt! Deine Zeit ist wieder aufgeladen. WICHTIG: Achte IMMER darauf, dass dir die Zeit nicht ausgeht!"),
        ],
      ),
      Task(
        name: "Essen in meiner Wohnung",
        description: "Ein einfacher Hauskreis in deinem Wohnzimmer. Die Keimzelle der Gemeinde.",
        duration: 10000.0,
        cost: [Time(value: 4.0), Faith(value: 20.0), Member(value: 5.0)],
        award: [Member(value: 15.0), Publicity(value: 2.0)],
        modifier: [
          MessageModifier(message: "Fantastisch! Deine kleine Herde ist gewachsen. Du bist bereit für die nächste Stufe: Gemeinschaftsgruppe!"),
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
          MessageModifier(message: "Wachstum bedeutet Verantwortung. Mit der 'Kasse' verwaltest du nun die Finanzen der Gemeinde."),
        ],
      ),
      Task(
        name: "Gottesdienst vorbereiten",
        description: "Thema festlegen und Lieder auswählen.",
        duration: 8000.0,
        cost: [Time(value: 2.0), Faith(value: 50.0)],
        award: [Faith(value: 60.0)],
        modifier: [
          RemoveTask(task: "Gottesdienst vorbereiten"),
          AddTask(task: "Predigt schreiben")
        ],
      ),
      Task(
        name: "Predigt schreiben",
        description: "Das Wort Gottes für die Menschen heute aufbereiten.",
        duration: 8000.0,
        cost: [Time(value: 6.0), Faith(value: 80.0)],
        award: [Member(value: 0.05), Faith(value: 40.0)],
        modifier: [
          RemoveTask(task: "Predigt schreiben"),
          AddTask(task: "Gottesdienst halten")
        ],
      ),
      Task(
        name: "Gottesdienst halten",
        description: "Zusammenkommen, um Gott zu begegnen.",
        duration: 4000.0,
        cost: [Member(value: 5.0), Time(value: 3.0), Faith(value: 150.0)],
        award: [Faith(value: 200.0), Member(value: 2.0), Money(value: 20.0)],
        modifier: [
          RemoveTask(task: "Gottesdienst halten"),
          AddTask(task: "Gottesdienst vorbereiten"),
          AddTask(task: "Einen Basar planen")
        ],
      ),
    ],
  ),

  // STAGE 2: Kleine Gemeinde (80)
  Stage(
    level: 2,
    member: 80,
    description: "Kleine Gemeinde - Wir fangen an, über unsere Grenzen hinaus zu blicken.",
    activeTasks: ["Bibellesen", "Beten", "Schlafen", "Gottesdienst halten", "Einen Basar planen"],
    randomTasks: ["Streit in der Gemeinde"],
    allTasks: [
      Task(
        name: "Einen Basar planen",
        description: "Geld für den guten Zweck sammeln und sichtbar werden.",
        duration: 6000.0,
        cost: [Time(value: 4.0), Faith(value: 20.0)],
        award: [Publicity(value: 10.0), Money(value: 50.0)],
        modifier: [
          AddTask(task: "Geistesgaben entdecken"),
          MessageModifier(message: "Sichtbarkeit! Die Stadt nimmt euch wahr. Zeit, die Gaben der Mitglieder zu fördern."),
        ],
      ),
      Task(
        name: "Geistesgaben entdecken",
        description: "Hilf Mitgliedern, ihre Talente zu finden.",
        duration: 8000.0,
        cost: [Time(value: 4.0), Wisdom(value: 50.0)],
        award: [Wisdom(value: 20.0)],
        modifier: [AddTask(task: "Korpsrat einsetzen")],
      ),
    ],
  ),

  // STAGE 3: Mittlere Gemeinde (140)
  Stage(
    level: 3,
    member: 140,
    description: "Mittlere Gemeinde - Struktur wird zum Träger der Mission.",
    activeTasks: ["Bibellesen", "Schlafen", "Gottesdienst halten", "Geistesgaben entdecken"],
    randomTasks: ["Rechnung nicht bezahlt"],
    allTasks: [
      Task(
        name: "Korpsrat einsetzen",
        description: "Leitung auf mehrere Schultern verteilen.",
        duration: 12000.0,
        cost: [Member(value: 10.0), Time(value: 10.0), Faith(value: 200.0)],
        award: [Wisdom(value: 100.0)],
        modifier: [
          MessageModifier(message: "Echte Multiplikation beginnt! Dein Korpsrat entlastet dich in der Leitung."),
        ],
      ),
    ],
  ),
];
