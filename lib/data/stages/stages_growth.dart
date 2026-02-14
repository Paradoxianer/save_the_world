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
  // STAGE 4: Kleine Gemeinde (200 Mitglieder) - Die Pastoral-Barriere
  Stage(
    level: 4,
    member: 200,
    description: "Kleine Gemeinde - Du kannst nicht mehr alles alleine machen. Es braucht Leiter.",
    activeTasks: ["Bibellesen", "Beten", "Schlafen", "Gottesdienst halten", "Geistesgaben entdecken"],
    randomTasks: ["Streit in der Gemeinde", "Kassendifferenz finden", "Rechnung nicht bezahlt"],
    allTasks: [
      Task(
        name: "Aufgaben verteilen",
        description: "Setze Menschen nach ihren Stärken ein. Delegation ist der Schlüssel zum Wachstum.",
        duration: 6000.0,
        cost: [Time(value: 6.0), Wisdom(value: 50.0)],
        award: [Faith(value: 10.0), Wisdom(value: 10.0)],
        modifier: [
          AddTask(task: "Ehrenamtliche Leiter einsetzen"),
          MessageModifier(message: "Gute Delegation! Deine Last wird leichter, wenn du Verantwortung teilst."),
        ],
      ),
      Task(
        name: "Ehrenamtliche Leiter einsetzen",
        description: "Befähige andere, Verantwortung für Teilbereiche zu übernehmen.",
        duration: 10000.0,
        cost: [Member(value: 10.0), Time(value: 12.0), Wisdom(value: 100.0)],
        award: [Wisdom(value: 50.0), Faith(value: 20.0)],
        modifier: [
          AddTask(task: "Kleingruppenverantwortlichen einsetzen"),
          MessageModifier(message: "Wachstum braucht Struktur. Deine Leiter begleiten nun die ersten Kleingruppen eigenständig."),
        ],
      ),
      Task(
        name: "FSJler einsetzen",
        description: "Junge Menschen investieren ein Jahr in den Dienst. Hilfe bei praktischen Aufgaben.",
        duration: 8000.0,
        cost: [Money(value: 300.0), Time(value: 4.0)],
        award: [Member(value: 1.0), Wisdom(value: 5.0)],
        modifier: [
          MessageModifier(message: "Frischer Wind! Dein FSJler entlastet dich bei der täglichen Korrespondenz."),
        ],
      ),
      // ... Standard-Tasks aus vorherigen Stages ...
    ],
  ),
  // Weitere Stages 5-10 folgen hier...
];
