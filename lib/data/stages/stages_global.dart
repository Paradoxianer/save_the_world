import 'package:save_the_world_flutter_app/models/addtask.model.dart';
import 'package:save_the_world_flutter_app/models/faith.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/member.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/message.modifier.dart';
import 'package:save_the_world_flutter_app/models/money.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/publicity.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/stage.model.dart';
import 'package:save_the_world_flutter_app/models/task.model.dart';
import 'package:save_the_world_flutter_app/models/time.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/wisdome.ressource.model.dart';

final List<Stage> globalStages = [
  // STAGE 21: Globale Größe (2.500.000+ Mitglieder) - Fokus: Strategische Vision
  Stage(
    level: 21,
    member: 5000000,
    description: "Globale Größe - Die Armee wirkt nun auf Kontinenten. Deine Strategie ist entscheidend.",
    activeTasks: ["Vision-Casting", "Regionale Leiter-Akademie", "Eigene Fernsehsendung"],
    randomTasks: ["Internationale Krise", "Währungsverfall"],
    allTasks: [
      Task(
        name: "Globale Strategie-Konferenz",
        description: "Versammle die Leiter aller Kontinente, um die Weltrettung zu koordinieren.",
        duration: 40000.0,
        cost: [
          Money(value: 200000.0),
          Time(value: 30.0),
          Wisdom(value: 5000.0),
        ],
        award: [
          Faith(value: 1000.0),
          Wisdom(value: 2000.0),
        ],
        modifier: [
          AddTask(task: "Weltweite Hilfsaktion"),
          MessageModifier(message: "Einheit in der Armee! Die globale Strategie steht. Jetzt können wir weltweit koordiniert helfen."),
        ],
      ),
    ],
  ),

  // STAGE 25: Globaler Beeinflusser (20.000.000+ Mitglieder)
  Stage(
    level: 25,
    member: 40000000,
    description: "Globaler Beeinflusser - Die Heilsarmee ist eine moralische Instanz auf der Weltbühne.",
    activeTasks: ["Globale Strategie-Konferenz", "Eigene Fernsehsendung"],
    randomTasks: ["Politische Verfolgung", "Diplomatischer Erfolg"],
    allTasks: [
      Task(
        name: "Weltweite Hilfsaktion",
        description: "Reagiere auf globale Katastrophen mit der vollen Kapazität der Armee.",
        duration: 50000.0,
        cost: [
          Money(value: 500000.0),
          Faith(value: 5000.0),
          Member(value: 10000.0),
        ],
        award: [
          Publicity(value: 10000.0),
          Member(value: 50000.0),
        ],
        modifier: [
          MessageModifier(message: "Gott sei Dank! Durch die weltweite Aktion konnten Millionen gerettet werden. Dein Einfluss wächst stetig."),
        ],
      ),
    ],
  ),

  // STAGE 30: Weltkirche (1.280.000.000+ Mitglieder)
  Stage(
    level: 30,
    member: 2560000000,
    description: "Weltkirche - Das Evangelium erreicht fast jeden Winkel der Erde.",
    activeTasks: ["Weltweite Hilfsaktion", "Vision-Casting"],
    randomTasks: ["Geistlicher Aufbruch", "Letzte Widerstände"],
    allTasks: [
      Task(
        name: "Globale Jüngerschafts-Plattform",
        description: "Nutze modernste Technologie, um Milliarden von Menschen geistlich zu begleiten.",
        duration: 60000.0,
        cost: [
          Money(value: 1000000.0),
          Wisdom(value: 10000.0),
          Time(value: 10.0),
        ],
        award: [
          Member(value: 1000000.0),
          Faith(value: 5000.0),
        ],
        modifier: [
          AddTask(task: "Die Welt retten"),
          MessageModifier(message: "Multiplikation im Milliarden-Bereich! Jüngerschaft ist nun für jeden Menschen auf der Welt zugänglich."),
        ],
      ),
    ],
  ),

  // STAGE 32: Finale (7.600.000.000 Mitglieder)
  Stage(
    level: 32,
    member: 7600000000,
    description: "Du hast die Welt gerettet - Jesus kommt wieder - YEAH!",
    activeTasks: ["Die Welt retten"],
    randomTasks: [],
    allTasks: [
      Task(
        name: "Die Welt retten",
        description: "Die letzte große Anstrengung, um Jüngerschaft für alle Menschen zu vollenden.",
        duration: 100000.0,
        cost: [
          Faith(value: 10000.0),
          Wisdom(value: 20000.0),
          Member(value: 5000000.0),
        ],
        award: [
          Faith(value: 1000000.0),
        ],
        modifier: [
          MessageModifier(message: "Es ist vollbracht! Die Welt ist bereit. YEAH!"),
        ],
      ),
    ],
  ),
];
