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

final Stage stage11 = Stage(
  level: 11,
  member: 4500,
  description: "Beeinflussende Kirche - Deine Stimme hat Gewicht in der Gesellschaft.",
  activeTasks: [
    "Schlafen",
    "Globalen Dienst aufrechterhalten",
    "Lobby-Arbeit aufbauen",
    "Regionale Konferenz veranstalten"
  ],
  randomTasks: ["Medien-Skandal", "Der Heilige Geist möchte wirken"],
  allTasks: [
    baseSleep,
    holySpiritWorking,
    Task(
      name: "Globalen Dienst aufrechterhalten",
      description: "WARTUNG: Koordiniere die weltweiten Aktivitäten.",
      duration: 20000.0,
      cost: [Time(value: 2.0), Wisdom(value: 50.0)],
      award: [Faith(value: 20.0), Publicity(value: 10.0)],
    ),
    Task(
      name: "Lobby-Arbeit aufbauen",
      description: "SYSTEM: Baue ein Netzwerk auf, um gesellschaftliche Anliegen zu vertreten.",
      duration: 18000.0,
      cost: [Money(value: 10000.0), Wisdom(value: 300.0)],
      award: [Publicity(value: 200.0)],
      modifier: [
        MessageModifier(message: "EINFLUSS: Dein Netzwerk generiert nun passiv Ansehen."),
        AutoExecuteModifier(
            intervalMs: 15000,
            modifiers: [
              MultiplyRes(targetResName: "Publicity", factorResName: "Wisdom", multiplier: 0.1),
            ]),
        RemoveTask(task: "Lobby-Arbeit aufbauen"),
      ],
    ),
    Task(
      name: "Regionale Konferenz veranstalten",
      description: "MEILENSTEIN: Ein Schlüssel-Event, das tausende Leiter zusammenbringt (Limit 10.000).",
      duration: 50000.0,
      isMilestone: true,
      cost: [Money(value: 50000.0), Wisdom(value: 1000.0), Publicity(value: 500.0)],
      award: [Member(value: 1.0)],
      modifier: [
        SetMax(ressource: "Member", newMax: 10000.0),
        MessageModifier(message: "BEWEGUNG: Die Konferenz war ein Wendepunkt. Limit auf 10.000 erhöht!"),
        RemoveTask(task: "Regionale Konferenz veranstalten"),
        AddTask(task: "Konferenz-Netzwerk pflegen"),
      ],
    ),
    Task(
      name: "Konferenz-Netzwerk pflegen",
      description: "WARTUNG: Halte die Verbindungen, die auf der Konferenz entstanden sind.",
      duration: 20000.0,
      cost: [Time(value: 2.0), Wisdom(value: 100.0)],
      award: [Faith(value: 50.0), Publicity(value: 50.0)],
    ),
    Task(
      name: "Medien-Skandal",
      description: "KRISE: Falschinformationen verbreiten sich global. Eine schnelle, weise Reaktion ist nötig.",
      duration: 8000.0,
      timeToSolve: 35000.0, // Sehr schnell für eine globale Krise
      cost: [Wisdom(value: 500.0), Publicity(value: 1500.0)],
      award: [Wisdom(value: 100.0)],
      missed: [
        SubtractRes(ressources: [Publicity(value: 2500.0), Faith(value: 500.0)]),
        MessageModifier(message: "REPUTATIONSCHADEN: Das Schweigen hat dem weltweiten Ansehen massiv geschadet."),
        AddTask(task: "Medien-Skandal"),
      ],
    ),
  ],
);
