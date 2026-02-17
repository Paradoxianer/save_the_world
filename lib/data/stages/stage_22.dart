import 'package:save_the_world_flutter_app/data/stages/common_tasks.dart';
import 'package:save_the_world_flutter_app/models/addtask.model.dart';
import 'package:save_the_world_flutter_app/models/faith.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/member.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/message.modifier.dart';
import 'package:save_the_world_flutter_app/models/money.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/publicity.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/removetask.model.dart';
import 'package:save_the_world_flutter_app/models/stage.model.dart';
import 'package:save_the_world_flutter_app/models/setmax.model.dart';
import 'package:save_the_world_flutter_app/models/subtractres.model.dart';
import 'package:save_the_world_flutter_app/models/task.model.dart';
import 'package:save_the_world_flutter_app/models/time.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/wisdome.ressource.model.dart';

final Stage stage22 = Stage(
  level: 22,
  member: 5000000,
  description: "Globale Größe Level 2 - Koordination interkontinentaler Projekte.",
  activeTasks: [
    "Schlafen",
    "Allianz diplomatisch führen",
    "Projekt 'Sauberes Wasser' global",
    "Weltweiten Bildungsfonds gründen"
  ],
  randomTasks: ["Logistik-Blockade (Krise)", "Der Heilige Geist möchte wirken"],
  allTasks: [
    baseSleep,
    holySpiritWorking,
    Task(
      name: "Allianz diplomatisch führen",
      description: "WARTUNG: Tägliche Vertretung auf globaler Ebene.",
      duration: 40000.0,
      cost: [Time(value: 2.0), Wisdom(value: 1500.0)],
      award: [Publicity(value: 500.0), Faith(value: 300.0)],
    ),
    Task(
      name: "Projekt 'Sauberes Wasser' global",
      description: "SYSTEM: Ein koordiniertes Hilfsprojekt auf drei Kontinenten.",
      duration: 60000.0,
      cost: [Money(value: 5000000.0), Member(value: 10000.0)],
      award: [Publicity(value: 25000.0), Faith(value: 5000.0), Member(value: 1.0)],
    ),
    Task(
      name: "Weltweiten Bildungsfonds gründen",
      description: "MEILENSTEIN: Stipendien für zukünftige Leiter weltweit (Limit 7.500.000).",
      duration: 120000.0,
      isMilestone: true,
      cost: [Money(value: 15000000.0), Wisdom(value: 30000.0)],
      award: [Member(value: 1.0)],
      modifier: [
        MessageModifier(message: "BILDUNG: Die nächste Generation Leiter ist gesichert. Limit 7.500.000!"),
        SetMax(ressource: "Member", newMax: 7500000.0),
        RemoveTask(task: "Weltweiten Bildungsfonds gründen"),
        AddTask(task: "Bildungsfonds verwalten"),
      ],
    ),
    Task(
      name: "Bildungsfonds verwalten",
      description: "WARTUNG: Operative Begleitung der weltweiten Stipendiaten.",
      duration: 50000.0,
      cost: [Time(value: 4.0), Money(value: 100000.0)],
      award: [Wisdom(value: 1000.0), Faith(value: 200.0)],
    ),
    Task(
      name: "Logistik-Blockade (Krise)",
      description: "KRISE: Politische Unruhen blockieren die globale Hilfsgüter-Verteilung!",
      duration: 20000.0,
      timeToSolve: 50000.0,
      cost: [Wisdom(value: 5000.0), Publicity(value: 5000.0)],
      award: [Wisdom(value: 1000.0)],
      modifier: [
        MessageModifier(message: "GELÖST: Die Korridore sind wieder offen."),
        RemoveTask(task: "Logistik-Blockade (Krise)"),
      ],
      missed: [
        SubtractRes(ressources: [Money(value: 1000000.0), Faith(value: 2000.0)]),
        MessageModifier(message: "KASKADE: Die Blockade führt zu einem globalen Versorgungsengpass!"),
        RemoveTask(task: "Logistik-Blockade (Krise)"),
        AddTask(task: "Versorgungsengpass (Krise)"),
      ],
    ),
    Task(
      name: "Versorgungsengpass (Krise)",
      description: "FOLGE-KRISE: Mangelnde Güter gefährden die Glaubwürdigkeit der Allianz.",
      duration: 30000.0,
      timeToSolve: 60000.0,
      cost: [Money(value: 5000000.0), Wisdom(value: 8000.0)],
      modifier: [
        MessageModifier(message: "BEHOBEN: Alternative Routen wurden etabliert."),
        RemoveTask(task: "Versorgungsengpass (Krise)"),
      ],
      missed: [
        SubtractRes(ressources: [Member(value: 200000.0), Publicity(value: 50000.0)]),
        RemoveTask(task: "Versorgungsengpass (Krise)"),
        AddTask(task: "Versorgungsengpass (Krise)"),
      ],
    ),
  ],
);
