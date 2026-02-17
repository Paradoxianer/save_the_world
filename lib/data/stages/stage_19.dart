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

final Stage stage19 = Stage(
  level: 19,
  member: 1500000,
  description: "Globale Bewegung Level 3 - Einheit über alle Kulturen hinweg.",
  activeTasks: ["Bibellesen", "Kollekte", "Katastrophen-Hilfsfonds", "Globale Statuten verabschieden"],
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
      modifier: [MultiplyRes(targetResName: "Money", factorResName: "Member", multiplier: 15.0)],
    ),
    Task(
      name: "Katastrophen-Hilfsfonds",
      description: "Automatische Hilfe bei weltweiten Krisen (Inspiration: Tabelle).",
      duration: 50000.0,
      cost: [Money(value: 500000.0), Wisdom(value: 1000.0)],
      modifier: [
        AutoExecuteModifier(
          intervalMs: 30000,
          modifiers: [
            MultiplyRes(targetResName: "Publicity", factorResName: "Member", multiplier: 0.2),
            MessageModifier(message: "HILFE: Euer Fonds hat in einer Krisenregion geholfen."),
          ]
        ),
      ],
    ),
    Task(
      name: "Globale Statuten verabschieden",
      description: "MEILENSTEIN: Rechtliche Einheit der Weltbewegung (Limit 2.500.000).",
      duration: 110000.0,
      cost: [Wisdom(value: 8000.0), Time(value: 40.0), Faith(value: 2000.0)],
      modifier: [
        MessageModifier(message: "HARMONISIERUNG: Die Statuten binden die Kontinente. Limit 2.500.000!"),
        SetMax(ressource: "Member", newMax: 2500000.0),
      ],
    ),
  ],
);
