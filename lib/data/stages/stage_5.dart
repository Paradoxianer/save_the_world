import 'package:save_the_world_flutter_app/models/addtask.model.dart';
import 'package:save_the_world_flutter_app/models/message.modifier.dart';
import 'package:save_the_world_flutter_app/models/stage.model.dart';
import 'package:save_the_world_flutter_app/models/setmax.model.dart';
import 'package:save_the_world_flutter_app/models/task.model.dart';
import 'package:save_the_world_flutter_app/models/time.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/wisdome.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/faith.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/money.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/member.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/publicity.ressource.model.dart';
import 'package:save_the_world_flutter_app/data/stages/common_tasks.dart';

final Stage stage5 = Stage(
  level: 5,
  member: 400,
  description: "Große Gemeinde - Struktur wird lebensnotwendig.",
  activeTasks: ["Bibellesen", "Schlafen", "Gottesdienst-Teams", "Jemand möchte heiraten"],
  allTasks: [
    baseBible,
    baseSleep,
    Task(
      name: "Jemand möchte heiraten",
      description: "Ein Paar bittet um Trauung (Inspiration: oldstages).",
      duration: 10000.0,
      cost: [Time(value: 0.5), Faith(value: 50.0), Wisdom(value: 50.0)],
      award: [Publicity(value: 5.0)],
      modifier: [AddTask(task: "Heiratsvorbereitung 1")],
    ),
    Task(
      name: "Heiratsvorbereitung 1",
      description: "In einer Beziehung muss man richtig streiten und versöhnen lernen.",
      duration: 10000.0,
      cost: [Time(value: 1.5), Faith(value: 50.0), Wisdom(value: 50.0)],
      award: [Faith(value: 60.0), Wisdom(value: 60.0)],
      modifier: [AddTask(task: "Hochzeit")],
    ),
    Task(
      name: "Hochzeit",
      description: "Sie dürfen die Braut jetzt küssen!",
      duration: 10000.0,
      cost: [Time(value: 3.0), Faith(value: 50.0), Wisdom(value: 50.0)],
      award: [Member(value: 0.5), Faith(value: 70.0), Wisdom(value: 60.0), Money(value: 200.0)],
    ),
    Task(
      name: "Gottesdienst-Teams",
      description: "DELEGATION (EFFEKT): Du gibst erste Aufgaben ab.",
      duration: 10000.0,
      cost: [Time(value: 4.0), Wisdom(value: 100.0)],
      award: [Time(value: 1.0)], 
      modifier: [AddTask(task: "Bereichsleiter einsetzen")],
    ),
    Task(
      name: "Bereichsleiter einsetzen",
      description: "MEILENSTEIN: Spezialisierung ermöglicht Wachstum auf 600.",
      duration: 25000.0,
      cost: [Time(value: 12.0), Wisdom(value: 300.0), Member(value: 100.0)],
      modifier: [
        MessageModifier(message: "STRUKTUR: Du leitest nun durch Teams. Das Glasdach steigt auf 600!"),
        SetMax(ressource: "Member", newMax: 600.0),
      ],
    ),
  ],
);
