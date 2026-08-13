import 'package:save_the_world_flutter_app/models/addtask.model.dart';
import 'package:save_the_world_flutter_app/models/autoexecute.model.dart';
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
import 'package:save_the_world_flutter_app/data/stages/common_tasks.dart';

final Stage stage17 = Stage(
  level: 17,
  member: 500000,
  description: "Globale Bewegung Level 3 - Wissenschaftliche Sicherung der Lehre für kommende Generationen.",
  activeTasks: [
    "Bibellesen", "Beten",
    "Schlafen",
    "Lehrmaterial für die nächste Generation entwickeln",
    "Bibelschulen zur Theologischen Fakultät umbauen"
  ],
  randomTasks: ["Lehrstreit gefährdet die Einheit (Krise)", "Der Heilige Geist möchte wirken"],
  allTasks: [
    baseBible,
    basePrayer,
    baseSleep,
    collectMoney,
    holySpiritWorking,
    Task(
      name: "Lehrmaterial für die nächste Generation entwickeln",
      description: "BEFÄHIGUNG: Was in den Bibel-, Propheten- und Lobpreisschulen an Substanz gewachsen "
          "ist, muss jetzt in vermittelbares Material gefasst werden - verständlich für neue Kulturen, "
          "ohne den Kern zu verwässern.",
      duration: 30000.0,
      cost: [Wisdom(value: 800.0), Money(value: 150000.0)],
      award: [Wisdom(value: 300.0)],
      modifier: [
        AddTask(task: "Das Glaubensfundament dokumentieren"),
        RemoveTask(task: "Lehrmaterial für die nächste Generation entwickeln"),
      ],
    ),
    Task(
      name: "Das Glaubensfundament dokumentieren",
      description: "SYSTEM: Die Kernlehre wird so dokumentiert, dass sie über Generationen und Kulturen "
          "hinweg verständlich bleibt - das kostet nicht nur Geld und Wissen, sondern echte geistliche "
          "Klarheit.",
      duration: 40000.0,
      cost: [Money(value: 400000.0), Wisdom(value: 1000.0), Faith(value: 500.0)],
      award: [Wisdom(value: 500.0), Faith(value: 200.0)],
      modifier: [
        MessageModifier(message: "FUNDAMENT GELEGT: Die Kernlehre ist jetzt tragfähig dokumentiert."),
        RemoveTask(task: "Das Glaubensfundament dokumentieren"),
      ],
    ),
    Task(
      name: "Bibelschulen zur Theologischen Fakultät umbauen",
      description: "MEILENSTEIN: Aus den einzelnen Bibel-, Propheten- und Lobpreisschulen wird eine "
          "wissenschaftlich anerkannte Theologische Fakultät - Absicherung der Lehre für Generationen "
          "(Limit 1.000.000). Aber reines Kopfwissen erstarrt: eine Fakultät braucht immer wieder neue "
          "geistliche Ausrichtung, sonst verliert sie genau das, was sie eigentlich bewahren soll.",
      duration: 95000.0,
      isMilestone: true,
      cost: [Money(value: 5000000.0), Wisdom(value: 8000.0), Faith(value: 4000.0)],
      award: [Member(value: 1.0)],
      modifier: [
        MessageModifier(message: "BILDUNG: Die Bibelschulen sind jetzt eine anerkannte Fakultät. Limit 1.000.000!"),
        SetMax(ressource: "Member", newMax: 1000000.0),
        AutoExecuteModifier(
          intervalMs: 12000,
          modifiers: [
            SubtractRes(ressources: [Faith(value: 600.0)]),
          ]
        ),
        RemoveTask(task: "Bibelschulen zur Theologischen Fakultät umbauen"),
        AddTask(task: "Fakultät wissenschaftlich leiten"),
        AddTask(task: "Die Fakultät geistlich neu ausrichten"),
      ],
    ),
    Task(
      name: "Fakultät wissenschaftlich leiten",
      description: "WARTUNG: Stetige Forschung und Lehre zur Bewahrung der DNA.",
      duration: 40000.0,
      cost: [Time(value: 2.0), Wisdom(value: 1000.0)],
      award: [Wisdom(value: 500.0), Faith(value: 200.0)],
    ),
    Task(
      name: "Die Fakultät geistlich neu ausrichten",
      description: "WARTUNG: Wissenschaftliche Arbeit an der Lehre kann leicht zu reiner Kopfarbeit "
          "erstarren - immer wieder braucht es bewusste Neuausrichtung auf Gott, sonst verliert die "
          "Fakultät genau die geistliche Substanz, die sie eigentlich bewahren soll.",
      duration: 25000.0,
      cost: [Time(value: 5.0), Wisdom(value: 200.0)],
      award: [Faith(value: 500.0)],
    ),
    Task(
      name: "Lehrstreit gefährdet die Einheit (Krise)",
      description: "KRISE: Unterschiedliche Auslegungen der Kernlehre drohen die Bewegung zu spalten - nur "
          "eine gemeinsame, geistlich fundierte Klärung kann die Einheit bewahren.",
      duration: 20000.0,
      timeToSolve: 60000.0,
      cost: [Wisdom(value: 1500.0), Faith(value: 800.0)],
      award: [Wisdom(value: 300.0)],
      modifier: [
        MessageModifier(message: "GEKLÄRT: Gemeinsames Verständnis der Kernlehre wiederhergestellt."),
        RemoveTask(task: "Lehrstreit gefährdet die Einheit (Krise)"),
      ],
      missed: [
        SubtractRes(ressources: [Member(value: 20000.0), Faith(value: 1500.0)]),
        MessageModifier(message: "KASKADE: Ganze Gruppen ziehen mit eigener Lehrauslegung von dannen!"),
        RemoveTask(task: "Lehrstreit gefährdet die Einheit (Krise)"),
        AddTask(task: "Die Bewegung spaltet sich (Krise)"), // Kaskade
      ],
    ),
    Task(
      name: "Die Bewegung spaltet sich (Krise)",
      description: "FOLGE-KRISE: Ganze Gruppen lösen sich mit eigener Lehrauslegung von der Bewegung - nur "
          "klare, aber demütige theologische Führung kann größeren Schaden noch abwenden.",
      duration: 30000.0,
      timeToSolve: 70000.0,
      cost: [Money(value: 500000.0), Wisdom(value: 3000.0), Faith(value: 1500.0)],
      award: [Wisdom(value: 800.0)],
      modifier: [
        MessageModifier(message: "BESTANDEN: Einheit trotz Vielfalt bewahrt."),
        RemoveTask(task: "Die Bewegung spaltet sich (Krise)"),
      ],
      missed: [
        SubtractRes(ressources: [Member(value: 150000.0), Faith(value: 3000.0)]),
        MessageModifier(message: "SCHISMA: Die Bewegung zerbricht in konkurrierende Lehrrichtungen."),
        RemoveTask(task: "Die Bewegung spaltet sich (Krise)"),
        AddTask(task: "Die Bewegung spaltet sich (Krise)"),
      ],
    ),
  ],
);
