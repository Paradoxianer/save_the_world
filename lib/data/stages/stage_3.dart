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

final Stage stage3 = Stage(
  level: 3,
  member: 140,
  description: "Mittlere Gemeinde - Vom Clan zur Organisation.",
  activeTasks: ["Bibellesen", "Beten", "Kollekte", "Schlafen", "Öffentlicher Gottesdienst"],
  allTasks: [
    Task(name: "Schlafen", duration: 8000.0, cost: [Time(value: 8.0)], award: [Time(value: 16.0)]),
    Task(name: "Bibellesen", duration: 3000.0, cost: [Time(value: 1.0)], award: [Faith(value: 15.0)]),
    Task(name: "Beten", duration: 4000.0, cost: [Time(value: 1.0)], award: [Faith(value: 15.0)]),
    Task(
      name: "Kollekte",
      duration: 3000.0,
      cost: [Time(value: 1.0)],
      modifier: [MultiplyRes(targetResName: "Money", factorResName: "Member", multiplier: 0.7)],
    ),
    Task(
      name: "Öffentlicher Gottesdienst",
      description: "Jeden Sonntag für die ganze Stadt.",
      duration: 6000.0,
      cost: [Time(value: 5.0), Money(value: 30.0)],
      award: [Member(value: 1.0), Publicity(value: 8.0)], 
      modifier: [
        MultiplyRes(targetResName: "Faith", factorResName: "Member", multiplier: 0.2),
        AddTask(task: "Korpsrat gründen"),
      ],
    ),
    Task(
      name: "Korpsrat gründen",
      description: "MEILENSTEIN: Ein Leitungsteam für die Zukunft (Limit 200).",
      duration: 20000.0,
      isMilestone: true,
      cost: [Time(value: 8.0), Wisdom(value: 50.0), Member(value: 60.0)],
      award: [Wisdom(value: 30.0), Member(value: 1.0)],
      modifier: [
        MessageModifier(message: "ORGANISATION: Gemeinsam seid ihr stärker. Willkommen in Stufe 4 (Limit 200)."),
        SetMax(ressource: "Member", newMax: 200.0),
        RemoveTask(task: "Korpsrat gründen"),
        AddTask(task: "Ratssitzungen koordinieren"),
        AddTask(task: "Erste hauptamtliche Kraft anstellen"),
        AddTask(task: "Team geistlich begleiten"),
      ],
    ),
    Task(
      name: "Ratssitzungen koordinieren",
      description: "WARTUNG: Sorge für Einheit und Vision im Leitungsteam.",
      duration: 15000.0,
      cost: [Time(value: 4.0), Wisdom(value: 10.0)],
      award: [Wisdom(value: 20.0), Faith(value: 10.0)],
    ),
    Task(
      name: "Erste hauptamtliche Kraft anstellen",
      description: "WENDEPUNKT: Du gibst die persönliche Seelsorge an jedem Einzelnen ab und wirst zum Leiter von "
          "Leitern statt zum Hirten aller. Die erste bezahlte Kraft entlastet dich dauerhaft - aber Verwaltung "
          "beginnt, deine eigene Zeit mit Gott zu beanspruchen.",
      duration: 20000.0,
      once: true,
      cost: [Time(value: 6.0), Money(value: 800.0), Wisdom(value: 30.0)],
      award: [Wisdom(value: 20.0)],
      modifier: [
        MessageModifier(
          message: "ACHTUNG: Organisation wächst jetzt von selbst weiter - aber sie zieht dir auch automatisch "
              "Glauben ab. Bleib bei Bibellesen und Gebet dran, sonst verdrängt die Verwaltung deine geistliche Basis.",
        ),
        AutoExecuteModifier(
          intervalMs: 25000,
          modifiers: [
            MultiplyRes(targetResName: "Money", factorResName: "Member", multiplier: 0.05),
            // Der Abzug skaliert mit der Mitgliederzahl statt fest zu sein - eine größere Bewegung
            // erzeugt automatisch mehr Verwaltungsaufwand, der Aufmerksamkeit vom Glauben abzieht.
            SubtractRes(ressources: [Faith(value: 1.0, multiplierResourceName: "Member", multiplierValue: 0.025)]),
          ],
        ),
      ],
    ),
    Task(
      name: "Team geistlich begleiten",
      description: "WARTUNG: Investiere immer wieder Zeit in die geistliche Begleitung deiner hauptamtlichen "
          "Kraft. Das bringt bei jedem Mal einen kleinen Glaubenszufluss, der den automatischen "
          "Verwaltungsabzug teilweise ausgleicht - anders als der Abzug läuft dieser Zufluss NICHT von selbst "
          "weiter, du musst aktiv dranbleiben.",
      duration: 15000.0,
      cost: [Time(value: 3.0), Wisdom(value: 10.0)],
      award: [
        Wisdom(value: 10.0),
        Faith(value: 1.0, multiplierResourceName: "Member", multiplierValue: 0.018),
      ],
    ),
  ],
);
