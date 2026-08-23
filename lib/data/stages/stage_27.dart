import 'package:save_the_world_flutter_app/data/stages/common_tasks.dart';
import 'package:save_the_world_flutter_app/models/addtask.model.dart';
import 'package:save_the_world_flutter_app/models/autoexecute.model.dart';
import 'package:save_the_world_flutter_app/models/faith.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/member.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/message.modifier.dart';
import 'package:save_the_world_flutter_app/models/money.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/multiplyres.model.dart';
import 'package:save_the_world_flutter_app/models/removetask.model.dart';
import 'package:save_the_world_flutter_app/models/stage.model.dart';
import 'package:save_the_world_flutter_app/models/setmax.model.dart';
import 'package:save_the_world_flutter_app/models/subtractres.model.dart';
import 'package:save_the_world_flutter_app/models/task.model.dart';
import 'package:save_the_world_flutter_app/models/time.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/wisdome.ressource.model.dart';

final Stage stage27 = Stage(
  level: 27,
  member: 160000000,
  description: "Denomination Level 2 - Ein Vermächtnis für kommende Generationen.",
  activeTasks: [ "Bibellesen", "Beten",
    "Schlafen",
    "Globales Stiftungsvermögen aufbauen",
    "Sich an die ursprüngliche Berufung erinnern"
  ],
  randomTasks: ["Die Stiftung wird zum Selbstzweck (Krise)", "Der Heilige Geist möchte wirken"],
  allTasks: [
    baseBible,
    basePrayer,
    baseSleep,
    holySpiritWorking,
    Task(
      name: "Globales Stiftungsvermögen aufbauen",
      description: "BEFÄHIGUNG: Kapital für ein dauerhaftes Fundament sammeln - aus vielen kleinen und "
          "großen Gaben wird ein Vermögen, das die Mission über die eigene Lebenszeit hinaus tragen soll.",
      duration: 150000.0,
      cost: [Wisdom(value: 30000.0), Money(value: 50000000.0)],
      award: [Wisdom(value: 10000.0)],
      modifier: [
        AddTask(task: "Eine Stiftung für die Mission errichten"),
        RemoveTask(task: "Globales Stiftungsvermögen aufbauen"),
      ],
    ),
    Task(
      name: "Sich an die ursprüngliche Berufung erinnern",
      description: "WARTUNG: Bewusst zurückkehren zu der Frage, warum alles einmal angefangen hat - nicht "
          "um nostalgisch zu sein, sondern um zu prüfen, ob die Mission noch die ist, für die man einmal "
          "alles aufgegeben hat.",
      duration: 20000.0,
      cost: [Time(value: 8.0)],
      award: [Faith(value: 600.0)],
    ),
    Task(
      name: "Eine Stiftung für die Mission errichten",
      description: "MEILENSTEIN: Ein dauerhaftes finanzielles Fundament, das die Arbeit über Generationen "
          "hinweg trägt - genug Kapital, um nie wieder ums Überleben kämpfen zu müssen. Aber genau das ist "
          "die Gefahr: eine Organisation, die nicht mehr ums Überleben kämpfen muss, kann leicht vergessen, "
          "wofür sie eigentlich lebt (Limit 320.000.000).",
      duration: 350000.0,
      isMilestone: true,
      cost: [Money(value: 600000000.0), Wisdom(value: 120000.0), Faith(value: 90000.0)],
      award: [Member(value: 1.0)],
      modifier: [
        MessageModifier(message: "FUNDAMENT: Die Stiftung steht - die Mission ist finanziell abgesichert. Limit 320.000.000!"),
        SetMax(ressource: "Member", newMax: 320000000.0),
        AutoExecuteModifier(
          intervalMs: 60000,
          modifiers: [
            MultiplyRes(targetResName: "Money", factorResName: "Money", multiplier: 0.002),
            SubtractRes(ressources: [Faith(value: 1500.0)]),
          ]
        ),
        RemoveTask(task: "Eine Stiftung für die Mission errichten"),
        AddTask(task: "Das Vermögen der Mission unterordnen"),
      ],
    ),
    Task(
      name: "Das Vermögen der Mission unterordnen",
      description: "WARTUNG: Stetige Arbeit daran, dass Kapitalerhalt und Investment-Ausschüsse Mittel "
          "zum Zweck bleiben - und nicht selbst zum Zweck werden.",
      duration: 60000.0,
      cost: [Time(value: 10.0), Wisdom(value: 15000.0)],
      award: [Faith(value: 8000.0), Wisdom(value: 3000.0)],
    ),
    Task(
      name: "Die Stiftung wird zum Selbstzweck (Krise)",
      description: "KRISE: Die Verwaltung des Vermögens beansprucht mehr Aufmerksamkeit als die "
          "eigentliche Mission - Investment-Ausschüsse und Kapitalerhalt werden wichtiger als die "
          "Menschen, für die das Kapital eigentlich da sein sollte.",
      duration: 40000.0,
      timeToSolve: 120000.0,
      cost: [Faith(value: 20000.0), Wisdom(value: 15000.0)],
      award: [Faith(value: 2000.0)],
      modifier: [
        MessageModifier(message: "ZURÜCKGEFUNDEN: Das Kapital dient wieder erkennbar der ursprünglichen Berufung."),
        RemoveTask(task: "Die Stiftung wird zum Selbstzweck (Krise)"),
      ],
      missed: [
        SubtractRes(ressources: [Faith(value: 30000.0)]),
        MessageModifier(message: "KASKADE: Die Verwaltung des Vermögens verdrängt endgültig die eigentliche Berufung!"),
        RemoveTask(task: "Die Stiftung wird zum Selbstzweck (Krise)"),
        AddTask(task: "Verwaltung ersetzt Berufung (Krise)"),
      ],
    ),
    Task(
      name: "Verwaltung ersetzt Berufung (Krise)",
      description: "FOLGE-KRISE: Die Organisation lebt jetzt vor allem für sich selbst - die Mission ist "
          "zur Erinnerung in alten Dokumenten geworden. Nur eine radikale Rückbesinnung kann das noch "
          "umkehren.",
      duration: 50000.0,
      timeToSolve: 130000.0,
      cost: [Faith(value: 50000.0), Wisdom(value: 30000.0)],
      award: [Faith(value: 5000.0)],
      modifier: [
        MessageModifier(message: "UMGEKEHRT: Die ursprüngliche Berufung trägt die Organisation wieder erkennbar."),
        RemoveTask(task: "Verwaltung ersetzt Berufung (Krise)"),
      ],
      missed: [
        SubtractRes(ressources: [
          Faith(value: 80000.0),
          Member(value: 1.0, multiplierResourceName: "Member", multiplierValue: 0.1),
        ]),
        MessageModifier(message: "ENTLEERT: Eine reiche, aber geistlich leere Institution bleibt zurück."),
        RemoveTask(task: "Verwaltung ersetzt Berufung (Krise)"),
        AddTask(task: "Verwaltung ersetzt Berufung (Krise)"),
      ],
    ),
  ],
);
