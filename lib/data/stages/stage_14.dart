import 'package:save_the_world_flutter_app/models/addtask.model.dart';
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

final Stage stage14 = Stage(
  level: 14,
  member: 50000,
  description: "Eine Bewegung Level 3 - Die Massen mobilisieren.",
  activeTasks: ["Bibellesen", "Kollekte", "Soziale Brennpunkt-Offensive", "Krisen-Interventions-Team"],
  randomTasks: ["Theologische Grundsatzfrage (Krise)", "Der Heilige Geist möchte wirken", "Beerdigung eines Generals"],
  allTasks: [
    baseBible,
    baseSleep,
    collectMoney,
    holySpiritWorking,
    someoneWantsToMarry,
    weddingPhase1,
    weddingPhase2,
    actualWedding,
    funeralGeneral,
    Task(
      name: "Soziale Brennpunkt-Offensive",
      description: "Städte durch Taten der Nächstenliebe verändern (Inspiration: oldstages).",
      duration: 40000.0,
      cost: [Money(value: 150000.0), Member(value: 1000.0)],
      award: [Publicity(value: 5000.0), Faith(value: 1000.0)],
      modifier: [
        AutoExecuteModifier(
          intervalMs: 30000,
          modifiers: [
            MultiplyRes(targetResName: "Member", factorResName: "Member", multiplier: 0.01),
          ]
        ),
      ],
    ),
    Task(
      name: "Krisen-Interventions-Team",
      description: "Professionelle Hilfe bei Katastrophen weltweit.",
      duration: 35000.0,
      cost: [Money(value: 100000.0), Wisdom(value: 1000.0)],
      award: [Publicity(value: 8000.0), Member(value: 2000.0)],
    ),
    Task(
      name: "Globales Headquarter gründen",
      description: "MEILENSTEIN: Ein Kontrollzentrum für die Weltmission (Limit 100000).",
      duration: 80000.0,
      cost: [Money(value: 500000.0), Wisdom(value: 5000.0), Member(value: 5000.0)],
      modifier: [
        MessageModifier(message: "EXPANSION: Euer Headquarter leitet nun Millionen. Limit 100.000!"),
        SetMax(ressource: "Member", newMax: 100000.0),
      ],
    ),
  ],
);
