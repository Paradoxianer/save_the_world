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
import 'package:save_the_world_flutter_app/models/wisdome.ressource.model.dart';
import 'package:save_the_world_flutter_app/data/stages/common_tasks.dart';

final Stage stage18 = Stage(
  level: 18,
  member: 1000000,
  description: "Globale Bewegung Level 2 - Einfluss auf die Weltpolitik.",
  activeTasks: ["Bibellesen", "Weltweites Gebetsnetzwerk", "UN-Beraterstatus"],
  randomTasks: ["Internationaler Rechtsstreit (Krise)", "Der Heilige Geist möchte wirken", "Beerdigung eines Generals"],
  allTasks: [
    baseBible,
    baseSleep,
    collectMoney,
    holySpiritWorking,
    funeralGeneral,
    Task(
      name: "Weltweites Gebetsnetzwerk",
      description: "Millionen Menschen beten zeitgleich für den Weltfrieden.",
      duration: 20000.0,
      cost: [Faith(value: 1000.0), Wisdom(value: 500.0)],
      modifier: [
        AutoExecuteModifier(
          intervalMs: 10000,
          modifiers: [
            MultiplyRes(targetResName: "Faith", factorResName: "Member", multiplier: 0.5),
          ]
        ),
      ],
    ),
    Task(
      name: "Internationaler Rechtsstreit (Krise)",
      description: "KRITISCH: Ein Staat versucht die Bewegung weltweit zu verbieten.",
      duration: 30000.0,
      timeToSolve: 100000.0,
      cost: [Money(value: 200000.0), Wisdom(value: 2000.0)],
      online: [MessageModifier(message: "RECHTSALARM: Eine juristische Klage bedroht ganze Kontinente!")],
      missed: [
        SubtractRes(ressources: [Money(value: 500000.0), Publicity(value: 5000.0)]),
        MessageModifier(message: "URTEIL: Rechtsstreit verloren. Massive Strafzahlungen fällig."),
        AddTask(task: "Internationaler Rechtsstreit (Krise)")
      ],
    ),
    Task(
      name: "UN-Beraterstatus beantragen",
      description: "MEILENSTEIN: Offizielle Anerkennung als globaler Akteur (Limit 1.500.000).",
      duration: 120000.0,
      cost: [Publicity(value: 20000.0), Wisdom(value: 10000.0)],
      modifier: [
        MessageModifier(message: "DIPLOMATIE: Die Welt hört auf euch. Limit 1.500.000!"),
        SetMax(ressource: "Member", newMax: 1500000.0),
      ],
    ),
  ],
);
