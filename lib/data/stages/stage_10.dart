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

final Stage stage10 = Stage(
  level: 10,
  member: 2800,
  description: "Internationale Multiplikation und globale Reichweite.",
  activeTasks: [
    "Bibellesen", "Beten",
    "Schlafen",
    "Ausbildung international multiplizieren",
    "Kulturelle Anpassung",
    "Internationale Vision",
    "Generalsekretär berufen"
  ],
  randomTasks: [
    "Der Heilige Geist möchte wirken",
    "Medien-Skandal", // Neue, schnellere Krise
    "Die Botschaft verliert sich in der Übersetzung",
  ],
  allTasks: [
    baseBible,
    basePrayer,
    baseSleep,
    collectMoney,
    holySpiritWorking,
    Task(
      name: "Generalsekretär berufen",
      description: "DELEGATION: Ein erfahrener Administrator übernimmt die operativen Systeme - viel Geld "
          "fließt jetzt automatisch, aber rein administratives Wachstum ohne geistliche Investition zehrt "
          "auf Dauer am Glauben der Bewegung.",
      duration: 15000.0,
      cost: [Money(value: 5000.0), Wisdom(value: 200.0)],
      modifier: [
        MessageModifier(message: "SYSTEM: Der Generalsekretär automatisiert nun die Kollekten-Einnahmen."),
        AutoExecuteModifier(
          intervalMs: 10000,
          modifiers: [
             MultiplyRes(targetResName: "Money", factorResName: "Member", multiplier: 0.1),
             SubtractRes(ressources: [Faith(value: 1.0, multiplierResourceName: "Member", multiplierValue: 0.01)]),
          ]
        ),
        RemoveTask(task: "Generalsekretär berufen"),
      ],
    ),
    Task(
      name: "Kulturelle Anpassung",
      description: "Materialien, Methoden und die Art der Verkündigung werden bewusst an jede Kultur "
          "angepasst - das kostet viel von dem Geld, das der Generalsekretär automatisch einbringt, aber "
          "ohne echte Anpassung bleibt die Botschaft fremd oder verwässert unterwegs.",
      duration: 20000.0,
      cost: [Time(value: 8.0), Money(value: 20000.0), Wisdom(value: 200.0)],
      award: [Member(value: 2.0), Faith(value: 100.0)],
    ),
    Task(
      name: "Ausbildung international multiplizieren",
      description: "BEFÄHIGUNG: Bibel-, Propheten- und Lobpreisschule werden zum exportierbaren Modell - "
          "Leiter in neuen Ländern lernen nach demselben Fundament, statt dass jedes Land bei null anfängt.",
      duration: 25000.0,
      cost: [Money(value: 15000.0), Wisdom(value: 500.0), Faith(value: 200.0)],
      award: [Wisdom(value: 300.0), Publicity(value: 100.0)],
      modifier: [
        MessageModifier(message: "WACHSTUM: Tausende Leiter wurden weltweit nach demselben Fundament ausgebildet."),
      ],
    ),
    Task(
      name: "Internationale Vision",
      description: "MEILENSTEIN: Eröffnung der globalen Zentrale und strategische Ausrichtung (Limit 4500).",
      duration: 45000.0,
      isMilestone: true,
      cost: [Money(value: 40000.0), Faith(value: 1000.0), Wisdom(value: 500.0)],
      award: [Publicity(value: 500.0), Member(value: 1.0)],
      modifier: [
        MessageModifier(message: "GLOBAL: Die Vision trägt Früchte auf allen Kontinenten! Limit 4500."),
        SetMax(ressource: "Member", newMax: 4500.0),
        RemoveTask(task: "Internationale Vision"),
        AddTask(task: "Globalen Dienst aufrechterhalten"),
      ],
    ),
    Task(
      name: "Globalen Dienst aufrechterhalten",
      description: "WARTUNG: Sichere die Kontinuität der weltweiten Bewegung.",
      duration: 20000.0,
      cost: [Time(value: 4.0), Wisdom(value: 100.0)],
      award: [Faith(value: 50.0), Publicity(value: 20.0)],
    ),
    Task(
      name: "Medien-Skandal",
      description: "KRISE: Ein Missverständnis bedroht den globalen Ruf. Reagiere sofort!",
      duration: 10000.0,
      timeToSolve: 45000.0, // Schneller als bisherige Krisen
      cost: [Wisdom(value: 200.0), Publicity(value: 500.0)],
      award: [Wisdom(value: 50.0)],
      modifier: [
        MessageModifier(message: "ENTSCHÄRFT: Das Missverständnis wurde rechtzeitig aufgeklärt."),
        RemoveTask(task: "Medien-Skandal"),
      ],
      missed: [
        SubtractRes(ressources: [Publicity(value: 1000.0), Faith(value: 200.0)]),
        MessageModifier(message: "SCHADEN: Die Bewegung hat weltweit massiv an Vertrauen verloren."),
        RemoveTask(task: "Medien-Skandal"),
        AddTask(task: "Medien-Skandal"),
      ],
    ),
    Task(
      name: "Die Botschaft verliert sich in der Übersetzung",
      description: "KRISE: In einem neuen Land wird die Botschaft missverstanden oder verwässert - "
          "kulturelle Unterschiede wurden unterschätzt, Wachstum ging vor echter Anpassung.",
      duration: 12000.0,
      timeToSolve: 55000.0,
      cost: [Time(value: 6.0), Wisdom(value: 150.0)],
      award: [Faith(value: 30.0)],
      modifier: [
        MessageModifier(message: "RICHTIGGESTELLT: Mit echtem kulturellem Verständnis nachgearbeitet."),
        RemoveTask(task: "Die Botschaft verliert sich in der Übersetzung"),
      ],
      missed: [
        SubtractRes(ressources: [Faith(value: 200.0), Member(value: 80.0)]),
        MessageModifier(message: "VERWÄSSERT: Die Botschaft hat unterwegs ihren Kern verloren."),
        RemoveTask(task: "Die Botschaft verliert sich in der Übersetzung"),
        AddTask(task: "Die Botschaft verliert sich in der Übersetzung"),
      ],
    ),
  ],
);
