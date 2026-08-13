import 'package:save_the_world_flutter_app/data/stages/common_tasks.dart';
import 'package:save_the_world_flutter_app/models/addres.model.dart';
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

final Stage stage16 = Stage(
  level: 16,
  member: 250000,
  description: "Globale Bewegung Level 2 - Koordination kontinentaler Netzwerke.",
  activeTasks: [
    "Bibellesen", "Beten", 
    "Schlafen", 
    "Kollekte", 
    "Strategischer Stab berufen",
    "Kontinentales Netzwerk gründen"
  ],
  randomTasks: ["Spannungen zwischen Kontinental-Leitern (Krise)", "Der Heilige Geist möchte wirken"],
  allTasks: [
    baseBible,
    basePrayer,
    baseSleep,
    collectMoney,
    holySpiritWorking,
    Task(
      name: "Strategischer Stab berufen",
      description: "DELEGATION: Ein Team von Experten übernimmt die globale Planung - viel Geld fließt "
          "jetzt automatisch, aber rein administratives Wachstum ohne geistliche Rückkopplung zehrt auf "
          "Dauer am Glauben der Bewegung.",
      duration: 20000.0,
      cost: [Money(value: 200000.0), Wisdom(value: 1000.0)],
      award: [Time(value: 2.0)],
      modifier: [
        MessageModifier(message: "SYSTEM: Der Stab automatisiert nun die internationale Kollekte."),
        AutoExecuteModifier(
          intervalMs: 10000,
          modifiers: [
             MultiplyRes(targetResName: "Money", factorResName: "Member", multiplier: 0.12),
             SubtractRes(ressources: [Faith(value: 400.0)]),
          ]
        ),
        RemoveTask(task: "Strategischer Stab berufen"),
        AddTask(task: "Ich weiß es besser als der Stab"),
        AddTask(task: "Den Stab ins Gebet führen"),
      ],
    ),
    Task(
      name: "Ich weiß es besser als der Stab",
      description: "VERSUCHUNG: Du setzt dich über den Rat des Stabs hinweg und drückst deine eigene "
          "Agenda durch - die Ergebnisse sind sofort spürbar, aber das Vertrauen im Team bricht weg. Von "
          "jetzt an musst du schwierige Situationen allein bewältigen.",
      duration: 15000.0,
      cost: [Time(value: 4.0)],
      award: [Money(value: 500000.0), Publicity(value: 3000.0)],
      modifier: [
        MessageModifier(message: "IM ALLEINGANG: Die Zahlen schießen hoch - aber du stehst jetzt allein da."),
        AutoExecuteModifier(
          intervalMs: 10000,
          modifiers: [
             SubtractRes(ressources: [Faith(value: 300.0)]),
          ]
        ),
        RemoveTask(task: "Ich weiß es besser als der Stab"),
        RemoveTask(task: "Den Stab ins Gebet führen"),
        AddTask(task: "Ohne Rückhalt im Stab"),
      ],
    ),
    Task(
      name: "Den Stab ins Gebet führen",
      description: "Statt weiter auf Kennzahlen zu drängen, nimmst du dir mit dem ganzen Stab eine Woche "
          "für Gebet und Fasten - das kostet spürbar Zeit und Geld, und erstmal sieht es nach Stillstand "
          "aus. Aber was auf Gott hört, trägt langfristig mehr Frucht als jede Strategie.",
      duration: 25000.0,
      cost: [Time(value: 15.0), Money(value: 150000.0)],
      award: [Faith(value: 400.0)],
      modifier: [
        MessageModifier(message: "ANSTRENGEND, ABER TRAGFÄHIG: Der Stab hört gemeinsam auf Gott."),
        AutoExecuteModifier(
          intervalMs: 10000,
          modifiers: [
             AddRes(ressources: [Faith(value: 600.0)]),
          ]
        ),
        RemoveTask(task: "Den Stab ins Gebet führen"),
        RemoveTask(task: "Ich weiß es besser als der Stab"),
        AddTask(task: "Betender und Fastender Stab"),
      ],
    ),
    Task(
      name: "Ohne Rückhalt im Stab",
      description: "FOLGE: Ohne den Rückhalt des Stabs triffst du jede schwierige Entscheidung allein - "
          "das kostet mehr Kraft und Weisheit, als eine einzelne Führungsperson eigentlich tragen sollte.",
      duration: 15000.0,
      timeToSolve: 50000.0,
      cost: [Wisdom(value: 1500.0), Time(value: 8.0)],
      award: [Wisdom(value: 100.0)],
      modifier: [
        MessageModifier(message: "DURCHGESTANDEN: Diesmal ging es gerade noch gut - allein."),
        RemoveTask(task: "Ohne Rückhalt im Stab"),
      ],
      missed: [
        SubtractRes(ressources: [Faith(value: 500.0), Member(value: 3000.0)]),
        MessageModifier(message: "ÜBERFORDERT: Ohne den Stab bricht die Entscheidung unter dir zusammen."),
        RemoveTask(task: "Ohne Rückhalt im Stab"),
        AddTask(task: "Ohne Rückhalt im Stab"),
      ],
    ),
    Task(
      name: "Betender und Fastender Stab",
      description: "WARTUNG: Gebet und Fasten sind fester Rhythmus im Stab geworden - Entscheidungen "
          "werden erst geistlich geprüft, dann getroffen.",
      duration: 20000.0,
      cost: [Time(value: 4.0), Wisdom(value: 300.0)],
      award: [Wisdom(value: 250.0), Faith(value: 150.0), Publicity(value: 80.0)],
    ),
    Task(
      name: "Kontinentales Netzwerk gründen",
      description: "MEILENSTEIN: Formierung einer Allianz über den gesamten Kontinent (Limit 500.000).",
      duration: 70000.0,
      isMilestone: true,
      cost: [Money(value: 2000000.0), Wisdom(value: 5000.0), Publicity(value: 2000.0), Faith(value: 3000.0)],
      award: [Member(value: 1.0)],
      modifier: [
        MessageModifier(message: "WACHSTUM: Der Kontinent ist vernetzt! Limit auf 500.000 erhöht."),
        SetMax(ressource: "Member", newMax: 500000.0),
        RemoveTask(task: "Kontinentales Netzwerk gründen"),
        AddTask(task: "Netzwerk koordinieren"),
      ],
    ),
    Task(
      name: "Netzwerk koordinieren",
      description: "WARTUNG: Regelmäßige Abstimmung mit den Leitern der einzelnen Kontinental-Regionen - "
          "Zeitzonen, Sprachen und Kulturen machen das aufwendiger, als es von außen aussieht.",
      duration: 30000.0,
      cost: [Time(value: 6.0), Wisdom(value: 800.0)],
      award: [Faith(value: 300.0), Publicity(value: 200.0)],
    ),
    Task(
      name: "Spannungen zwischen Kontinental-Leitern (Krise)",
      description: "KRISE: Zwei der neu eingesetzten Kontinental-Leiter geraten in einen offenen "
          "Machtkonflikt um Ressourcen und Ausrichtung. Ohne schnelle Vermittlung drohen ganze Regionen "
          "sich zu spalten.",
      duration: 15000.0,
      timeToSolve: 45000.0,
      cost: [Wisdom(value: 1200.0), Faith(value: 400.0)],
      award: [Wisdom(value: 200.0)],
      modifier: [
        MessageModifier(message: "VERSÖHNT: Die Leiter finden zu gemeinsamer Ausrichtung zurück."),
        RemoveTask(task: "Spannungen zwischen Kontinental-Leitern (Krise)"),
      ],
      missed: [
        SubtractRes(ressources: [Publicity(value: 4000.0), Member(value: 8000.0)]),
        MessageModifier(message: "KASKADE: Der ungelöste Konflikt bedroht jetzt den Zusammenhalt des ganzen Netzwerks!"),
        RemoveTask(task: "Spannungen zwischen Kontinental-Leitern (Krise)"),
        AddTask(task: "Netzwerk droht zu zerbrechen (Krise)"), // Kaskade
      ],
    ),
    Task(
      name: "Netzwerk droht zu zerbrechen (Krise)",
      description: "FOLGE-KRISE: Ganze Regionen erwägen offen, sich vom Netzwerk loszusagen - nur "
          "entschlossene, geistlich getragene Vermittlung kann die Einheit noch retten.",
      duration: 25000.0,
      timeToSolve: 60000.0,
      cost: [Money(value: 300000.0), Wisdom(value: 3000.0), Faith(value: 1000.0)],
      award: [Wisdom(value: 500.0)],
      modifier: [
        MessageModifier(message: "BESTANDEN: Die Einheit des Netzwerks ist gerettet - mit Mühe."),
        RemoveTask(task: "Netzwerk droht zu zerbrechen (Krise)"),
      ],
      missed: [
        SubtractRes(ressources: [Member(value: 30000.0), Faith(value: 2000.0)]),
        MessageModifier(message: "ZERBROCHEN: Ganze Regionen lösen sich vom Netzwerk - der Kontinent zerfällt in Einzelteile."),
        RemoveTask(task: "Netzwerk droht zu zerbrechen (Krise)"),
        AddTask(task: "Netzwerk droht zu zerbrechen (Krise)"),
      ],
    ),
  ],
);
