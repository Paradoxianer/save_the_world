import 'package:save_the_world_flutter_app/models/autoexecute.model.dart';
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

final Stage stage22 = Stage(
  level: 22,
  member: 7500000,
  description: "Globale Bewegung Level 6 - Systemische Jüngerschaft (Multiplikation).",
  activeTasks: ["Bibellesen", "Kollekte", "Multiplikatoren-Schulung", "Regionale Koordinatoren einsetzen"],
  randomTasks: ["Der Heilige Geist möchte wirken", "Theologische Grundsatzfrage (Krise)", "Ethik-Skandal in einer Region (Krise)"],
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
      modifier: [MultiplyRes(targetResName: "Money", factorResName: "Member", multiplier: 35.0)],
    ),
    Task(
      name: "Multiplikatoren-Schulung",
      description: "Leiter bilden Leiter aus (2. Tim 2,2). Erzeugt exponentielles passives Wachstum.",
      duration: 120000.0,
      cost: [Wisdom(value: 15000.0), Faith(value: 5000.0), Time(value: 40.0)],
      modifier: [
        AutoExecuteModifier(
          intervalMs: 30000,
          modifiers: [
            // Jüngerschafts-Effekt: 0,5% Wachstum der Mitglieder alle 30 Sek. basierend auf Bestand
            MultiplyRes(targetResName: "Member", factorResName: "Member", multiplier: 0.005),
            MessageModifier(message: "MULTIPLIKATION: Deine Leiter gewinnen neue Jünger weltweit."),
          ]
        ),
      ],
    ),
    Task(
      name: "Regionale Koordinatoren einsetzen",
      description: "Delegation auf Kontinental-Ebene. Erzeugt passiv Management-Kapazität (Weisheit).",
      duration: 100000.0,
      cost: [Money(value: 2000000.0), Wisdom(value: 8000.0)],
      modifier: [
        AutoExecuteModifier(
          intervalMs: 45000,
          modifiers: [
            // Management-Ertrag: Koordinatoren liefern Berichte und Erkenntnisse
            MultiplyRes(targetResName: "Wisdom", factorResName: "Member", multiplier: 0.0005),
          ]
        ),
      ],
    ),
    Task(
      name: "Ethik-Skandal in einer Region (Krise)",
      description: "KRITISCH: Ein regionaler Leiter ist korrupt geworden! Sofortige Intervention nötig.",
      duration: 50000.0,
      timeToSolve: 120000.0,
      cost: [Wisdom(value: 12000.0), Publicity(value: 50000.0), Faith(value: 2000.0)],
      online: [MessageModifier(message: "SKANDAL: Die Presse berichtet über Missstände in Übersee!")],
      missed: [
        SubtractRes(ressources: [Faith(value: 5000.0), Member(value: 500000.0), Money(value: 1000000.0)]),
        MessageModifier(message: "VERTRAUENSVERLUST: Die Bewegung verliert massiv an Glaubwürdigkeit und Mitgliedern."),
      ],
    ),
    Task(
      name: "Dezentrale Struktur festigen",
      description: "MEILENSTEIN: Die Bewegung trägt sich ohne deine direkte Aufsicht (Limit 15.000.000).",
      duration: 250000.0,
      cost: [Wisdom(value: 35000.0), Time(value: 150.0), Faith(value: 15000.0)],
      modifier: [
        MessageModifier(message: "SYSTEMSPRUNG: Die Jüngerschafts-Kette hält weltweit. Limit 15.000.000!"),
        SetMax(ressource: "Member", newMax: 15000000.0),
      ],
    ),
  ],
);
