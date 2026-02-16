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
import 'package:save_the_world_flutter_app/models/subtractres.model.dart';
import 'package:save_the_world_flutter_app/models/task.model.dart';
import 'package:save_the_world_flutter_app/models/time.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/wisdome.ressource.model.dart';
import 'package:save_the_world_flutter_app/data/stages/common_tasks.dart';

final Stage stage11 = Stage(
  level: 11,
  member: 4500,
  description: "Beeinflussende Kirche - DNA-Transfer in die Regionen.",
  activeTasks: ["Bibellesen", "Schlafen", "Pionier-Team aussenden", "Der Heilige Geist möchte wirken"],
  randomTasks: ["Wirtschaftsprüfung (Audit)", "Streit in der Bewegung", "Jemand möchte heiraten"],
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
      name: "Wirtschaftsprüfung (Audit)",
      description: "KRITISCH: Die Behörden prüfen die Gemeinnützigkeit weltweit (Inspiration: Tabelle).",
      duration: 15000.0,
      timeToSolve: 60000.0,
      cost: [Wisdom(value: 100.0), Time(value: 10.0)],
      award: [Wisdom(value: 50.0), Publicity(value: 20.0)],
      online: [MessageModifier(message: "BÜROKRATIE: Ein großes Audit steht an. Alles muss korrekt sein!")],
      missed: [
        SubtractRes(ressources: [Money(value: 10000.0)]),
        MessageModifier(message: "STRAFE: Audit fehlgeschlagen! Hohe Steuernachzahlungen fällig (-10k)."),
        AddTask(task: "Wirtschaftsprüfung (Audit)")
      ],
    ),
    Task(
      name: "Pionier-Team aussenden",
      description: "DELEGATION (EXP): Ein Team gründet eigenständig neue Werke.",
      duration: 45000.0,
      cost: [Member(value: 50.0), Faith(value: 200.0), Money(value: 5000.0)],
      award: [Publicity(value: 100.0)],
      modifier: [
        AutoExecuteModifier(
          intervalMs: 15000,
          modifiers: [
            MultiplyRes(targetResName: "Member", factorResName: "Member", multiplier: 0.02),
          ]
        ),
        AddTask(task: "Regionale Leiter-Akademie"),
      ],
    ),
    Task(
      name: "Regionale Leiter-Akademie",
      description: "MEILENSTEIN: Systematische Ausbildung auf Führungsebene (Limit 10000).",
      duration: 60000.0,
      cost: [Money(value: 25000.0), Wisdom(value: 800.0), Member(value: 200.0)],
      modifier: [
        MessageModifier(message: "BILDUNG: Die Akademie sichert die Zukunft der Bewegung. Limit 10.000!"),
        SetMax(ressource: "Member", newMax: 10000.0),
      ],
    ),
  ],
);
