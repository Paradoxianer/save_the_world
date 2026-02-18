import 'package:save_the_world_flutter_app/models/addtask.model.dart';
import 'package:save_the_world_flutter_app/models/faith.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/member.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/message.modifier.dart';
import 'package:save_the_world_flutter_app/models/removetask.model.dart';
import 'package:save_the_world_flutter_app/models/stage.model.dart';
import 'package:save_the_world_flutter_app/models/setmax.model.dart';
import 'package:save_the_world_flutter_app/models/setmin.model.dart';
import 'package:save_the_world_flutter_app/models/task.model.dart';
import 'package:save_the_world_flutter_app/models/time.ressource.model.dart';

final Stage stage0 = Stage(
  level: 0,
  member: 20,
  description: "Hausgemeinde - Lerne die Grundlagen der Ressourcenverwaltung.",
  activeTasks: ["Bibellesen", "Schlafen"],
  allTasks: [
    Task(
      name: "Bibellesen",
      description: "Zeit investieren, um 'Glauben' zu stärken - Deine Ressource Glauben zu erhöhen.",
      duration: 3000.0,
      cost: [Time(value: 1.0)],
      award: [Faith(value: 15.0)],
      modifier: [
        AddTask(task: "Beten"),
        MessageModifier(message: "BASICS: Aufgaben kosten links angezeigte Ressourcen (hier 1x Zeit) und bringen rechts Belohnungen (hier Glauben)."),
      ],
    ),
    Task(
      name: "Beten",
      description: "Wandelt 'Glauben' in erste 'Mitglieder' um.",
      duration: 4000.0,
      cost: [Time(value: 1.0), Faith(value: 5.0)],
      award: [Member(value: 0.5)], // Reduziert von 1.0
      modifier: [
        AddTask(task: "Mein erster Hausbesuch"),
        MessageModifier(message: "ACHTUNG: 'Beten' benötigt Zeit UND Glauben. Hast du von einer Ressource zu wenig, wird die Karte blass und lässt sich nicht starten!"),
      ],
    ),
    Task(
      name: "Mein erster Hausbesuch",
      description: "Zeitaufwendig, aber bringt leute näher zu Gott.",
      duration: 6000.0,
      cost: [Time(value: 3.0)],
      award: [Member(value: 0.75)], // Reduziert von 2.0
      modifier: [
        AddTask(task: "Essen in meiner Wohnung"),
        AddTask(task: "Hausbesuch"),
        RemoveTask(task: "Mein erster Hausbesuch"),
        MessageModifier(message: "STRATEGIE: Manche Aufgaben brauchen viel Zeit. Behalte den blauen Zeit-Balken oben im Auge!"),
      ],
    ),
    Task(
      name: "Hausbesuch",
      description: "Regelmäßige Besuche bei Gemeindegliedern zur Seelsorge.",
      duration: 6000.0,
      cost: [Time(value: 3.0)],
      award: [Member(value: 1.1)], // Etwas effizienter, da Routine
    ),
    Task(
      name: "Schlafen",
      description: "Regeneriert 'Zeit'. WICHTIG: Ohne Zeit-Punkte kannst du keine Aufgaben starten!",
      duration: 8000.0,
      cost: [Time(value: 8.0)],
      award: [Time(value: 16.0)],
      modifier: [
        MessageModifier(message: "REGENERATION: Wenn dir die Zeit ausgeht, ist 'Schlafen' deine wichtigste Aufgabe."),
      ],
    ),
    Task(
      name: "Essen in meiner Wohnung",
      description: "MEILENSTEIN: Erhöht deine maximale Mitglieder-Kapazität auf 40.",
      duration: 10000.0,
      cost: [Time(value: 4.0), Member(value: 5.0)],
      award: [Member(value: 10.0)], // Reduziert von 15.0
      modifier: [
        MessageModifier(message: "GLÜCKWUNSCH: Du hast das Limit erhöht! Dein neues Maximum liegt nun bei 40 Mitgliedern. Wenn du über 20 kommst steigst in die Stufe 1 auf."),
        SetMin(ressource: "Member", newMin: 1.0), 
        SetMax(ressource: "Member", newMax: 40.0),
        RemoveTask(task: "Essen in meiner Wohnung"),
        AddTask(task: "Gastfreundschaft leben"),
      ],
    ),
    Task(
      name: "Gastfreundschaft leben",
      description: "Gemeinschaft stärken und neue Leute einladen.",
      duration: 10000.0,
      cost: [Time(value: 4.0), Faith(value: 5.0)],
      award: [Member(value: 2.0)],
    ),
  ],
);
