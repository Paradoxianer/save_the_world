import 'package:save_the_world_flutter_app/models/addtask.model.dart';
import 'package:save_the_world_flutter_app/models/faith.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/member.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/message.modifier.dart';
import 'package:save_the_world_flutter_app/models/money.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/publicity.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/removetask.model.dart';
import 'package:save_the_world_flutter_app/models/stage.model.dart';
import 'package:save_the_world_flutter_app/models/setmax.model.dart';
import 'package:save_the_world_flutter_app/models/task.model.dart';
import 'package:save_the_world_flutter_app/models/time.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/wisdome.ressource.model.dart';
import 'package:save_the_world_flutter_app/data/stages/common_tasks.dart';

final Stage stage14 = Stage(
  level: 14,
  member: 50000,
  description: "Eine Bewegung Level 3 - Fokus auf regionale Infrastruktur und Großevangelisation.",
  activeTasks: [
    "Bibellesen", 
    "Schlafen", 
    "Kollekte", 
    "Logistik-Planung", 
    "Regionales Zentrum eröffnen"
  ],
  randomTasks: ["Finanzprüfung (Krise)", "Der Heilige Geist möchte wirken"],
  allTasks: [
    baseBible,
    baseSleep,
    collectMoney,
    holySpiritWorking,
    Task(
      name: "Logistik-Planung",
      description: "BEFÄHIGUNG: Die organisatorische Basis für Großveranstaltungen legen.",
      duration: 20000.0,
      cost: [Time(value: 4.0), Wisdom(value: 300.0)],
      award: [Wisdom(value: 100.0)],
      modifier: [
        AddTask(task: "Großevangelisation durchführen"),
        RemoveTask(task: "Logistik-Planung"),
      ],
    ),
    Task(
      name: "Großevangelisation durchführen",
      description: "Tausende Menschen hören die Botschaft auf Marktplätzen und in Stadien.",
      duration: 40000.0,
      cost: [Money(value: 100000.0), Publicity(value: 1000.0)],
      award: [Member(value: 1.0), Publicity(value: 500.0)],
      modifier: [
        AddTask(task: "Logistik-Planung"), // Muss für die nächste Aktion neu geplant werden
      ]
    ),
    Task(
      name: "Regionales Zentrum eröffnen",
      description: "MEILENSTEIN: Ein fester Ankerpunkt für die gesamte Region (Limit 100.000).",
      duration: 60000.0,
      isMilestone: true,
      cost: [Money(value: 500000.0), Wisdom(value: 3000.0), Faith(value: 1000.0)],
      award: [Member(value: 1.0)],
      modifier: [
        MessageModifier(message: "STRUKTUR: Das Zentrum ist eingeweiht! Das regionale Netzwerk wächst. Limit 100.000."),
        SetMax(ressource: "Member", newMax: 100000.0),
        RemoveTask(task: "Regionales Zentrum eröffnen"),
        AddTask(task: "Zentrum operativ leiten"),
      ],
    ),
    Task(
      name: "Zentrum operativ leiten",
      description: "WARTUNG: Sicherung der regionalen Stabilität und Seelsorge.",
      duration: 25000.0,
      cost: [Time(value: 2.0), Money(value: 1000.0)],
      award: [Faith(value: 100.0), Publicity(value: 50.0)],
    ),
    Task(
      name: "Finanzprüfung (Krise)",
      description: "KRISE: Behörden prüfen die Gemeinnützigkeit der Bewegung. Absolute Sorgfalt nötig!",
      duration: 15000.0,
      timeToSolve: 50000.0,
      cost: [Wisdom(value: 500.0), Money(value: 5000.0)],
      award: [Wisdom(value: 100.0)],
      modifier: [
        MessageModifier(message: "BESTANDEN: Die Transparenz hat sich ausgezahlt. Das Vertrauen ist gestärkt."),
        RemoveTask(task: "Finanzprüfung (Krise)"),
      ],
      missed: [
        SubtractRes(ressources: [Money(value: 50000.0), Publicity(value: 2000.0)]),
        MessageModifier(message: "STRAFE: Dokumentationsmängel führten zu Bußgeldern und Imageverlust."),
        RemoveTask(task: "Finanzprüfung (Krise)"),
        AddTask(task: "Finanzprüfung (Krise)"),
      ],
    ),
  ],
);
