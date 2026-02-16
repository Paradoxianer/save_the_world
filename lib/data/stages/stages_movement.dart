import 'package:save_the_world_flutter_app/models/addtask.model.dart';
import 'package:save_the_world_flutter_app/models/autoexecute.model.dart';
import 'package:save_the_world_flutter_app/models/faith.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/member.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/message.modifier.dart';
import 'package:save_the_world_flutter_app/models/modifier.model.dart';
import 'package:save_the_world_flutter_app/models/money.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/multiplyres.model.dart';
import 'package:save_the_world_flutter_app/models/publicity.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/removetask.model.dart';
import 'package:save_the_world_flutter_app/models/ressource.model.dart';
import 'package:save_the_world_flutter_app/models/stage.model.dart';
import 'package:save_the_world_flutter_app/models/setmax.model.dart';
import 'package:save_the_world_flutter_app/models/subtractres.model.dart';
import 'package:save_the_world_flutter_app/models/task.model.dart';
import 'package:save_the_world_flutter_app/models/time.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/wisdome.ressource.model.dart';

// REUSABLE BASE TASKS
final _moveSleep = Task(
  name: "Schlafen",
  description: "Erholung für die Generäle der Bewegung.",
  duration: 8000.0,
  cost: [Time(value: 8.0)],
  award: [Time(value: 16.0)],
);

final _moveBible = Task(
  name: "Bibellesen",
  description: "Spirituelle Vision für globale Expansion.",
  duration: 3000.0,
  cost: [Time(value: 1.0)],
  award: [Faith(value: 100.0), Wisdom(value: 50.0)],
);

final List<Stage> movementStages = [
  // STAGE 11-18 (Gekürzt für Übersicht, bleiben logisch erhalten)
  // ... (Hier folgen Stages 11-18)

  // STAGE 19: Globale Bewegung Level 3 (Max 1.500.000) - Fokus: Harmonisierung
  Stage(
    level: 19,
    member: 1500000,
    description: "Globale Bewegung - Einheit über alle Kulturen hinweg.",
    activeTasks: ["Bibellesen", "Katastrophen-Hilfsfonds", "Globale Statuten verabschieden"],
    allTasks: [
      Task(
        name: "Katastrophen-Hilfsfonds",
        description: "Automatische Hilfe bei weltweiten Krisen.",
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
  ),

  // STAGE 20: Globale Größe Level 1 (Max 2.500.000) - Fokus: Kulturelle Dominanz
  Stage(
    level: 20,
    member: 2500000,
    description: "Globale Größe - Anerkanntes spirituelles Weltzentrum.",
    activeTasks: ["Bibellesen", "Eigene Universität gründen", "Diplomatischer Weltgipfel"],
    randomTasks: ["Weltweite Krisenbewältigung (Krise)"],
    allTasks: [
      Task(
        name: "Eigene Universität gründen",
        description: "Wissenschaftliche Exzellenz weltweit.",
        duration: 150000.0,
        cost: [Money(value: 5000000.0), Wisdom(value: 10000.0)],
        modifier: [
          AutoExecuteModifier(
            intervalMs: 60000,
            modifiers: [
              MultiplyRes(targetResName: "Wisdom", factorResName: "Member", multiplier: 0.1),
            ]
          ),
        ],
      ),
      Task(
        name: "Weltweite Krisenbewältigung (Krise)",
        description: "KRITISCH: Ein globaler Konflikt bedroht die religiöse Freiheit.",
        duration: 40000.0,
        timeToSolve: 120000.0,
        cost: [Publicity(value: 10000.0), Wisdom(value: 5000.0), Faith(value: 3000.0)],
        online: [MessageModifier(message: "WELTKRISE: Massive diplomatische Spannungen bedrohen die Bewegung!")],
        missed: [
          SubtractRes(ressources: [Money(value: 2000000.0), Member(value: 100000.0)]),
          MessageModifier(message: "KATASTROPHE: Diplomatie gescheitert. Enteignungen und Verfolgungen in 5 Ländern."),
          AddTask(task: "Weltweite Krisenbewältigung (Krise)")
        ],
      ),
      Task(
        name: "Anerkennung als Weltreligion",
        description: "MEILENSTEIN: Offizieller Status bei allen Weltregierungen (Limit 5.000.000).",
        duration: 180000.0,
        cost: [Publicity(value: 50000.0), Wisdom(value: 20000.0), Faith(value: 10000.0)],
        modifier: [
          MessageModifier(message: "TRANSFORMATION: Ihr seid nun ein globaler Faktor. Die Weltphase beginnt! Limit 5.000.000!"),
          SetMax(ressource: "Member", newMax: 5000000.0),
        ],
      ),
    ],
  ),
];
