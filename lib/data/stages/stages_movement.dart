import 'package:save_the_world_flutter_app/models/addtask.model.dart';
import 'package:save_the_world_flutter_app/models/faith.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/member.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/message.modifier.dart';
import 'package:save_the_world_flutter_app/models/money.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/publicity.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/stage.model.dart';
import 'package:save_the_world_flutter_app/models/task.model.dart';
import 'package:save_the_world_flutter_app/models/time.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/wisdome.ressource.model.dart';

final List<Stage> movementStages = [
  // STAGE 11: Beeinflussende Kirche Level 1 (4.500)
  Stage(
    level: 11,
    member: 4500,
    description: "Beeinflussende Kirche Level 1 - Multiplikation & Pioniergeist.",
    activeTasks: ["Bibellesen", "Beten", "Leiter-Konferenz"],
    allTasks: [
      Task(
        name: "Pionier-Team aussenden",
        description: "DNA der Heilsarmee verbreiten.",
        duration: 45000.0,
        cost: [Member(value: 50.0), Faith(value: 1000.0), Money(value: 10000.0), Time(value: 20.0)],
        award: [Publicity(value: 100.0), Wisdom(value: 200.0)],
      ),
    ],
  ),

  // STAGE 12: Beeinflussende Kirche Level 2 (10.000)
  Stage(
    level: 12,
    member: 10000,
    description: "Beeinflussende Kirche Level 2 - Systematische Expansion.",
    activeTasks: ["Bibellesen", "Schlafen", "Pionier-Team aussenden"],
    allTasks: [],
  ),

  // STAGE 13: Beeinflussende Kirche Level 3 (20.000)
  Stage(
    level: 13,
    member: 20000,
    description: "Beeinflussende Kirche Level 3 - Regionale Verankerung.",
    activeTasks: ["Bibellesen", "Beten", "Schlafen"],
    allTasks: [
      Task(
        name: "DNA-Transfer Workshop",
        description: "Kernwerte in allen Kleingruppen sicherstellen.",
        duration: 20000.0,
        cost: [Time(value: 15.0), Wisdom(value: 500.0)],
        award: [Faith(value: 200.0), Wisdom(value: 100.0)],
      ),
    ],
  ),

  // STAGE 14: Eine Bewegung Level 1 (50.000)
  Stage(
    level: 14,
    member: 50000,
    description: "Eine Bewegung Level 1 - Fokus auf Massen-Jüngerschaft.",
    activeTasks: ["DNA-Transfer Workshop", "Bibellesen", "Schlafen"],
    allTasks: [],
  ),

  // STAGE 15: Eine Bewegung Level 2 (100.000)
  Stage(
    level: 15,
    member: 100000,
    description: "Eine Bewegung Level 2 - Jüngerschaft im großen Stil.",
    activeTasks: ["Bibellesen", "Schlafen"],
    allTasks: [
      Task(
        name: "Regionale Leiter-Akademie",
        description: "Ausbildungszentrum für hunderte neue Offiziere.",
        duration: 60000.0,
        cost: [Money(value: 50000.0), Time(value: 40.0), Wisdom(value: 2000.0)],
        award: [Member(value: 500.0), Wisdom(value: 500.0)],
      ),
    ],
  ),

  // STAGE 16: Eine Bewegung Level 3 (250.000)
  Stage(
    level: 16,
    member: 250000,
    description: "Eine Bewegung Level 3 - Kulturelle Relevanz.",
    activeTasks: ["Bibellesen", "Schlafen", "Regionale Leiter-Akademie"],
    allTasks: [],
  ),

  // STAGE 17: Globale Bewegung Level 1 (500.000)
  Stage(
    level: 17,
    member: 500000,
    description: "Globale Bewegung Level 1 - Über die Kontinente hinweg.",
    activeTasks: ["Bibellesen", "Schlafen"],
    allTasks: [
      Task(
        name: "Soziale Brennpunkt-Offensive",
        description: "Neue Projekte in 10 Städten gleichzeitig.",
        duration: 40000.0,
        cost: [Money(value: 20000.0), Faith(value: 3000.0)],
        award: [Publicity(value: 1000.0), Member(value: 1000.0)],
      ),
    ],
  ),

  // STAGE 18: Globale Bewegung Level 2 (1.000.000)
  Stage(
    level: 18,
    member: 1000000,
    description: "Globale Bewegung Level 2 - Millionen in der Armee.",
    activeTasks: ["Bibellesen", "Schlafen", "Soziale Brennpunkt-Offensive"],
    allTasks: [],
  ),

  // STAGE 19: Globale Bewegung Level 3 (1.500.000)
  Stage(
    level: 19,
    member: 1500000,
    description: "Globale Bewegung Level 3 - Unaufhaltsames Wirken.",
    activeTasks: ["Bibellesen", "Schlafen"],
    allTasks: [],
  ),

  // STAGE 20: Globale Größe Level 1 (2.500.000)
  Stage(
    level: 20,
    member: 2500000,
    description: "Globale Größe Level 1 - Jüngerschaft durch mediale Präsenz.",
    activeTasks: ["Bibellesen", "Schlafen"],
    allTasks: [
      Task(
        name: "Eigene Fernsehsendung",
        description: "Evangelium über Massenmedien verkünden.",
        duration: 30000.0,
        cost: [Money(value: 100000.0), Time(value: 10.0)],
        award: [Publicity(value: 5000.0), Member(value: 5000.0)],
      ),
    ],
  ),
];
