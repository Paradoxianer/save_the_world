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

final List<Stage> globalStages = [
  // STAGE 21: Globale Größe Level 1 (2.500.000+)
  Stage(
    level: 21,
    member: 5000000,
    description: "Globale Größe Level 1 - Strategische Vision.",
    activeTasks: ["Vision-Casting", "Regionale Leiter-Akademie", "Eigene Fernsehsendung"],
    allTasks: [
      Task(
        name: "Globale Strategie-Konferenz",
        description: "Versammle Leiter aller Kontinente.",
        duration: 40000.0,
        cost: [Money(value: 200000.0), Time(value: 30.0), Wisdom(value: 5000.0)],
        award: [Faith(value: 1000.0), Wisdom(value: 2000.0)],
        modifier: [AddTask(task: "Weltweite Hilfsaktion")],
      ),
    ],
  ),

  // STAGE 22: Globale Größe Level 2 (5.000.000)
  Stage(
    level: 22,
    member: 5000000,
    description: "Globale Größe Level 2 - Festigung der Vision.",
    activeTasks: ["Globale Strategie-Konferenz"],
    allTasks: [],
  ),

  // STAGE 23: Globale Größe Level 3 (7.500.000)
  Stage(
    level: 23,
    member: 7500000,
    description: "Globale Größe Level 3 - Nachhaltige Wirkung.",
    activeTasks: ["Eigene Fernsehsendung"],
    allTasks: [],
  ),

  // STAGE 24: Globaler Beeinflusser Level 1 (10.000.000)
  Stage(
    level: 24,
    member: 10000000,
    description: "Globaler Beeinflusser Level 1 - Moralische Instanz.",
    activeTasks: ["Globale Strategie-Konferenz"],
    allTasks: [],
  ),

  // STAGE 25: Globaler Beeinflusser Level 2 (20.000.000)
  Stage(
    level: 25,
    member: 20000000,
    description: "Globaler Beeinflusser Level 2 - Weltweite Hilfsaktionen.",
    activeTasks: ["Vision-Casting"],
    allTasks: [
      Task(
        name: "Weltweite Hilfsaktion",
        description: "Reagiere auf globale Katastrophen.",
        duration: 50000.0,
        cost: [Money(value: 500000.0), Faith(value: 5000.0), Member(value: 10000.0)],
        award: [Publicity(value: 10000.0), Member(value: 50000.0)],
      ),
    ],
  ),

  // STAGE 26: Globaler Beeinflusser Level 3 (40.000.000)
  Stage(
    level: 26,
    member: 40000000,
    description: "Globaler Beeinflusser Level 3 - Diplomatischer Erfolg.",
    activeTasks: ["Weltweite Hilfsaktion"],
    allTasks: [],
  ),

  // STAGE 27: Denomination Level 1 (80.000.000)
  Stage(
    level: 27,
    member: 80000000,
    description: "Denomination Level 1 - Weltweite Organisation.",
    activeTasks: ["Weltweite Hilfsaktion"],
    allTasks: [],
  ),

  // STAGE 28: Denomination Level 2 (160.000.000)
  Stage(
    level: 28,
    member: 160000000,
    description: "Denomination Level 2 - Strukturierte Jüngerschaft.",
    activeTasks: ["Weltweite Hilfsaktion"],
    allTasks: [],
  ),

  // STAGE 29: Denomination Level 3 (320.000.000)
  Stage(
    level: 29,
    member: 320000000,
    description: "Denomination Level 3 - Globale Relevanz.",
    activeTasks: ["Weltweite Hilfsaktion"],
    allTasks: [],
  ),

  // STAGE 30: Weltkirche Level 1 (1.280.000.000)
  Stage(
    level: 30,
    member: 1280000000,
    description: "Weltkirche Level 1 - Digitales Evangelium.",
    activeTasks: ["Vision-Casting"],
    allTasks: [
      Task(
        name: "Globale Jüngerschafts-Plattform",
        description: "Milliarden geistlich begleiten.",
        duration: 60000.0,
        cost: [Money(value: 1000000.0), Wisdom(value: 10000.0), Time(value: 10.0)],
        award: [Member(value: 1000000.0), Faith(value: 5000.0)],
        modifier: [AddTask(task: "Die Welt retten")],
      ),
    ],
  ),

  // STAGE 31: Weltkirche Level 2 (2.560.000.000)
  Stage(
    level: 31,
    member: 2560000000,
    description: "Weltkirche Level 2 - Fast vollbracht.",
    activeTasks: ["Globale Jüngerschafts-Plattform"],
    allTasks: [],
  ),

  // STAGE 32: Weltkirche Level 3 (5.120.000.000)
  Stage(
    level: 32,
    member: 5120000000,
    description: "Weltkirche Level 3 - Das Finale beginnt.",
    activeTasks: ["Globale Jüngerschafts-Plattform"],
    allTasks: [
      Task(
        name: "Die Welt retten",
        description: "Letzte große Anstrengung.",
        duration: 100000.0,
        cost: [Faith(value: 10000.0), Wisdom(value: 20000.0), Member(value: 5000000.0)],
        award: [Faith(value: 1000000.0)],
        modifier: [MessageModifier(message: "Es ist vollbracht! YEAH!")],
      ),
    ],
  ),
];
