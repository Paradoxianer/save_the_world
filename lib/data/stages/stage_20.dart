import 'package:save_the_world_flutter_app/data/stages/common_tasks.dart';
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

final Stage stage20 = Stage(
  level: 20,
  member: 2500000,
  description: "Globale Bewegung Level 6 - Koordination weltweiter Netzwerke.",
  activeTasks: [
    "Bibellesen", "Beten",
    "Schlafen",
    "Kollekte",
    "Ein Aufsichtsgremium einsetzen, das dich wirklich stoppen kann",
    "Geistliche Väter und Mütter einsetzen",
    "Globale Allianz gründen"
  ],
  randomTasks: ["Wer kommt nach dir? (Krise)", "Der Heilige Geist möchte wirken"],
  allTasks: [
    baseBible,
    basePrayer,
    baseSleep,
    collectMoney,
    holySpiritWorking,
    Task(
      name: "Ein Aufsichtsgremium einsetzen, das dich wirklich stoppen kann",
      description: "SYSTEM: Ein Gremium mit echter Vetomacht - nicht nur auf dem Papier, sondern mit der "
          "tatsächlichen Möglichkeit, dich zu stoppen. Das professionalisiert die Finanzstrukturen und "
          "schafft Spendervertrauen, aber Strukturen ohne geistliche Tiefe erstarren irgendwann zu bloßer "
          "Bürokratie.",
      duration: 25000.0,
      cost: [Money(value: 300000.0), Wisdom(value: 2000.0)],
      award: [Wisdom(value: 300.0)],
      modifier: [
        MessageModifier(message: "SYSTEM: Das Gremium ist eingesetzt und beginnt, die Finanzen zu professionalisieren."),
        AutoExecuteModifier(
          intervalMs: 10000,
          modifiers: [
             MultiplyRes(targetResName: "Money", factorResName: "Member", multiplier: 0.15),
             SubtractRes(ressources: [Faith(value: 400.0)]),
          ]
        ),
        RemoveTask(task: "Ein Aufsichtsgremium einsetzen, das dich wirklich stoppen kann"),
      ],
    ),
    Task(
      name: "Geistliche Väter und Mütter einsetzen",
      description: "WARTUNG: Menschen ohne Platz in der Organisationsstruktur und ohne eigenes Interesse "
          "an Wachstumszahlen, die dir trotzdem - oder gerade deshalb - ehrlich sagen dürfen, was ein "
          "Gremium allein nie sehen würde.",
      duration: 18000.0,
      cost: [Time(value: 6.0)],
      award: [Faith(value: 450.0)],
    ),
    Task(
      name: "Globale Allianz gründen",
      description: "MEILENSTEIN: Formierung einer Allianz über alle Kontinente (Limit 5.000.000).",
      duration: 80000.0,
      isMilestone: true,
      cost: [Money(value: 12000000.0), Wisdom(value: 15000.0), Publicity(value: 8000.0), Faith(value: 5000.0)],
      award: [Member(value: 1.0)],
      modifier: [
        MessageModifier(message: "WACHSTUM: Die Allianz steht! Limit auf 5.000.000 erhöht."),
        SetMax(ressource: "Member", newMax: 5000000.0),
        RemoveTask(task: "Globale Allianz gründen"),
        AddTask(task: "Allianz koordinieren"),
      ],
    ),
    Task(
      name: "Allianz koordinieren",
      description: "WARTUNG: Laufende Abstimmung zwischen allen Kontinentalallianzen - Zeitzonen und "
          "Sprachen sind das eine, aber jetzt wollen auch das Aufsichtsgremium und die geistlichen "
          "Begleiter ehrlich eingebunden werden, nicht nur informiert.",
      duration: 35000.0,
      cost: [Time(value: 4.0), Wisdom(value: 1000.0)],
      award: [Faith(value: 200.0), Publicity(value: 200.0)],
    ),
    Task(
      name: "Wer kommt nach dir? (Krise)",
      description: "KRISE: Eine plötzliche Erkrankung des Gründers zeigt schonungslos: Es gibt keinen "
          "geregelten Übergang. Die ganze Allianz hängt an einer einzigen Person.",
      duration: 20000.0,
      timeToSolve: 60000.0,
      cost: [Wisdom(value: 2000.0), Faith(value: 1000.0)],
      award: [Wisdom(value: 500.0)],
      modifier: [
        MessageModifier(message: "GEREGELT: Ein erster, echter Nachfolgeplan steht."),
        RemoveTask(task: "Wer kommt nach dir? (Krise)"),
      ],
      missed: [
        SubtractRes(ressources: [Faith(value: 3000.0), Publicity(value: 15000.0)]),
        MessageModifier(message: "KASKADE: Ohne geregelte Nachfolge brechen offene Machtkämpfe aus!"),
        RemoveTask(task: "Wer kommt nach dir? (Krise)"),
        AddTask(task: "Machtkampf um die Nachfolge (Krise)"), // Kaskade
      ],
    ),
    Task(
      name: "Machtkampf um die Nachfolge (Krise)",
      description: "FOLGE-KRISE: Mehrere Fraktionen kämpfen offen um die Führung - die Allianz droht an der "
          "ungelösten Machtfrage zu zerbrechen.",
      duration: 30000.0,
      timeToSolve: 70000.0,
      cost: [Money(value: 1000000.0), Wisdom(value: 4000.0), Faith(value: 2000.0)],
      award: [Wisdom(value: 1000.0)],
      modifier: [
        MessageModifier(message: "BEIGELEGT: Eine gemeinsam getragene Übergangslösung hält die Allianz zusammen."),
        RemoveTask(task: "Machtkampf um die Nachfolge (Krise)"),
      ],
      missed: [
        SubtractRes(ressources: [Member(value: 500000.0), Faith(value: 4000.0)]),
        MessageModifier(message: "ZERBROCHEN: Ganze Fraktionen spalten sich in der ungelösten Machtfrage ab."),
        RemoveTask(task: "Machtkampf um die Nachfolge (Krise)"),
        AddTask(task: "Machtkampf um die Nachfolge (Krise)"),
      ],
    ),
  ],
);
