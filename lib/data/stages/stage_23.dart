import 'package:save_the_world_flutter_app/models/addtask.model.dart';
import 'package:save_the_world_flutter_app/models/autoexecute.model.dart';
import 'package:save_the_world_flutter_app/models/faith.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/member.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/message.modifier.dart';
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

final Stage stage23 = Stage(
  level: 23,
  member: 10000000,
  description: "Globale Bewegung Level 7 - Kulturelle Prägung durch Multiplikation.",
  activeTasks: [
    "Bibellesen", "Beten", 
    "Schlafen", 
    "Kollekte", 
    "Globales Mentoring-Netzwerk",
    "Einzelne persönlich begleiten",
    "Globale Strategieklausur"
  ],
  randomTasks: ["Wer hat euch dazu ernannt? (Krise)", "Der Heilige Geist möchte wirken"],
  allTasks: [
    baseBible,
    basePrayer,
    baseSleep,
    holySpiritWorking,
    collectMoney,
    Task(
      name: "Globales Mentoring-Netzwerk",
      description: "DELEGATION: Sichert die geistliche Qualität durch dezentrale Leiterschaftsbegleitung - "
          "aber ein automatisiertes Netzwerk kann echte geistliche Vaterschaft nicht ersetzen, nur "
          "skalieren.",
      duration: 150000.0,
      once: true,
      cost: [Wisdom(value: 25000.0), Faith(value: 10000.0)],
      modifier: [
        MessageModifier(message: "SYSTEM: Das Mentoring-Netzwerk läuft jetzt dezentral über alle Regionen."),
        AutoExecuteModifier(
          intervalMs: 20000,
          modifiers: [
            MultiplyRes(targetResName: "Wisdom", factorResName: "Member", multiplier: 0.0003),
            SubtractRes(ressources: [Faith(value: 800.0)]),
          ]
        ),
        RemoveTask(task: "Globales Mentoring-Netzwerk"),
      ],
    ),
    Task(
      name: "Einzelne persönlich begleiten",
      description: "WARTUNG: Bei Millionen Mitgliedern automatisiert das Netzwerk die "
          "Leiterschaftsbegleitung - aber echte geistliche Vaterschaft und Mutterschaft lässt sich nicht "
          "delegieren. Zeit für wenige, echte Beziehungen bleibt unersetzlich.",
      duration: 20000.0,
      cost: [Time(value: 8.0)],
      award: [Faith(value: 500.0)],
    ),
    Task(
      name: "Globale Strategieklausur",
      description: "BEFÄHIGUNG: Erarbeitet das moralische Fundament für den nächsten globalen Schritt.",
      duration: 100000.0,
      cost: [Wisdom(value: 10000.0), Time(value: 50.0)],
      award: [Wisdom(value: 5000.0)],
      modifier: [
        AddTask(task: "Vom Einfluss zur Prägung"),
        RemoveTask(task: "Globale Strategieklausur"),
      ],
    ),
    Task(
      name: "Vom Einfluss zur Prägung",
      description: "MEILENSTEIN: Die Bewegung wird zum moralischen Kompass der Weltgemeinschaft (Limit 20.000.000).",
      duration: 200000.0,
      isMilestone: true,
      cost: [Wisdom(value: 50000.0), Time(value: 100.0), Faith(value: 40000.0)],
      award: [Member(value: 1.0)],
      modifier: [
        MessageModifier(message: "GLOBAL: Eure Stimme prägt nun die Weltwerte. Limit 20.000.000!"),
        SetMax(ressource: "Member", newMax: 20000000.0),
        RemoveTask(task: "Vom Einfluss zur Prägung"),
        AddTask(task: "Globalen moralischen Kompass halten"),
      ],
    ),
    Task(
      name: "Globalen moralischen Kompass halten",
      description: "WARTUNG: Stetige Vertretung christlicher Werte in globalen Gremien.",
      duration: 60000.0,
      cost: [Time(value: 10.0), Wisdom(value: 5000.0)],
      award: [Faith(value: 1000.0), Publicity(value: 5000.0)],
    ),
    Task(
      name: "Wer hat euch dazu ernannt? (Krise)",
      description: "KRISE: Kritiker fragen unbequem: Wer hat einer Bewegung von wenigen Millionen unter "
          "acht Milliarden Menschen das Recht gegeben, sich zum moralischen Kompass der Welt "
          "aufzuschwingen? Der Anspruch selbst steht infrage.",
      duration: 30000.0,
      timeToSolve: 80000.0,
      cost: [Wisdom(value: 10000.0), Faith(value: 5000.0)],
      modifier: [
        MessageModifier(message: "DEMUT STATT ANSPRUCH: Dienst statt Status überzeugt mehr als jede Verteidigung."),
        RemoveTask(task: "Wer hat euch dazu ernannt? (Krise)"),
      ],
      missed: [
        SubtractRes(ressources: [Member(value: 500000.0), Faith(value: 5000.0)]),
        MessageModifier(message: "ZURÜCKGEWIESEN: Der Anspruch wirkt überheblich - Millionen wenden sich ab."),
        RemoveTask(task: "Wer hat euch dazu ernannt? (Krise)"),
        AddTask(task: "Wer hat euch dazu ernannt? (Krise)"),
      ],
    ),
  ],
);
