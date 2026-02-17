import 'package:save_the_world_flutter_app/models/addtask.model.dart';
import 'package:save_the_world_flutter_app/models/faith.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/member.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/message.modifier.dart';
import 'package:save_the_world_flutter_app/models/money.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/removetask.model.dart';
import 'package:save_the_world_flutter_app/models/stage.model.dart';
import 'package:save_the_world_flutter_app/models/setmax.model.dart';
import 'package:save_the_world_flutter_app/models/subtractres.model.dart';
import 'package:save_the_world_flutter_app/models/task.model.dart';
import 'package:save_the_world_flutter_app/models/time.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/wisdome.ressource.model.dart';

final Stage stage1 = Stage(
  level: 1,
  member: 40,
  description: "Gemeinschaftsgruppe - Die Verantwortung wächst.",
  activeTasks: [
    "Bibellesen", 
    "Beten", 
    "Schlafen", 
    "Gottesdienst vorbereiten",
  ],
  randomTasks: ["Konflikt in der Gruppe"],
  allTasks: [
    Task(
      name: "Bibellesen",
      description: "Die geistliche Grundlage für das Wachstum der Gemeinschaft legen.",
      duration: 3000.0,
      cost: [Time(value: 1.0)],
      award: [Faith(value: 10.0), Wisdom(value: 1.0)],
    ),
    Task(
      name: "Beten",
      description: "Im Gebet für die Gemeinschaft und für neue Mitglieder einstehen.",
      duration: 4000.0,
      cost: [Time(value: 1.0), Faith(value: 5.0)],
      award: [Member(value: 0.2)],
    ),
    Task(
      name: "Schlafen",
      description: "Auch ein Leiter braucht Ruhe, um weise Entscheidungen zu treffen.",
      duration: 8000.0,
      cost: [Time(value: 8.0)],
      award: [Time(value: 16.0)],
    ),
    Task(
      name: "Gottesdienst vorbereiten",
      description: "MEILENSTEIN: Schafft die Strukturen für regelmäßige Treffen und hebt das Mitgliederlimit auf 80.",
      duration: 12000.0,
      isMilestone: true, 
      cost: [Time(value: 6.0), Faith(value: 20.0), Wisdom(value: 10.0)],
      award: [Member(value: 1.0)], 
      modifier: [
        MessageModifier(message: "MEILENSTEIN: Der erste Gottesdienst war ein Erfolg! Die Gemeinschaft wächst und dein Limit liegt nun bei 80 Mitgliedern."),
        SetMax(ressource: "Member", newMax: 80.0),
        RemoveTask(task: "Gottesdienst vorbereiten"),
        AddTask(task: "Gottesdienst feiern"),
        AddTask(task: "Gottesdienst koordinieren"),
      ],
    ),
    Task(
      name: "Gottesdienst feiern",
      description: "Regelmäßige Gottesdienste sind das Herzstück der wachsenden Gemeinde.",
      duration: 8000.0,
      cost: [Time(value: 4.0), Faith(value: 15.0)],
      award: [Member(value: 1.0), Money(value: 20.0)],
      modifier: [
         MessageModifier(message: "KOLLEKTE: Die Gemeinde gibt großzügig. Nutze das Geld für wichtige Upgrades!"),
         AddTask(task: "FSJler einstellen"),
      ]
    ),
    Task(
      name: "Gottesdienst koordinieren",
      description: "WARTUNG: Sorge für einen reibungslosen Ablauf der wöchentlichen Treffen.",
      duration: 10000.0,
      cost: [Time(value: 2.0), Faith(value: 5.0)],
      award: [Faith(value: 10.0), Wisdom(value: 2.0)],
    ),
    Task(
      name: "FSJler einstellen",
      description: "Entlastung für dich. Schaltet 32h-Tag frei.",
      duration: 4000.0,
      cost: [Money(value: 100.0)],
      modifier: [
        MessageModifier(message: "UPGRADE: Der FSJler ist da! Dein Zeit-Maximum wurde auf 32h erhöht."),
        SetMax(ressource: "Time", newMax: 32.0),
        AddTask(task: "FSJler bezahlen"),
      ],
    ),
    Task(
      name: "FSJler bezahlen",
      description: "KRITISCH: Bezahle den FSJler pünktlich, sonst verlässt er die Gemeinschaft!",
      duration: 10000.0,
      timeToSolve: 80000.0,
      cost: [Money(value: 50.0)],
      award: [Time(value: 8.0)],
      missed: [
        SetMax(ressource: "Time", newMax: 24.0),
        AddTask(task: "FSJler einstellen"),
        MessageModifier(message: "VERLUST: Der FSJler hat gekündigt! Dein Zeit-Limit sinkt wieder auf 24h."),
      ],
    ),
    Task(
      name: "Konflikt in der Gruppe",
      description: "ES BRODELT: Eine Meinungsverschiedenheit droht, die Gruppe zu spalten. Kümmere dich darum!",
      duration: 15000.0,
      timeToSolve: 120000.0, 
      cost: [Time(value: 2.0), Wisdom(value: 5.0)],
      award: [Faith(value: 10.0)],
      modifier: [
        MessageModifier(message: "GELÖST: Puh, der Konflikt ist beigelegt. Die Gemeinschaft ist gestärkt."),
        RemoveTask(task: "Konflikt in der Gruppe"),
      ],
      missed: [
        SubtractRes(ressources: [Member(value: 5.0)]),
        MessageModifier(message: "SPALTUNG: Der Konflikt ist eskaliert! Einige Mitglieder haben die Gemeinschaft verlassen."),
        RemoveTask(task: "Konflikt in der Gruppe"),
        AddTask(task: "Konflikt in der Gruppe"),
      ],
    ),
  ],
);
