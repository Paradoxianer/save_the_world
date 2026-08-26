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

final Stage stage29 = Stage(
  level: 29,
  member: 1280000000,
  description: "Weltkirche Level 1 - Finale globale Strukturen.",
  activeTasks: [ "Bibellesen", "Beten",
    "Schlafen",
    "Kontrolle loslassen, Gott vertrauen",
    "Die neue Generation im Bund ausbilden"
  ],
  randomTasks: ["Globale Pandemie (Krise)", "Der Heilige Geist möchte wirken"],
  allTasks: [
    baseBible,
    basePrayer,
    baseSleep,
    holySpiritWorking,
    Task(
      name: "Kontrolle loslassen, Gott vertrauen",
      description: "WARTUNG: Bei dieser Größe lässt sich nichts mehr zentral steuern oder \"stabilisieren\" "
          "- nur das bewusste Loslassen der Kontrolle und das Vertrauen, dass Gott selbst trägt, was kein "
          "Mensch mehr überblicken kann.",
      duration: 20000.0,
      cost: [Time(value: 10.0), Faith(value: 10000.0)],
      award: [Faith(value: 15000.0)],
    ),
    Task(
      name: "Die neue Generation im Bund ausbilden",
      description: "BEFÄHIGUNG: Der Bund lebt nur weiter, wenn die neue Generation ihn nicht nur erbt, "
          "sondern selbst durchlebt - Gebet, Fasten, Lehre und Jüngerschaft neu entdeckt, nicht nur "
          "überliefert bekommt.",
      duration: 150000.0,
      cost: [Faith(value: 100000.0), Wisdom(value: 50000.0)],
      award: [Wisdom(value: 10000.0)],
      modifier: [
        AddTask(task: "Ein Leib aus allen Völkern und Sprachen"),
        RemoveTask(task: "Die neue Generation im Bund ausbilden"),
      ],
    ),
    Task(
      name: "Ein Leib aus allen Völkern und Sprachen",
      description: "MEILENSTEIN: \"Eine große Schar, die niemand zählen konnte, aus allen Nationen und "
          "Stämmen und Völkern und Sprachen\" (Offenbarung 7,9) - der Bund trägt jetzt wirklich die ganze "
          "bewohnte Erde (Limit 2.560.000.000).",
      duration: 800000.0,
      isMilestone: true,
      cost: [Faith(value: 600000.0), Wisdom(value: 400000.0), Time(value: 150.0)],
      award: [Member(value: 1.0)],
      modifier: [
        MessageModifier(message: "GESCHAFFT: Aus allen Nationen und Sprachen ein Leib in Jesus. Limit 2,56 Mrd!"),
        SetMax(ressource: "Member", newMax: 2560000000.0),
        RemoveTask(task: "Ein Leib aus allen Völkern und Sprachen"),
        AddTask(task: "Den Bund über alle Generationen wahren"),
      ],
    ),
    Task(
      name: "Den Bund über alle Generationen wahren",
      description: "WARTUNG: Gebet, Fasten, Lehre und gelebte Jüngerschaft bleiben die tragenden Säulen - "
          "über Generationen, Kulturen und Sprachen hinweg.",
      duration: 100000.0,
      cost: [Time(value: 20.0), Wisdom(value: 50000.0)],
      award: [Faith(value: 20000.0), Publicity(value: 20000.0)],
    ),
    Task(
      name: "Globale Pandemie (Krise)",
      description: "KRISE: Ein unbekanntes Virus legt die Welt lahm. Dein globales Netzwerk ist die letzte Hoffnung!",
      duration: 80000.0,
      timeToSolve: 200000.0,
      cost: [Money(value: 1000000000.0), Member(value: 1000000.0)],
      award: [Publicity(value: 200000.0)],
      modifier: [
        MessageModifier(message: "HELDENHAFT: Deine Bewegung hat Millionen Leben gerettet und die Welt stabilisiert."),
        RemoveTask(task: "Globale Pandemie (Krise)"),
      ],
      missed: [
        SubtractRes(ressources: [Member(value: 50000000.0), Faith(value: 100000.0)]),
        MessageModifier(message: "KASKADE: Die Pandemie hat zu einem globalen Wirtschafts-Kollaps geführt!"),
        RemoveTask(task: "Globale Pandemie (Krise)"),
        AddTask(task: "Globaler Wirtschafts-Kollaps (Krise)"),
      ],
    ),
    Task(
      name: "Globaler Wirtschafts-Kollaps (Krise)",
      description: "FOLGE-KRISE: Weltweite Armut und Hunger bedrohen die Stabilität.",
      duration: 100000.0,
      cost: [Money(value: 5000000000.0), Wisdom(value: 200000.0)],
      modifier: [
        MessageModifier(message: "GELÖST: Deine Bewegung hat die Weltwirtschaft wieder aufgebaut."),
        RemoveTask(task: "Globaler Wirtschafts-Kollaps (Krise)"),
      ],
      missed: [
        SubtractRes(ressources: [Member(value: 100000000.0)]),
        RemoveTask(task: "Globaler Wirtschafts-Kollaps (Krise)"),
        AddTask(task: "Globaler Wirtschafts-Kollaps (Krise)"),
      ],
    ),
  ],
);
