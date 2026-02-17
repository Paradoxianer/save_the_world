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

final Stage stage31 = Stage(
  level: 31,
  member: 5120000000,
  description: "Weltkirche Level 3 - Die finale Erweckung.",
  activeTasks: [
    "Schlafen",
    "Märtyrer-Gedenken",
    "Weltweiter Gebetsaufruf"
  ],
  randomTasks: ["Globale Apathie (Krise)", "Der Heilige Geist möchte wirken"],
  allTasks: [
    baseSleep,
    holySpiritWorking,
    Task(
      name: "Märtyrer-Gedenken",
      description: "WARTUNG: Bewahrung des geistlichen Erbes der Verfolgten.",
      duration: 80000.0,
      cost: [Time(value: 10.0), Faith(value: 20000.0)],
      award: [Faith(value: 50000.0), Wisdom(value: 10000.0)],
    ),
    Task(
      name: "Weltweiter Gebetsaufruf",
      description: "BEFÄHIGUNG: Ruft die gesamte Weltkirche zum Gebet für die letzte Ernte.",
      duration: 150000.0,
      cost: [Faith(value: 500000.0), Publicity(value: 200000.0)],
      award: [Faith(value: 200000.0)],
      modifier: [
        AddTask(task: "Globale Erweckung entfachen"),
        RemoveTask(task: "Weltweiter Gebetsaufruf"),
      ],
    ),
    Task(
      name: "Globale Erweckung entfachen",
      description: "MEILENSTEIN: Eine beispiellose Welle des Geistes erfasst die Welt (Limit 7.600.000.000).",
      duration: 900000.0,
      isMilestone: true,
      cost: [Faith(value: 2000000.0), Wisdom(value: 500000.0)],
      award: [Member(value: 1.0)],
      modifier: [
        MessageModifier(message: "ERWECKUNG: Die letzte große Ernte hat begonnen! Limit 7,6 Mrd!"),
        SetMax(ressource: "Member", newMax: 7600000000.0),
        RemoveTask(task: "Globale Erweckung entfachen"),
        AddTask(task: "Erweckung bewahren"),
      ],
    ),
    Task(
      name: "Erweckung bewahren",
      description: "WARTUNG: Die Früchte der Erweckung durch Lehre und Gemeinschaft sichern.",
      duration: 120000.0,
      cost: [Time(value: 20.0), Wisdom(value: 100000.0)],
      award: [Faith(value: 500000.0), Wisdom(value: 50000.0)],
    ),
    Task(
      name: "Globale Apathie (Krise)",
      description: "KRISE: Eine Welle der Gleichgültigkeit droht die geistliche Glut zu ersticken!",
      duration: 60000.0,
      timeToSolve: 180000.0,
      cost: [Wisdom(value: 200000.0), Faith(value: 200000.0)],
      modifier: [
        MessageModifier(message: "NEUES FEUER: Die Apathie wurde durchbrochen."),
        RemoveTask(task: "Globale Apathie (Krise)"),
      ],
      missed: [
        SubtractRes(ressources: [Faith(value: 1000000.0)]),
        MessageModifier(message: "KASKADE: Die Apathie führt zum Verlust der ersten Liebe bei Millionen."),
        RemoveTask(task: "Globale Apathie (Krise)"),
        AddTask(task: "Verlust der ersten Liebe (Krise)"),
      ],
    ),
    Task(
      name: "Verlust der ersten Liebe (Krise)",
      description: "FOLGE-KRISE: Millionen sind geistlich erkaltet. Eine Bußbewegung ist nötig.",
      duration: 120000.0,
      cost: [Faith(value: 1000000.0), Wisdom(value: 300000.0)],
      modifier: [
        MessageModifier(message: "UMKEHR: Die Bewegung hat zu ihrer ersten Liebe zurückgefunden."),
        RemoveTask(task: "Verlust der ersten Liebe (Krise)"),
      ],
      missed: [
        SubtractRes(ressources: [Member(value: 1000000000.0)]),
        RemoveTask(task: "Verlust der ersten Liebe (Krise)"),
        AddTask(task: "Verlust der ersten Liebe (Krise)"),
      ],
    ),
  ],
);
