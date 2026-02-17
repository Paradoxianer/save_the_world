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

final Stage stage15 = Stage(
  level: 15,
  member: 100000,
  description: "Globale Bewegung Level 1 - Die Stimme in der Weltgesellschaft.",
  activeTasks: [
    "Bibellesen", 
    "Schlafen", 
    "Kollekte", 
    "Weltweite Kampagne planen"
  ],
  randomTasks: ["Politischer Druck (Krise)", "Der Heilige Geist möchte wirken"],
  allTasks: [
    baseBible,
    baseSleep,
    collectMoney,
    holySpiritWorking,
    Task(
      name: "Weltweite Kampagne planen",
      description: "BEFÄHIGUNG: Vorbereitung einer globalen Aktion für Gerechtigkeit.",
      duration: 30000.0,
      cost: [Wisdom(value: 1000.0), Publicity(value: 500.0)],
      award: [Wisdom(value: 200.0)],
      modifier: [
        AddTask(task: "Weltweite Kampagne starten"),
        RemoveTask(task: "Weltweite Kampagne planen"),
      ],
    ),
    Task(
      name: "Weltweite Kampagne starten",
      description: "MEILENSTEIN: Ein globales Signal, das Millionen erreicht (Limit 250.000).",
      duration: 80000.0,
      isMilestone: true,
      cost: [Money(value: 1000000.0), Publicity(value: 5000.0), Faith(value: 2000.0)],
      award: [Member(value: 1.0)],
      modifier: [
        MessageModifier(message: "IMPULS: Die Welt hat zugehört. Die Bewegung wächst! Limit 250.000."),
        SetMax(ressource: "Member", newMax: 250000.0),
        RemoveTask(task: "Weltweite Kampagne starten"),
        AddTask(task: "Globale Anliegen vertreten"),
      ],
    ),
    Task(
      name: "Globale Anliegen vertreten",
      description: "WARTUNG: Stetige Arbeit an den Zielen der Bewegung.",
      duration: 30000.0,
      cost: [Time(value: 4.0), Wisdom(value: 500.0)],
      award: [Publicity(value: 200.0), Faith(value: 100.0)],
    ),
    Task(
      name: "Politischer Druck (Krise)",
      description: "KRISE: Regierungen stellen die Gemeinnützigkeit in Frage!",
      duration: 20000.0,
      timeToSolve: 60000.0,
      cost: [Wisdom(value: 1500.0), Money(value: 20000.0)],
      award: [Wisdom(value: 200.0)],
      modifier: [
        MessageModifier(message: "BESTANDEN: Die rechtliche Position wurde gefestigt."),
        RemoveTask(task: "Politischer Druck (Krise)"),
      ],
      missed: [
        SubtractRes(ressources: [Money(value: 100000.0), Publicity(value: 5000.0)]),
        MessageModifier(message: "REPRESSION: Schwere finanzielle und rechtliche Folgen weltweit!"),
        RemoveTask(task: "Politischer Druck (Krise)"),
        AddTask(task: "Rechtlicher Beistand suchen"), // Folge-Task bei Misserfolg
      ],
    ),
    Task(
      name: "Rechtlicher Beistand suchen",
      description: "FOLGE-KRISE: Repariere den juristischen Schaden der Bewegung.",
      duration: 25000.0,
      cost: [Money(value: 50000.0), Wisdom(value: 1000.0)],
      modifier: [
        RemoveTask(task: "Rechtlicher Beistand suchen"),
      ],
    ),
  ],
);
