import 'package:save_the_world_flutter_app/models/addtask.model.dart';
import 'package:save_the_world_flutter_app/models/autoexecute.model.dart';
import 'package:save_the_world_flutter_app/models/message.modifier.dart';
import 'package:save_the_world_flutter_app/models/money.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/multiplyres.model.dart';
import 'package:save_the_world_flutter_app/models/publicity.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/removetask.model.dart';
import 'package:save_the_world_flutter_app/models/stage.model.dart';
import 'package:save_the_world_flutter_app/models/setmax.model.dart';
import 'package:save_the_world_flutter_app/models/task.model.dart';
import 'package:save_the_world_flutter_app/models/time.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/wisdome.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/faith.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/member.ressource.model.dart';
import 'package:save_the_world_flutter_app/data/stages/common_tasks.dart';

final Stage stage9 = Stage(
  level: 9,
  member: 1800,
  description: "MegaChurch Level 2 - Management von Systemen statt Menschen.",
  activeTasks: ["Bibellesen", "Schlafen", "Kollekte", "FSJler einstellen", "Campus-Pastoren einsetzen"],
  randomTasks: ["Jemand möchte heiraten", "Der Heilige Geist möchte wirken", "Streit in der Bewegung"],
  allTasks: [
    baseBible,
    baseSleep,
    collectMoney,
    someoneWantsToMarry,
    holySpiritWorking,
    weddingPhase1,
    weddingPhase2,
    actualWedding,
    Task(
      name: "FSJler einstellen",
      description: "DELEGATION: Administrative Entlastung schaltet den 32-Stunden-Tag frei.",
      duration: 4000.0,
      cost: [Money(value: 500.0), Publicity(value: 100.0), Wisdom(value: 50.0)],
      award: [Time(value: 1.0)],
      modifier: [
        MessageModifier(message: "STRUKTUR: Dein Stab wächst. Zeit-Maximum auf 32h erhöht."),
        SetMax(ressource: "Time", newMax: 32.0),
        AddTask(task: "FSJler bezahlen"),
      ],
    ),
    Task(
      name: "Campus-Pastoren einsetzen",
      description: "MEILENSTEIN: Schult und bevollmächtigt regionale Leiter (Limit 2800).",
      duration: 40000.0,
      isMilestone: true,
      cost: [Wisdom(value: 1000.0), Money(value: 10000.0), Member(value: 200.0)],
      award: [Member(value: 1.0)],
      modifier: [
        MessageModifier(message: "MULTIPLIKATION: Die Campus-Leitung steht. Limit 2800!"),
        SetMax(ressource: "Member", newMax: 2800.0),
        RemoveTask(task: "Campus-Pastoren einsetzen"),
        AddTask(task: "Campus-Netzwerk pflegen"),
      ],
    ),
    Task(
      name: "Campus-Netzwerk pflegen",
      description: "SYSTEM: Halte die Verbindung und unterstütze deine regionalen Teams.",
      duration: 15000.0,
      cost: [Time(value: 4.0), Wisdom(value: 100.0)],
      award: [Faith(value: 50.0)],
      modifier: [
        AutoExecuteModifier(
          intervalMs: 30000,
          modifiers: [
            MultiplyRes(targetResName: "Member", factorResName: "Member", multiplier: 0.002),
            MessageModifier(message: "WACHSTUM: Das Netzwerk gedeiht durch weise Leitung."),
          ]
        ),
      ],
    ),
  ],
);
