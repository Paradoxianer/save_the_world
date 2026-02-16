import 'package:save_the_world_flutter_app/models/autoexecute.model.dart';
import 'package:save_the_world_flutter_app/models/faith.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/member.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/message.modifier.dart';
import 'package:save_the_world_flutter_app/models/money.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/multiplyres.model.dart';
import 'package:save_the_world_flutter_app/models/publicity.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/stage.model.dart';
import 'package:save_the_world_flutter_app/models/setmax.model.dart';
import 'package:save_the_world_flutter_app/models/task.model.dart';
import 'package:save_the_world_flutter_app/models/wisdome.ressource.model.dart';
import 'package:save_the_world_flutter_app/data/stages/common_tasks.dart';

final Stage stage10 = Stage(
  level: 10,
  member: 2800,
  description: "Internationale Multiplikation und globale Reichweite.",
  activeTasks: ["Bibellesen", "Schlafen", "Leadership Summit", "Internationale Vision", "Heilsarmeekongress"],
  randomTasks: ["Jemand möchte heiraten", "Der Heilige Geist möchte wirken", "Beerdigung eines Generals"],
  allTasks: [
    baseBible,
    baseSleep,
    collectMoney,
    someoneWantsToMarry,
    holySpiritWorking,
    weddingPhase1,
    weddingPhase2,
    actualWedding,
    funeralGeneral,
    Task(
      name: "Leadership Summit",
      description: "Befähige tausende Leiter weltweit (Inspiration: Tabelle).",
      duration: 25000.0,
      cost: [Money(value: 20000.0), Wisdom(value: 800.0)],
      award: [Faith(value: 500.0), Publicity(value: 200.0)],
      modifier: [
        AutoExecuteModifier(
          intervalMs: 15000,
          modifiers: [
            MultiplyRes(targetResName: "Wisdom", factorResName: "Member", multiplier: 0.05),
          ]
        ),
      ],
    ),
    Task(
      name: "Heilsarmeekongress",
      description: "Tausende Menschen kommen zusammen.",
      duration: 20000.0,
      cost: [Money(value: 10000.0), Faith(value: 500.0), Wisdom(value: 200.0)],
      award: [Faith(value: 1000.0), Publicity(value: 500.0), Member(value: 100.0)],
    ),
    Task(
      name: "Internationale Vision",
      description: "MEILENSTEIN: Startet globale Phase (Limit 4500).",
      duration: 50000.0,
      cost: [Money(value: 50000.0), Faith(value: 2000.0)],
      award: [Publicity(value: 1000.0)],
      modifier: [
        MessageModifier(message: "GLOBAL: Ihr seid nun eine weltweite Bewegung! Limit 4500."),
        SetMax(ressource: "Member", newMax: 4500.0),
      ],
    ),
  ],
);
