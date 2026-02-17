import 'package:save_the_world_flutter_app/data/stages/common_tasks.dart';
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

final Stage stage21 = Stage(
  level: 21,
  member: 2500000,
  description: "Globale Größe Level 1 - Die Bewegung wird zum diplomatischen Akteur.",
  activeTasks: [
    "Schlafen",
    "Globalen Dienst aufrechterhalten",
    "Diplomatische Kanäle öffnen",
    "Internationale Allianz gründen"
  ],
  randomTasks: ["Cyber-Angriff (Krise)", "Der Heilige Geist möchte wirken"],
  allTasks: [
    baseSleep,
    holySpiritWorking,
    Task(
      name: "Globalen Dienst aufrechterhalten",
      description: "WARTUNG: Koordination der weltweiten Hilfswerke.",
      duration: 35000.0,
      cost: [Time(value: 2.0), Wisdom(value: 1000.0)],
      award: [Faith(value: 200.0), Publicity(value: 200.0)],
    ),
    Task(
      name: "Diplomatische Kanäle öffnen",
      description: "BEFÄHIGUNG: Schafft die Basis für globale Anerkennung durch Staaten.",
      duration: 45000.0,
      cost: [Publicity(value: 5000.0), Wisdom(value: 2000.0)],
      award: [Wisdom(value: 1000.0)],
      modifier: [
        AddTask(task: "Weltweiten Friedensgipfel ausrichten"),
        RemoveTask(task: "Diplomatische Kanäle öffnen"),
      ],
    ),
    Task(
      name: "Weltweiten Friedensgipfel ausrichten",
      description: "SYSTEM: Deine Stimme vermittelt in globalen Konflikten.",
      duration: 70000.0,
      cost: [Money(value: 2000000.0), Publicity(value: 10000.0)],
      award: [Member(value: 1.0), Publicity(value: 5000.0)],
      modifier: [
        AddTask(task: "Diplomatische Kanäle öffnen"),
      ]
    ),
    Task(
      name: "Internationale Allianz gründen",
      description: "MEILENSTEIN: Offizieller Status als globale Körperschaft (Limit 5.000.000).",
      duration: 150000.0,
      isMilestone: true,
      cost: [Money(value: 10000000.0), Wisdom(value: 20000.0), Publicity(value: 15000.0)],
      award: [Member(value: 1.0)],
      modifier: [
        MessageModifier(message: "ANERKENNUNG: Die Bewegung ist nun völkerrechtlich relevant. Limit 5.000.000!"),
        SetMax(ressource: "Member", newMax: 5000000.0),
        RemoveTask(task: "Internationale Allianz gründen"),
        AddTask(task: "Allianz diplomatisch führen"),
      ],
    ),
    Task(
      name: "Allianz diplomatisch führen",
      description: "WARTUNG: Tägliche Vertretung der Allianz auf globaler Ebene.",
      duration: 60000.0,
      cost: [Time(value: 4.0), Wisdom(value: 2000.0)],
      award: [Publicity(value: 2000.0), Faith(value: 500.0)],
    ),
    Task(
      name: "Cyber-Angriff (Krise)",
      description: "KRISE: Hacker versuchen die globale Infrastruktur der Allianz lahmzulegen!",
      duration: 15000.0,
      timeToSolve: 35000.0, // Sehr schnell
      cost: [Wisdom(value: 5000.0), Money(value: 500000.0)],
      award: [Wisdom(value: 1000.0)],
      modifier: [
        MessageModifier(message: "ABGEWEHRT: Die Systeme sind wieder sicher."),
        RemoveTask(task: "Cyber-Angriff (Krise)"),
      ],
      missed: [
        SubtractRes(ressources: [Money(value: 2000000.0), Publicity(value: 20000.0)]),
        MessageModifier(message: "KASKADE: Die Angreifer haben sensible Daten erbeutet!"),
        RemoveTask(task: "Cyber-Angriff (Krise)"),
        AddTask(task: "Daten-Leck Skandal (Krise)"),
      ],
    ),
    Task(
      name: "Daten-Leck Skandal (Krise)",
      description: "FOLGE-KRISE: Weltweites Vertrauen schwindet durch gestohlene Daten.",
      duration: 25000.0,
      timeToSolve: 50000.0,
      cost: [Publicity(value: 30000.0), Wisdom(value: 5000.0)],
      modifier: [
        MessageModifier(message: "BEREINIGT: Mühsame Transparenzoffensive hat den Schaden begrenzt."),
        RemoveTask(task: "Daten-Leck Skandal (Krise)"),
      ],
      missed: [
        SubtractRes(ressources: [Member(value: 100000.0), Faith(value: 10000.0)]),
        RemoveTask(task: "Daten-Leck Skandal (Krise)"),
        AddTask(task: "Daten-Leck Skandal (Krise)"),
      ],
    ),
  ],
);
