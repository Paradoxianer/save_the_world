import 'package:save_the_world_flutter_app/models/addtask.model.dart';
import 'package:save_the_world_flutter_app/models/faith.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/member.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/message.modifier.dart';
import 'package:save_the_world_flutter_app/models/money.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/publicity.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/removetask.model.dart';
import 'package:save_the_world_flutter_app/models/stage.model.dart';
import 'package:save_the_world_flutter_app/models/setmax.model.dart';
import 'package:save_the_world_flutter_app/models/subtractres.model.dart';
import 'package:save_the_world_flutter_app/models/task.model.dart';
import 'package:save_the_world_flutter_app/models/time.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/wisdome.ressource.model.dart';
import 'package:save_the_world_flutter_app/data/stages/common_tasks.dart';

final Stage stage17 = Stage(
  level: 17,
  member: 500000,
  description: "Globale Bewegung Level 1 - Wissenschaftliche DNA-Wahrung und Logistik.",
  activeTasks: [
    "Bibellesen", 
    "Schlafen", 
    "Logistik-Infrastruktur planen", 
    "Theologische Fakultät gründen"
  ],
  randomTasks: ["Wirtschaftsprüfung (Audit)", "Der Heilige Geist möchte wirken"],
  allTasks: [
    baseBible,
    baseSleep,
    collectMoney,
    holySpiritWorking,
    Task(
      name: "Logistik-Infrastruktur planen",
      description: "BEFÄHIGUNG: Die Basis für globale Hilfsgüter-Verteilung.",
      duration: 30000.0,
      cost: [Wisdom(value: 500.0), Money(value: 100000.0)],
      award: [Wisdom(value: 200.0)],
      modifier: [
        AddTask(task: "Logistikzentrum Weltmission betreiben"),
        RemoveTask(task: "Logistik-Infrastruktur planen"),
      ],
    ),
    Task(
      name: "Logistikzentrum Weltmission betreiben",
      description: "SYSTEM: Verteilung von Hilfsgütern weltweit innerhalb von Stunden.",
      duration: 40000.0,
      cost: [Money(value: 500000.0), Time(value: 5.0)],
      award: [Publicity(value: 10000.0), Faith(value: 1000.0), Member(value: 1.0)],
      modifier: [
        AddTask(task: "Logistik-Infrastruktur planen"),
      ]
    ),
    Task(
      name: "Theologische Fakultät gründen",
      description: "MEILENSTEIN: Wissenschaftliche Sicherung der Bewegung für Generationen (Limit 1.000.000).",
      duration: 95000.0,
      isMilestone: true,
      cost: [Money(value: 1000000.0), Wisdom(value: 5000.0), Faith(value: 2000.0)],
      award: [Member(value: 1.0)],
      modifier: [
        MessageModifier(message: "BILDUNG: Die Elite wird nun intern geschult. Limit 1.000.000!"),
        SetMax(ressource: "Member", newMax: 1000000.0),
        RemoveTask(task: "Theologische Fakultät gründen"),
        AddTask(task: "Fakultät wissenschaftlich leiten"),
      ],
    ),
    Task(
      name: "Fakultät wissenschaftlich leiten",
      description: "WARTUNG: Stetige Forschung und Lehre zur Bewahrung der DNA.",
      duration: 40000.0,
      cost: [Time(value: 2.0), Wisdom(value: 1000.0)],
      award: [Wisdom(value: 500.0), Faith(value: 200.0)],
    ),
    Task(
      name: "Wirtschaftsprüfung (Audit)",
      description: "KRISE: Unregelmäßigkeiten in einem Kontinent-Büro werden gemeldet. Volle Kooperation nötig!",
      duration: 25000.0,
      timeToSolve: 70000.0,
      cost: [Wisdom(value: 1000.0), Money(value: 50000.0)],
      award: [Wisdom(value: 500.0)],
      modifier: [
        MessageModifier(message: "BESTANDEN: Die Transparenz hat die Integrität der Bewegung bestätigt."),
        RemoveTask(task: "Wirtschaftsprüfung (Audit)"),
      ],
      missed: [
        SubtractRes(ressources: [Publicity(value: 15000.0), Money(value: 200000.0)]),
        MessageModifier(message: "KASKADE: Korruptionsverdacht! Die Presse stürzt sich auf das Thema."),
        RemoveTask(task: "Wirtschaftsprüfung (Audit)"),
        AddTask(task: "Internationaler Presse-Skandal"), // Kaskade
      ],
    ),
    Task(
      name: "Internationaler Presse-Skandal",
      description: "FOLGE-KRISE: Die Weltöffentlichkeit fordert Antworten auf den Korruptionsverdacht.",
      duration: 20000.0,
      timeToSolve: 50000.0,
      cost: [Publicity(value: 10000.0), Wisdom(value: 2000.0)],
      modifier: [
        MessageModifier(message: "GEKLÄRT: Mühsame Aufarbeitung hat den Ruf teilweise gerettet."),
        RemoveTask(task: "Internationaler Presse-Skandal"),
      ],
      missed: [
        SubtractRes(ressources: [Member(value: 10000.0), Faith(value: 2000.0)]),
        MessageModifier(message: "DESASTER: Ein massiver Vertrauensbruch führt zum Austritt ganzer Verbände."),
        RemoveTask(task: "Internationaler Presse-Skandal"),
        AddTask(task: "Internationaler Presse-Skandal"),
      ],
    ),
  ],
);
