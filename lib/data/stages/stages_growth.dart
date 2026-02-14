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
        award: [Time(value: 4.0)], // Einzige Aufgabe, die Zeit "generiert" durch Entlastung
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

  // STAGE 5: Mittelgroße Gemeinde (400 Mitglieder) - Fokus: Leiter von Leitern
  Stage(
    level: 5,
    member: 400,
    description: "Mittelgroße Gemeinde - Die Struktur muss sich festigen. Multiplikation beginnt.",
    activeTasks: ["Bibellesen", "Beten", "Schlafen", "Gottesdienst halten", "Ehrenamtliche Leiter schulen"],
    randomTasks: ["Streit in der Gemeinde", "Mitarbeiter-Burnout"],
    allTasks: [
      Task(
        name: "Kleingruppen-Mentoring",
        description: "Begleite deine Leiter in ihrer Arbeit mit den Gruppen.",
        duration: 15000.0,
        cost: [Time(value: 10.0), Wisdom(value: 200.0), Faith(value: 100.0)],
        award: [Wisdom(value: 150.0), Faith(value: 50.0)],
        modifier: [
          MessageModifier(message: "Deine Leiter werden zu geistlichen Vätern und Müttern. Die Gemeinde ruht auf vielen Schultern."),
        ],
      ),
      Task(
        name: "Geistesgaben-Workshop",
        description: "Hilf der Gemeinde, ihre Berufung zu finden und zu leben.",
        duration: 12000.0,
        cost: [Time(value: 8.0), Wisdom(value: 150.0)],
        award: [Member(value: 5.0), Wisdom(value: 100.0)],
        modifier: [
          AddTask(task: "Leiter-Konferenz"),
          MessageModifier(message: "Ein Leib, viele Glieder! Die Menschen blühen in ihren Gaben auf."),
        ],
      ),
      Task(
        name: "Pionier-Team aussenden",
        description: "Sende eine kleine Gruppe aus, um an einem neuen Ort Dienst zu tun.",
        duration: 30000.0,
        cost: [Member(value: 10.0), Faith(value: 500.0), Money(value: 1000.0)],
        award: [Publicity(value: 50.0), Wisdom(value: 200.0)],
        modifier: [
          MessageModifier(message: "Mutig! Dein Pionier-Team trägt die Heilsarmee-DNA an neue Orte."),
        ],
      ),
    ],
  ),

  // STAGE 10: Delegations-Schwelle (2.800 Mitglieder)
  Stage(
    level: 10,
    member: 2800,
    description: "MegaChurch - Multiplikation als Lebensstil.",
    activeTasks: ["Bibellesen", "Beten", "Schlafen", "Kleingruppen-Mentoring", "Pionier-Team aussenden"],
    randomTasks: ["Struktur-Krise", "Leitungsvakuum"],
    allTasks: [
      Task(
        name: "Leiter-Konferenz",
        description: "Ein Wochenende zur Stärkung und Neuausrichtung aller Verantwortlichen.",
        duration: 40000.0,
        cost: [Money(value: 5000.0), Time(value: 40.0), Faith(value: 1000.0)],
        award: [Wisdom(value: 500.0), Faith(value: 500.0)],
        modifier: [
          MessageModifier(message: "Einheit in der Vision! Deine Leiter sind neu inspiriert für die nächste Phase der Armee."),
        ],
      ),
      Task(
        name: "Internationale Mission",
        description: "Unterstütze Projekte weltweit und lerne von der globalen Armee.",
        duration: 50000.0,
        cost: [Money(value: 10000.0), Time(value: 20.0), Faith(value: 2000.0)],
        award: [Publicity(value: 500.0), Wisdom(value: 1000.0), Member(value: 50.0)],
        modifier: [
          MessageModifier(message: "Globaler Einfluss! Die Weltrettung nimmt Fahrt auf."),
        ],
      ),
    ],
  ),
];
