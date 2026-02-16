import 'package:save_the_world_flutter_app/models/addtask.model.dart';
import 'package:save_the_world_flutter_app/models/autoexecute.model.dart';
import 'package:save_the_world_flutter_app/models/message.modifier.dart';
import 'package:save_the_world_flutter_app/models/money.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/multiplyres.model.dart';
import 'package:save_the_world_flutter_app/models/publicity.ressource.model.dart';
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
  activeTasks: ["Bibellesen", "Schlafen", "Kollekte", "FSJler einstellen"],
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
      description: "Spart wahrlich Zeit. Schaltet 32-Stunden-Tag frei (Inspiration: Tabelle).",
      duration: 4000.0,
      cost: [Money(value: 100.0), Publicity(value: 30.0), Time(value: 5.0), Wisdom(value: 5.0)],
      award: [Member(value: 1.0), Time(value: 1.0)],
      modifier: [
        MessageModifier(message: "UPGRADE: Die FSJler sind da! Zeit-Maximum auf 32h erhöht."),
        SetMax(ressource: "Time", newMax: 32.0),
        AddTask(task: "FSJler bezahlen"),
      ],
    ),
    Task(
      name: "FSJler bezahlen",
      description: "KRITISCH: Ohne Moos keine Zeit! Bezahle sie regelmäßig.",
      duration: 10000.0,
      timeToSolve: 60000.0,
      cost: [Money(value: 36.0)],
      award: [Time(value: 8.0)],
      online: [MessageModifier(message: "GEHALT: Deine FSJler warten auf ihre Vergütung.")],
      missed: [
        SetMax(ressource: "Time", newMax: 24.0),
        AddTask(task: "FSJler einstellen"),
        MessageModifier(message: "KÜNDIGUNG: Deine FSJler sind weg. Zeit-Limit wieder bei 24h."),
      ],
    ),
    Task(
      name: "Campus-Pastoren einsetzen",
      description: "MEILENSTEIN: Regionale Leiter übernehmen die Front (Limit 2800).",
      duration: 30000.0,
      cost: [Wisdom(value: 500.0), Money(value: 5000.0), Member(value: 200.0)],
      award: [Time(value: 10.0)],
      modifier: [
        AutoExecuteModifier(
          intervalMs: 20000,
          modifiers: [
            MultiplyRes(targetResName: "Member", factorResName: "Member", multiplier: 0.01),
            MessageModifier(message: "CAMPUS: Eure Zweigstellen wachsen eigenständig."),
          ]
        ),
        SetMax(ressource: "Member", newMax: 2800.0),
      ],
    ),
  ],
);
