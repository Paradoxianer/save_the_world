import 'package:save_the_world_flutter_app/models/autoexecute.model.dart';
import 'package:save_the_world_flutter_app/models/faith.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/member.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/message.modifier.dart';
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
  activeTasks: ["Bibellesen", "24/7 Fürbitte-Dienst", "Geistliche Unterscheidung"],
  randomTasks: ["Angriff auf die Einheit (Krise)", "Der Heilige Geist möchte wirken"],
  allTasks: [
    baseBible,
    baseSleep,
    holySpiritWorking,
    Task(
      name: "24/7 Fürbitte-Dienst",
      description: "Ein ununterbrochener Gebetsstrom. Ohne diesen Schutz zerbricht die Weltkirche.",
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
        SubtractRes(ressources: [Faith(value: 500000.0)]),
        MessageModifier(message: "GEFAHR: Der Gebetsschirm ist gerissen. Die Dunkelheit dringt ein."),
      ],
    ),
    Task(
      name: "Geistliche Unterscheidung",
      description: "Schutz vor Irrwegen. MEILENSTEIN: Nur durch Demut wächst das Limit auf 2.560.000.000.",
      duration: 400000.0,
      cost: [Wisdom(value: 500000.0), Faith(value: 300000.0), Time(value: 100.0)],
      modifier: [
        MessageModifier(message: "DEMUT: Die Kirche erkennt ihre Abhängigkeit von Gott. Limit 2.560.000.000!"),
        SetMax(ressource: "Member", newMax: 2560000000.0),
      ],
    ),
  ],
);
