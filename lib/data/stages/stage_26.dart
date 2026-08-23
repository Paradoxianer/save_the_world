import 'package:save_the_world_flutter_app/models/addtask.model.dart';
import 'package:save_the_world_flutter_app/models/autoexecute.model.dart';
import 'package:save_the_world_flutter_app/models/faith.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/member.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/message.modifier.dart';
import 'package:save_the_world_flutter_app/models/money.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/multiplyres.model.dart';
import 'package:save_the_world_flutter_app/models/removetask.model.dart';
import 'package:save_the_world_flutter_app/models/stage.model.dart';
import 'package:save_the_world_flutter_app/models/setmax.model.dart';
import 'package:save_the_world_flutter_app/models/subtractres.model.dart';
import 'package:save_the_world_flutter_app/models/task.model.dart';
import 'package:save_the_world_flutter_app/models/time.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/wisdome.ressource.model.dart';
import 'package:save_the_world_flutter_app/data/stages/common_tasks.dart';

final Stage stage26 = Stage(
  level: 26,
  member: 80000000,
  description: "Denomination Level 1 - Globale Infrastruktur und theologische Einheit.",
  activeTasks: [
    "Bibellesen", "Beten", 
    "Schlafen", 
    "Kollekte", 
    "Weltweites Logistik-Netzwerk",
    "Trotz globaler Logistik still werden vor Gott",
    "Weltweites Gebet für Einheit"
  ],
  randomTasks: ["Die Liebe erkaltet (Krise)", "Der Heilige Geist möchte wirken"],
  allTasks: [
    baseBible,
    basePrayer,
    baseSleep,
    collectMoney,
    holySpiritWorking,
    Task(
      name: "Weltweites Gebet für Einheit",
      description: "BEFÄHIGUNG: Nicht doktrinäre Verhandlung, sondern gemeinsames Gebet - so wie Jesus "
          "selbst für die Einheit seiner Nachfolger gebetet hat: \"dass sie alle eins seien... damit die "
          "Welt glaube\" (Johannes 17,21).",
      duration: 100000.0,
      cost: [Faith(value: 20000.0), Wisdom(value: 10000.0)],
      award: [Faith(value: 5000.0)],
      modifier: [
        AddTask(task: "Ein gemeinsames Bekenntnis zu Jesus ablegen"),
        RemoveTask(task: "Weltweites Gebet für Einheit"),
      ],
    ),
    Task(
      name: "Ein gemeinsames Bekenntnis zu Jesus ablegen",
      description: "MEILENSTEIN: Nicht eine neue Institution, sondern ein gemeinsames, weltweites "
          "Bekenntnis zu Jesus - über alle kulturellen und organisatorischen Grenzen hinweg (Limit "
          "160.000.000).",
      duration: 300000.0,
      isMilestone: true,
      cost: [Wisdom(value: 100000.0), Time(value: 100.0), Faith(value: 70000.0)],
      award: [Member(value: 1.0)],
      modifier: [
        MessageModifier(message: "EINHEIT: Das gemeinsame Bekenntnis trägt über alle Grenzen hinweg. Limit 160.000.000!"),
        SetMax(ressource: "Member", newMax: 160000000.0),
        RemoveTask(task: "Ein gemeinsames Bekenntnis zu Jesus ablegen"),
        AddTask(task: "Einheit im Alltag leben"),
      ],
    ),
    Task(
      name: "Einheit im Alltag leben",
      description: "WARTUNG: Stetige Begleitung der regionalen Gemeinschaften, damit aus dem Bekenntnis "
          "gelebte Liebe wird und keine bloße Erklärung bleibt.",
      duration: 60000.0,
      cost: [Time(value: 10.0), Wisdom(value: 10000.0)],
      award: [Faith(value: 5000.0), Wisdom(value: 2000.0)],
    ),
    Task(
      name: "Weltweites Logistik-Netzwerk",
      description: "SYSTEM: Eigene Transportflotten sichern die globale Ressourcenverteilung - effizient, "
          "aber rein logistisches Wachstum ohne geistliche Rückbindung zehrt bei dieser Größe schnell am "
          "Glauben.",
      duration: 200000.0,
      cost: [Money(value: 500000000.0), Wisdom(value: 60000.0)],
      modifier: [
        MessageModifier(message: "LOGISTIK: Eure Flotten erreichen nun jeden Winkel der Erde. Publicity automatisiert."),
        AutoExecuteModifier(
          intervalMs: 60000,
          modifiers: [
            MultiplyRes(targetResName: "Publicity", factorResName: "Member", multiplier: 0.1),
            SubtractRes(ressources: [Faith(value: 1000.0)]),
          ]
        ),
        RemoveTask(task: "Weltweites Logistik-Netzwerk"),
      ],
    ),
    Task(
      name: "Trotz globaler Logistik still werden vor Gott",
      description: "WARTUNG: Bei Millionen Kilometern Transportrouten und globaler Infrastruktur ist es "
          "leicht, im reinen Betrieb unterzugehen - bewusst innehalten und Zeit mit Gott suchen bleibt "
          "trotzdem nötig.",
      duration: 20000.0,
      cost: [Time(value: 8.0)],
      award: [Faith(value: 500.0)],
    ),
    Task(
      name: "Die Liebe erkaltet (Krise)",
      description: "KRISE: Rivalisierende Lager, gegenseitige Vorwürfe und wachsende Distanz zwischen den "
          "Teilen der Bewegung - nicht weil die Lehre falsch wäre, sondern weil die Liebe zueinander "
          "erkaltet ist. \"Weil die Gesetzlosigkeit überhandnimmt, wird die Liebe in vielen erkalten\" "
          "(Matthäus 24,12).",
      duration: 30000.0,
      timeToSolve: 90000.0,
      cost: [Faith(value: 15000.0), Wisdom(value: 10000.0)],
      award: [Faith(value: 2000.0)],
      modifier: [
        MessageModifier(message: "\"Daran wird jedermann erkennen, dass ihr meine Jünger seid, wenn ihr Liebe untereinander habt\" (Johannes 13,35) - gelebte Liebe über Lagergrenzen hinweg heilt den Riss."),
        RemoveTask(task: "Die Liebe erkaltet (Krise)"),
      ],
      missed: [
        SubtractRes(ressources: [
          Faith(value: 20000.0),
          Member(value: 1.0, multiplierResourceName: "Member", multiplierValue: 0.05),
        ]),
        MessageModifier(message: "KASKADE: Aus Rivalität wird offener Bruch - ganze Teile der Bewegung sagen sich los!"),
        RemoveTask(task: "Die Liebe erkaltet (Krise)"),
        AddTask(task: "Große Spaltung (Krise)"),
      ],
    ),
    Task(
      name: "Große Spaltung (Krise)",
      description: "FOLGE-KRISE: Nur eine Rückkehr zu dem, worum Jesus selbst gebetet hat - \"dass sie "
          "alle eins seien\" (Johannes 17,21) - kann die Spaltung noch aufhalten.",
      duration: 40000.0,
      timeToSolve: 100000.0,
      cost: [Faith(value: 40000.0), Wisdom(value: 20000.0)],
      award: [Faith(value: 5000.0)],
      modifier: [
        MessageModifier(message: "EINHEIT WIEDERHERGESTELLT: Über alle Lagergrenzen hinweg wird die Liebe neu sichtbar."),
        RemoveTask(task: "Große Spaltung (Krise)"),
      ],
      missed: [
        SubtractRes(ressources: [
          Faith(value: 30000.0),
          Member(value: 1.0, multiplierResourceName: "Member", multiplierValue: 0.25),
        ]),
        MessageModifier(message: "ZERBROCHEN: Ganze Teile der Bewegung sagen sich endgültig los."),
        RemoveTask(task: "Große Spaltung (Krise)"),
        AddTask(task: "Große Spaltung (Krise)"),
      ],
    ),
  ],
);
