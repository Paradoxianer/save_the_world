import 'package:save_the_world_flutter_app/data/stages/common_tasks.dart';
import 'package:save_the_world_flutter_app/models/addtask.model.dart';
import 'package:save_the_world_flutter_app/models/AddToRandom.model.dart';
import 'package:save_the_world_flutter_app/models/faith.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/member.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/message.modifier.dart';
import 'package:save_the_world_flutter_app/models/money.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/removetask.model.dart';
import 'package:save_the_world_flutter_app/models/stage.model.dart';
import 'package:save_the_world_flutter_app/models/setmax.model.dart';
import 'package:save_the_world_flutter_app/models/subtractres.model.dart';
import 'package:save_the_world_flutter_app/models/task.model.dart';
import 'package:save_the_world_flutter_app/models/time.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/wisdome.ressource.model.dart';

final Stage stage5 = Stage(
    level: 5,
    member: 400,
    description: "Große Gemeinde - Delegation wird zur Notwendigkeit.",
    activeTasks: ["Bibellesen", "Beten", "Schlafen", "Koordinatoren ausbilden"],
    randomTasks: ["Ein zwischenmenschliches Problem klären", "Verlorene Schafe"],
    allTasks: [
      baseBible,
      basePrayer,
      baseSleep,
      holySpiritWorking,
      Task(
        name: "Koordinatoren ausbilden",
        description: "Fördere Leiter, die wiederum andere fördern.",
        duration: 15000.0,
        cost: [Time(value: 8.0), Wisdom(value: 100.0)],
        award: [Wisdom(value: 120.0)],
        modifier: [
          AddTask(task: "Fasten und Beten"),
          AddTask(task: "Jüngerschaftsgruppen einführen"),
        ],
      ),
      Task(
        name: "Jüngerschaftsgruppen einführen",
        description: "Aus den Hauskreisen werden bewusst multiplizierende Jüngerschaftsgruppen - kleine Kreise, "
            "die gezielt neue Leiter heranbilden, damit bei dieser Größe niemand zur Nummer wird.",
        duration: 12000.0,
        cost: [Time(value: 5.0), Wisdom(value: 20.0)],
        award: [Member(value: 2.0), Faith(value: 15.0)],
      ),
      Task(
        name: "Verlorene Schafe",
        description: "KRISE: Ein Gemeindemitglied fehlt seit Wochen - kaum jemandem ist es aufgefallen. Bei "
            "dieser Größe geht niemand mehr von selbst nach, wenn sich ein Schaf verirrt.",
        duration: 8000.0,
        timeToSolve: 60000.0,
        cost: [Time(value: 5.0), Wisdom(value: 20.0)],
        award: [Faith(value: 10.0)],
        modifier: [
          MessageModifier(
            message: "NACHGEGANGEN: Persönlich gefunden - und Jüngerschaftsgruppen werden jetzt bewusst "
                "gefördert, damit niemand mehr unbemerkt verloren geht.",
          ),
          RemoveTask(task: "Verlorene Schafe"),
          AddTask(task: "Jüngerschaftsgruppen einführen"),
        ],
        missed: [
          MessageModifier(message: "UNBEMERKT: Noch hat es niemand gemerkt - aber die Zeit läuft ihm davon."),
          RemoveTask(task: "Verlorene Schafe"),
          AddTask(task: "Ein Schaf verirrt sich weiter"),
        ],
      ),
      Task(
        name: "Ein Schaf verirrt sich weiter",
        description: "LETZTE CHANCE: Das vermisste Mitglied steht kurz davor, sich ganz abzuwenden. Ein "
            "persönliches, geduldiges Gespräch könnte es noch erreichen.",
        duration: 10000.0,
        timeToSolve: 40000.0,
        cost: [Time(value: 8.0), Faith(value: 20.0)],
        award: [Faith(value: 20.0), Member(value: 0.5)],
        modifier: [
          MessageModifier(
            message: "HEIMGEHOLT: Das verlorene Schaf ist zurück - Jüngerschaftsgruppen werden jetzt bewusst "
                "gefördert, damit so etwas seltener passiert.",
          ),
          RemoveTask(task: "Ein Schaf verirrt sich weiter"),
          AddTask(task: "Jüngerschaftsgruppen einführen"),
        ],
        missed: [
          SubtractRes(ressources: [Member(value: 20.0), Faith(value: 15.0)]),
          MessageModifier(
            message: "VERLOREN: Das Schaf ist gegangen, ohne dass es jemand bemerkt hätte. Andere könnten "
                "unbemerkt folgen.",
          ),
          RemoveTask(task: "Ein Schaf verirrt sich weiter"),
          AddTask(task: "Verlorene Schafe"),
        ],
      ),
      Task(
        name: "Fasten und Beten",
        description: "Bevor ein Offizier berufen wird, sucht die Bewegung im Fasten und Gebet gemeinsam Gottes "
            "Führung für diesen Schritt.",
        duration: 15000.0,
        cost: [Time(value: 10.0)],
        award: [Faith(value: 80.0), Wisdom(value: 20.0)],
        modifier: [
          AddTask(task: "Offizier berufen"),
          // Je mehr Glauben, desto wahrscheinlicher greift Gott sichtbar ein:
          // ab 400 Glauben ist "Der Heilige Geist möchte wirken" pro Roll
          // (alle ~10s) fast garantiert, darunter proportional seltener.
          AddToRandom(
            task: "Der Heilige Geist möchte wirken",
            resourceName: "Faith",
            resourceThreshold: 400.0,
          ),
        ],
      ),
      Task(
        name: "Offizier berufen",
        description: "MEILENSTEIN: Ein hauptamtlicher Offizier für die Seelsorge (Limit 600).",
        duration: 25000.0,
        isMilestone: true,
        cost: [Time(value: 10.0), Money(value: 500.0), Wisdom(value: 200.0)],
        award: [Member(value: 1.0)], // Pacing: Reduziert auf 1.0
        modifier: [
          MessageModifier(message: "PROFESSIONALISIERUNG: Mit einem Offizier seid ihr bereit für die nächste Stufe (Limit 600)."),
          SetMax(ressource: "Member", newMax: 600.0),
          RemoveTask(task: "Offizier berufen"),
          AddTask(task: "Offiziersarbeit koordinieren"),
        ],
      ),
      Task(
        name: "Offiziersarbeit koordinieren",
        description: "WARTUNG: Unterstützung des Offiziers bei der Begleitung der Gemeinde.",
        duration: 20000.0,
        cost: [Time(value: 4.0), Wisdom(value: 100.0)],
        award: [Faith(value: 50.0), Wisdom(value: 50.0)],
      ),
      Task(
        name: "Ein zwischenmenschliches Problem klären",
        description: "KRISE: Ein tiefer gehender Konflikt erfordert deine volle Aufmerksamkeit.",
        duration: 8000.0,
        timeToSolve: 50000.0,
        cost: [Time(value: 4.0), Wisdom(value: 30.0)],
        modifier: [
          MessageModifier(message: "GEKLÄRT: Die Krise wurde durch weise Begleitung beigelegt."),
          RemoveTask(task: "Ein zwischenmenschliches Problem klären"),
        ],
        missed: [
          SubtractRes(ressources: [Member(value: 15.0)]),
          MessageModifier(message: "ESKALIERT: Der ungelöste Konflikt hat zu Austritten geführt."),
          RemoveTask(task: "Ein zwischenmenschliches Problem klären"),
          AddTask(task: "Ein zwischenmenschliches Problem klären"),
        ],
      ),
    ]);
