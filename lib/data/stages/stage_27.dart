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

final Stage stage27 = Stage(
  level: 27,
  member: 250000000,
  description: "Denomination Level 2 - Globale Philanthropie & Eigene Ökonomie.",
  activeTasks: ["Bibellesen", "Kollekte", "Kingdom-Coin (Interne Währung)", "Hilfswerk 'Bread of Life'"],
  randomTasks: ["Theologische Grundsatzfrage (Krise)", "Der Heilige Geist möchte wirken", "Währungs-Spekulation (Krise)"],
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
      modifier: [MultiplyRes(targetResName: "Money", factorResName: "Member", multiplier: 150.0)],
    ),
    Task(
      name: "Kingdom-Coin (Interne Währung)",
      description: "Ein blockchain-basiertes Währungssystem für alle Mitglieder. Macht die Bewegung ökonomisch autark.",
      duration: 250000.0,
      cost: [Money(value: 500000000.0), Wisdom(value: 120000.0)],
      modifier: [
        AutoExecuteModifier(
          intervalMs: 90000,
          modifiers: [
            // Interne Ökonomie: Generiert Geld basierend auf Binnennachfrage der Mitglieder
            MultiplyRes(targetResName: "Money", factorResName: "Member", multiplier: 2.5),
            MessageModifier(message: "ÖKONOMIE: Der Kingdom-Coin stabilisiert eure globalen Finanzen."),
          ]
        ),
      ],
    ),
    Task(
      name: "Hilfswerk 'Bread of Life'",
      description: "Versorgung von Krisengebieten weltweit. Generiert massiv Publicity basierend auf Member-Einsatz.",
      duration: 200000.0,
      cost: [Money(value: 1000000000.0), Wisdom(value: 80000.0), Faith(value: 10000.0)],
      modifier: [
        AutoExecuteModifier(
          intervalMs: 60000,
          modifiers: [
            // Publicity skaliert mit der Größe der Bewegung (Sichtbarkeit der Liebe)
            MultiplyRes(targetResName: "Publicity", factorResName: "Member", multiplier: 0.2),
            MessageModifier(message: "PHILANTHROPIE: Euer Hilfswerk rettet heute tausende Leben."),
          ]
        ),
      ],
    ),
    Task(
      name: "Sitz im Weltbank-Beirat",
      description: "MEILENSTEIN: Anerkennung als globaler Finanzakteur (Limit 500.000.000).",
      duration: 500000.0,
      cost: [Wisdom(value: 150000.0), Time(value: 250.0), Faith(value: 80000.0)],
      modifier: [
        MessageModifier(message: "MACHT: Ihr beeinflusst nun die Weltwirtschaft. Limit 500.000.000!"),
        SetMax(ressource: "Member", newMax: 500000000.0),
      ],
    ),
  ],
);
