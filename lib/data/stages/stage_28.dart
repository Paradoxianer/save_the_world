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

final Stage stage28 = Stage(
  level: 28,
  member: 500000000,
  description: "Denomination Level 3 - Das digitale Jüngerschafts-Imperium.",
  activeTasks: ["Bibellesen", "Kollekte", "AI-Seelsorge-Netzwerk", "Kingdom-Sat-Internet"],
  randomTasks: ["Theologische Grundsatzfrage (Krise)", "Der Heilige Geist möchte wirken", "Satelliten-Hack (Krise)"],
  allTasks: [
    baseBible,
    baseSleep,
    collectMoney,
    holySpiritWorking,
    funeralGeneral,
    Task(
      name: "Kollekte",
      duration: 3000.0,
      cost: [Time(value: 1.0)],
      modifier: [MultiplyRes(targetResName: "Money", factorResName: "Member", multiplier: 200.0)],
    ),
    Task(
      name: "AI-Seelsorge-Netzwerk",
      description: "KI-gestützte Mentoren begleiten hunderte Millionen gleichzeitig. Sichert die Qualität bei globaler Masse.",
      duration: 180000.0,
      cost: [Money(value: 2000000000.0), Wisdom(value: 200000.0)],
      modifier: [
        AutoExecuteModifier(
          intervalMs: 30000,
          modifiers: [
            // Geistliche Qualitätssicherung: Glaube und Weisheit pro Member generieren
            MultiplyRes(targetResName: "Faith", factorResName: "Member", multiplier: 0.0005),
            MultiplyRes(targetResName: "Wisdom", factorResName: "Member", multiplier: 0.0001),
          ]
        ),
      ],
    ),
    Task(
      name: "Kingdom-Sat-Internet",
      description: "Eigene Satelliten für zensurfreies Evangelium weltweit. Bekanntheit konvertiert direkt zu Mitgliedern.",
      duration: 300000.0,
      cost: [Money(value: 5000000000.0), Wisdom(value: 250000.0), Time(value: 100.0)],
      modifier: [
        AutoExecuteModifier(
          intervalMs: 120000,
          modifiers: [
            // Globale Erreichbarkeit: Bekanntheit wird direkt zu Mitgliedern (Faktor 0.5)
            MultiplyRes(targetResName: "Member", factorResName: "Publicity", multiplier: 0.5),
            MessageModifier(message: "REICHWEITE: Euer Signal ist nun auf jedem Kontinent empfangbar."),
          ]
        ),
      ],
    ),
    Task(
      name: "Satelliten-Hack (Krise)",
      description: "KRITISCH: Ein feindliches Regime hat eure Satelliten gehackt! Die Übertragung ist gestört.",
      duration: 80000.0,
      timeToSolve: 200000.0,
      cost: [Wisdom(value: 100000.0), Money(value: 500000000.0)],
      online: [MessageModifier(message: "ALARM: Satelliten-Netzwerk gehackt! Ergreift Gegenmaßnahmen.")],
      missed: [
        SubtractRes(ressources: [Publicity(value: 500000.0), Faith(value: 50000.0)]),
        MessageModifier(message: "SABOTAGE: Die Übertragung fiel aus. Millionen konnten nicht erreicht werden."),
      ],
    ),
    Task(
      name: "Die erste Milliarden-Marke",
      description: "MEILENSTEIN: Jedes achte Lebewesen gehört zur Bewegung (Limit 1.280.000.000).",
      duration: 600000.0,
      cost: [Wisdom(value: 400000.0), Time(value: 500.0), Faith(value: 200000.0)],
      modifier: [
        MessageModifier(message: "HISTORISCH: 1.000.000.000 Seelen! Das Ende der Weltphase rückt näher. Limit 1.280.000.000!"),
        SetMax(ressource: "Member", newMax: 1280000000.0),
      ],
    ),
  ],
);
