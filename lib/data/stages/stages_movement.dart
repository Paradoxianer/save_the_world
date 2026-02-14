import 'package:save_the_world_flutter_app/models/addtask.model.dart';
import 'package:save_the_world_flutter_app/models/faith.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/member.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/message.modifier.dart';
import 'package:save_the_world_flutter_app/models/money.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/publicity.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/stage.model.dart';
import 'package:save_the_world_flutter_app/models/task.model.dart';
import 'package:save_the_world_flutter_app/models/time.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/wisdome.ressource.model.dart';

final List<Stage> movementStages = [
  // STAGE 11: Beeinflussende Kirche (4.500 Mitglieder) - Fokus: Multiplikation & Pioniergeist
  Stage(
    level: 11,
    member: 4500,
    description: "Beeinflussende Kirche - Deine Gemeinde ist nun ein regionales Zentrum. Es geht um Multiplikation.",
    activeTasks: ["Bibellesen", "Beten", "Schlafen", "Leiter-Konferenz", "International Mission"],
    randomTasks: ["Medienrummel", "Logistik-Engpass"],
    allTasks: [
      Task(
        name: "Pionier-Team aussenden",
        description: "Sende eine bewährte Leiterfamilie aus, um in einer Nachbarstadt ein neues Werk zu gründen.",
        duration: 45000.0,
        cost: [
          Member(value: 50.0), 
          Faith(value: 1000.0), 
          Money(value: 10000.0),
          Time(value: 20.0),
        ],
        award: [
          Publicity(value: 100.0),
          Wisdom(value: 200.0),
        ],
        modifier: [
          MessageModifier(message: "Multiplikation! Dein Pionier-Team hat den ersten Außeneinsatz erfolgreich gestartet. Die DNA der Heilsarmee verbreitet sich."),
        ],
      ),
      Task(
        name: "DNA-Transfer Workshop",
        description: "Stelle sicher, dass die Kernwerte der Heilsarmee in allen Kleingruppen und Standorten gleich gelebt werden.",
        duration: 20000.0,
        cost: [Time(value: 15.0), Wisdom(value: 500.0)],
        award: [Faith(value: 200.0), Wisdom(value: 100.0)],
        modifier: [
          MessageModifier(message: "Einheit in der Vielfalt! Die gemeinsame Vision hält die wachsende Bewegung zusammen."),
        ],
      ),
    ],
  ),

  // STAGE 15: Eine Bewegung (100.000 Mitglieder) - Fokus: Systematische Jüngerschaft im großen Stil
  Stage(
    level: 15,
    member: 100000,
    description: "Eine Bewegung - Hunderttausende gehören nun zur Vision. Du musst Strukturen für Massen-Jüngerschaft schaffen.",
    activeTasks: ["Bibellesen", "Pionier-Team aussenden", "DNA-Transfer Workshop"],
    randomTasks: ["Identitäts-Krise", "Großereignis planen"],
    allTasks: [
      Task(
        name: "Regionale Leiter-Akademie",
        description: "Gründe ein Zentrum zur Ausbildung von hunderten neuen Offizieren und Leitern.",
        duration: 60000.0,
        cost: [Money(value: 50000.0), Time(value: 40.0), Wisdom(value: 2000.0)],
        award: [Member(value: 500.0), Wisdom(value: 500.0)],
        modifier: [
          MessageModifier(message: "Nachhaltiges Wachstum! Die Akademie sichert den Nachschub an geistlich reifen Leitern."),
        ],
      ),
      Task(
        name: "Soziale Brennpunkt-Offensive",
        description: "Starte in 10 Städten gleichzeitig neue soziale Projekte.",
        duration: 40000.0,
        cost: [Money(value: 20000.0), Faith(value: 3000.0), Member(value: 200.0)],
        award: [Publicity(value: 1000.0), Member(value: 1000.0)],
        modifier: [
          MessageModifier(message: "Salz und Licht! Die Heilsarmee wird als Retterin in der Not regional bekannt."),
        ],
      ),
    ],
  ),

  // STAGE 20: Globale Größe (2.500.000 Mitglieder)
  Stage(
    level: 20,
    member: 2500000,
    description: "Globale Größe - Die Bewegung erreicht Millionen. Jüngerschaft geschieht nun durch mediale Präsenz und lokale Stärke.",
    activeTasks: ["Vision-Casting", "Regionale Leiter-Akademie", "Soziale Brennpunkt-Offensive"],
    randomTasks: ["Weltpolitische Spannungen", "Finanzmarkt-Schwankungen"],
    allTasks: [
      Task(
        name: "Eigene Fernsehsendung",
        description: "Verkünde das Evangelium und die Vision der Armee über Massenmedien.",
        duration: 30000.0,
        cost: [Money(value: 100000.0), Time(value: 10.0), Publicity(value: 500.0)],
        award: [Publicity(value: 5000.0), Member(value: 5000.0)],
        modifier: [
          MessageModifier(message: "Massen-Evangelisation! Millionen hören die Botschaft. Die Jüngerschaft muss nun lokal aufgefangen werden."),
        ],
      ),
    ],
  ),
];
