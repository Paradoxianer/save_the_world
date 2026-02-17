import 'package:save_the_world_flutter_app/models/addtask.model.dart';
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
import 'package:save_the_world_flutter_app/models/faith.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/member.ressource.model.dart';
import 'package:save_the_world_flutter_app/data/stages/common_tasks.dart';

final Stage stage6 = Stage(
  level: 6,
  member: 600,
  description: "Sehr große Gemeinde - Professionalität & Stadtmission.",
  activeTasks: ["Bibellesen", "Schlafen", "Kollekte", "Einsatzwagen anschaffen", "Kinderprogramm"],
  randomTasks: ["Einsatzwagen kaputt", "Jemand möchte heiraten", "Der Heilige Geist möchte wirken"],
  allTasks: [
    baseBible,
    baseSleep,
    collectMoney,
    someoneWantsToMarry,
    holySpiritWorking,
    weddingPhase1,
    weddingPhase2,
    actualWedding,
    Task(
      name: "Kinderprogramm",
      description: "Wie ein Hauskreis, nur viel anstrengender.",
      duration: 8000.0,
      cost: [Money(value: 4.0), Time(value: 4.0), Faith(value: 10.0)],
      award: [Faith(value: 30.0), Member(value: 0.5)], 
    ),
    Task(
      name: "Einsatzwagen anschaffen",
      description: "Eine alte Klapperkiste für die Stadtmission.",
      duration: 20000.0,
      cost: [Money(value: 600.0), Wisdom(value: 5.0)],
      award: [Publicity(value: 2.0)],
      modifier: [
        AddTask(task: "Für den Einsatzwagen einkaufen"),
        RemoveTask(task: "Einsatzwagen anschaffen"),
      ],
    ),
    Task(
      name: "Für den Einsatzwagen einkaufen",
      description: "Am besten Eintopf!",
      duration: 3000.0,
      cost: [Time(value: 2.0), Money(value: 2.0)],
      award: [Publicity(value: 6.0)],
      modifier: [
        AddTask(task: "Mit dem Einsatzwagen raus"),
        RemoveTask(task: "Für den Einsatzwagen einkaufen"),
      ],
    ),
    Task(
      name: "Mit dem Einsatzwagen raus",
      description: "Ab zum Kotti!",
      duration: 6000.0,
      award: [Publicity(value: 15.0), Member(value: 0.1)], 
      modifier: [
        AddTask(task: "Für den Einsatzwagen einkaufen"),
        RemoveTask(task: "Mit dem Einsatzwagen raus"),
      ],
    ),
    Task(
      name: "Einsatzwagen kaputt",
      description: "NOTFALL: Der Wagen streikt! Reparatur ist teuer.",
      duration: 10000.0,
      timeToSolve: 60000.0,
      cost: [Money(value: 200.0), Time(value: 4.0)],
      modifier: [
        AddTask(task: "Für den Einsatzwagen einkaufen"),
        MessageModifier(message: "REPARIERT: Der Wagen läuft wieder. Weiter geht's!"),
        RemoveTask(task: "Einsatzwagen kaputt"),
      ],
      missed: [
        MessageModifier(message: "VERLUST: Der Wagen wurde verschrottet. Du musst einen neuen anschaffen."),
        AddTask(task: "Einsatzwagen anschaffen"),
        RemoveTask(task: "Einsatzwagen kaputt"),
      ],
    ),
    Task(
      name: "Hauptamtliche einstellen",
      description: "MEILENSTEIN: Vollzeitkräfte für die Front (Limit 800).",
      duration: 30000.0,
      isMilestone: true,
      cost: [Money(value: 3000.0), Wisdom(value: 200.0), Member(value: 100.0)],
      award: [Member(value: 1.0)],
      modifier: [
        MessageModifier(message: "PROFIS: Die ersten Pastoren sind angestellt. Limit 800!"),
        SetMax(ressource: "Member", newMax: 800.0),
        RemoveTask(task: "Hauptamtliche einstellen"),
        AddTask(task: "Team leiten & koordinieren"),
      ],
    ),
    Task(
      name: "Team leiten & koordinieren",
      description: "WARTUNG: Unterstützung der Hauptamtlichen im Dienst.",
      duration: 20000.0,
      cost: [Time(value: 4.0), Wisdom(value: 50.0)],
      award: [Wisdom(value: 20.0), Faith(value: 20.0)],
    ),
  ],
);
