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

final Stage stage20 = Stage(
  level: 20,
  member: 2500000,
  description: "Globale Bewegung Level 4 - Eigene Medienhäuser.",
  activeTasks: ["Bibellesen", "Kollekte", "Globaler TV-Sender", "Online-Universität"],
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
      modifier: [MultiplyRes(targetResName: "Money", factorResName: "Member", multiplier: 20.0)],
    ),
    Task(
      name: "Globaler TV-Sender",
      description: "Ein eigener TV-Sender, um die Botschaft weltweit zu verbreiten.",
      duration: 80000.0,
      cost: [Money(value: 1000000.0), Wisdom(value: 2000.0)],
      award: [Publicity(value: 50000.0)],
      modifier: [
        AutoExecuteModifier(
          intervalMs: 60000,
          modifiers: [
            MultiplyRes(targetResName: "Publicity", factorResName: "Member", multiplier: 0.5),
            MessageModifier(message: "Eilmeldung: Dein TV-Sender erreicht Millionen!"),
          ]
        ),
      ],
    ),
    Task(
      name: "Online-Universität gründen",
      description: "Eine eigene Universität, um Theologen und Leiter auszubilden.",
      duration: 100000.0,
      cost: [Money(value: 800000.0), Wisdom(value: 5000.0)],
      award: [Wisdom(value: 10000.0), Publicity(value: 20000.0)],
       modifier: [
        MessageModifier(message: "BILDUNG: Deine Universität prägt die nächste Generation!"),
      ],
    ),
    Task(
      name: "Nächste Wachstums-Schwelle (Meilenstein)",
      description: "MEILENSTEIN: Globale Medienpräsenz etabliert (Limit 4.000.000).",
      duration: 150000.0,
      cost: [Wisdom(value: 12000.0), Time(value: 60.0), Faith(value: 5000.0)],
      modifier: [
        MessageModifier(message: "WACHSTUM: Eure Medien erreichen die ganze Welt. Limit 4.000.000!"),
        SetMax(ressource: "Member", newMax: 4000000.0),
      ],
    ),
  ],
);
