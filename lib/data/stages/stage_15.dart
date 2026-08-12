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

final Stage stage15 = Stage(
  level: 15,
  member: 100000,
  description: "Globale Bewegung Level 1 - Die Stimme in der Weltgesellschaft.",
  activeTasks: [
    "Bibellesen", "Beten",
    "Schlafen",
    "Kollekte",
    "Weltweite Kampagne planen",
    "Zur Aktivistenorganisation werden"
  ],
  randomTasks: [
    "Korruption durch das große Geld",
    "Wer sind wir eigentlich noch?",
    "Der Heilige Geist möchte wirken"
  ],
  allTasks: [
    baseBible,
    basePrayer,
    baseSleep,
    collectMoney,
    holySpiritWorking,
    Task(
      name: "Weltweite Kampagne planen",
      description: "BEFÄHIGUNG: Vorbereitung einer globalen Aktion für Gerechtigkeit.",
      duration: 30000.0,
      cost: [Wisdom(value: 1000.0), Publicity(value: 500.0)],
      award: [Wisdom(value: 200.0)],
      modifier: [
        AddTask(task: "Weltweite Kampagne starten"),
        RemoveTask(task: "Weltweite Kampagne planen"),
      ],
    ),
    Task(
      name: "Weltweite Kampagne starten",
      description: "MEILENSTEIN: Ein globales Signal, das Millionen erreicht (Limit 250.000).",
      duration: 80000.0,
      isMilestone: true,
      cost: [Money(value: 1000000.0), Publicity(value: 5000.0), Faith(value: 2000.0)],
      award: [Member(value: 1.0)],
      modifier: [
        MessageModifier(message: "IMPULS: Die Welt hat zugehört. Die Bewegung wächst! Limit 250.000."),
        SetMax(ressource: "Member", newMax: 250000.0),
        RemoveTask(task: "Weltweite Kampagne starten"),
        AddTask(task: "Globale Anliegen vertreten"),
      ],
    ),
    Task(
      name: "Zur Aktivistenorganisation werden",
      description: "VERSUCHUNG: Die Bewegung könnte sich als säkulare Aktivistenorganisation neu "
          "aufstellen - Geld und Aufmerksamkeit strömen dann in einem Maß, das mit geistlicher Arbeit "
          "kaum zu erreichen wäre. Der Preis läuft dauerhaft mit: Glaube blutet aus, solange diese "
          "Ausrichtung besteht.",
      duration: 30000.0,
      cost: [Time(value: 6.0), Publicity(value: 500.0)],
      award: [Money(value: 300000.0), Publicity(value: 2000.0)],
      modifier: [
        MessageModifier(message: "KURSWECHSEL: Die Bewegung tritt jetzt öffentlich als Aktivistenorganisation auf."),
        AutoExecuteModifier(
          intervalMs: 15000,
          modifiers: [
            MultiplyRes(targetResName: "Money", factorResName: "Member", multiplier: 0.05),
            MultiplyRes(targetResName: "Publicity", factorResName: "Member", multiplier: 0.02),
            SubtractRes(ressources: [Faith(value: 500.0)]),
          ],
        ),
        RemoveTask(task: "Zur Aktivistenorganisation werden"),
      ],
    ),
    Task(
      name: "Globale Anliegen vertreten",
      description: "WARTUNG: Stetige Arbeit an den Zielen der Bewegung.",
      duration: 30000.0,
      cost: [Time(value: 4.0), Wisdom(value: 500.0)],
      award: [Publicity(value: 200.0), Faith(value: 100.0)],
    ),
    Task(
      name: "Korruption durch das große Geld",
      description: "KRISE: Die automatisch fließenden Summen wecken Begehrlichkeiten - Vorwürfe, dass sich "
          "Führungskräfte bereichern oder Mittel zweckentfremdet werden, machen die Runde. Nur echte "
          "Transparenz kann das Vertrauen wiederherstellen.",
      duration: 20000.0,
      timeToSolve: 60000.0,
      cost: [Wisdom(value: 1500.0), Faith(value: 500.0)],
      award: [Wisdom(value: 200.0)],
      modifier: [
        MessageModifier(message: "OFFENGELEGT: Volle Transparenz über alle Mittel stellt das Vertrauen wieder her."),
        RemoveTask(task: "Korruption durch das große Geld"),
      ],
      missed: [
        SubtractRes(ressources: [Money(value: 100000.0), Publicity(value: 5000.0), Faith(value: 300.0)]),
        MessageModifier(message: "SKANDAL: Berichte über Misswirtschaft schockieren Öffentlichkeit und eigene Leute."),
        RemoveTask(task: "Korruption durch das große Geld"),
        AddTask(task: "Finanzielle Transparenz schaffen"), // Folge-Task bei Misserfolg
      ],
    ),
    Task(
      name: "Finanzielle Transparenz schaffen",
      description: "FOLGE-KRISE: Repariere den Vertrauensschaden mit offengelegten Finanzberichten und "
          "unabhängiger Prüfung.",
      duration: 25000.0,
      cost: [Money(value: 50000.0), Wisdom(value: 1000.0)],
      modifier: [
        RemoveTask(task: "Finanzielle Transparenz schaffen"),
      ],
    ),
    Task(
      name: "Wer sind wir eigentlich noch?",
      description: "KRISE: Mitglieder und die eigene Basis fragen offen, ob die Bewegung noch für Jesus "
          "steht - oder nur noch eine gut vermarktete NGO mit Spiritualitäts-Anstrich ist. Nur geistliche "
          "Klarheit, kein PR-Statement, kann diese Frage beantworten.",
      duration: 18000.0,
      timeToSolve: 55000.0,
      cost: [Time(value: 10.0), Faith(value: 300.0)],
      award: [Faith(value: 150.0)],
      modifier: [
        MessageModifier(message: "NEU AUSGERICHTET: Die Bewegung besinnt sich glaubwürdig auf ihren Ursprung."),
        RemoveTask(task: "Wer sind wir eigentlich noch?"),
      ],
      missed: [
        SubtractRes(ressources: [Faith(value: 800.0), Member(value: 5000.0)]),
        MessageModifier(message: "ENTFREMDET: Enttäuschte Mitglieder wenden sich ab - die Bewegung hat ihre Mitte verloren."),
        RemoveTask(task: "Wer sind wir eigentlich noch?"),
        AddTask(task: "Wer sind wir eigentlich noch?"),
      ],
    ),
  ],
);
