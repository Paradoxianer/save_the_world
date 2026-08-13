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

final Stage stage18 = Stage(
  level: 18,
  member: 1000000,
  description: "Globale Bewegung Level 4 - Institutionalisierung der Nächstenliebe.",
  activeTasks: [
    "Bibellesen", "Beten", 
    "Schlafen", 
    "Kollekte", 
    "Machbarkeitsstudie Hilfsprojekt",
    "Internationales Hilfswerk gründen",
    "Rückzug zur Quelle"
  ],
  randomTasks: ["Humanitäre Krise", "Der Heilige Geist möchte wirken"],
  allTasks: [
    baseBible,
    basePrayer,
    baseSleep,
    collectMoney,
    holySpiritWorking,
    Task(
      name: "Machbarkeitsstudie Hilfsprojekt",
      description: "BEFÄHIGUNG: Analyse der Bedürfnisse vor Ort, um effektive Hilfe zu leisten.",
      duration: 35000.0,
      cost: [Wisdom(value: 800.0), Money(value: 50000.0)],
      award: [Wisdom(value: 300.0)],
      modifier: [
        AddTask(task: "Großprojekt Wasserversorgung"),
        RemoveTask(task: "Machbarkeitsstudie Hilfsprojekt"),
      ],
    ),
    Task(
      name: "Großprojekt Wasserversorgung",
      description: "SYSTEM: Nachhaltige Hilfe für ganze Regionen schafft massives Ansehen und lässt die "
          "Bewegung äußerlich enorm wachsen - wie bei der Heilsarmee ist es viel einfacher, ein weiteres "
          "Hilfsprojekt zu betreiben, als sich wirklich auf das Geistliche zu konzentrieren. Die Zeit und "
          "Energie, die hier hineinfließen, fehlen anderswo - der Glaube wächst kaum noch mit.",
      duration: 50000.0,
      cost: [Money(value: 1000000.0), Member(value: 1000.0), Time(value: 15.0)],
      award: [Publicity(value: 4000.0), Faith(value: 50.0), Member(value: 1.0)],
      modifier: [
        AddTask(task: "Machbarkeitsstudie Hilfsprojekt"),
      ]
    ),
    Task(
      name: "Rückzug zur Quelle",
      description: "WARTUNG: Bewusst aus dem Betrieb der Hilfsorganisation heraustreten und sich neu an "
          "der eigentlichen Quelle ausrichten - nicht das Trinkwasser der Großprojekte, sondern "
          "\"lebendiges Wasser\" (Johannes 4,14). Kostet Zeit, die sonst ins nächste Projekt fließen "
          "würde, aber ohne diese Rückbindung trägt die ganze Organisation irgendwann nicht mehr.",
      duration: 20000.0,
      cost: [Time(value: 8.0)],
      award: [Faith(value: 400.0)],
    ),
    Task(
      name: "Internationales Hilfswerk gründen",
      description: "MEILENSTEIN: Gründung einer eigenen NGO zur Skalierung der Hilfe (Limit 1.500.000).",
      duration: 100000.0,
      isMilestone: true,
      cost: [Money(value: 7000000.0), Wisdom(value: 10000.0), Publicity(value: 5000.0)],
      award: [Member(value: 1.0)],
      modifier: [
        MessageModifier(message: "NGO: Dein Hilfswerk ist nun eine anerkannte globale Macht. Limit 1.500.000!"),
        SetMax(ressource: "Member", newMax: 1500000.0),
        RemoveTask(task: "Internationales Hilfswerk gründen"),
        AddTask(task: "Hilfswerk operativ leiten"),
      ],
    ),
    Task(
      name: "Hilfswerk operativ leiten",
      description: "WARTUNG: Tägliches Management der globalen NGO-Strukturen.",
      duration: 45000.0,
      cost: [Time(value: 4.0), Money(value: 5000.0)],
      award: [Publicity(value: 500.0), Wisdom(value: 500.0)],
    ),
    Task(
      name: "Humanitäre Krise",
      description: "KRISE: Eine Katastrophe erfordert sofortige Mobilisierung deiner NGO - die Krise nimmt "
          "dich mit Beschlag und lässt kaum Raum für etwas anderes.",
      duration: 20000.0,
      timeToSolve: 60000.0,
      cost: [Money(value: 100000.0), Member(value: 2000.0), Time(value: 10.0)],
      award: [Publicity(value: 5000.0), Faith(value: 1000.0)],
      modifier: [
        MessageModifier(message: "HELDENHAFT: Deine Bewegung war zuerst vor Ort. Das Vertrauen wächst."),
        RemoveTask(task: "Humanitäre Krise"),
      ],
      missed: [
        SubtractRes(ressources: [Publicity(value: 20000.0), Faith(value: 5000.0)]),
        MessageModifier(message: "KASKADE: Mangelnde Reaktion führt zu einem logistischen Chaos!"),
        RemoveTask(task: "Humanitäre Krise"),
        AddTask(task: "Logistisches Chaos (Krise)"),
      ],
    ),
    Task(
      name: "Logistisches Chaos (Krise)",
      description: "FOLGE-KRISE: Repariere die unterbrochenen Versorgungsketten deiner NGO.",
      duration: 30000.0,
      timeToSolve: 50000.0,
      cost: [Wisdom(value: 2000.0), Money(value: 200000.0)],
      modifier: [
        MessageModifier(message: "GELÖST: Die Versorgungsketten funktionieren wieder."),
        RemoveTask(task: "Logistisches Chaos (Krise)"),
      ],
      missed: [
        SubtractRes(ressources: [Money(value: 500000.0), Publicity(value: 10000.0)]),
        RemoveTask(task: "Logistisches Chaos (Krise)"),
        AddTask(task: "Logistisches Chaos (Krise)"),
      ],
    ),
  ],
);
