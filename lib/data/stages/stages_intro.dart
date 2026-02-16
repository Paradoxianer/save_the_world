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
        award: [Faith(value: 15.0)],
        modifier: [
          AddTask(task: "Beten"),
          MessageModifier(message: "Aus dem Wort wächst die Kraft. Als Offizier ist die Stille Zeit dein wichtigstes Fundament."),
        ],
      ),
      Task(
        name: "Beten",
        description: "Der Motor der Heilsarmee. Gott wendet dir die Herzen der Menschen zu.",
        duration: 4000.0,
        cost: [Time(value: 1.0)],
        award: [Faith(value: 10.0), Member(value: 0.1)],
        modifier: [
          AddTask(task: "Hausbesuch"),
          MessageModifier(message: "Das Gebet ist der Motor. Gott schenkt dir erste Weggefährten."),
        ],
      ),
      Task(
        name: "Hausbesuch",
        description: "Beziehungen pflegen braucht Zeit. Schaltet das nächste Event frei.",
        duration: 6000.0,
        cost: [Time(value: 3.0)],
        award: [Member(value: 1.5)], 
        modifier: [
          AddTask(task: "Essen in meiner Wohnung"),
          MessageModifier(message: "Hausbesuche vertiefen die Gemeinschaft. Lade deine 5 Freunde zum Essen ein."),
        ],
      ),
      Task(
        name: "Schlafen",
        description: "Regeneration ist Dienst am Nächsten. Achte auf deine Zeit!",
        duration: 8000.0,
        cost: [Time(value: 8.0)],
        award: [Time(value: 16.0)],
        modifier: [
          MessageModifier(message: "Erholt! Deine Zeit ist aufgeladen. Ohne Zeit kannst du nicht dienen!"),
        ],
      ),
      Task(
        name: "Essen in meiner Wohnung",
        description: "Die Keimzelle der Gemeinde. Hebt die Kapazität auf 40 Mitglieder!",
        duration: 10000.0,
        cost: [Time(value: 4.0), Member(value: 5.0)],
        award: [Member(value: 15.0)],
        modifier: [
          SetMax(ressource: "Member", newMax: 40.0), // Blocker-Fix Stage 0 -> 1
          MessageModifier(message: "Wunderbar! Dein Heim ist voll. Willkommen in der Gemeinschaftsgruppe!"),
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
    allTasks: [
      Task(
        name: "Kasse führen",
        description: "Spenden treu verwalten. Ordnung gehört dazu.",
        duration: 4000.0,
        cost: [Time(value: 2.0)],
        award: [Money(value: 5.0)],
        modifier: [
          AddTask(task: "Gottesdienst vorbereiten"),
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
        description: "Worte finden, die Herzen bewegen.",
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
        description: "Gott begegnen. Erweitert die Kapazität auf 80 Mitglieder!",
        duration: 4000.0,
        cost: [Member(value: 5.0), Time(value: 3.0), Faith(value: 150.0)],
        award: [Faith(value: 200.0), Member(value: 2.0), Money(value: 20.0)],
        modifier: [
          RemoveTask(task: "Gottesdienst halten"),
          AddTask(task: "Gottesdienst vorbereiten"),
          SetMax(ressource: "Member", newMax: 80.0), // Blocker-Fix Stage 1 -> 2
          MessageModifier(message: "Ein gesegneter Gottesdienst! Mehr Menschen haben nun Platz in eurer Mitte."),
        ],
      ),
    ],
  ),

  // STAGE 2: Kleine Gemeinde (80)
  Stage(
    level: 2,
    member: 80,
    description: "Kleine Gemeinde - Wir blicken über den Tellerrand.",
    activeTasks: ["Bibellesen", "Beten", "Schlafen", "Gottesdienst halten"],
    allTasks: [
      Task(
        name: "Einen Basar planen",
        description: "Sichtbar werden. Erhöht die Kapazität auf 140 Mitglieder!",
        duration: 6000.0,
        cost: [Time(value: 4.0), Faith(value: 20.0)],
        award: [Publicity(value: 10.0), Money(value: 50.0)],
        modifier: [
          AddTask(task: "Geistesgaben entdecken"),
          SetMax(ressource: "Member", newMax: 140.0), // Blocker-Fix Stage 2 -> 3
          MessageModifier(message: "Der Basar war ein Erfolg! Ihr seid nun bereit für eine mittlere Gemeinde."),
        ],
      ),
      Task(
        name: "Geistesgaben entdecken",
        description: "Befähige andere, ihren Platz zu finden.",
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
    description: "Mittlere Gemeinde - Struktur trägt die Vision.",
    activeTasks: ["Bibellesen", "Schlafen", "Gottesdienst halten", "Geistesgaben entdecken"],
    allTasks: [
      Task(
        name: "Korpsrat einsetzen",
        description: "Leitung teilen. Erhöht die Kapazität auf 200 Mitglieder!",
        duration: 12000.0,
        cost: [Member(value: 10.0), Time(value: 10.0), Faith(value: 200.0)],
        award: [Wisdom(value: 100.0)],
        modifier: [
          SetMax(ressource: "Member", newMax: 200.0), // Blocker-Fix Stage 3 -> 4
          MessageModifier(message: "Dein Korpsrat steht! Gemeinsam geht es in die Wachstumsphase."),
        ],
      ),
    ],
  ),
];
