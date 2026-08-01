import 'package:save_the_world_flutter_app/models/addtask.model.dart';
import 'package:save_the_world_flutter_app/models/autoexecute.model.dart';
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
import 'package:save_the_world_flutter_app/models/faith.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/member.ressource.model.dart';
import 'package:save_the_world_flutter_app/data/stages/common_tasks.dart';

final Stage stage9 = Stage(
  level: 9,
  member: 1800,
  description: "MegaChurch Level 2 - Management von Systemen statt Menschen.",
  activeTasks: [
    "Bibellesen",
    "Beten",
    "Schlafen",
    "Kollekte",
    "FSJler einstellen",
    "Ein Betriebssystem für die Bewegung entwickeln",
  ],
  randomTasks: [
    "Jemand möchte heiraten",
    "Der Heilige Geist möchte wirken",
    "Streit in der Bewegung",
    "Menschen werden zu Zahlen",
  ],
  allTasks: [
    baseBible,
    basePrayer,
    baseSleep,
    collectMoney,
    holySpiritWorking,
    ...weddingQuestline,
    Task(
      name: "FSJler bezahlen",
      description: "VERPFLICHTUNG: Dein Stab will regelmäßig bezahlt werden.",
      duration: 8000.0,
      cost: [Money(value: 300.0)],
      award: [Publicity(value: 20.0), Wisdom(value: 10.0)],
    ),
    Task(
      name: "Streit in der Bewegung",
      description: "KRISE: Zwei Campus-Teams streiten über die Ausrichtung.",
      duration: 12000.0,
      timeToSolve: 80000.0,
      cost: [Wisdom(value: 200.0), Faith(value: 100.0)],
      modifier: [
        MessageModifier(message: "VERSÖHNT: Die Einheit der Bewegung wurde bewahrt."),
        RemoveTask(task: "Streit in der Bewegung"),
      ],
      missed: [
        SubtractRes(ressources: [Member(value: 50.0), Faith(value: 200.0)]),
        MessageModifier(message: "ESKALIERT: Der Streit hat Mitglieder und Vertrauen gekostet."),
        RemoveTask(task: "Streit in der Bewegung"),
        AddTask(task: "Streit in der Bewegung"),
      ],
    ),
    Task(
      name: "FSJler einstellen",
      description: "DELEGATION: Administrative Entlastung schaltet den 32-Stunden-Tag frei.",
      duration: 4000.0,
      cost: [Money(value: 500.0), Publicity(value: 100.0), Wisdom(value: 50.0)],
      award: [Time(value: 1.0)],
      modifier: [
        MessageModifier(message: "STRUKTUR: Dein Stab wächst. Zeit-Maximum auf 32h erhöht."),
        SetMax(ressource: "Time", newMax: 32.0),
        AddTask(task: "FSJler bezahlen"),
      ],
    ),
    Task(
      name: "Ein Betriebssystem für die Bewegung entwickeln",
      description: "Damit die Bewegung weiterwächst, ohne dass du persönlich überall dabei sein musst, "
          "braucht es verlässliche Systeme: Ausbildung, Berichtswege, Finanzen. Die Gefahr dabei: Systeme "
          "sollen Menschen dienen - nicht umgekehrt.",
      duration: 20000.0,
      cost: [Time(value: 6.0), Wisdom(value: 300.0)],
      award: [Wisdom(value: 150.0)],
      modifier: [AddTask(task: "Skalierbare Leitungsstruktur etablieren")],
    ),
    Task(
      name: "Skalierbare Leitungsstruktur etablieren",
      description: "MEILENSTEIN: Ausbildungspipeline, Berichtswege und Finanzsysteme tragen jetzt die ganze "
          "Bewegung - unabhängig von dir persönlich (Limit 2800).",
      duration: 40000.0,
      isMilestone: true,
      cost: [Wisdom(value: 1000.0), Money(value: 10000.0), Member(value: 200.0)],
      award: [Member(value: 1.0)],
      modifier: [
        MessageModifier(message: "MULTIPLIKATION: Die Leitungsstruktur trägt sich selbst. Limit 2800!"),
        SetMax(ressource: "Member", newMax: 2800.0),
        RemoveTask(task: "Skalierbare Leitungsstruktur etablieren"),
        AddTask(task: "Netzwerk pflegen"),
      ],
    ),
    Task(
      name: "Netzwerk pflegen",
      description: "SYSTEM: Halte die Verbindung und unterstütze deine regionalen Teams.",
      duration: 15000.0,
      cost: [Time(value: 4.0), Wisdom(value: 100.0)],
      award: [Faith(value: 50.0)],
      modifier: [
        AutoExecuteModifier(
          intervalMs: 30000,
          modifiers: [
            MultiplyRes(targetResName: "Member", factorResName: "Member", multiplier: 0.002),
            MessageModifier(message: "WACHSTUM: Das Netzwerk gedeiht durch weise Leitung."),
          ]
        ),
      ],
    ),
    Task(
      name: "Menschen werden zu Zahlen",
      description: "KRISE: In den Berichten und Kennzahlen der Bewegung sind Menschen zu Datenpunkten "
          "geworden. Niemand hat böse Absicht - aber die Systeme, die eigentlich dienen sollten, beginnen "
          "zu bestimmen, wie über Menschen gedacht wird.",
      duration: 12000.0,
      timeToSolve: 60000.0,
      cost: [Time(value: 8.0), Faith(value: 100.0)],
      award: [Faith(value: 40.0)],
      modifier: [
        MessageModifier(
          message: "ERINNERT: Bewusst wieder von Menschen statt von Kennzahlen gesprochen - die Systeme "
              "dienen wieder, statt zu bestimmen.",
        ),
        RemoveTask(task: "Menschen werden zu Zahlen"),
      ],
      missed: [
        SubtractRes(ressources: [Faith(value: 150.0), Member(value: 60.0)]),
        MessageModifier(
          message: "ENTFREMDET: Wer sich nur noch als Nummer im System fühlt, geht irgendwann - leise, ohne "
              "Vorwarnung.",
        ),
        RemoveTask(task: "Menschen werden zu Zahlen"),
        AddTask(task: "Menschen werden zu Zahlen"),
      ],
    ),
  ],
);
