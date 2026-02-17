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

final Stage stage27 = Stage(
  level: 27,
  member: 250000000,
  description: "Denomination Level 2 - Ökumenische Einheit und globale Verantwortung.",
  activeTasks: [
    "Schlafen",
    "Konzils-Entscheidungen wahren",
    "Ökumenische Dialoge führen",
    "Weltweite Ökumene-Charta"
  ],
  randomTasks: ["Internationales Spaltungsrisiko (Krise)", "Der Heilige Geist möchte wirken"],
  allTasks: [
    baseSleep,
    holySpiritWorking,
    Task(
      name: "Konzils-Entscheidungen wahren",
      description: "WARTUNG: Sicherstellung der dogmatischen Einheit über alle Kontinente hinweg.",
      duration: 60000.0,
      cost: [Time(value: 5.0), Wisdom(value: 8000.0)],
      award: [Faith(value: 5000.0)],
    ),
    Task(
      name: "Ökumenische Dialoge führen",
      description: "BEFÄHIGUNG: Vorbereitung der Charta durch Gespräche mit anderen Weltreligionen.",
      duration: 120000.0,
      cost: [Publicity(value: 100000.0), Wisdom(value: 30000.0)],
      award: [Wisdom(value: 10000.0)],
      modifier: [
        AddTask(task: "Weltweite Ökumene-Charta"),
        RemoveTask(task: "Ökumenische Dialoge führen"),
      ],
    ),
    Task(
      name: "Weltweite Ökumene-Charta",
      description: "MEILENSTEIN: Historische Einigung der Weltreligionen (Limit 500.000.000).",
      duration: 500000.0,
      isMilestone: true,
      cost: [Money(value: 500000000.0), Faith(value: 100000.0), Wisdom(value: 150000.0)],
      award: [Member(value: 1.0)],
      modifier: [
        MessageModifier(message: "FRIEDEN: Ein historischer Moment für die Menschheit! Limit 500.000.000."),
        SetMax(ressource: "Member", newMax: 500000000.0),
        RemoveTask(task: "Weltweite Ökumene-Charta"),
        AddTask(task: "Interreligiösen Dialog fördern"),
      ],
    ),
    Task(
      name: "Interreligiösen Dialog fördern",
      description: "WARTUNG: Tägliche Arbeit an der globalen religiösen Harmonie.",
      duration: 80000.0,
      cost: [Time(value: 10.0), Wisdom(value: 15000.0)],
      award: [Faith(value: 10000.0), Publicity(value: 20000.0)],
    ),
    Task(
      name: "Internationales Spaltungsrisiko (Krise)",
      description: "KRISE: Nationalistische Strömungen drohen, die globale Einheit zu zerbrechen!",
      duration: 50000.0,
      timeToSolve: 150000.0,
      cost: [Wisdom(value: 50000.0), Publicity(value: 100000.0)],
      modifier: [
        MessageModifier(message: "EINHEIT GESTÄRKT: Die gemeinsamen Werte haben sich durchgesetzt."),
        RemoveTask(task: "Internationales Spaltungsrisiko (Krise)"),
      ],
      missed: [
        SubtractRes(ressources: [Member(value: 10000000.0), Faith(value: 50000.0)]),
        MessageModifier(message: "ZERFALL: Ganze Kontinentalverbände haben die Allianz verlassen."),
        RemoveTask(task: "Internationales Spaltungsrisiko (Krise)"),
        AddTask(task: "Internationales Spaltungsrisiko (Krise)"),
      ],
    ),
  ],
);
