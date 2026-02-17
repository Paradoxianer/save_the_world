import 'package:save_the_world_flutter_app/models/autoexecute.model.dart';
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
import 'package:save_the_world_flutter_app/data/stages/common_tasks.dart';

final Stage stage23 = Stage(
  level: 23,
  member: 15000000,
  description: "Globale Bewegung Level 7 - Bewegung der Bewegungen (Kulturelle Prägung).",
  activeTasks: ["Bibellesen", "Kollekte", "Globales Mentoring-Netzwerk", "Kultur-Transformations-Programm"],
  randomTasks: ["Der Heilige Geist möchte wirken", "Geistlicher Aufbruch in Metropolen", "Theologische Grundsatzfrage (Krise)"],
  allTasks: [
    baseBible,
    baseSleep,
    collectMoney,
    holySpiritWorking,
    funeralGeneral,
    Task(
      name: "Kollekte",
      duration: 3000.0,
      cost: [Time(value: 1.0)],
      modifier: [MultiplyRes(targetResName: "Money", factorResName: "Member", multiplier: 45.0)],
    ),
    Task(
      name: "Globales Mentoring-Netzwerk",
      description: "Jeder erfahrene Leiter begleitet 10 neue Leiter. Sichert die geistliche Qualität bei Massenwachstum.",
      duration: 150000.0,
      cost: [Wisdom(value: 25000.0), Faith(value: 10000.0)],
      modifier: [
        AutoExecuteModifier(
          intervalMs: 20000,
          modifiers: [
            // Qualitätssicherung: Erzeugt Glaube und Weisheit proportional zur Mitgliederzahl
            MultiplyRes(targetResName: "Faith", factorResName: "Member", multiplier: 0.0002),
            MultiplyRes(targetResName: "Wisdom", factorResName: "Member", multiplier: 0.0003),
          ]
        ),
      ],
    ),
    Task(
      name: "Kultur-Transformations-Programm",
      description: "Einfluss auf Kunst, Wirtschaft und Politik. Hohe Bekanntheit zieht automatisch neue Sucher an.",
      duration: 200000.0,
      cost: [Money(value: 10000000.0), Wisdom(value: 20000.0), Publicity(value: 100000.0)],
      modifier: [
        AutoExecuteModifier(
          intervalMs: 50000,
          modifiers: [
            // Verschachtelte Logik: Publicity wirkt als Multiplikator für Member-Zuwachs
            MultiplyRes(targetResName: "Member", factorResName: "Publicity", multiplier: 0.1),
            MessageModifier(message: "TRANSFORMATION: Christliche Werte prägen die globale Kultur und ziehen Suchende an."),
          ]
        ),
      ],
    ),
    Task(
      name: "Geistlicher Aufbruch in Metropolen",
      description: "In den Megacitys entstehen tausende neue Gemeinden gleichzeitig. Ein gewaltiger Schub.",
      duration: 120000.0,
      cost: [Faith(value: 20000.0), Time(value: 50.0), Wisdom(value: 5000.0)],
      award: [Member(value: 1000000.0), Publicity(value: 50000.0)],
      modifier: [
        MessageModifier(message: "ERWECKUNG: Die Großstädte brennen für das Evangelium!"),
      ],
    ),
    Task(
      name: "Vom Einfluss zur Prägung",
      description: "MEILENSTEIN: Die Bewegung wird zum moralischen Kompass der Weltgemeinschaft (Limit 30.000.000).",
      duration: 300000.0,
      cost: [Wisdom(value: 50000.0), Time(value: 200.0), Faith(value: 40000.0)],
      modifier: [
        MessageModifier(message: "GLOBALER EINFLUSS: Eure Stimme zählt im Weltrat. Limit 30.000.000!"),
        SetMax(ressource: "Member", newMax: 30000000.0),
      ],
    ),
  ],
);
