import 'package:save_the_world_flutter_app/data/stages/common_tasks.dart';
import 'package:save_the_world_flutter_app/models/addtask.model.dart';
import 'package:save_the_world_flutter_app/models/faith.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/gamewon.modifier.dart';
import 'package:save_the_world_flutter_app/models/member.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/message.modifier.dart';
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
  member: 7600000000,
  description: "Jesus kommt wieder - Die Vollendung des Auftrags.",
  activeTasks: [
    "Schlafen",
    "Bibellesen", "Beten",
    "Die Einheit des Leibes bis zuletzt bewahren",
    "Das Finale Evangelium vorbereiten"
  ],
  randomTasks: ["Finale theologische Anfechtung (Krise)", "Der Heilige Geist möchte wirken"],
  allTasks: [
    baseBible,
    basePrayer,
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
      description: "MEILENSTEIN: Die Rettung der Welt verkünden. Jede Zunge, jedes Volk - \"dieses "
          "Evangelium vom Reich wird verkündigt werden in der ganzen Welt zu einem Zeugnis für alle "
          "Völker, und dann wird das Ende kommen\" (Matthäus 24,14) (Limit 7.600.000.000).",
      duration: 1000000.0,
      isMilestone: true,
      cost: [Faith(value: 1000000.0), Publicity(value: 1000000.0), Wisdom(value: 1000000.0)],
      award: [Member(value: 1.0)],
      modifier: [
        MessageModifier(message: "VOLLBRACHT: Die Botschaft hat jedes Volk erreicht. Limit 7,6 Mrd - jetzt bleibt nur noch, zu warten und wachsam zu sein."),
        SetMax(ressource: "Member", newMax: 7600000000.0),
        RemoveTask(task: "Die frohe Botschaft vollenden"),
        AddTask(task: "Auf die Wiederkunft warten"),
      ],
    ),
    Task(
      name: "Auf die Wiederkunft warten",
      description: "Das Gleichnis von den zehn Jungfrauen (Matthäus 25,1-13) endet mit einer Mahnung: "
          "\"Wacht also, denn ihr wisst weder Tag noch Stunde.\" Nach allem, was aufgebaut, gelehrt und "
          "durchlitten wurde, bleibt am Ende nur noch geduldiges, wachsames Warten in Gebet.",
      duration: 1800000.0,
      once: true,
      cost: [Time(value: 100.0), Faith(value: 500000.0)],
      award: [Faith(value: 1000000.0)],
      modifier: [
        GameWonModifier(),
        RemoveTask(task: "Auf die Wiederkunft warten"),
      ],
    ),
    Task(
      name: "Die Einheit des Leibes bis zuletzt bewahren",
      description: "WARTUNG: \"...damit sie vollendet seien in eins... so wie du, Vater, in mir bist und "
          "ich in dir\" (Johannes 17,23) - der Bund aus allen Völkern und Sprachen hält bis zuletzt "
          "zusammen, nicht durch Strukturen, sondern durch das, worum Jesus selbst gebetet hat.",
      duration: 100000.0,
      cost: [Time(value: 10.0), Faith(value: 100000.0)],
      award: [Publicity(value: 50000.0), Faith(value: 20000.0)],
    ),
    Task(
      name: "Finale theologische Anfechtung (Krise)",
      description: "KRISE: \"Falsche Christusse und falsche Propheten werden auftreten und große Zeichen "
          "und Wunder tun, um, wenn möglich, auch die Auserwählten zu verführen\" (Matthäus 24,24) - der "
          "ultimative Zweifel versucht die Weltkirche kurz vor dem Ziel zu spalten!",
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
