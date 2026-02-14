import 'package:save_the_world_flutter_app/models/addres.model.dart';
import 'package:save_the_world_flutter_app/models/addtask.model.dart';
import 'package:save_the_world_flutter_app/models/faith.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/member.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/message.modifier.dart';
import 'package:save_the_world_flutter_app/models/modifier.model.dart';
import 'package:save_the_world_flutter_app/models/money.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/publicity.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/removetask.model.dart';
import 'package:save_the_world_flutter_app/models/ressource.model.dart';
import 'package:save_the_world_flutter_app/models/setmax.model.dart';
import 'package:save_the_world_flutter_app/models/stage.model.dart';
import 'package:save_the_world_flutter_app/models/subtractres.model.dart';
import 'package:save_the_world_flutter_app/models/task.model.dart';
import 'package:save_the_world_flutter_app/models/time.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/wisdome.ressource.model.dart';

final List<Stage> growthStages = [
  // STAGE 4: Kleine Gemeinde (200 Mitglieder) - Fokus: Jüngerschaft & Mentoring
  Stage(
    level: 4,
    member: 200,
    description: "Kleine Gemeinde - Wahres Wachstum geschieht durch die Befähigung der Einzelnen.",
    activeTasks: ["Bibellesen", "Beten", "Schlafen", "Gottesdienst halten", "Geistesgaben entdecken"],
    randomTasks: ["Streit in der Gemeinde", "Mitarbeiter-Burnout"],
    allTasks: [
      Task(
        name: "1-zu-1 Mentoring",
        description: "Investiere tief in eine Person. Jüngerschaft ist Beziehungsarbeit.",
        duration: 12000.0,
        cost: [Time(value: 6.0), Wisdom(value: 20.0), Faith(value: 10.0)],
        award: [Wisdom(value: 50.0), Faith(value: 20.0)],
        modifier: [
          AddTask(task: "Aufgaben abgeben"),
          MessageModifier(message: "Tiefe Jüngerschaft! Durch dein Mentoring wächst ein neuer Leiter heran, der bald Lasten mittragen kann."),
        ],
      ),
      Task(
        name: "Aufgaben abgeben",
        description: "Vertraue deinen Jüngern praktische Aufgaben an. Schafft Freiraum für das Gebet.",
        duration: 5000.0,
        cost: [Time(value: 2.0), Wisdom(value: 100.0)],
        award: [Time(value: 4.0)],
        modifier: [
          MessageModifier(message: "Befreiend! Indem du Aufgaben abgibst, handelst du nach biblischem Vorbild und gewinnst Zeit für das Wesentliche."),
        ],
      ),
      Task(
        name: "Ehrenamtliche Leiter schulen",
        description: "Befähige deine Leiter, selbst wieder Jünger zu machen (Multiplikation).",
        duration: 15000.0,
        cost: [Time(value: 10.0), Wisdom(value: 300.0), Faith(value: 100.0)],
        award: [Member(value: 5.0), Wisdom(value: 100.0)],
        modifier: [
          AddTask(task: "Pionier-Team aussenden"),
          MessageModifier(message: "Multiplikations-Effekt: Deine Leiter fangen an, eigenständig Jüngerschaftskreise zu leiten."),
        ],
      ),
    ],
  ),

  // STAGE 5: Mittelgroße Gemeinde (400)
  Stage(
    level: 5,
    member: 400,
    description: "Mittelgroße Gemeinde - Die Struktur muss sich festigen. Multiplikation beginnt.",
    activeTasks: ["Bibellesen", "Beten", "Schlafen", "Ehrenamtliche Leiter schulen"],
    allTasks: [
      Task(
        name: "Kleingruppen-Mentoring",
        description: "Begleite deine Leiter in ihrer Arbeit mit den Gruppen.",
        duration: 15000.0,
        cost: [Time(value: 10.0), Wisdom(value: 200.0), Faith(value: 100.0)],
        award: [Wisdom(value: 150.0), Faith(value: 50.0)],
      ),
    ],
  ),

  // STAGE 6: Große Gemeinde (600)
  Stage(
    level: 6,
    member: 600,
    description: "Große Gemeinde - Professionalität wird wichtig.",
    activeTasks: ["Bibellesen", "Schlafen", "Gottesdienst halten", "Einsatzwagen raus"],
    allTasks: [
      Task(
        name: "PR-Manager einstellen",
        description: "Ein Profi kümmert sich um die Außendarstellung.",
        duration: 20000.0,
        cost: [Money(value: 1500.0), Wisdom(value: 100.0)],
        award: [Publicity(value: 100.0)],
      ),
    ],
  ),

  // STAGE 7: Sehr große Gemeinde (800)
  Stage(
    level: 7,
    member: 800,
    description: "Sehr große Gemeinde - Die Stadt nimmt dich wahr.",
    activeTasks: ["Bibellesen", "Schlafen", "PR-Manager einstellen"],
    allTasks: [],
  ),

  // STAGE 8: Fast eine MegaChurch (1100)
  Stage(
    level: 8,
    member: 1100,
    description: "Fast eine MegaChurch - Die Dynamik ändert sich.",
    activeTasks: ["Bibellesen", "Schlafen", "Kleingruppen-Mentoring"],
    allTasks: [],
  ),

  // STAGE 9: MegaChurch Level 1 (1800)
  Stage(
    level: 9,
    member: 1800,
    description: "MegaChurch Level 1 - Eine neue Dimension der Verantwortung.",
    activeTasks: ["Vision-Casting", "Bibellesen", "Schlafen"],
    allTasks: [],
  ),

  // STAGE 10: MegaChurch Level 2 (2800)
  Stage(
    level: 10,
    member: 2800,
    description: "MegaChurch Level 2 - Multiplikation als Lebensstil.",
    activeTasks: ["Bibellesen", "Beten", "Schlafen", "Pionier-Team aussenden"],
    randomTasks: ["Struktur-Krise"],
    allTasks: [
      Task(
        name: "Vision-Casting",
        description: "Wo soll die Reise hingehen? Begeistere deine Leiter.",
        duration: 25000.0,
        cost: [Time(value: 20.0), Faith(value: 500.0)],
        award: [Faith(value: 300.0), Publicity(value: 50.0)],
      ),
    ],
  ),
];
