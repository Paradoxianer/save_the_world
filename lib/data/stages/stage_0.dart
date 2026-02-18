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
      description: "Zeit investieren, um 'Glauben' zu stärken.",
      duration: 3000.0,
      cost: [Time(value: 1.0)],
      award: [Faith(value: 15.0)],
      modifier: [
        AddTask(task: "Beten"),
      ],
    ),
    Task(
      name: "Beten",
      description: "Wandelt 'Glauben' in erste 'Mitglieder' um.",
      duration: 4000.0,
      cost: [Time(value: 1.0), Faith(value: 5.0)],
      award: [Member(value: 0.5)], 
      modifier: [
        AddTask(task: "Hausbesuch"),
      ],
    ),
    // TUTORIAL VERSION of House Visit
    Task(
      name: "Hausbesuch",
      description: "Zeitaufwendig, aber bringt viele neue Mitglieder.",
      duration: 6000.0,
      cost: [Time(value: 3.0)],
      award: [Member(value: 1.0)], 
      modifier: [
        AddTask(task: "Essen in meiner Wohnung"),
        MessageModifier(message: "TUTORIAL: Durch deine Besuche sind Leute bereit, zu dir nach Hause zu kommen!"),
      ],
    ),
    // STANDARD VERSION of House Visit (added after Tutorial)
    Task(
      name: "Hausbesuch (Routine)",
      description: "Regelmäßige Besuche bei Gemeindegliedern zur Seelsorge.",
      duration: 6000.0,
      cost: [Time(value: 3.0)],
      award: [Member(value: 0.75)], // Etwas effizienter, da Routine
    ),
    Task(
      name: "Schlafen",
      description: "Regeneriert 'Zeit'.",
      duration: 8000.0,
      cost: [Time(value: 8.0)],
      award: [Time(value: 16.0)],
    ),
    Task(
      name: "Essen in meiner Wohnung",
      description: "MEILENSTEIN: Erhöht deine maximale Mitglieder-Kapazität auf 40.",
      duration: 10000.0,
      isMilestone: true,
      cost: [Time(value: 4.0), Member(value: 5.0)],
      award: [Member(value: 10.0)],
      modifier: [
        MessageModifier(message: "GLÜCKWUNSCH: Du hast das Limit erhöht! Dein neues Maximum liegt nun bei 40 Mitgliedern."),
        SetMin(ressource: "Member", newMin: 1.0), 
        SetMax(ressource: "Member", newMax: 40.0),
        RemoveTask(task: "Essen in meiner Wohnung"),
        RemoveTask(task: "Hausbesuch"), // Remove the Tutorial-Trigger version
        AddTask(task: "Hausbesuch (Routine)"), // Add the clean version
        AddTask(task: "Gastfreundschaft leben"),
      ],
    ),
    Task(
      name: "Gastfreundschaft leben",
      description: "Gemeinschaft stärken und neue Leute einladen.",
      duration: 10000.0,
      cost: [Time(value: 4.0), Faith(value: 5.0)],
      award: [Member(value: 1.0)],
    ),
  ],
);
