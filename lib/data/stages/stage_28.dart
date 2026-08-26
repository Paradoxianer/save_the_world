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
import 'package:save_the_world_flutter_app/data/stages/common_tasks.dart';

final Stage stage28 = Stage(
  level: 28,
  member: 320000000,
  description: "Denomination Level 3 - Globales technologisches Zeugnis.",
  activeTasks: [
    "Bibellesen", "Beten", 
    "Schlafen", 
    "Kollekte", 
    "AI-Seelsorge-Netzwerk",
    "Echte Menschen in die Seelsorge investieren",
    "Wie erreichen wir die Welt für Jesus? (Gebet und Fasten)"
  ],
  randomTasks: ["Verdacht der Vereinnahmung (Krise)", "Der Heilige Geist möchte wirken"],
  allTasks: [
    baseBible,
    basePrayer,
    baseSleep,
    collectMoney,
    holySpiritWorking,
    Task(
      name: "AI-Seelsorge-Netzwerk",
      description: "DELEGATION: KI-gestützte Begleitung skaliert die Erreichbarkeit bei Milliarden von "
          "Gläubigen - aber ein Algorithmus kann Menschen in echter Not nicht wirklich trösten. Der Anschein "
          "geistlicher Betreuung ersetzt nicht die Sache selbst.",
      duration: 180000.0,
      cost: [Money(value: 2000000000.0), Wisdom(value: 200000.0)],
      modifier: [
        MessageModifier(message: "SYSTEM: Das Netzwerk ist online. Weisheit generiert sich nun passiv."),
        AutoExecuteModifier(
          intervalMs: 30000,
          modifiers: [
            MultiplyRes(targetResName: "Wisdom", factorResName: "Member", multiplier: 0.0001),
            SubtractRes(ressources: [Faith(value: 2000.0)]),
          ]
        ),
        RemoveTask(task: "AI-Seelsorge-Netzwerk"),
      ],
    ),
    Task(
      name: "Echte Menschen in die Seelsorge investieren",
      description: "WARTUNG: Technologie skaliert Reichweite, aber niemals echtes Mitgefühl - bewusst "
          "Menschen statt nur Algorithmen für die Seelsorge freistellen und tragen.",
      duration: 20000.0,
      cost: [Time(value: 8.0)],
      award: [Faith(value: 700.0)],
    ),
    Task(
      name: "Wie erreichen wir die Welt für Jesus? (Gebet und Fasten)",
      description: "BEFÄHIGUNG: Nicht Strategie oder Zählung - schon Davids Volkszählung hat ihn teuer zu "
          "stehen gekommen (2. Samuel 24) - sondern Gebet und Fasten stellen die eigentliche Frage neu: "
          "Wie erreichen wir die Welt wirklich für Jesus?",
      duration: 100000.0,
      cost: [Faith(value: 50000.0), Time(value: 50.0)],
      award: [Wisdom(value: 10000.0)],
      modifier: [
        AddTask(task: "Gespräche mit anderen christlichen Organisationen suchen"),
        RemoveTask(task: "Wie erreichen wir die Welt für Jesus? (Gebet und Fasten)"),
      ],
    ),
    Task(
      name: "Gespräche mit anderen christlichen Organisationen suchen",
      description: "BEFÄHIGUNG: Kontakt zu anderen christlichen Organisationen und Denominationen suchen - "
          "nicht um zu vereinnahmen, sondern um gemeinsam Menschen für Jesus zu gewinnen. Der Weg ist "
          "holprig: zu oft verschiebt sich der Fokus auf das, was in der Doktrin trennt, statt auf das, was "
          "in der Sendung eint.",
      duration: 60000.0,
      timeToSolve: 150000.0,
      cost: [Wisdom(value: 60000.0), Faith(value: 30000.0)],
      award: [Wisdom(value: 15000.0)],
      modifier: [
        MessageModifier(message: "DURCHBRUCH: Gemeinsame Sendung wiegt am Ende schwerer als die Unterschiede."),
        AddTask(task: "Einen Bund der Einheit gründen"),
        RemoveTask(task: "Gespräche mit anderen christlichen Organisationen suchen"),
      ],
      missed: [
        SubtractRes(ressources: [Wisdom(value: 10000.0)]),
        MessageModifier(message: "RÜCKSCHLAG: Die Gespräche verlieren sich in Doktrin-Debatten statt in der gemeinsamen Sendung - ein neuer Anlauf ist nötig."),
        RemoveTask(task: "Gespräche mit anderen christlichen Organisationen suchen"),
        AddTask(task: "Gespräche mit anderen christlichen Organisationen suchen"),
      ],
    ),
    Task(
      name: "Einen Bund der Einheit gründen",
      description: "MEILENSTEIN: Ein Bund, der Christen verschiedenster Traditionen um das sammelt, was "
          "wirklich zählt - Gebet, Fasten, Lehre und gelebte Jüngerschaft, damit Menschen für Jesus "
          "gewonnen werden (vgl. Apostelgeschichte 2,42) (Limit 1.280.000.000).",
      duration: 600000.0,
      isMilestone: true,
      cost: [Wisdom(value: 400000.0), Time(value: 200.0), Faith(value: 250000.0)],
      award: [Member(value: 1.0)],
      modifier: [
        MessageModifier(message: "BUND GESCHLOSSEN: Viele Traditionen, eine Sendung. Limit 1.280.000.000!"),
        SetMax(ressource: "Member", newMax: 1280000000.0),
        RemoveTask(task: "Einen Bund der Einheit gründen"),
        AddTask(task: "Den Bund in Gebet, Fasten, Lehre und Jüngerschaft leben"),
        AddTask(task: "Die nächste Generation in den Bund hineinrufen"),
      ],
    ),
    Task(
      name: "Den Bund in Gebet, Fasten, Lehre und Jüngerschaft leben",
      description: "WARTUNG: Die vier Säulen des Bundes lebendig halten, damit er nicht zur bloßen "
          "Erklärung erstarrt.",
      duration: 80000.0,
      cost: [Time(value: 20.0), Wisdom(value: 20000.0)],
      award: [Faith(value: 10000.0), Publicity(value: 10000.0)],
    ),
    Task(
      name: "Die nächste Generation in den Bund hineinrufen",
      description: "Der Bund ist geschlossen - aber er muss an eine neue Generation weitergegeben werden, "
          "sonst bleibt er nur ein Ereignis der Vergangenheit statt einer lebendigen Bewegung.",
      duration: 20000.0,
      cost: [Time(value: 10.0)],
      award: [Wisdom(value: 3000.0), Faith(value: 3000.0)],
    ),
    Task(
      name: "Verdacht der Vereinnahmung (Krise)",
      description: "KRISE: Führende Stimmen in anderen Traditionen warnen: Ist das echte Einheit, oder "
          "will die Bewegung am Ende doch nur die anderen schlucken? Misstrauen bedroht die gerade "
          "gewachsene Nähe.",
      duration: 40000.0,
      timeToSolve: 100000.0,
      cost: [Wisdom(value: 100000.0), Faith(value: 50000.0)],
      award: [Wisdom(value: 10000.0)],
      modifier: [
        MessageModifier(message: "VERTRAUEN BESTÄTIGT: Demütiges Auftreten überzeugt mehr als jede Erklärung."),
        RemoveTask(task: "Verdacht der Vereinnahmung (Krise)"),
      ],
      missed: [
        SubtractRes(ressources: [Faith(value: 80000.0), Publicity(value: 300000.0)]),
        MessageModifier(message: "KASKADE: Das Misstrauen wächst - ganze Traditionsgemeinschaften erwägen den Rückzug!"),
        RemoveTask(task: "Verdacht der Vereinnahmung (Krise)"),
        AddTask(task: "Rückzug ganzer Traditionsgemeinschaften (Krise)"),
      ],
    ),
    Task(
      name: "Rückzug ganzer Traditionsgemeinschaften (Krise)",
      description: "FOLGE-KRISE: Ganze Traditionsgemeinschaften ziehen sich aus dem Bund zurück - das "
          "Vertrauen muss mühsam neu aufgebaut werden.",
      duration: 50000.0,
      timeToSolve: 120000.0,
      cost: [Wisdom(value: 200000.0), Faith(value: 100000.0)],
      award: [Wisdom(value: 20000.0)],
      modifier: [
        MessageModifier(message: "ZURÜCKGEWONNEN: Die zurückgezogenen Traditionen kehren in den Bund zurück."),
        RemoveTask(task: "Rückzug ganzer Traditionsgemeinschaften (Krise)"),
      ],
      missed: [
        SubtractRes(ressources: [
          Member(value: 1.0, multiplierResourceName: "Member", multiplierValue: 0.05),
        ]),
        MessageModifier(message: "ZERBROCHEN: Der Bund verliert dauerhaft an Substanz."),
        RemoveTask(task: "Rückzug ganzer Traditionsgemeinschaften (Krise)"),
        AddTask(task: "Rückzug ganzer Traditionsgemeinschaften (Krise)"),
      ],
    ),
  ],
);
