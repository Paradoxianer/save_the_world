import 'package:save_the_world_flutter_app/models/addtask.model.dart';
import 'package:save_the_world_flutter_app/models/message.modifier.dart';
import 'package:save_the_world_flutter_app/models/money.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/stage.model.dart';
import 'package:save_the_world_flutter_app/models/setmax.model.dart';
import 'package:save_the_world_flutter_app/models/task.model.dart';
import 'package:save_the_world_flutter_app/models/time.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/wisdome.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/faith.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/publicity.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/member.ressource.model.dart';
import 'package:save_the_world_flutter_app/data/stages/common_tasks.dart';

final Stage stage8 = Stage(
  level: 8,
  member: 1100,
  description: "MegaChurch Level 1 - Die Leitung durch Vision wird zentral.",
  activeTasks: ["Bibellesen", "Schlafen", "Budget erstellen", "Vision-Casting"],
  randomTasks: ["Jemand möchte heiraten", "Der Heilige Geist möchte wirken", "Kassendifferenz finden"],
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
      name: "Vision-Casting",
      description: "Begeistere die Massen für die Zukunft der Gemeinde.",
      duration: 15000.0,
      cost: [Time(value: 4.0), Faith(value: 300.0)],
      award: [Faith(value: 500.0), Publicity(value: 50.0), Member(value: 0.5)],
    ),
    Task(
      name: "Budget erstellen",
      description: "Die Finanzen einer MegaChurch erfordern Planung.",
      duration: 15000.0,
      cost: [Time(value: 4.0), Wisdom(value: 100.0)],
      award: [Money(value: 500.0), Wisdom(value: 20.0)],
      modifier: [AddTask(task: "Budget verteidigen")],
    ),
    Task(
      name: "Budget verteidigen",
      description: "Überzeuge die Gremien von den notwendigen Ausgaben.",
      duration: 10000.0,
      cost: [Time(value: 2.0), Faith(value: 50.0)],
      award: [Wisdom(value: 30.0), Money(value: 1000.0)],
    ),
    Task(
      name: "Filialgemeinde gründen",
      description: "MEILENSTEIN: Erster Ableger in einer Nachbarstadt (Limit 1800).",
      duration: 35000.0,
      isMilestone: true,
      cost: [Money(value: 5000.0), Faith(value: 500.0)],
      award: [Publicity(value: 200.0), Member(value: 1.0)],
      modifier: [
        MessageModifier(message: "MULTIPLIKATION: Der erste Campus ist eröffnet! Limit 1800!"),
        SetMax(ressource: "Member", newMax: 1800.0),
      ],
    ),
  ],
);
