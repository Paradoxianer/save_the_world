import 'package:save_the_world_flutter_app/models/addtask.model.dart';
import 'package:save_the_world_flutter_app/models/faith.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/member.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/message.modifier.dart';
import 'package:save_the_world_flutter_app/models/money.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/publicity.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/stage.model.dart';
import 'package:save_the_world_flutter_app/models/setmax.model.dart';
import 'package:save_the_world_flutter_app/models/task.model.dart';
import 'package:save_the_world_flutter_app/models/time.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/wisdome.ressource.model.dart';
import 'package:save_the_world_flutter_app/data/stages/common_tasks.dart';

final Stage stage17 = Stage(
  level: 17,
  member: 500000,
  description: "Globale Bewegung Level 1 - Weltweite Infrastruktur.",
  activeTasks: ["Bibellesen", "Kollekte", "Theologische Fakultät gründen", "Logistikzentrum Weltmission"],
  randomTasks: ["Wirtschaftsprüfung (Audit)", "Der Heilige Geist möchte wirken", "Beerdigung eines Generals"],
  allTasks: [
    baseBible,
    baseSleep,
    collectMoney,
    holySpiritWorking,
    funeralGeneral,
    Task(
      name: "Logistikzentrum Weltmission",
      description: "Hilfsgüter weltweit innerhalb von Stunden verteilen.",
      duration: 40000.0,
      cost: [Money(value: 500000.0), Member(value: 5000.0)],
      award: [Publicity(value: 10000.0), Faith(value: 1000.0)],
    ),
    Task(
      name: "Theologische Fakultät gründen",
      description: "MEILENSTEIN: Wissenschaftliche DNA-Wahrung (Limit 1.000.000).",
      duration: 95000.0,
      cost: [Money(value: 1000000.0), Wisdom(value: 5000.0), Time(value: 30.0)],
      modifier: [
        MessageModifier(message: "BILDUNG: Eure Fakultät bildet die Elite der Zukunft aus. Limit 1.000.000!"),
        SetMax(ressource: "Member", newMax: 1000000.0),
      ],
    ),
  ],
);
