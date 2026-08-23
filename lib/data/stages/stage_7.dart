import 'package:save_the_world_flutter_app/models/addtask.model.dart';
import 'package:save_the_world_flutter_app/models/faith.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/member.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/message.modifier.dart';
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
  description: "Fast eine MegaChurch - Fokus auf Außenwirkung und Lehre.",
  activeTasks: ["Bibellesen", "Beten", "Schlafen", "Lehre auf Balance prüfen", "Pressearbeit"],
  randomTasks: ["Jemand möchte heiraten", "Der Heilige Geist möchte wirken", "Die Lehre kippt"],
  allTasks: [
    baseBible,
    basePrayer,
    baseSleep,
    collectMoney,
    holySpiritWorking,
    ...weddingQuestline,
    Task(
      name: "Lehre auf Balance prüfen",
      description: "Bei so vielen Menschen driftet Lehre leicht in eine Richtung ab - zu viel Gesetz, zu viel "
          "beliebige Gnade, oder zu viel Fokus auf Wunder ohne Fundament. Ein bewusster Blick auf die eigene "
          "Verkündigung hält die Balance zwischen Gesetzlichkeit, Gnade und dem Wirken des Heiligen Geistes.",
      duration: 12000.0,
      cost: [Time(value: 6.0), Wisdom(value: 80.0)],
      award: [Wisdom(value: 60.0), Faith(value: 20.0)],
      modifier: [
        AddTask(task: "Satellitengemeinden gründen"),
        AddTask(task: "Lehre in Balance halten"),
      ],
    ),
    Task(
      name: "Lehre in Balance halten",
      description: "WARTUNG: Gesetzlichkeit, Gnade und Raum für den Heiligen Geist bleiben nur im Gleichgewicht, "
          "wenn immer wieder bewusst nachjustiert wird - keiner der drei darf die anderen verdrängen.",
      duration: 15000.0,
      cost: [Time(value: 5.0), Wisdom(value: 40.0)],
      award: [Faith(value: 25.0), Wisdom(value: 15.0)],
    ),
    Task(
      name: "Die Lehre kippt",
      description: "KRISE: Ohne bewusste Balance rutscht die Verkündigung in eine Richtung ab - mal zu starr, "
          "mal zu beliebig, mal zu sehr aufs Außergewöhnliche fixiert. Die Gemeinde spürt, dass etwas nicht "
          "stimmt.",
      duration: 10000.0,
      timeToSolve: 55000.0,
      cost: [Time(value: 6.0), Wisdom(value: 60.0)],
      award: [Faith(value: 15.0)],
      modifier: [
        MessageModifier(message: "KORRIGIERT: Die Balance zwischen Gesetzlichkeit, Gnade und dem Heiligen Geist ist wiederhergestellt."),
        RemoveTask(task: "Die Lehre kippt"),
      ],
      missed: [
        SubtractRes(ressources: [Member(value: 25.0), Faith(value: 30.0)]),
        MessageModifier(message: "ABGEDRIFTET: Enttäuschte und verunsicherte Mitglieder wenden sich ab."),
        RemoveTask(task: "Die Lehre kippt"),
        AddTask(task: "Die Lehre kippt"),
      ],
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
      name: "Satellitengemeinden gründen",
      description: "MEILENSTEIN: Vorbereitung auf mehrere Standorte (Limit 1100).",
      duration: 30000.0,
      isMilestone: true,
      cost: [Time(value: 15.0), Wisdom(value: 500.0), Faith(value: 200.0)],
      award: [Wisdom(value: 100.0), Member(value: 1.0)],
      modifier: [
        MessageModifier(message: "SYSTEM: Die ersten Satellitengemeinden stehen. Ihr seid bereit für den Sprung zur MegaChurch!"),
        SetMax(ressource: "Member", newMax: 1100.0),
        RemoveTask(task: "Satellitengemeinden gründen"),
        AddTask(task: "Satellitengemeinden koordinieren"),
      ],
    ),
    Task(
      name: "Satellitengemeinden koordinieren",
      description: "WARTUNG: Unterstützung der verschiedenen Standorte im Dienst.",
      duration: 25000.0,
      cost: [Time(value: 4.0), Wisdom(value: 100.0)],
      award: [Faith(value: 50.0), Wisdom(value: 50.0)],
    ),
  ],
);
