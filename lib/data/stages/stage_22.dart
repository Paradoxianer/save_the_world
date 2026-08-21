import 'package:save_the_world_flutter_app/data/stages/common_tasks.dart';
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

final Stage stage22 = Stage(
  level: 22,
  member: 7500000,
  description: "Globale Größe Level 2 - Koordination interkontinentaler Projekte.",
  activeTasks: [ "Bibellesen", "Beten",
    "Schlafen",
    "Interkontinentale Projekte koordinieren",
    "Schutzstrukturen für die nächste Generation einführen"
  ],
  randomTasks: ["Stipendiengelder versickern (Krise)", "Der Heilige Geist möchte wirken"],
  allTasks: [
    baseBible,
    basePrayer,
    baseSleep,
    holySpiritWorking,
    Task(
      name: "Interkontinentale Projekte koordinieren",
      description: "WARTUNG: Laufende Abstimmung der großen, über Kontinente verteilten Programme - "
          "Allianz-Vertretung, Stipendien und Schutzstrukturen laufen jetzt parallel und wollen "
          "koordiniert werden.",
      duration: 40000.0,
      cost: [Time(value: 2.0), Wisdom(value: 1500.0)],
      award: [Publicity(value: 500.0), Faith(value: 300.0)],
    ),
    Task(
      name: "Schutzstrukturen für die nächste Generation einführen",
      description: "BEFÄHIGUNG: Bevor Stipendien und Bildungsprogramme für eine ganze Generation "
          "zukünftiger Leiter aufgesetzt werden, müssen wirksame Schutzstrukturen stehen - unabhängige "
          "Meldestellen, Background-Checks, klare Konsequenzen. Nicht nachträglich reparieren, sondern "
          "von Anfang an richtig machen.",
      duration: 30000.0,
      cost: [Money(value: 500000.0), Wisdom(value: 3000.0), Faith(value: 1000.0)],
      award: [Wisdom(value: 500.0)],
      modifier: [
        MessageModifier(message: "SCHUTZ VERANKERT: Unabhängige Meldestellen und klare Regeln stehen, bevor das Programm startet."),
        AddTask(task: "Weltweiten Bildungsfonds gründen"),
        RemoveTask(task: "Schutzstrukturen für die nächste Generation einführen"),
      ],
    ),
    Task(
      name: "Weltweiten Bildungsfonds gründen",
      description: "MEILENSTEIN: Stipendien für zukünftige Leiter weltweit (Limit 10.000.000).",
      duration: 120000.0,
      isMilestone: true,
      cost: [Money(value: 18000000.0), Wisdom(value: 30000.0), Faith(value: 7000.0)],
      award: [Member(value: 1.0)],
      modifier: [
        MessageModifier(message: "BILDUNG: Die nächste Generation Leiter ist gesichert. Limit 10.000.000!"),
        SetMax(ressource: "Member", newMax: 10000000.0),
        RemoveTask(task: "Weltweiten Bildungsfonds gründen"),
        AddTask(task: "Bildungsfonds verwalten"),
      ],
    ),
    Task(
      name: "Bildungsfonds verwalten",
      description: "WARTUNG: Operative Begleitung der weltweiten Stipendiaten.",
      duration: 50000.0,
      cost: [Time(value: 4.0), Money(value: 100000.0)],
      award: [Wisdom(value: 1000.0), Faith(value: 200.0)],
    ),
    Task(
      name: "Stipendiengelder versickern (Krise)",
      description: "KRISE: In einzelnen Ländern erreichen die Stipendien nicht die vorgesehenen "
          "Studierenden - Korruption oder schlicht mangelnde Kontrolle lässt Fördergelder versickern.",
      duration: 20000.0,
      timeToSolve: 50000.0,
      cost: [Wisdom(value: 5000.0), Money(value: 500000.0)],
      award: [Wisdom(value: 1000.0)],
      modifier: [
        MessageModifier(message: "KONTROLLIERT: Strengere Prüfung sorgt dafür, dass die Mittel ankommen."),
        RemoveTask(task: "Stipendiengelder versickern (Krise)"),
      ],
      missed: [
        SubtractRes(ressources: [Money(value: 2000000.0), Faith(value: 2000.0)]),
        MessageModifier(message: "KASKADE: Die Misswirtschaft wird öffentlich bekannt!"),
        RemoveTask(task: "Stipendiengelder versickern (Krise)"),
        AddTask(task: "Vertrauen in den Bildungsfonds bricht weg (Krise)"),
      ],
    ),
    Task(
      name: "Vertrauen in den Bildungsfonds bricht weg (Krise)",
      description: "FOLGE-KRISE: Öffentlich bekannt gewordene Misswirtschaft lässt Spender und Partner am "
          "ganzen Fonds zweifeln.",
      duration: 30000.0,
      timeToSolve: 60000.0,
      cost: [Money(value: 5000000.0), Wisdom(value: 8000.0), Publicity(value: 10000.0)],
      modifier: [
        MessageModifier(message: "WIEDERHERGESTELLT: Transparente Aufarbeitung gewinnt das Vertrauen zurück."),
        RemoveTask(task: "Vertrauen in den Bildungsfonds bricht weg (Krise)"),
      ],
      missed: [
        SubtractRes(ressources: [Member(value: 200000.0), Publicity(value: 50000.0)]),
        RemoveTask(task: "Vertrauen in den Bildungsfonds bricht weg (Krise)"),
        AddTask(task: "Vertrauen in den Bildungsfonds bricht weg (Krise)"),
      ],
    ),
  ],
);
