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
final _growthSleep = Task(
  name: "Schlafen",
  description: "Erholung für den Visionär.",
  duration: 8000.0,
  cost: [Time(value: 8.0)],
  award: [Time(value: 16.0)],
);

final _growthBible = Task(
  name: "Bibellesen",
  description: "Geistliches Fundament vertiefen.",
  duration: 3000.0,
  cost: [Time(value: 1.0)],
  award: [Faith(value: 20.0), Wisdom(value: 10.0)],
);

final List<Stage> growthStages = [
  // STAGE 4-8 (Hier gekürzt für Übersicht, Fokus auf 9-10)
  // ... (Die vorherigen Stages 4-8 bleiben logisch erhalten) ...

  // STAGE 9: MegaChurch Level 2 (Max 1800) - SAMY: System-Management
  Stage(
    level: 9,
    member: 1800,
    description: "MegaChurch - Management von Systemen und Teams.",
    activeTasks: ["Bibellesen", "Schlafen", "Co-Pastor einstellen", "Sekretärin anstellen"],
    allTasks: [
      _growthBible,
      _growthSleep,
      Task(
        name: "Sekretärin anstellen",
        description: "Automatisiert die Verwaltung und Pressearbeit.",
        duration: 5000.0,
        cost: [Money(value: 1500.0), Wisdom(value: 100.0)],
        award: [Time(value: 2.0)],
        modifier: [
          AutoExecuteModifier(
            intervalMs: 30000,
            modifiers: [
              MultiplyRes(targetResName: "Publicity", factorResName: "Member", multiplier: 0.05),
              MessageModifier(message: "Sekretariat: Pressemitteilung wurde automatisch versendet."),
            ]
          ),
        ],
      ),
      Task(
        name: "Co-Pastor einstellen",
        description: "DELEGATION: Er hält nun automatisch Gottesdienste.",
        duration: 8000.0,
        cost: [Money(value: 3000.0), Wisdom(value: 300.0)],
        modifier: [
          AutoExecuteModifier(
            intervalMs: 45000,
            modifiers: [
              MultiplyRes(targetResName: "Faith", factorResName: "Member", multiplier: 0.1),
              MultiplyRes(targetResName: "Member", factorResName: "Member", multiplier: 0.01),
              MessageModifier(message: "Co-Pastor: Der Sonntagsgottesdienst lief fantastisch!"),
            ]
          ),
          SetMax(ressource: "Member", newMax: 2800.0),
        ],
      ),
    ],
  ),

  // STAGE 10: Globale Bewegung (Max 2800) - SAMY: Multiplikation
  Stage(
    level: 10,
    member: 2800,
    description: "Internationale Multiplikation und Reichweite.",
    activeTasks: ["Leadership Summit", "Internationale Vision", "Heilsarmeekongress"],
    allTasks: [
      _growthSleep,
      Task(
        name: "Heilsarmeekongress",
        description: "Tausende Menschen kommen zusammen (Inspiration: Tabelle).",
        duration: 20000.0,
        cost: [Money(value: 10000.0), Faith(value: 500.0), Wisdom(value: 200.0)],
        award: [Faith(value: 1000.0), Publicity(value: 500.0), Member(value: 100.0)],
      ),
      Task(
        name: "Internationale Vision",
        description: "MEILENSTEIN: Startet globale Phase (Limit 4500).",
        duration: 50000.0,
        cost: [Money(value: 50000.0), Faith(value: 2000.0)],
        award: [Publicity(value: 1000.0)],
        modifier: [
          MessageModifier(message: "GLOBAL: Ihr seid nun eine weltweite Bewegung! Limit 4500."),
          SetMax(ressource: "Member", newMax: 4500.0),
        ],
      ),
    ],
  ),
];
