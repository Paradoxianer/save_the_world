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

final Stage stage26 = Stage(
  level: 26,
  member: 120000000,
  description: "Denomination Level 1 - Globale Logistik & Infrastruktur.",
  activeTasks: ["Bibellesen", "Kollekte", "Weltweites Logistik-Netzwerk", "Theologische Forschungszentren"],
  randomTasks: ["Theologische Grundsatzfrage (Krise)", "Der Heilige Geist möchte wirken", "Infrastruktur-Ausfall (Krise)"],
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
      modifier: [MultiplyRes(targetResName: "Money", factorResName: "Member", multiplier: 100.0)],
    ),
    Task(
      name: "Weltweites Logistik-Netzwerk",
      description: "Eigene Transportflotten und Lagerhäuser für Hilfsgüter weltweit. Steigert die Effizienz der Ressourcenverteilung.",
      duration: 200000.0,
      cost: [Money(value: 500000000.0), Wisdom(value: 60000.0)],
      modifier: [
        AutoExecuteModifier(
          intervalMs: 60000,
          modifiers: [
            // Logistik-Effekt: Reduziert Verluste und generiert passiv Publicity durch sichtbare Präsenz
            MultiplyRes(targetResName: "Publicity", factorResName: "Member", multiplier: 0.1),
            MessageModifier(message: "LOGISTIK: Eure Flotten erreichen entlegene Regionen."),
          ]
        ),
      ],
    ),
    Task(
      name: "Theologische Forschungszentren",
      description: "Wissenschaftliche Aufarbeitung des Glaubens in allen Kulturen. Generiert massiv Weisheit.",
      duration: 150000.0,
      cost: [Wisdom(value: 50000.0), Money(value: 200000000.0)],
      modifier: [
        AutoExecuteModifier(
          intervalMs: 40000,
          modifiers: [
            // Forschungseffekt: Weisheit generiert sich passiv durch Publikationen
            MultiplyRes(targetResName: "Wisdom", factorResName: "Member", multiplier: 0.0005),
          ]
        ),
      ],
    ),
    Task(
      name: "Infrastruktur-Ausfall (Krise)",
      description: "KRITISCH: Ein Hackerangriff legt das globale Kommunikationsnetz der Denomination lahm!",
      duration: 60000.0,
      timeToSolve: 150000.0,
      cost: [Wisdom(value: 40000.0), Money(value: 100000000.0)],
      online: [MessageModifier(message: "ALARM: Globales Netzwerk offline! Handelt sofort.")],
      missed: [
        SubtractRes(ressources: [Publicity(value: 100000.0), Member(value: 1000000.0)]),
        MessageModifier(message: "CHAOS: Die Kommunikation brach zusammen. Mitglieder sind verunsichert."),
      ],
    ),
    Task(
      name: "Globale Konzils-Beschlüsse",
      description: "MEILENSTEIN: Dogmatische Einigkeit über alle Kontinente hinweg (Limit 250.000.000).",
      duration: 400000.0,
      cost: [Wisdom(value: 100000.0), Time(value: 200.0), Faith(value: 60000.0)],
      modifier: [
        MessageModifier(message: "EINHEIT: Das Konzil hat gesprochen. Die Bewegung ist gefestigt. Limit 250.000.000!"),
        SetMax(ressource: "Member", newMax: 250000000.0),
      ],
    ),
  ],
);
