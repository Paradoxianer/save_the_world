import 'package:save_the_world_flutter_app/models/addtask.model.dart';
import 'package:save_the_world_flutter_app/models/autoexecute.model.dart';
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
import 'package:save_the_world_flutter_app/models/faith.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/member.ressource.model.dart';
import 'package:save_the_world_flutter_app/data/stages/common_tasks.dart';

final Stage stage6 = Stage(
  level: 6,
  member: 600,
  description: "Sehr große Gemeinde - Bereiche werden professionalisiert.",
  activeTasks: ["Bibellesen", "Beten", "Schlafen", "Kollekte", "Professionalisierungskonzept entwickeln"],
  randomTasks: ["Jemand möchte heiraten", "Der Heilige Geist möchte wirken"],
  allTasks: [
    baseBible,
    basePrayer,
    baseSleep,
    collectMoney,
    holySpiritWorking,
    ...weddingQuestline,
    Task(
      name: "Professionalisierungskonzept entwickeln",
      description: "Bevor einzelne Bereiche professionalisiert werden, braucht es eine gemeinsame Grundidee: "
          "Exzellenz nicht als Selbstzweck, sondern weil Gott das Beste verdient - nicht der eigene Ruf.",
      duration: 15000.0,
      cost: [Time(value: 8.0), Wisdom(value: 80.0)],
      award: [Wisdom(value: 40.0)],
      modifier: [
        MessageModifier(
          message: "ACHTUNG: Professionalität ist kein Selbstzweck. Wird sie zum Streben nach Ruhm statt nach "
              "Gott, verliert die Bewegung langfristig an Glauben - bleib im Gebet verankert.",
        ),
        AddTask(task: "Lehre professionalisieren"),
        AddTask(task: "Seelsorge professionalisieren"),
        AddTask(task: "Gebet professionalisieren"),
        AddTask(task: "Gottesdienst professionalisieren"),
        AddTask(task: "Technik professionalisieren"),
        AddTask(task: "Willkommenskultur professionalisieren"),
        AddTask(task: "Hauptamtliches Team ausbauen"),
        // Die Gefahr der Professionalisierung: sie kann zum Streben nach
        // Ruhm statt nach Gott werden. Automatischer Glaubensabzug, der NUR
        // durch aktives, dranbleibendes Gebet (siehe "Gebet
        // professionalisieren" unten) teilweise ausgeglichen wird - genau
        // wie schon der Verwaltungsabzug in Stage 3 nie ganz von selbst
        // verschwindet, sondern bewusstes Gegensteuern braucht.
        AutoExecuteModifier(
          intervalMs: 25000,
          modifiers: [
            SubtractRes(ressources: [Faith(value: 1.0, multiplierResourceName: "Member", multiplierValue: 0.02)]),
          ],
        ),
      ],
    ),
    Task(
      name: "Lehre professionalisieren",
      description: "EINMALIG: Fundierte, durchdachte Lehre statt Zufallspredigten.",
      duration: 18000.0,
      once: true,
      cost: [Time(value: 6.0), Wisdom(value: 150.0), Money(value: 500.0)],
      award: [Wisdom(value: 80.0)],
    ),
    Task(
      name: "Seelsorge professionalisieren",
      description: "EINMALIG: Ausgebildete Seelsorger statt Zufallsgesprächen zwischen Tür und Angel.",
      duration: 18000.0,
      once: true,
      cost: [Time(value: 6.0), Wisdom(value: 150.0), Money(value: 500.0)],
      award: [Faith(value: 60.0)],
    ),
    Task(
      name: "Gottesdienst professionalisieren",
      description: "EINMALIG: Ein Gottesdienst, der bei dieser Größe wirklich noch alle erreicht.",
      duration: 18000.0,
      once: true,
      cost: [Time(value: 6.0), Wisdom(value: 150.0), Money(value: 500.0)],
      award: [Publicity(value: 40.0), Member(value: 1.0)],
    ),
    Task(
      name: "Technik professionalisieren",
      description: "EINMALIG: Ton, Bild, Übertragung - ohne technische Ausreden.",
      duration: 18000.0,
      once: true,
      cost: [Time(value: 6.0), Wisdom(value: 100.0), Money(value: 800.0)],
      award: [Publicity(value: 60.0)],
    ),
    Task(
      name: "Willkommenskultur professionalisieren",
      description: "EINMALIG: Niemand soll sich als Fremder fühlen - bei dieser Größe passiert das nicht mehr "
          "von selbst.",
      duration: 18000.0,
      once: true,
      cost: [Time(value: 6.0), Wisdom(value: 100.0), Money(value: 300.0)],
      award: [Member(value: 1.5)],
    ),
    Task(
      name: "Gebet professionalisieren",
      description: "WARTUNG: Der eine Bereich, der alle anderen zusammenhält - bewusste, gemeinsame Gebetszeiten "
          "halten die Ausrichtung auf Gott aufrecht statt auf den eigenen Ruf. Läuft NICHT von selbst weiter, "
          "anders als der Ruhm-Abzug oben - du musst aktiv dranbleiben.",
      duration: 10000.0,
      cost: [Time(value: 4.0), Wisdom(value: 20.0)],
      award: [Faith(value: 1.0, multiplierResourceName: "Member", multiplierValue: 0.015)],
    ),
    Task(
      name: "Hauptamtliches Team ausbauen",
      description: "MEILENSTEIN: Aus einzeln professionalisierten Bereichen wird ein echtes, eingespieltes Team "
          "(Limit 800).",
      duration: 30000.0,
      isMilestone: true,
      cost: [Money(value: 3000.0), Wisdom(value: 200.0), Member(value: 100.0)],
      award: [Member(value: 1.0)],
      modifier: [
        MessageModifier(message: "PROFIS: Aus einzelnen Bereichen ist ein echtes Team geworden. Limit 800!"),
        SetMax(ressource: "Member", newMax: 800.0),
        RemoveTask(task: "Hauptamtliches Team ausbauen"),
        AddTask(task: "Team leiten & koordinieren"),
      ],
    ),
    Task(
      name: "Team leiten & koordinieren",
      description: "WARTUNG: Unterstützung der Hauptamtlichen im Dienst.",
      duration: 20000.0,
      cost: [Time(value: 4.0), Wisdom(value: 50.0)],
      award: [Wisdom(value: 20.0), Faith(value: 20.0)],
    ),
  ],
);
