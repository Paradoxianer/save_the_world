import 'package:save_the_world_flutter_app/data/stages/common_tasks.dart';
import 'package:save_the_world_flutter_app/models/addtask.model.dart';
import 'package:save_the_world_flutter_app/models/autoexecute.model.dart';
import 'package:save_the_world_flutter_app/models/faith.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/member.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/message.modifier.dart';
import 'package:save_the_world_flutter_app/models/money.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/multiplyres.model.dart';
import 'package:save_the_world_flutter_app/models/publicity.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/removetask.model.dart';
import 'package:save_the_world_flutter_app/models/stage.model.dart';
import 'package:save_the_world_flutter_app/models/setmax.model.dart';
import 'package:save_the_world_flutter_app/models/subtractres.model.dart';
import 'package:save_the_world_flutter_app/models/task.model.dart';
import 'package:save_the_world_flutter_app/models/time.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/wisdome.ressource.model.dart';

final Stage stage32 = Stage(
  level: 32,
  member: 5120000000,
  description: "Weltkirche Level 3 - Die Vollendung des Auftrags.",
  activeTasks: [
    "Schlafen",
    "Bibellesen",
    "Globale Einheit wahren",
    "Das Finale Evangelium vorbereiten"
  ],
  randomTasks: ["Finale theologische Anfechtung (Krise)", "Der Heilige Geist möchte wirken"],
  allTasks: [
    baseBible,
    baseSleep,
    holySpiritWorking,
    Task(
      name: "Das Finale Evangelium vorbereiten",
      description: "BEFÄHIGUNG: Die letzte, alles entscheidende Botschaft an die gesamte Menschheit formulieren.",
      duration: 200000.0,
      cost: [Wisdom(value: 500000.0), Faith(value: 500000.0)],
      award: [Wisdom(value: 100000.0)],
      modifier: [
        AddTask(task: "Die frohe Botschaft vollenden"),
        RemoveTask(task: "Das Finale Evangelium vorbereiten"),
      ],
    ),
    Task(
      name: "Die frohe Botschaft vollenden",
      description: "MEILENSTEIN: Die Rettung der Welt verkünden. Jede Zunge, jedes Volk (Limit 7.600.000.000).",
      duration: 1000000.0,
      isMilestone: true,
      cost: [Faith(value: 1000000.0), Publicity(value: 1000000.0), Wisdom(value: 1000000.0)],
      award: [Member(value: 1.0)],
      modifier: [
        MessageModifier(message: "MARANATHA: Der Auftrag ist erfüllt! Jedes Knie wird sich beugen. Limit 7,6 Mrd - JESUS KOMMT WIEDER!"),
        SetMax(ressource: "Member", newMax: 7600000000.0),
        RemoveTask(task: "Die frohe Botschaft vollenden"),
        AddTask(task: "Auf die Wiederkunft warten"),
      ],
    ),
    Task(
      name: "Auf die Wiederkunft warten",
      description: "WARTUNG: In Gebet und Wachsamkeit die Gemeinschaft bis zum Ende führen.",
      duration: 100000.0,
      cost: [Time(value: 20.0), Faith(value: 100000.0)],
      award: [Faith(value: 500000.0)],
    ),
    Task(
      name: "Globale Einheit wahren",
      description: "WARTUNG: Sicherung der letzten Strukturen der Weltkirche.",
      duration: 100000.0,
      cost: [Time(value: 10.0), Wisdom(value: 100000.0)],
      award: [Publicity(value: 50000.0)],
    ),
    Task(
      name: "Finale theologische Anfechtung (Krise)",
      description: "KRISE: Der ultimative Zweifel versucht die Weltkirche kurz vor dem Ziel zu spalten!",
      duration: 60000.0,
      timeToSolve: 120000.0,
      cost: [Wisdom(value: 500000.0), Faith(value: 500000.0)],
      modifier: [
        MessageModifier(message: "SIEGREICH: Die Wahrheit hat über die Lüge triumphiert."),
        RemoveTask(task: "Finale theologische Anfechtung (Krise)"),
      ],
      missed: [
        SubtractRes(ressources: [Member(value: 1000000000.0), Faith(value: 1000000.0)]),
        MessageModifier(message: "VERLUST: Milliarden Seelen sind im letzten Moment irregeführt worden!"),
        RemoveTask(task: "Finale theologische Anfechtung (Krise)"),
        AddTask(task: "Finale theologische Anfechtung (Krise)"),
      ],
    ),
  ],
);
