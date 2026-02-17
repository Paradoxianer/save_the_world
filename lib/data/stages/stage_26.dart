import 'package:save_the_world_flutter_app/models/addtask.model.dart';
import 'package:save_the_world_flutter_app/models/autoexecute.model.dart';
import 'package:save_the_world_flutter_app/models/faith.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/member.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/message.modifier.dart';
import 'package:save_the_world_flutter_app/models/money.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/multiplyres.model.dart';
import 'package:save_the_world_flutter_app/models/publicity.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/removetask.model.dart';
import 'package:save_the_world_flutter_app/models/stage.model.dart';
import 'package:save_the_world_flutter_app/models/setmax.model.dart';
import 'package:save_the_world_flutter_app/models/subtractres.model.dart';
import 'package:save_the_world_flutter_app/models/task.model.dart';
import 'package:save_the_world_flutter_app/models/time.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/wisdome.ressource.model.dart';
import 'package:save_the_world_flutter_app/data/stages/common_tasks.dart';

final Stage stage26 = Stage(
  level: 26,
  member: 120000000,
  description: "Denomination Level 1 - Globale Infrastruktur und theologische Einheit.",
  activeTasks: [
    "Bibellesen", 
    "Schlafen", 
    "Kollekte", 
    "Weltweites Logistik-Netzwerk", 
    "Theologische Konsens-Findung"
  ],
  randomTasks: ["Infrastruktur-Ausfall (Krise)", "Der Heilige Geist möchte wirken"],
  allTasks: [
    baseBible,
    baseSleep,
    collectMoney,
    holySpiritWorking,
    Task(
      name: "Theologische Konsens-Findung",
      description: "BEFÄHIGUNG: Erarbeitet die dogmatische Basis für das globale Konzil.",
      duration: 100000.0,
      cost: [Wisdom(value: 20000.0), Faith(value: 10000.0)],
      award: [Wisdom(value: 5000.0)],
      modifier: [
        AddTask(task: "Globale Konzils-Beschlüsse"),
        RemoveTask(task: "Theologische Konsens-Findung"),
      ],
    ),
    Task(
      name: "Globale Konzils-Beschlüsse",
      description: "MEILENSTEIN: Formelle Einigung über alle Kontinente hinweg (Limit 250.000.000).",
      duration: 300000.0,
      isMilestone: true,
      cost: [Wisdom(value: 100000.0), Time(value: 100.0), Faith(value: 60000.0)],
      award: [Member(value: 1.0)],
      modifier: [
        MessageModifier(message: "EINHEIT: Das Konzil hat gesprochen. Die Weltkirche ist gefestigt. Limit 250.000.000!"),
        SetMax(ressource: "Member", newMax: 250000000.0),
        RemoveTask(task: "Globale Konzils-Beschlüsse"),
        AddTask(task: "Konzils-Entscheidungen wahren"),
      ],
    ),
    Task(
      name: "Konzils-Entscheidungen wahren",
      description: "WARTUNG: Stetige Begleitung der regionalen Kirchen bei der Umsetzung der Beschlüsse.",
      duration: 60000.0,
      cost: [Time(value: 10.0), Wisdom(value: 10000.0)],
      award: [Faith(value: 5000.0), Wisdom(value: 2000.0)],
    ),
    Task(
      name: "Weltweites Logistik-Netzwerk",
      description: "SYSTEM: Eigene Transportflotten sichern die globale Ressourcenverteilung.",
      duration: 200000.0,
      cost: [Money(value: 500000000.0), Wisdom(value: 60000.0)],
      modifier: [
        MessageModifier(message: "LOGISTIK: Eure Flotten erreichen nun jeden Winkel der Erde. Publicity automatisiert."),
        AutoExecuteModifier(
          intervalMs: 60000,
          modifiers: [
            MultiplyRes(targetResName: "Publicity", factorResName: "Member", multiplier: 0.1),
          ]
        ),
        RemoveTask(task: "Weltweites Logistik-Netzwerk"),
      ],
    ),
    Task(
      name: "Infrastruktur-Ausfall (Krise)",
      description: "KRISE: Ein globaler Hackerangriff bedroht die Kommunikationswege der Allianz!",
      duration: 40000.0,
      timeToSolve: 120000.0,
      cost: [Wisdom(value: 30000.0), Money(value: 50000000.0)],
      modifier: [
        MessageModifier(message: "GELÖST: Die Systeme wurden erfolgreich gehärtet."),
        RemoveTask(task: "Infrastruktur-Ausfall (Krise)"),
      ],
      missed: [
        SubtractRes(ressources: [Publicity(value: 100000.0), Member(value: 1000000.0)]),
        MessageModifier(message: "KASKADE: Der Ausfall führt zu einem massiven globalen Daten-Leck!"),
        RemoveTask(task: "Infrastruktur-Ausfall (Krise)"),
        AddTask(task: "Globales Daten-Leck (Krise)"),
      ],
    ),
    Task(
      name: "Globales Daten-Leck (Krise)",
      description: "FOLGE-KRISE: Sensible Mitgliederdaten sind öffentlich. Repariere das Vertrauen.",
      duration: 60000.0,
      cost: [Wisdom(value: 50000.0), Publicity(value: 200000.0)],
      modifier: [
        MessageModifier(message: "BEREINIGT: Die Integrität wurde mühsam wiederhergestellt."),
        RemoveTask(task: "Globales Daten-Leck (Krise)"),
      ],
      missed: [
        SubtractRes(ressources: [Member(value: 5000000.0)]),
        RemoveTask(task: "Globales Daten-Leck (Krise)"),
        AddTask(task: "Globales Daten-Leck (Krise)"),
      ],
    ),
  ],
);
