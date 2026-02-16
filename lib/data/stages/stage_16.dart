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
import 'package:save_the_world_flutter_app/models/time.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/wisdome.ressource.model.dart';
import 'package:save_the_world_flutter_app/data/stages/common_tasks.dart';

final Stage stage16 = Stage(
  level: 16,
  member: 250000,
  description: "Eine Bewegung Level 3 - Die Welt nimmt die Botschaft wahr.",
  activeTasks: ["Bibellesen", "Schlafen", "Eigener Fernsehsender", "Politische Lobbyarbeit"],
  randomTasks: ["Theologische Grundsatzfrage (Krise)", "Der Heilige Geist möchte wirken", "Jemand möchte heiraten"],
  allTasks: [
    baseBible,
    baseSleep,
    collectMoney,
    holySpiritWorking,
    someoneWantsToMarry,
    weddingPhase1,
    weddingPhase2,
    actualWedding,
    Task(
      name: "Eigener Fernsehsender",
      description: "24/7 Verkündigung über Satellit weltweit.",
      duration: 45000.0,
      cost: [Money(value: 500000.0), Publicity(value: 1000.0)],
      modifier: [
        AutoExecuteModifier(
          intervalMs: 20000,
          modifiers: [
            MultiplyRes(targetResName: "Publicity", factorResName: "Member", multiplier: 0.1),
          ]
        ),
      ],
    ),
    Task(
      name: "Politische Lobbyarbeit",
      description: "Einfluss auf Gesetze für mehr soziale Gerechtigkeit.",
      duration: 35000.0,
      cost: [Publicity(value: 2000.0), Wisdom(value: 1000.0)],
      award: [Publicity(value: 5000.0), Faith(value: 500.0)],
    ),
    Task(
      name: "Weltkongress planen",
      description: "MEILENSTEIN: Alle Generäle der Kontinente kommen zusammen (Limit 500000).",
      duration: 90000.0,
      cost: [Money(value: 1000000.0), Faith(value: 5000.0), Member(value: 10000.0)],
      modifier: [
        MessageModifier(message: "KONGRESS: Die Weltarmee marschiert. Limit 500.000!"),
        SetMax(ressource: "Member", newMax: 500000.0),
      ],
    ),
  ],
);
