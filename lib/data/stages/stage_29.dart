import 'package:save_the_world_flutter_app/models/autoexecute.model.dart';
import 'package:save_the_world_flutter_app/models/faith.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/member.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/message.modifier.dart';
import 'package:save_the_world_flutter_app/models/money.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/multiplyres.model.dart';
import 'package:save_the_world_flutter_app/models/stage.model.dart';
import 'package:save_the_world_flutter_app/models/setmax.model.dart';
import 'package:save_the_world_flutter_app/models/subtractres.model.dart';
import 'package:save_the_world_flutter_app/models/task.model.dart';
import 'package:save_the_world_flutter_app/models/time.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/wisdome.ressource.model.dart';
import 'package:save_the_world_flutter_app/data/stages/common_tasks.dart';

final Stage stage29 = Stage(
  level: 29,
  member: 1280000000,
  description: "Weltkirche Level 1 - Die Herrschaft des Gebets.",
  activeTasks: ["Bibellesen", "24/7 Fürbitte-Dienst", "Radikale Gütergemeinschaft"],
  randomTasks: ["Geistlicher Angriff (Krise)", "Der Heilige Geist möchte wirken"],
  allTasks: [
    baseBible,
    baseSleep,
    holySpiritWorking,
    Task(
      name: "24/7 Fürbitte-Dienst",
      description: "Ein ununterbrochener Gebetsstrom. Ohne diesen Schutz sinkt der Glaube der Weltkirche rapide.",
      duration: 120000.0,
      cost: [Time(value: 10.0), Wisdom(value: 100000.0)],
      modifier: [
        AutoExecuteModifier(
          intervalMs: 30000,
          modifiers: [
            // Gebet generiert Faith basierend auf der schieren Masse der Beter
            MultiplyRes(targetResName: "Faith", factorResName: "Member", multiplier: 0.0001),
          ]
        ),
      ],
      missed: [
        SubtractRes(ressources: [Faith(value: 1000000.0)]),
        MessageModifier(message: "GEFAHR: Der Gebetsschirm ist gerissen. Massive geistliche Dürre!"),
      ],
    ),
    Task(
      name: "Radikale Gütergemeinschaft",
      description: "Verzicht auf weltliche Absicherung. Alles wird geteilt. Erzeugt massiven Zusammenhalt.",
      duration: 200000.0,
      cost: [Money(value: 50000000000.0), Wisdom(value: 200000.0)],
      award: [Faith(value: 500000.0)],
      modifier: [
        MessageModifier(message: "ZEUGNIS: Die Welt staunt über die Liebe unter euch."),
      ],
    ),
    Task(
      name: "Geistliche Unterscheidung",
      description: "MEILENSTEIN: Nur durch Demut wächst das Limit auf 2.560.000.000.",
      duration: 400000.0,
      cost: [Wisdom(value: 800000.0), Faith(value: 500000.0), Time(value: 100.0)],
      modifier: [
        MessageModifier(message: "DEMUT: Die Kirche erkennt ihre Abhängigkeit. Limit 2.560.000.000!"),
        SetMax(ressource: "Member", newMax: 2560000000.0),
      ],
    ),
  ],
);
