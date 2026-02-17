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

final Stage stage7 = Stage(
  level: 7,
  member: 800,
  description: "Sehr große Gemeinde - Fokus auf Außenwirkung und Gaben.",
  activeTasks: ["Bibellesen", "Schlafen", "Geistesgaben entdecken", "Pressearbeit"],
  randomTasks: ["Jemand möchte heiraten", "Der Heilige Geist möchte wirken", "Rechnung nicht bezahlt"],
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
      name: "Geistesgaben entdecken",
      description: "Findet heraus, wie man sich am besten einbringen kann.",
      duration: 5000.0,
      cost: [Time(value: 5.0), Faith(value: 20.0)],
      award: [Faith(value: 40.0), Wisdom(value: 10.0), Member(value: 0.2)], 
    ),
    Task(
      name: "Pressearbeit",
      description: "Du willst dich in Film und Fernsehen zeigen.",
      duration: 10000.0,
      cost: [Publicity(value: 15.0), Time(value: 1.0)],
      modifier: [AddTask(task: "Interview geben")],
    ),
    Task(
      name: "Interview geben",
      description: "Vielleicht hören es ja die richtigen Leute!",
      duration: 5000.0,
      award: [Publicity(value: 50.0), Faith(value: 10.0), Member(value: 0.1)], 
    ),
    Task(
      name: "Campus-Modell planen",
      description: "MEILENSTEIN: Vorbereitung auf mehrere Standorte (Limit 1100).",
      duration: 30000.0,
      isMilestone: true,
      cost: [Time(value: 15.0), Wisdom(value: 500.0), Faith(value: 200.0)],
      award: [Wisdom(value: 100.0), Member(value: 1.0)],
      modifier: [
        MessageModifier(message: "SYSTEM: Das Campus-Modell steht. Ihr seid bereit für den Sprung zur MegaChurch!"),
        SetMax(ressource: "Member", newMax: 1100.0),
        RemoveTask(task: "Campus-Modell planen"),
        AddTask(task: "Campus-Standorte koordinieren"),
      ],
    ),
    Task(
      name: "Campus-Standorte koordinieren",
      description: "WARTUNG: Unterstützung der verschiedenen Standorte im Dienst.",
      duration: 25000.0,
      cost: [Time(value: 4.0), Wisdom(value: 100.0)],
      award: [Faith(value: 50.0), Wisdom(value: 50.0)],
    ),
    Task(
      name: "Rechnung nicht bezahlt",
      description: "KRITISCH: Bezahle sofort, um Mahngebühren zu vermeiden.",
      duration: 5000.0,
      timeToSolve: 45000.0,
      cost: [Money(value: 30.0)],
      modifier: [
        MessageModifier(message: "ERLEDIGT: Die Finanzen sind wieder im Reinen."),
        RemoveTask(task: "Rechnung nicht bezahlt"),
      ],
      missed: [
        SubtractRes(ressources: [Money(value: 50.0)]),
        MessageModifier(message: "MAHNUNG: Hohe Verzugsgebühren wurden abgezogen!"),
        RemoveTask(task: "Rechnung nicht bezahlt"),
        AddTask(task: "Rechnung nicht bezahlt"),
      ],
    ),
  ],
);
