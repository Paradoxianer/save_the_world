import 'package:save_the_world_flutter_app/models/addtask.model.dart';
import 'package:save_the_world_flutter_app/models/faith.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/member.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/message.modifier.dart';
import 'package:save_the_world_flutter_app/models/money.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/stage.model.dart';
import 'package:save_the_world_flutter_app/models/setmax.model.dart';
import 'package:save_the_world_flutter_app/models/subtractres.model.dart';
import 'package:save_the_world_flutter_app/models/task.model.dart';
import 'package:save_the_world_flutter_app/models/time.ressource.model.dart';

final Stage stage1 = Stage(
  level: 1,
  member: 40,
  description: "Gemeinschaftsgruppe - Die Verantwortung wächst.",
  activeTasks: [
    "Bibellesen", 
    "Beten", 
    "Schlafen", 
    "Kuchenverkauf", 
    "Essen in meiner Wohnung", 
    "FSJler einstellen"
  ],
  randomTasks: [], // 'Rechnung nicht bezahlt' entfernt - Katastrophen erst ab Stage 2
  allTasks: [
    Task(
      name: "Bibellesen",
      description: "Zeit investieren, um 'Glauben' zu stärken.",
      duration: 3000.0,
      cost: [Time(value: 1.0)],
      award: [Faith(value: 15.0)],
    ),
    Task(
      name: "Beten",
      description: "Wandelt 'Glauben' in neue 'Mitglieder' um.",
      duration: 4000.0,
      cost: [Time(value: 1.0), Faith(value: 5.0)],
      award: [Member(value: 1.0)],
    ),
    Task(
      name: "Schlafen",
      duration: 8000.0,
      cost: [Time(value: 8.0)],
      award: [Time(value: 16.0)],
    ),
    Task(
      name: "Kuchenverkauf",
      description: "Ein paar Kuchen verkaufen, um die Kasse für Upgrades aufzubessern.",
      duration: 5000.0,
      cost: [Time(value: 2.0), Faith(value: 5.0)],
      award: [Money(value: 30.0)],
      modifier: [
        MessageModifier(message: "GELD: Du hast deine ersten Einnahmen! Geld brauchst du für Upgrades wie den FSJler."),
      ],
    ),
    Task(
      name: "Essen in meiner Wohnung",
      description: "Gemeinschaft stärken und neue Leute einladen.",
      duration: 10000.0,
      cost: [Time(value: 4.0), Faith(value: 10.0)],
      award: [Member(value: 5.0)],
      // KEIN SetMax mehr - Das Limit wurde bereits in Stage 0 auf 40 erhöht.
    ),
    Task(
      name: "FSJler einstellen",
      description: "Hilfe im Alltag. Schaltet 32-Stunden-Tag frei!",
      duration: 4000.0,
      cost: [Money(value: 50.0), Time(value: 5.0)],
      award: [Time(value: 1.0)],
      modifier: [
        MessageModifier(message: "UPGRADE: Der FSJler ist da! Dein Zeit-Maximum wurde auf 32h erhöht. Aber er will regelmäßig bezahlt werden!"),
        SetMax(ressource: "Time", newMax: 32.0),
        AddTask(task: "FSJler bezahlen"),
      ],
    ),
    Task(
      name: "FSJler bezahlen",
      description: "KRITISCH: Bezahle den FSJler, bevor er kündigt!",
      duration: 10000.0,
      timeToSolve: 60000.0,
      cost: [Money(value: 36.0)],
      award: [Time(value: 8.0)],
      missed: [
        SetMax(ressource: "Time", newMax: 24.0),
        AddTask(task: "FSJler einstellen"),
        MessageModifier(message: "OH NEIN: Der FSJler hat gekündigt! Dein Zeit-Limit sinkt wieder auf 24h."),
      ],
    ),
    Task(
      name: "Rechnung nicht bezahlt",
      description: "KRITISCH: Bezahle sofort, um Mahngebühren zu vermeiden.",
      duration: 5000.0,
      timeToSolve: 45000.0,
      cost: [Money(value: 30.0)],
      missed: [
        SubtractRes(ressources: [Money(value: 50.0)]),
        AddTask(task: "Rechnung nicht bezahlt"),
        MessageModifier(message: "MAHNUNG: Du hast zu lange gewartet. 50 Geld wurden als Strafe abgezogen!"),
      ],
    ),
  ],
);
