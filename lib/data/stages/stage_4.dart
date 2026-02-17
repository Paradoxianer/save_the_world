import 'package:save_the_world_flutter_app/models/addtask.model.dart';
import 'package:save_the_world_flutter_app/models/message.modifier.dart';
import 'package:save_the_world_flutter_app/models/removetask.model.dart';
import 'package:save_the_world_flutter_app/models/stage.model.dart';
import 'package:save_the_world_flutter_app/models/setmax.model.dart';
import 'package:save_the_world_flutter_app/models/subtractres.model.dart';
import 'package:save_the_world_flutter_app/models/task.model.dart';
import 'package:save_the_world_flutter_app/models/time.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/wisdome.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/faith.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/member.ressource.model.dart';
import 'package:save_the_world_flutter_app/data/stages/common_tasks.dart';

final Stage stage4 = Stage(
  level: 4,
  member: 200,
  description: "Kleine Gemeinde - Wachstum durch persönliche Begleitung.",
  activeTasks: ["Bibellesen", "Schlafen", "Mentoring", "Korps aufräumen"],
  randomTasks: ["Ein zwischenmenschliches Problem klären", "Streit in der Gemeinde"],
  allTasks: [
    baseBible,
    baseSleep,
    Task(
      name: "Mentoring",
      description: "DELEGATION (START): Kostet viel Weisheit, bringt noch keine Zeit.",
      duration: 12000.0,
      cost: [Time(value: 6.0), Wisdom(value: 50.0)],
      award: [Wisdom(value: 60.0)], 
      modifier: [AddTask(task: "Leiter-Mentoring")],
    ),
    Task(
      name: "Korps aufräumen",
      description: "Immer schön Ordnung schaffen.",
      duration: 20000.0,
      timeToSolve: 70000.0,
      cost: [Time(value: 1.0)],
      award: [Wisdom(value: 5.0)],
      modifier: [AddTask(task: "Korps fegen und putzen")],
    ),
    Task(
      name: "Leiter-Mentoring",
      description: "MEILENSTEIN: Schult Leiter von Leitern (Limit 400).",
      duration: 20000.0,
      isMilestone: true,
      cost: [Time(value: 10.0), Wisdom(value: 200.0), Faith(value: 50.0)],
      award: [Wisdom(value: 100.0), Member(value: 1.0)],
      modifier: [
        MessageModifier(message: "WACHSTUMSSCHWELLE: Du hast die erste Jüngerschafts-Ebene etabliert. Limit 400!"),
        SetMax(ressource: "Member", newMax: 400.0),
        RemoveTask(task: "Leiter-Mentoring"),
        AddTask(task: "Mentoring-Programm leiten"),
      ],
    ),
    Task(
      name: "Mentoring-Programm leiten",
      description: "WARTUNG: Sorge für die Qualität der geistlichen Begleitung.",
      duration: 15000.0,
      cost: [Time(value: 4.0), Wisdom(value: 50.0)],
      award: [Wisdom(value: 80.0), Faith(value: 20.0)],
    ),
    Task(
      name: "Ein zwischenmenschliches Problem klären",
      description: "KRISE: Ein Gemeindemitglied ist sauer. Schlichtung ist nötig.",
      duration: 6000.0,
      timeToSolve: 60000.0,
      cost: [Time(value: 3.0), Wisdom(value: 10.0)],
      modifier: [
        MessageModifier(message: "GELÖST: Das Problem wurde aus der Welt geschafft."),
        RemoveTask(task: "Ein zwischenmenschliches Problem klären"),
      ],
      missed: [
        SubtractRes(ressources: [Member(value: 5.0)]),
        MessageModifier(message: "ESKALIERT: Der Streit hat Mitglieder gekostet."),
        RemoveTask(task: "Ein zwischenmenschliches Problem klären"),
        AddTask(task: "Ein zwischenmenschliches Problem klären"),
      ],
    ),
    Task(
      name: "Streit in der Gemeinde",
      description: "KRISE: Eine Meinungsverschiedenheit droht die Einheit zu spalten.",
      duration: 10000.0,
      timeToSolve: 80000.0,
      cost: [Wisdom(value: 50.0), Faith(value: 20.0)],
      modifier: [
        MessageModifier(message: "VERSÖHNT: Die Einheit wurde bewahrt."),
        RemoveTask(task: "Streit in der Gemeinde"),
      ],
      missed: [
        SubtractRes(ressources: [Member(value: 10.0), Faith(value: 50.0)]),
        RemoveTask(task: "Streit in der Gemeinde"),
        AddTask(task: "Streit in der Gemeinde"),
      ],
    ),
  ],
);
