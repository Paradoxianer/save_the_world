import 'package:save_the_world_flutter_app/models/addtask.model.dart';
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

final Stage stage13 = Stage(
  level: 13,
  member: 20000,
  description: "Eine Bewegung Level 2 - Fokus auf DNA-Transfer und Identität.",
  activeTasks: ["Bibellesen", "Kollekte", "DNA-Transfer Workshop", "Fernsehsendung produzieren"],
  randomTasks: ["Theologische Grundsatzfrage (Krise)", "Der Heilige Geist möchte wirken", "Jemand möchte heiraten"],
  allTasks: [
    baseBible,
    collectMoney,
    holySpiritWorking,
    someoneWantsToMarry,
    weddingPhase1,
    weddingPhase2,
    actualWedding,
    Task(
      name: "DNA-Transfer Workshop",
      description: "Kernwerte in alle Regionen exportieren.",
      duration: 25000.0,
      cost: [Time(value: 5.0), Wisdom(value: 500.0), Faith(value: 200.0)],
      award: [Faith(value: 300.0), Wisdom(value: 200.0)],
    ),
    Task(
      name: "Fernsehsendung produzieren",
      description: "Das Evangelium über Massenmedien verbreiten (Inspiration: oldstages).",
      duration: 30000.0,
      cost: [Money(value: 50000.0), Publicity(value: 500.0)],
      award: [Publicity(value: 1000.0), Member(value: 1000.0)],
    ),
    Task(
      name: "Theologische Grundsatzfrage (Krise)",
      description: "GEFAHR: Ein Konflikt über die DNA der Bewegung droht alles zu spalten.",
      duration: 20000.0,
      timeToSolve: 60000.0,
      cost: [Wisdom(value: 1000.0), Faith(value: 500.0)],
      online: [MessageModifier(message: "DNA-ALARM: Eine theologische Kontroverse gefährdet die Einheit!")],
      missed: [
        SubtractRes(ressources: [Member(value: 2000.0), Faith(value: 500.0)]),
        MessageModifier(message: "SPALTUNG: Wegen ungeklärter Grundsatzfragen haben sich ganze Regionen abgespalten."),
        AddTask(task: "Theologische Grundsatzfrage (Krise)")
      ],
    ),
    Task(
      name: "Internationale Konferenz",
      description: "MEILENSTEIN: Vernetzung über Landesgrenzen hinweg (Limit 50000).",
      duration: 60000.0,
      cost: [Money(value: 200000.0), Publicity(value: 1000.0), Wisdom(value: 2000.0)],
      modifier: [
        MessageModifier(message: "GLOBAL: Ihr seid nun bereit für den Kontinentalen Sprung! Limit 50.000."),
        SetMax(ressource: "Member", newMax: 50000.0),
      ],
    ),
  ],
);
