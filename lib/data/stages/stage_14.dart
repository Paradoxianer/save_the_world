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
import 'package:save_the_world_flutter_app/data/stages/common_tasks.dart';

final Stage stage14 = Stage(
  level: 14,
  member: 50000,
  description: "Eine Bewegung Level 1 - Nicht in den Räumen bleiben, sondern aussenden.",
  activeTasks: [
    "Bibellesen", "Beten",
    "Schlafen",
    "Kollekte",
    "Logistik-Planung",
  ],
  randomTasks: [
    "Finanzprüfung (Krise)",
    "Die Bewegung wird bequem",
    "Der Heilige Geist möchte wirken",
  ],
  allTasks: [
    baseBible,
    basePrayer,
    baseSleep,
    collectMoney,
    holySpiritWorking,
    Task(
      name: "Logistik-Planung",
      description: "BEFÄHIGUNG: Die organisatorische Basis für Großveranstaltungen legen.",
      duration: 20000.0,
      cost: [Time(value: 4.0), Wisdom(value: 300.0)],
      award: [Wisdom(value: 100.0)],
      modifier: [
        AddTask(task: "Großevangelisation durchführen"),
        RemoveTask(task: "Logistik-Planung"),
      ],
    ),
    Task(
      name: "Großevangelisation durchführen",
      description: "Tausende Menschen hören die Botschaft auf Marktplätzen und in Stadien - Mitglieder "
          "gehen selbst hinaus, statt nur in den eigenen Räumen zu bleiben.",
      duration: 40000.0,
      cost: [Money(value: 100000.0), Publicity(value: 1000.0)],
      award: [Member(value: 1.0), Publicity(value: 500.0)],
      modifier: [
        AddTask(task: "Logistik-Planung"), // Muss für die nächste Aktion neu geplant werden
        AddTask(task: "Die Gemeinde nach draußen mobilisieren"),
      ]
    ),
    Task(
      name: "Die Gemeinde nach draußen mobilisieren",
      description: "MEILENSTEIN: Ein regionales Zentrum wie in Stage 7 gäbe es schon - die eigentliche "
          "Aufgabe jetzt ist eine andere: Statt sich an vollen Räumen zu erfreuen, wird die Bewegung zur "
          "sendenden Bewegung. Jeder wird ermutigt und ausgerüstet, selbst hinauszugehen, statt nur zu "
          "kommen und zu bleiben (Limit 100.000).",
      duration: 60000.0,
      isMilestone: true,
      cost: [Money(value: 200000.0), Wisdom(value: 3000.0), Faith(value: 1000.0)],
      award: [Member(value: 1.0)],
      modifier: [
        MessageModifier(message: "AUFBRUCH: Aus Zuschauern werden Sendboten. Limit 100.000."),
        SetMax(ressource: "Member", newMax: 100000.0),
        RemoveTask(task: "Die Gemeinde nach draußen mobilisieren"),
        AddTask(task: "Aussendungskultur pflegen"),
      ],
    ),
    Task(
      name: "Aussendungskultur pflegen",
      description: "WARTUNG: Die Bequemlichkeit voller Räume zieht immer wieder zurück ins Bleiben - "
          "aktives Ermutigen und Ausrüsten hält die Sendungskultur lebendig.",
      duration: 25000.0,
      cost: [Time(value: 4.0), Wisdom(value: 200.0)],
      award: [Faith(value: 100.0), Member(value: 0.3)],
    ),
    Task(
      name: "Die Bewegung wird bequem",
      description: "KRISE: Volle Räume fühlen sich nach Erfolg an - aber immer mehr Mitglieder kommen nur "
          "noch, um zu konsumieren, statt selbst hinauszugehen. Die Sendungskultur erodiert leise.",
      duration: 15000.0,
      timeToSolve: 55000.0,
      cost: [Time(value: 6.0), Faith(value: 300.0)],
      award: [Faith(value: 50.0)],
      modifier: [
        MessageModifier(message: "AUFGERÜTTELT: Die Bewegung erinnert sich an ihren Auftrag."),
        RemoveTask(task: "Die Bewegung wird bequem"),
      ],
      missed: [
        SubtractRes(ressources: [Member(value: 3000.0), Faith(value: 500.0)]),
        MessageModifier(
          message: "STAGNATION: Wer nur noch konsumiert statt zu senden, verliert irgendwann das Interesse "
              "ganz.",
        ),
        RemoveTask(task: "Die Bewegung wird bequem"),
        AddTask(task: "Die Bewegung wird bequem"),
      ],
    ),
    Task(
      name: "Finanzprüfung (Krise)",
      description: "KRISE: Behörden prüfen die Gemeinnützigkeit der Bewegung. Absolute Sorgfalt nötig!",
      duration: 15000.0,
      timeToSolve: 50000.0,
      cost: [Wisdom(value: 500.0), Money(value: 5000.0)],
      award: [Wisdom(value: 100.0)],
      modifier: [
        MessageModifier(message: "BESTANDEN: Die Transparenz hat sich ausgezahlt. Das Vertrauen ist gestärkt."),
        RemoveTask(task: "Finanzprüfung (Krise)"),
      ],
      missed: [
        SubtractRes(ressources: [Money(value: 50000.0), Publicity(value: 2000.0)]),
        MessageModifier(message: "STRAFE: Dokumentationsmängel führten zu Bußgeldern und Imageverlust."),
        RemoveTask(task: "Finanzprüfung (Krise)"),
        AddTask(task: "Finanzprüfung (Krise)"),
      ],
    ),
  ],
);
