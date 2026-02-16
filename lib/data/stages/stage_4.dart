import 'package:save_the_world_flutter_app/models/addtask.model.dart';
import 'package:save_the_world_flutter_app/models/message.modifier.dart';
import 'package:save_the_world_flutter_app/models/stage.model.dart';
import 'package:save_the_world_flutter_app/models/setmax.model.dart';
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
      description: "Immer schön Ordnung schaffen (Inspiration: oldstages).",
      duration: 20000.0,
      timeToSolve: 70000.0,
      cost: [Time(value: 1.0)],
      award: [Wisdom(value: 5.0)],
      missed: [AddTask(task: "Ein zwischenmenschliches Problem klären")],
      modifier: [AddTask(task: "Korps fegen und putzen")],
    ),
    Task(
      name: "Leiter-Mentoring",
      description: "MEILENSTEIN: Schult Leiter von Leitern (Limit 400).",
      duration: 20000.0,
      cost: [Time(value: 10.0), Wisdom(value: 200.0), Faith(value: 50.0)],
      award: [Wisdom(value: 100.0)],
      modifier: [
        MessageModifier(message: "WACHSTUMSSCHWELLE: Du hast die erste Jüngerschafts-Ebene etabliert. Limit 400!"),
        SetMax(ressource: "Member", newMax: 400.0),
      ],
    ),
  ],
);
