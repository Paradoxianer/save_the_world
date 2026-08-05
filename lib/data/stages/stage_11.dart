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
  activeTasks: [ "Bibellesen", "Beten",
    "Schlafen",
    "Gesellschaftliche Präsenz zeigen",
    "Lobby-Arbeit aufbauen",
    "Regionale Konferenz veranstalten"
  ],
  randomTasks: ["Vereinnahmt von der Politik", "Der Heilige Geist möchte wirken"],
  allTasks: [
    baseBible,
    basePrayer,
    baseSleep,
    holySpiritWorking,
    Task(
      name: "Gesellschaftliche Präsenz zeigen",
      description: "WARTUNG: Öffentliche Stellungnahmen, Community-Engagement, echte Präsenz im "
          "gesellschaftlichen Diskurs - anders als Lobby-Arbeit geht es hier nicht um Zugang zu "
          "Entscheidungsträgern, sondern um eine authentische, sichtbare Stimme für alle.",
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
      name: "Vereinnahmt von der Politik",
      description: "KRISE: Politische Kräfte wollen euren Einfluss für ihre eigenen Zwecke nutzen. Die "
          "Versuchung ist groß - Zugang zu Macht, Schutz, Fördergelder - aber wer sich vereinnahmen lässt, "
          "verliert die prophetische Distanz, die diese Stimme erst glaubwürdig macht.",
      duration: 12000.0,
      timeToSolve: 50000.0,
      cost: [Wisdom(value: 400.0), Faith(value: 200.0)],
      award: [Publicity(value: 100.0)],
      modifier: [
        MessageModifier(message: "UNABHÄNGIG GEBLIEBEN: Der Einfluss bleibt - aber nicht käuflich."),
        RemoveTask(task: "Vereinnahmt von der Politik"),
      ],
      missed: [
        SubtractRes(ressources: [Faith(value: 400.0), Member(value: 100.0)]),
        MessageModifier(
          message: "VEREINNAHMT: Die Bewegung wird als politisches Werkzeug wahrgenommen - Glaubwürdigkeit "
              "und Vertrauen gehen verloren.",
        ),
        RemoveTask(task: "Vereinnahmt von der Politik"),
        AddTask(task: "Vereinnahmt von der Politik"),
      ],
    ),
  ],
);
