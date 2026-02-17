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

final Stage stage24 = Stage(
  level: 24,
  member: 30000000,
  description: "Globaler Beeinflusser Level 1 - Strukturierte Denomination.",
  activeTasks: ["Bibellesen", "Kollekte", "Regional-Präsidien einsetzen", "Digitaler Jüngerschafts-Hub"],
  randomTasks: ["Theologische Grundsatzfrage (Krise)", "Der Heilige Geist möchte wirken", "Finanzprüfung durch den Weltrat"],
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
      modifier: [MultiplyRes(targetResName: "Money", factorResName: "Member", multiplier: 60.0)],
    ),
    Task(
      name: "Regional-Präsidien einsetzen",
      description: "Dezentrale Verwaltungseinheiten auf allen Kontinenten. Stabilisiert die Finanzen passiv.",
      duration: 180000.0,
      cost: [Money(value: 25000000.0), Wisdom(value: 15000.0)],
      modifier: [
        AutoExecuteModifier(
          intervalMs: 60000,
          modifiers: [
            MultiplyRes(targetResName: "Money", factorResName: "Member", multiplier: 15.0),
            MessageModifier(message: "BÜROKRATIE: Deine Präsidien haben die Quartalsbeiträge eingezogen."),
          ]
        ),
      ],
    ),
    Task(
      name: "Digitaler Jüngerschafts-Hub",
      description: "Eine KI-gestützte Plattform zur Begleitung von Millionen. Wandelt Faith in Members um.",
      duration: 120000.0,
      cost: [Wisdom(value: 30000.0), Money(value: 10000000.0)],
      modifier: [
        AutoExecuteModifier(
          intervalMs: 30000,
          modifiers: [
            MultiplyRes(targetResName: "Member", factorResName: "Faith", multiplier: 0.01),
          ]
        ),
      ],
    ),
    Task(
      name: "Globale Satzung verabschieden",
      description: "MEILENSTEIN: Rechtliche Anerkennung als weltweite Konfession (Limit 60.000.000).",
      duration: 300000.0,
      cost: [Wisdom(value: 60000.0), Time(value: 120.0), Faith(value: 30000.0)],
      modifier: [
        MessageModifier(message: "ANERKENNUNG: Die Weltgemeinschaft akzeptiert eure Statuten. Limit 60.000.000!"),
        SetMax(ressource: "Member", newMax: 60000000.0),
      ],
    ),
  ],
);
