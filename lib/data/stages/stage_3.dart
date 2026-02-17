import 'package:save_the_world_flutter_app/models/addtask.model.dart';
import 'package:save_the_world_flutter_app/models/faith.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/member.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/message.modifier.dart';
import 'package:save_the_world_flutter_app/models/money.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/multiplyres.model.dart';
import 'package:save_the_world_flutter_app/models/publicity.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/stage.model.dart';
import 'package:save_the_world_flutter_app/models/setmax.model.dart';
import 'package:save_the_world_flutter_app/models/task.model.dart';
import 'package:save_the_world_flutter_app/models/time.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/wisdome.ressource.model.dart';

final Stage stage3 = Stage(
  level: 3,
  member: 140,
  description: "Mittlere Gemeinde - Vom Clan zur Organisation.",
  activeTasks: ["Kollekte", "Schlafen", "Öffentlicher Gottesdienst"],
  allTasks: [
    Task(name: "Schlafen", duration: 8000.0, cost: [Time(value: 8.0)], award: [Time(value: 16.0)]),
    Task(name: "Bibellesen", duration: 3000.0, cost: [Time(value: 1.0)], award: [Faith(value: 15.0)]),
    Task(
      name: "Kollekte",
      duration: 3000.0,
      cost: [Time(value: 1.0)],
      modifier: [MultiplyRes(targetResName: "Money", factorResName: "Member", multiplier: 0.7)],
    ),
    Task(
      name: "Öffentlicher Gottesdienst",
      description: "Jeden Sonntag für die ganze Stadt.",
      duration: 6000.0,
      cost: [Time(value: 5.0), Money(value: 30.0)],
      award: [Member(value: 1.0), Publicity(value: 8.0)], // Pacing: 5.0 -> 1.0
      modifier: [
        MultiplyRes(targetResName: "Faith", factorResName: "Member", multiplier: 0.2),
      ],
    ),
    Task(
      name: "Korpsrat gründen",
      description: "MEILENSTEIN: Ein Leitungsteam für die Zukunft (Limit 200).",
      duration: 20000.0,
      isMilestone: true,
      cost: [Time(value: 8.0), Wisdom(value: 50.0), Member(value: 60.0)],
      award: [Wisdom(value: 30.0), Member(value: 1.0)],
      modifier: [
        MessageModifier(message: "ORGANISATION: Gemeinsam seid ihr stärker. Willkommen in Stufe 4 (Limit 200)."),
        SetMax(ressource: "Member", newMax: 200.0),
      ],
    ),
  ],
);
