import 'package:save_the_world_flutter_app/data/stages/common_tasks.dart';
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

final Stage stage16 = Stage(
  level: 16,
  member: 250000,
  description: "Globale Bewegung Level 2 - Koordination kontinentaler Netzwerke.",
  activeTasks: [
    "Bibellesen", 
    "Schlafen", 
    "Kollekte", 
    "Strategischer Stab berufen",
    "Kontinentales Netzwerk gründen"
  ],
  randomTasks: ["Öffentlicher Widerspruch (Krise)", "Der Heilige Geist möchte wirken"],
  allTasks: [
    baseBible,
    baseSleep,
    collectMoney,
    holySpiritWorking,
    Task(
      name: "Strategischer Stab berufen",
      description: "DELEGATION: Ein Team von Experten übernimmt die globale Planung.",
      duration: 20000.0,
      cost: [Money(value: 50000.0), Wisdom(value: 1000.0)],
      award: [Time(value: 2.0)],
      modifier: [
        MessageModifier(message: "SYSTEM: Der Stab automatisiert nun die internationale Kollekte."),
        AutoExecuteModifier(
          intervalMs: 8000,
          modifiers: [
             MultiplyRes(targetResName: "Money", factorResName: "Member", multiplier: 0.2),
          ]
        ),
        RemoveTask(task: "Strategischer Stab berufen"),
      ],
    ),
    Task(
      name: "Kontinentales Netzwerk gründen",
      description: "MEILENSTEIN: Formierung einer Allianz über den gesamten Kontinent (Limit 500.000).",
      duration: 70000.0,
      isMilestone: true,
      cost: [Money(value: 2000000.0), Wisdom(value: 5000.0), Publicity(value: 2000.0)],
      award: [Member(value: 1.0)],
      modifier: [
        MessageModifier(message: "WACHSTUM: Der Kontinent ist vernetzt! Limit auf 500.000 erhöht."),
        SetMax(ressource: "Member", newMax: 500000.0),
        RemoveTask(task: "Kontinentales Netzwerk gründen"),
        AddTask(task: "Netzwerk koordinieren"),
      ],
    ),
    Task(
      name: "Netzwerk koordinieren",
      description: "WARTUNG: Tägliche Abstimmung mit kontinentalen Leitern.",
      duration: 30000.0,
      cost: [Time(value: 4.0), Wisdom(value: 500.0)],
      award: [Faith(value: 200.0), Publicity(value: 100.0)],
    ),
    Task(
      name: "Öffentlicher Widerspruch (Krise)",
      description: "KRISE: Kritische Stimmen fordern eine Stellungnahme der Bewegung. Schnelles Handeln nötig!",
      duration: 15000.0,
      timeToSolve: 45000.0,
      cost: [Wisdom(value: 800.0), Publicity(value: 1000.0)],
      award: [Wisdom(value: 200.0)],
      modifier: [
        MessageModifier(message: "GELÖST: Die Stellungnahme wurde positiv aufgenommen."),
        RemoveTask(task: "Öffentlicher Widerspruch (Krise)"),
      ],
      missed: [
        SubtractRes(ressources: [Publicity(value: 5000.0), Faith(value: 1000.0)]),
        MessageModifier(message: "KASKADE: Dein Schweigen führt zu einer rechtlichen Untersuchung!"),
        RemoveTask(task: "Öffentlicher Widerspruch (Krise)"),
        AddTask(task: "Rechtliche Untersuchung (Krise)"), // Kaskade
      ],
    ),
    Task(
      name: "Rechtliche Untersuchung (Krise)",
      description: "FOLGE-KRISE: Behörden prüfen die Gemeinnützigkeit aufgrund des öffentlichen Drucks.",
      duration: 25000.0,
      timeToSolve: 60000.0,
      cost: [Money(value: 100000.0), Wisdom(value: 2000.0)],
      award: [Wisdom(value: 500.0)],
      modifier: [
        MessageModifier(message: "BESTANDEN: Die Untersuchung ist abgeschlossen. Integrität bewiesen."),
        RemoveTask(task: "Rechtliche Untersuchung (Krise)"),
      ],
      missed: [
        SubtractRes(ressources: [Money(value: 500000.0), Publicity(value: 10000.0)]),
        MessageModifier(message: "DESASTER: Massive Strafen und Vertrauensverlust weltweit."),
        RemoveTask(task: "Rechtliche Untersuchung (Krise)"),
        AddTask(task: "Rechtliche Untersuchung (Krise)"),
      ],
    ),
  ],
);
