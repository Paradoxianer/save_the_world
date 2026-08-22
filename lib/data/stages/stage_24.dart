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

final Stage stage24 = Stage(
  level: 24,
  member: 20000000,
  description: "Globaler Beeinflusser Level 1 - Die Geburt einer weltweiten Denomination.",
  activeTasks: [
    "Bibellesen", "Beten",
    "Schlafen",
    "Kollekte",
    "Regional-Präsidien einsetzen",
    "Ein Schritt im Vertrauen wagen",
    "Verfassungs-Entwurf"
  ],
  randomTasks: ["Der Glaube wird zur Herkunft (Krise)", "Finanzprüfung (Krise)", "Der Heilige Geist möchte wirken"],
  allTasks: [
    baseBible,
    basePrayer,
    baseSleep,
    holySpiritWorking,
    collectMoney,
    Task(
      name: "Regional-Präsidien einsetzen",
      description: "DELEGATION: Dezentrale Verwaltungseinheiten stabilisieren die globalen Finanzen passiv "
          "- effizient, aber rein administratives Wachstum ohne geistliche Rückbindung zehrt bei dieser "
          "Größe schneller am Glauben, als es sich durch Verwaltung ersetzen lässt.",
      duration: 180000.0,
      cost: [Money(value: 25000000.0), Wisdom(value: 15000.0)],
      modifier: [
        MessageModifier(message: "BÜROKRATIE: Deine Präsidien arbeiten effizient. Kollekte nun automatisiert."),
        AutoExecuteModifier(
          intervalMs: 60000,
          modifiers: [
            MultiplyRes(targetResName: "Money", factorResName: "Member", multiplier: 8.0),
            SubtractRes(ressources: [Faith(value: 1500.0)]),
          ]
        ),
        RemoveTask(task: "Regional-Präsidien einsetzen"),
      ],
    ),
    Task(
      name: "Ein Schritt im Vertrauen wagen",
      description: "Eine Entscheidung, die sich wirtschaftlich nicht rechnet - kein sofortiger Ertrag "
          "sichtbar, nur die Zusage, dass Gott mehrt, was im Vertrauen gesät wird: \"Der Same geht auf und "
          "wächst - er weiß selbst nicht wie\" (Markus 4,26-29). Bei einer Größe, in der Effizienz und "
          "Verwaltung alles zu bestimmen drohen, ist bewusstes Warten auf Gott selbst schon ein Statement.",
      duration: 300000.0,
      cost: [Faith(value: 2000.0)],
      award: [Faith(value: 6000.0), Wisdom(value: 1500.0)],
    ),
    Task(
      name: "Verfassungs-Entwurf",
      description: "BEFÄHIGUNG: Juristische Vorbereitung der globalen Satzung.",
      duration: 80000.0,
      cost: [Wisdom(value: 10000.0), Time(value: 20.0)],
      award: [Wisdom(value: 2000.0)],
      modifier: [
        AddTask(task: "Globale Satzung verabschieden"),
        RemoveTask(task: "Verfassungs-Entwurf"),
      ],
    ),
    Task(
      name: "Globale Satzung verabschieden",
      description: "MEILENSTEIN: Rechtliche Anerkennung als weltweite Konfession (Limit 40.000.000).",
      duration: 250000.0,
      isMilestone: true,
      cost: [Wisdom(value: 60000.0), Time(value: 100.0), Faith(value: 45000.0)],
      award: [Member(value: 1.0)],
      modifier: [
        MessageModifier(message: "ANERKENNUNG: Die Weltgemeinschaft akzeptiert eure Statuten. Limit 40.000.000!"),
        SetMax(ressource: "Member", newMax: 40000000.0),
        RemoveTask(task: "Globale Satzung verabschieden"),
        AddTask(task: "Satzung rechtlich wahren"),
      ],
    ),
    Task(
      name: "Satzung rechtlich wahren",
      description: "WARTUNG: Stetige juristische Begleitung der weltweiten Kirchenstruktur.",
      duration: 60000.0,
      cost: [Time(value: 10.0), Wisdom(value: 5000.0)],
      award: [Faith(value: 1000.0), Publicity(value: 2000.0)],
    ),
    Task(
      name: "Finanzprüfung (Krise)",
      description: "KRISE: Der Weltrat fordert absolute Transparenz über die globalen Konten!",
      duration: 40000.0,
      timeToSolve: 100000.0,
      cost: [Wisdom(value: 15000.0), Money(value: 5000000.0)],
      modifier: [
        MessageModifier(message: "BESTANDEN: Die Prüfung war erfolgreich. Die Integrität ist gewahrt."),
        RemoveTask(task: "Finanzprüfung (Krise)"),
      ],
      missed: [
        SubtractRes(ressources: [Money(value: 20000000.0), Publicity(value: 50000.0)]),
        MessageModifier(message: "KASKADE: Korruptionsverdacht führt zum Vermögensarrest!"),
        RemoveTask(task: "Finanzprüfung (Krise)"),
        AddTask(task: "Vermögensarrest (Krise)"),
      ],
    ),
    Task(
      name: "Vermögensarrest (Krise)",
      description: "FOLGE-KRISE: Deine Konten sind weltweit eingefroren. Repariere das Vertrauen.",
      duration: 60000.0,
      cost: [Wisdom(value: 30000.0), Publicity(value: 100000.0)],
      modifier: [
        MessageModifier(message: "BEHOBEN: Der Arrest wurde aufgehoben, aber der Schaden ist groß."),
        RemoveTask(task: "Vermögensarrest (Krise)"),
      ],
      missed: [
        SubtractRes(ressources: [Member(value: 1000000.0)]),
        RemoveTask(task: "Vermögensarrest (Krise)"),
        AddTask(task: "Vermögensarrest (Krise)"),
      ],
    ),
    Task(
      name: "Der Glaube wird zur Herkunft (Krise)",
      description: "KRISE: Für immer mehr Mitglieder ist der Glaube nicht mehr persönliche Entscheidung, "
          "sondern einfach das, worin man hineingeboren wurde - Zugehörigkeit ohne echte Überzeugung "
          "breitet sich aus. Die Zahlen wachsen weiter, die geistliche Substanz nicht.",
      duration: 30000.0,
      timeToSolve: 80000.0,
      cost: [Faith(value: 10000.0), Wisdom(value: 5000.0)],
      modifier: [
        MessageModifier(message: "ERWECKT: Bewusste Entscheidung statt bloßer Herkunft wird neu betont - und gelebt."),
        RemoveTask(task: "Der Glaube wird zur Herkunft (Krise)"),
      ],
      missed: [
        SubtractRes(ressources: [Faith(value: 15000.0)]),
        MessageModifier(message: "AUSGEHÖHLT: Die Mitglieder bleiben - aber der Glaube dahinter ist zur leeren Hülle geworden."),
        RemoveTask(task: "Der Glaube wird zur Herkunft (Krise)"),
        AddTask(task: "Der Glaube wird zur Herkunft (Krise)"),
      ],
    ),
  ],
);
