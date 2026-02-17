import 'package:save_the_world_flutter_app/data/stages/common_tasks.dart';
import 'package:save_the_world_flutter_app/models/addtask.model.dart';
import 'package:save_the_world_flutter_app/models/faith.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/member.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/message.modifier.dart';
import 'package:save_the_world_flutter_app/models/money.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/removetask.model.dart';
import 'package:save_the_world_flutter_app/models/stage.model.dart';
import 'package:save_the_world_flutter_app/models/setmax.model.dart';
import 'package:save_the_world_flutter_app/models/subtractres.model.dart';
import 'package:save_the_world_flutter_app/models/task.model.dart';
import 'package:save_the_world_flutter_app/models/time.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/wisdome.ressource.model.dart';

final Stage stage5 = Stage(
    level: 5,
    member: 400,
    description: "Große Gemeinde - Delegation wird zur Notwendigkeit.",
    activeTasks: ["Bibellesen", "Schlafen", "Leiter-Mentoring"],
    randomTasks: ["Ein zwischenmenschliches Problem klären"],
    allTasks: [
      baseBible,
      baseSleep,
      Task(
        name: "Leiter-Mentoring",
        description: "Fördere Leiter, die wiederum andere fördern.",
        duration: 15000.0,
        cost: [Time(value: 8.0), Wisdom(value: 100.0)],
        award: [Wisdom(value: 120.0)],
        modifier: [AddTask(task: "Pastoralreferent einstellen")],
      ),
      Task(
        name: "Pastoralreferent einstellen",
        description: "MEILENSTEIN: Eine professionelle Kraft für die Seelsorge (Limit 600).",
        duration: 25000.0,
        isMilestone: true,
        cost: [Time(value: 10.0), Money(value: 500.0), Wisdom(value: 200.0)],
        award: [Member(value: 1.0)], // Pacing: Reduziert auf 1.0
        modifier: [
          MessageModifier(message: "PROFESSIONALISIERUNG: Mit einem Pastoralreferenten seid ihr bereit für die nächste Stufe (Limit 600)."),
          SetMax(ressource: "Member", newMax: 600.0),
          RemoveTask(task: "Pastoralreferent einstellen"),
          AddTask(task: "Pastorale Arbeit koordinieren"),
        ],
      ),
      Task(
        name: "Pastorale Arbeit koordinieren",
        description: "WARTUNG: Unterstützung des Pastoralteams bei der Begleitung der Gemeinde.",
        duration: 20000.0,
        cost: [Time(value: 4.0), Wisdom(value: 100.0)],
        award: [Faith(value: 50.0), Wisdom(value: 50.0)],
      ),
      Task(
        name: "Ein zwischenmenschliches Problem klären",
        description: "KRISE: Ein tiefer gehender Konflikt erfordert deine volle Aufmerksamkeit.",
        duration: 8000.0,
        timeToSolve: 50000.0,
        cost: [Time(value: 4.0), Wisdom(value: 30.0)],
        modifier: [
          MessageModifier(message: "GEKLÄRT: Die Krise wurde durch weise Begleitung beigelegt."),
          RemoveTask(task: "Ein zwischenmenschliches Problem klären"),
        ],
        missed: [
          SubtractRes(ressources: [Member(value: 15.0)]),
          MessageModifier(message: "ESKALIERT: Der ungelöste Konflikt hat zu Austritten geführt."),
          RemoveTask(task: "Ein zwischenmenschliches Problem klären"),
          AddTask(task: "Ein zwischenmenschliches Problem klären"),
        ],
      ),
    ]);
