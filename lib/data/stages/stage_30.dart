import 'package:save_the_world_flutter_app/models/autoexecute.model.dart';
import 'package:save_the_world_flutter_app/models/faith.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/member.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/message.modifier.dart';
import 'package:save_the_world_flutter_app/models/multiplyres.model.dart';
import 'package:save_the_world_flutter_app/models/stage.model.dart';
import 'package:save_the_world_flutter_app/models/setmax.model.dart';
import 'package:save_the_world_flutter_app/models/task.model.dart';
import 'package:save_the_world_flutter_app/models/time.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/wisdome.ressource.model.dart';
import 'package:save_the_world_flutter_app/data/stages/common_tasks.dart';

final Stage stage30 = Stage(
  level: 30,
  member: 2560000000,
  description: "Weltkirche Level 2 - Das Wirken der Kraft Gottes.",
  activeTasks: ["Bibellesen", "Dienst der Heilung", "Standhaftigkeit in Verfolgung"],
  randomTasks: ["Der Heilige Geist möchte wirken"],
  allTasks: [
    baseBible,
    baseSleep,
    holySpiritWorking,
    Task(
      name: "Dienst der Heilung",
      description: "Gott tut Wunder. Die Welt schaut zu. Erzeugt massiv Publicity, kostet aber extrem viel Faith.",
      duration: 150000.0,
      cost: [Faith(value: 1000000.0), Time(value: 5.0)],
      modifier: [
        AutoExecuteModifier(
          intervalMs: 40000,
          modifiers: [
            // Wunder ziehen Menschen an, die mit Logik nicht mehr erreichbar sind
            MultiplyRes(targetResName: "Member", factorResName: "Faith", multiplier: 0.1),
            MessageModifier(message: "WUNDER: Lahme gehen, Blinde sehen. Die Welt erzittert."),
          ]
        ),
      ],
    ),
    Task(
      name: "Standhaftigkeit in Verfolgung",
      description: "MEILENSTEIN: Zeugnis geben bis zum Äußersten (Limit 5.120.000.000).",
      duration: 600000.0,
      cost: [Faith(value: 2000000.0), Wisdom(value: 1000000.0), Time(value: 200.0)],
      modifier: [
        MessageModifier(message: "ZEUGNIS: Euer Blut ist der Same der Kirche. Limit 5.120.000.000!"),
        SetMax(ressource: "Member", newMax: 5120000000.0),
      ],
    ),
  ],
);
