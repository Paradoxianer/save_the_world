import 'package:save_the_world_flutter_app/models/addtask.model.dart';
import 'package:save_the_world_flutter_app/models/message.modifier.dart';
import 'package:save_the_world_flutter_app/models/money.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/removetask.model.dart';
import 'package:save_the_world_flutter_app/models/stage.model.dart';
import 'package:save_the_world_flutter_app/models/setmax.model.dart';
import 'package:save_the_world_flutter_app/models/subtractres.model.dart';
import 'package:save_the_world_flutter_app/models/task.model.dart';
import 'package:save_the_world_flutter_app/models/time.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/wisdome.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/faith.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/publicity.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/member.ressource.model.dart';
import 'package:save_the_world_flutter_app/data/stages/common_tasks.dart';

final Stage stage8 = Stage(
  level: 8,
  member: 1100,
  description: "MegaChurch Level 1 - Die Leitung durch Vision wird zentral.",
  activeTasks: ["Bibellesen", "Beten", "Schlafen", "Vision-Casting", "Budget erstellen"],
  randomTasks: [
    "Kassendifferenz finden",
    "Standorte kriseln",
    "Isolation an der Spitze",
    "Ein großer Spender springt ab",
    "Der Heilige Geist möchte wirken",
  ],
  allTasks: [
    baseBible,
    basePrayer,
    baseSleep,
    collectMoney,
    holySpiritWorking,
    Task(
      name: "Vision-Casting",
      description: "Begeistere die Massen für eine gemeinsame Zukunft - die eine Vision, die alle Standorte "
          "trägt, statt vieler einzelner Gemeinden unter einem Dach.",
      duration: 15000.0,
      cost: [Time(value: 4.0), Faith(value: 300.0)],
      award: [Faith(value: 500.0), Publicity(value: 50.0), Member(value: 0.2)],
      modifier: [AddTask(task: "Filialnetzwerk unter einer Vision vereinen")],
    ),
    Task(
      name: "Budget erstellen",
      description: "Auch eine gemeinsame Vision braucht Geld, um an jedem Standort umgesetzt zu werden.",
      duration: 15000.0,
      cost: [Time(value: 4.0), Wisdom(value: 100.0)],
      award: [Money(value: 500.0), Wisdom(value: 20.0)],
      modifier: [AddTask(task: "Budget verteidigen")],
    ),
    Task(
      name: "Budget verteidigen",
      description: "Überzeuge die Gremien von den notwendigen Ausgaben.",
      duration: 10000.0,
      cost: [Time(value: 2.0), Faith(value: 50.0)],
      award: [Wisdom(value: 30.0), Money(value: 1000.0)],
      modifier: [AddTask(task: "Filialnetzwerk unter einer Vision vereinen")],
    ),
    Task(
      name: "Filialnetzwerk unter einer Vision vereinen",
      description: "MEILENSTEIN: Nicht noch ein Standort - die bestehenden Standorte wachsen unter einer "
          "gemeinsamen, zentral getragenen Vision zusammen statt auseinanderzudriften (Limit 1800).",
      duration: 35000.0,
      isMilestone: true,
      cost: [Money(value: 5000.0), Faith(value: 500.0)],
      award: [Publicity(value: 200.0), Member(value: 1.0)],
      modifier: [
        MessageModifier(message: "EINHEIT: Eine Vision trägt jetzt das ganze Netzwerk. Limit 1800!"),
        SetMax(ressource: "Member", newMax: 1800.0),
        RemoveTask(task: "Filialnetzwerk unter einer Vision vereinen"),
        AddTask(task: "Filialnetzwerk betreuen"),
      ],
    ),
    Task(
      name: "Filialnetzwerk betreuen",
      description: "WARTUNG: Sorge für geistliche Einheit zwischen den Standorten.",
      duration: 25000.0,
      cost: [Time(value: 4.0), Wisdom(value: 50.0)],
      award: [Faith(value: 100.0), Publicity(value: 100.0)],
    ),
    Task(
      name: "Kassendifferenz finden",
      description: "KRISE: Ein Fehler in der Buchhaltung gefährdet das Vertrauen.",
      duration: 10000.0,
      timeToSolve: 60000.0,
      cost: [Time(value: 2.0), Wisdom(value: 50.0)],
      modifier: [
        MessageModifier(message: "GELÖST: Der Fehler wurde gefunden. Die Transparenz ist gewahrt."),
        RemoveTask(task: "Kassendifferenz finden"),
      ],
      missed: [
        SubtractRes(ressources: [Publicity(value: 100.0), Money(value: 500.0)]),
        MessageModifier(message: "SCHADEN: Ungeklärte Finanzen kosten Ruf und Geld."),
        RemoveTask(task: "Kassendifferenz finden"),
        AddTask(task: "Kassendifferenz finden"),
      ],
    ),
    Task(
      name: "Standorte kriseln",
      description: "KRISE: An mehreren Standorten sinkt die Beteiligung, die Leitung vor Ort ist überfordert, "
          "Ehrenamtliche sind frustriert. Du kannst nicht überall gleichzeitig sein - ohne gezielte "
          "Unterstützung drohen einzelne Standorte zu zerfallen.",
      duration: 12000.0,
      timeToSolve: 55000.0,
      cost: [Time(value: 6.0), Wisdom(value: 80.0)],
      award: [Faith(value: 30.0)],
      modifier: [
        MessageModifier(
          message: "STABILISIERT: Gezielte Unterstützung und Coaching haben die Standorte wieder gefestigt.",
        ),
        RemoveTask(task: "Standorte kriseln"),
      ],
      missed: [
        SubtractRes(ressources: [Member(value: 40.0), Publicity(value: 80.0)]),
        MessageModifier(message: "ZERFALL: Ein Standort verliert an Substanz - Mitglieder und Ruf gehen verloren."),
        RemoveTask(task: "Standorte kriseln"),
        AddTask(task: "Standorte kriseln"),
      ],
    ),
    Task(
      name: "Isolation an der Spitze",
      description: "KRISE: Trotz äußerem Erfolg spürst du selbst kaum noch Nähe zu Gott - zu viele Termine, "
          "zu wenig echte geistliche Begleitung für dich persönlich. Niemand fragt den Leiter, wie es IHM geht.",
      duration: 15000.0,
      timeToSolve: 60000.0,
      cost: [Time(value: 12.0)],
      award: [Faith(value: 150.0)],
      modifier: [
        MessageModifier(
          message: "AUFGETANKT: Eine bewusste Auszeit mit einem geistlichen Begleiter hat dich wieder verankert.",
        ),
        RemoveTask(task: "Isolation an der Spitze"),
      ],
      missed: [
        SubtractRes(ressources: [Faith(value: 300.0)]),
        MessageModifier(message: "AUSGEBRANNT: Du funktionierst nur noch - die Nähe zu Gott ist fast verschwunden."),
        RemoveTask(task: "Isolation an der Spitze"),
        AddTask(task: "Isolation an der Spitze"),
      ],
    ),
    Task(
      name: "Ein großer Spender springt ab",
      description: "KRISE: Einer eurer größten Geldgeber zieht sich unerwartet zurück - ein großer Teil des "
          "Budgets steht plötzlich infrage.",
      duration: 10000.0,
      timeToSolve: 50000.0,
      cost: [Time(value: 6.0), Wisdom(value: 60.0)],
      award: [Money(value: 500.0)],
      modifier: [
        MessageModifier(
          message: "AUFGEFANGEN: Neue, breiter gestreute Unterstützer gefunden - weniger abhängig von Einzelnen.",
        ),
        RemoveTask(task: "Ein großer Spender springt ab"),
      ],
      missed: [
        SubtractRes(ressources: [Money(value: 3000.0)]),
        MessageModifier(message: "LOCH IM BUDGET: Die Abhängigkeit von wenigen großen Gebern rächt sich."),
        RemoveTask(task: "Ein großer Spender springt ab"),
        AddTask(task: "Ein großer Spender springt ab"),
      ],
    ),
  ],
);
