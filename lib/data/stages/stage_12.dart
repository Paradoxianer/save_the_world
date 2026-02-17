import 'package:save_the_world_flutter_app/data/stages/common_tasks.dart';
import 'package:save_the_world_flutter_app/models/addtask.model.dart';
import 'package:save_the_world_flutter_app/models/autoexecute.model.dart';
import 'package:save_the_world_flutter_app/models/faith.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/member.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/message.modifier.dart';
import 'package:save_the_world_flutter_app/models/money.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/multiplyres.model.dart';
import 'package:save_the_world_flutter_app/models/publicity.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/removetask.model.dart';
import 'package:save_the_world_flutter_app/models/stage.model.dart';
import 'package:save_the_world_flutter_app/models/setmax.model.dart';
import 'package:save_the_world_flutter_app/models/subtractres.model.dart';
import 'package:save_the_world_flutter_app/models/task.model.dart';
import 'package:save_the_world_flutter_app/models/time.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/wisdome.ressource.model.dart';

final Stage stage12 = Stage(
  level: 12,
  member: 10000,
  description: "Beeinflussende Kirche Lvl. 2 - Dein Wirken prägt das Land.",
  activeTasks: [
    "Schlafen",
    "Konferenz-Netzwerk pflegen",
    "Strategische Allianzen bilden",
    "Leiter-Akademie gründen"
  ],
  randomTasks: ["Medien-Skandal", "Politischer Druck", "Der Heilige Geist möchte wirken"],
  allTasks: [
    baseSleep,
    holySpiritWorking,
    Task(
      name: "Konferenz-Netzwerk pflegen",
      description: "WARTUNG: Unterstützung der regionalen Partner.",
      duration: 20000.0,
      cost: [Time(value: 2.0), Wisdom(value: 100.0)],
      award: [Faith(value: 50.0), Publicity(value: 50.0)],
    ),
    Task(
      name: "Strategische Allianzen bilden",
      description: "BEFÄHIGUNG: Vernetzung mit anderen Organisationen bereitet das 'Nationale Gebetstreffen' vor.",
      duration: 30000.0,
      cost: [Money(value: 20000.0), Wisdom(value: 500.0), Publicity(value: 300.0)],
      award: [Wisdom(value: 200.0)],
      modifier: [
        MessageModifier(message: "ALLIANZ: Die Partner sind bereit. Schaltet 'Nationales Gebetstreffen' frei."),
        AddTask(task: "Nationales Gebetstreffen"),
        RemoveTask(task: "Strategische Allianzen bilden"),
      ],
    ),
    Task(
      name: "Leiter-Akademie gründen",
      description: "SYSTEM: Eine Akademie zur Ausbildung hochkarätiger Führungskräfte.",
      duration: 40000.0,
      cost: [Money(value: 80000.0), Wisdom(value: 1000.0)],
      modifier: [
        MessageModifier(message: "MULTIPLIKATION: Die Akademie generiert nun passiv Weisheit."),
        AutoExecuteModifier(
            intervalMs: 20000,
            modifiers: [
              MultiplyRes(targetResName: "Wisdom", factorResName: "Member", multiplier: 0.02),
            ]),
        RemoveTask(task: "Leiter-Akademie gründen"),
      ],
    ),
    Task(
      name: "Nationales Gebetstreffen",
      description: "MEILENSTEIN: Ein Tag des Gebets, der das ganze Land mobilisiert (Limit 20.000).",
      duration: 60000.0,
      isMilestone: true,
      cost: [Money(value: 100000.0), Faith(value: 5000.0), Wisdom(value: 2000.0), Publicity(value: 1000.0)],
      award: [Member(value: 1.0)],
      modifier: [
        SetMax(ressource: "Member", newMax: 20000.0),
        MessageModifier(message: "DURCHBRUCH: Ein nationales Zeichen! Limit auf 20.000 erhöht."),
        RemoveTask(task: "Nationales Gebetstreffen"),
        AddTask(task: "Geistliche nationale Erneuerung"),
      ],
    ),
    Task(
      name: "Geistliche nationale Erneuerung",
      description: "WARTUNG: Begleitung der nationalen Bewegung.",
      duration: 25000.0,
      cost: [Time(value: 4.0), Wisdom(value: 200.0)],
      award: [Faith(value: 100.0), Publicity(value: 100.0)],
    ),
    Task(
      name: "Politischer Druck",
      description: "KRISE: Neue Gesetze erschweren die Arbeit. Diplomatische Weisheit ist gefragt.",
      duration: 12000.0,
      timeToSolve: 50000.0,
      cost: [Wisdom(value: 800.0), Publicity(value: 500.0)],
      award: [Wisdom(value: 200.0)],
      missed: [
        SubtractRes(ressources: [Money(value: 10000.0), Publicity(value: 1000.0)]),
        MessageModifier(message: "REPRESSION: Juristische Folgen kosten Geld und Ansehen."),
        AddTask(task: "Politischer Druck"),
      ],
    ),
    Task(
      name: "Medien-Skandal",
      description: "KRISE: Schnelle Reaktion auf globale Fehlmeldungen.",
      duration: 8000.0,
      timeToSolve: 30000.0,
      cost: [Wisdom(value: 600.0), Publicity(value: 2000.0)],
      award: [Wisdom(value: 100.0)],
      missed: [
        SubtractRes(ressources: [Publicity(value: 5000.0), Faith(value: 1000.0)]),
        AddTask(task: "Medien-Skandal"),
      ],
    ),
  ],
);
