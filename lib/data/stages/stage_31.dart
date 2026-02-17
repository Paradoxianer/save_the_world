import 'package:save_the_world_flutter_app/models/faith.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/message.modifier.dart';
import 'package:save_the_world_flutter_app/models/stage.model.dart';
import 'package:save_the_world_flutter_app/models/setmax.model.dart';
import 'package:save_the_world_flutter_app/models/subtractres.model.dart';
import 'package:save_the_world_flutter_app/models/task.model.dart';
import 'package:save_the_world_flutter_app/models/time.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/wisdome.ressource.model.dart';
import 'package:save_the_world_flutter_app/data/stages/common_tasks.dart';

final Stage stage31 = Stage(
  level: 31,
  member: 5120000000,
  description: "Weltkirche Level 3 - Das große Schweigen vor dem Sturm.",
  activeTasks: ["Bibellesen", "Stilles Ausharren", "Das Unmögliche erbitten"],
  randomTasks: ["Der Heilige Geist möchte wirken"],
  allTasks: [
    baseBible,
    baseSleep,
    Task(
      name: "Das Unmögliche erbitten",
      description: "Menschlich ist niemand mehr zu erreichen. Nur ein göttliches Eingreifen rettet die letzten Seelen.",
      duration: 1000000.0,
      cost: [Faith(value: 5000000.0), Wisdom(value: 2000000.0)],
      modifier: [
        MessageModifier(message: "ERWARTUNG: Die gesamte Schöpfung sehnt sich nach der Offenbarung."),
      ],
      missed: [
        SubtractRes(ressources: [Faith(value: 2000000.0)]),
        MessageModifier(message: "ZWEIFEL: Die Dunkelheit scheint zu siegen. Haltet fest am Glauben!"),
      ],
    ),
    Task(
      name: "Die Vision der Wiederkunft",
      description: "MEILENSTEIN: Vorbereitung der Welt auf das Ende aller Tage (Limit 8.000.000.000).",
      duration: 1500000.0,
      cost: [Faith(value: 10000000.0), Time(value: 1000.0)],
      modifier: [
        MessageModifier(message: "MARANATHA: Bereitet den Weg für den König! Limit 8.000.000.000!"),
        SetMax(ressource: "Member", newMax: 8000000000.0),
      ],
    ),
  ],
);
