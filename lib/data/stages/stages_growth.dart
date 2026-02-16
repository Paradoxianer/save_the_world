import 'package:save_the_world_flutter_app/models/addtask.model.dart';
import 'package:save_the_world_flutter_app/models/faith.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/member.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/message.modifier.dart';
import 'package:save_the_world_flutter_app/models/modifier.model.dart';
import 'package:save_the_world_flutter_app/models/money.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/multiplyres.model.dart';
import 'package:save_the_world_flutter_app/models/publicity.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/removetask.model.dart';
import 'package:save_the_world_flutter_app/models/ressource.model.dart';
import 'package:save_the_world_flutter_app/models/stage.model.dart';
import 'package:save_the_world_flutter_app/models/setmax.model.dart';
import 'package:save_the_world_flutter_app/models/task.model.dart';
import 'package:save_the_world_flutter_app/models/time.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/wisdome.ressource.model.dart';

// REUSABLE BASE TASKS FOR GROWTH PHASE
final _growthSleep = Task(
  name: "Schlafen",
  description: "Erholung ist wichtig für einen Leiter.",
  duration: 8000.0,
  cost: [Time(value: 8.0)],
  award: [Time(value: 16.0)],
);

final _growthBible = Task(
  name: "Bibellesen",
  description: "Tiefe spirituelle Nahrung für die Gemeindeleitung.",
  duration: 3000.0,
  cost: [Time(value: 1.0)],
  award: [Faith(value: 20.0), Wisdom(value: 5.0)],
);

final List<Stage> growthStages = [
  // STAGE 4: Mittelgroße Gemeinde (Max 200) - Fokus: Jüngerschaft & Mentoring
  Stage(
    level: 4,
    member: 200,
    description: "Mittelgroße Gemeinde - Wahres Wachstum geschieht durch Befähigung.",
    activeTasks: ["Bibellesen", "Schlafen", "Kollekte", "Mentoring"],
    randomTasks: ["Ein zwischenmenschliches Problem klären", "Streit in der Gemeinde"],
    allTasks: [
      _growthBible,
      _growthSleep,
      Task(
        name: "Kollekte",
        duration: 3000.0,
        cost: [Time(value: 1.0)],
        modifier: [MultiplyRes(targetResName: "Money", factorResName: "Member", multiplier: 1.0)],
      ),
      Task(
        name: "Mentoring",
        description: "Investiere in potenzielle Leiter.",
        duration: 8000.0,
        cost: [Time(value: 4.0), Wisdom(value: 20.0)],
        award: [Wisdom(value: 30.0), Faith(value: 10.0)],
        modifier: [AddTask(task: "Leiter-Training")],
      ),
      Task(
        name: "Ein zwischenmenschliches Problem klären",
        description: "Konflikte kosten Zeit, bringen aber Reife.",
        duration: 6000.0,
        cost: [Time(value: 3.0), Wisdom(value: 10.0)],
        award: [Wisdom(value: 15.0), Member(value: 0.5)],
      ),
      Task(
        name: "Leiter-Training",
        description: "MEILENSTEIN: Schult Leiter, die selbst führen (Limit 400).",
        duration: 15000.0,
        cost: [Time(value: 8.0), Wisdom(value: 100.0), Member(value: 50.0)],
        award: [Wisdom(value: 50.0)],
        modifier: [
          MessageModifier(message: "Befähigung: Deine Leiter übernehmen Verantwortung. Limit steigt auf 400!"),
          SetMax(ressource: "Member", newMax: 400.0),
        ],
      ),
    ],
  ),

  // STAGE 5: Große Gemeinde (Max 400) - Fokus: Spezialisierung
  Stage(
    level: 5,
    member: 400,
    description: "Große Gemeinde - Die Struktur wird professioneller.",
    activeTasks: ["Bibellesen", "Schlafen", "Kollekte", "Seelsorge"],
    allTasks: [
      _growthBible,
      _growthSleep,
      Task(
        name: "Kollekte",
        duration: 3000.0,
        cost: [Time(value: 1.0)],
        modifier: [MultiplyRes(targetResName: "Money", factorResName: "Member", multiplier: 1.2)],
      ),
      Task(
        name: "Seelsorge",
        description: "Begleitung in schweren Zeiten (aus oldstages).",
        duration: 5000.0,
        cost: [Time(value: 2.0), Wisdom(value: 10.0)],
        award: [Wisdom(value: 20.0), Member(value: 1.0)],
      ),
      Task(
        name: "Gottesdienst-Teams bilden",
        description: "MEILENSTEIN: Qualität durch Spezialisierung (Limit 600).",
        duration: 18000.0,
        cost: [Time(value: 10.0), Money(value: 500.0), Member(value: 100.0)],
        award: [Publicity(value: 20.0)],
        modifier: [
          MessageModifier(message: "Struktur: Musik, Technik und Empfang sind nun Teams. Limit steigt auf 600!"),
          SetMax(ressource: "Member", newMax: 600.0),
        ],
      ),
    ],
  ),

  // STAGE 6: Sehr große Gemeinde (Max 600) - Fokus: Außenwirkung
  Stage(
    level: 6,
    member: 600,
    description: "Sehr große Gemeinde - Relevanz in der Stadt.",
    activeTasks: ["Bibellesen", "Kollekte", "Stadtmission"],
    allTasks: [
      _growthBible,
      _growthSleep,
      Task(
        name: "Kollekte",
        duration: 3000.0,
        cost: [Time(value: 1.0)],
        modifier: [MultiplyRes(targetResName: "Money", factorResName: "Member", multiplier: 1.5)],
      ),
      Task(
        name: "Stadtmission",
        description: "Präsenz zeigen und Gutes tun (oldstages: Wirtschaftsmission).",
        duration: 8000.0,
        cost: [Time(value: 5.0), Money(value: 200.0)],
        award: [Publicity(value: 30.0), Member(value: 10.0)],
      ),
      Task(
        name: "Hauptamtliche einstellen",
        description: "MEILENSTEIN: Erste Vollzeitkräfte für die Arbeit (Limit 800).",
        duration: 25000.0,
        cost: [Money(value: 2000.0), Wisdom(value: 200.0), Member(value: 150.0)],
        award: [Wisdom(value: 100.0)],
        modifier: [
          MessageModifier(message: "Professionalität: Die ersten Pastoren/Mitarbeiter sind angestellt. Limit steigt auf 800!"),
          SetMax(ressource: "Member", newMax: 800.0),
        ],
      ),
    ],
  ),

  // STAGE 7-10 folgen im nächsten Schritt...
];
