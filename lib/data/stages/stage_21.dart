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

final Stage stage21 = Stage(
  level: 21,
  member: 5000000,
  description: "Globale Größe Level 2 - Die Bewegung wird zum diplomatischen Akteur.",
  activeTasks: [ "Bibellesen", "Beten",
    "Schlafen",
    "Prophetische Distanz bewahren",
    "Diplomatische Kanäle öffnen",
    "Internationale Allianz gründen"
  ],
  randomTasks: ["Innere Integrität prüfen", "Der Heilige Geist möchte wirken"],
  allTasks: [
    baseBible,
    basePrayer,
    baseSleep,
    holySpiritWorking,
    Task(
      name: "Prophetische Distanz bewahren",
      description: "WARTUNG: \"Wieder führte ihn der Teufel... und zeigte ihm alle Reiche der Welt\" "
          "(Matthäus 4,8-10) - je mehr die Bewegung selbst zur Akteurin auf der Weltbühne wird, desto "
          "wichtiger wird es, sich aktiv daran zu erinnern, wem die Loyalität eigentlich gehört.",
      duration: 18000.0,
      cost: [Time(value: 6.0)],
      award: [Faith(value: 400.0)],
    ),
    Task(
      name: "Diplomatische Kanäle öffnen",
      description: "BEFÄHIGUNG: Schafft die Basis für globale Anerkennung durch Staaten.",
      duration: 45000.0,
      cost: [Publicity(value: 5000.0), Wisdom(value: 2000.0)],
      award: [Wisdom(value: 1000.0)],
      modifier: [
        AddTask(task: "Weltweiten Friedensgipfel ausrichten"),
        RemoveTask(task: "Diplomatische Kanäle öffnen"),
      ],
    ),
    Task(
      name: "Weltweiten Friedensgipfel ausrichten",
      description: "SYSTEM: Deine Stimme vermittelt in globalen Konflikten - die Bewegung wird selbst zur "
          "Akteurin unter den Mächtigen. Genau das ist die alte Versuchung: die Reiche der Welt statt des "
          "Reiches Gottes. Der Einfluss wächst spürbar, geistliche Tiefe nicht von selbst mit.",
      duration: 70000.0,
      cost: [Money(value: 2000000.0), Publicity(value: 10000.0), Time(value: 12.0)],
      award: [Member(value: 1.0), Publicity(value: 5000.0)],
      modifier: [
        AddTask(task: "Diplomatische Kanäle öffnen"),
      ]
    ),
    Task(
      name: "Internationale Allianz gründen",
      description: "MEILENSTEIN: Offizieller Status als globale Körperschaft (Limit 7.500.000).",
      duration: 150000.0,
      isMilestone: true,
      cost: [Money(value: 15000000.0), Wisdom(value: 20000.0), Publicity(value: 15000.0), Faith(value: 6000.0)],
      award: [Member(value: 1.0)],
      modifier: [
        MessageModifier(message: "ANERKENNUNG: Die Bewegung ist nun völkerrechtlich relevant. Limit 7.500.000!"),
        SetMax(ressource: "Member", newMax: 7500000.0),
        AutoExecuteModifier(
          intervalMs: 12000,
          modifiers: [
            MultiplyRes(targetResName: "Publicity", factorResName: "Member", multiplier: 0.04),
            SubtractRes(ressources: [Faith(value: 700.0)]),
          ]
        ),
        RemoveTask(task: "Internationale Allianz gründen"),
        AddTask(task: "Allianz diplomatisch führen"),
      ],
    ),
    Task(
      name: "Allianz diplomatisch führen",
      description: "WARTUNG: Tägliche Vertretung der Allianz auf globaler Ebene.",
      duration: 60000.0,
      cost: [Time(value: 4.0), Wisdom(value: 2000.0)],
      award: [Publicity(value: 2000.0), Faith(value: 500.0)],
    ),
    Task(
      name: "Innere Integrität prüfen",
      description: "PRÜFUNG: Werden die geistlichen und moralischen Grundregeln in der Führung noch "
          "wirklich gelebt, oder nur noch behauptet? Bei dieser Größe merkt man schleichende Abweichungen "
          "erst, wenn aktiv hingeschaut wird.",
      duration: 15000.0,
      timeToSolve: 60000.0,
      cost: [Wisdom(value: 1500.0), Faith(value: 1000.0)],
      award: [Faith(value: 200.0)],
      modifier: [
        MessageModifier(message: "BEWAHRT: Die Grundregeln werden weiter ehrlich gelebt - diesmal."),
        RemoveTask(task: "Innere Integrität prüfen"),
      ],
      missed: [
        SubtractRes(ressources: [Faith(value: 500.0)]),
        MessageModifier(message: "VERNACHLÄSSIGT: Niemand hat wirklich hingeschaut - die Grundregeln erodieren im Stillen."),
        RemoveTask(task: "Innere Integrität prüfen"),
        AddTask(task: "Moralischer Skandal (Krise)"), // Kaskade: Skandal als Folge vernachlässigter Grundregeln
      ],
    ),
    Task(
      name: "Moralischer Skandal (Krise)",
      description: "FOLGE-KRISE: Vorwürfe über Machtmissbrauch und Fehlverhalten in der Führung werden "
          "öffentlich - die vernachlässigten Grundregeln rächen sich jetzt in aller Öffentlichkeit. Bei "
          "dieser Größe reicht ein Fall für weltweite Schlagzeilen.",
      duration: 20000.0,
      timeToSolve: 55000.0,
      cost: [Wisdom(value: 3000.0), Faith(value: 2000.0)],
      award: [Wisdom(value: 500.0)],
      modifier: [
        MessageModifier(message: "AUFGEARBEITET: Ehrliche Aufarbeitung und echte Konsequenzen begrenzen den Schaden."),
        RemoveTask(task: "Moralischer Skandal (Krise)"),
      ],
      missed: [
        SubtractRes(ressources: [Faith(value: 5000.0), Member(value: 200000.0)]),
        MessageModifier(message: "KASKADE: Vertuschungsversuche werden publik!"),
        RemoveTask(task: "Moralischer Skandal (Krise)"),
        AddTask(task: "Die Vertuschung fliegt auf (Krise)"),
      ],
    ),
    Task(
      name: "Die Vertuschung fliegt auf (Krise)",
      description: "FOLGE-KRISE: Geleakte interne Dokumente zeigen nicht nur das ursprüngliche "
          "Fehlverhalten, sondern den Versuch, es zu vertuschen - das zerstört Vertrauen oft mehr als der "
          "Skandal selbst.",
      duration: 25000.0,
      timeToSolve: 50000.0,
      cost: [Publicity(value: 30000.0), Wisdom(value: 5000.0), Faith(value: 3000.0)],
      award: [Wisdom(value: 1000.0)],
      modifier: [
        MessageModifier(message: "BEREINIGT: Mühsame, ehrliche Transparenzoffensive hat den Schaden begrenzt."),
        RemoveTask(task: "Die Vertuschung fliegt auf (Krise)"),
      ],
      missed: [
        SubtractRes(ressources: [Member(value: 300000.0), Faith(value: 10000.0)]),
        RemoveTask(task: "Die Vertuschung fliegt auf (Krise)"),
        AddTask(task: "Die Vertuschung fliegt auf (Krise)"),
      ],
    ),
  ],
);
