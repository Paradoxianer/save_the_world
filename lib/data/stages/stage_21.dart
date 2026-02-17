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

final Stage stage21 = Stage(
  level: 21,
  member: 4000000,
  description: "Globale Bewegung Level 5 - Diplomatischer Status.",
  activeTasks: ["Bibellesen", "Kollekte", "Diplomatisches Korps", "Globale Katastrophenhilfe"],
  randomTasks: ["Theologische Grundsatzfrage (Krise)", "Der Heilige Geist möchte wirken", "Beerdigung eines Generals"],
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
      modifier: [MultiplyRes(targetResName: "Money", factorResName: "Member", multiplier: 25.0)],
    ),
    Task(
      name: "Diplomatisches Korps",
      description: "Entsendung von Botschaftern in alle Nationen zur Friedensstiftung.",
      duration: 90000.0,
      cost: [Wisdom(value: 6000.0), Money(value: 500000.0)],
      award: [Publicity(value: 80000.0), Faith(value: 1000.0)],
      modifier: [
        AutoExecuteModifier(
          intervalMs: 45000,
          modifiers: [
            MultiplyRes(targetResName: "Wisdom", factorResName: "Member", multiplier: 0.001),
            MessageModifier(message: "DIPLOMATIE: Eure Botschafter vermitteln in Konflikten."),
          ]
        ),
      ],
    ),
    Task(
      name: "Globale Katastrophenhilfe",
      description: "Soforteinsatzkräfte für weltweite Krisengebiete koordinieren.",
      duration: 120000.0,
      cost: [Money(value: 2000000.0), Wisdom(value: 3000.0), Time(value: 20.0)],
      award: [Publicity(value: 150000.0), Faith(value: 2000.0)],
      modifier: [
        MessageModifier(message: "HILFE: Eure Teams retten Leben an vorderster Front!"),
      ],
    ),
    Task(
      name: "Sitz in der UN-Vollversammlung",
      description: "MEILENSTEIN: Anerkennung als völkerrechtliches Subjekt (Limit 7.500.000).",
      duration: 200000.0,
      cost: [Wisdom(value: 20000.0), Time(value: 100.0), Faith(value: 10000.0)],
      modifier: [
        MessageModifier(message: "ANERKENNUNG: Die Weltgemeinschaft hört auf eure Stimme. Limit 7.500.000!"),
        SetMax(ressource: "Member", newMax: 7500000.0),
      ],
    ),
  ],
);
