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

//Gottesdienst in der Wohnung sollte hier raus... hier sind wir schlielich  über 80 Personen
// es sollten noch als weiter Aufgaben praktisch alle von Stage 1 dazu kommen.. (evtl mit Ressourcenabhängigen  Ressourcen?)
// hier könnten w

final Stage stage2 = Stage(
  level: 2,
  member: 80,
  description: "Kleine Gemeinde - Es wird eng im Wohnzimmer.",
  activeTasks: ["Bibellesen", "Beten", "Schlafen", "Kollekte", "Gottesdienst in der Wohnung"],
  randomTasks: ["Rechnung nicht bezahlt"],
  allTasks: [
    Task(name: "Schlafen", duration: 8000.0, cost: [Time(value: 8.0)], award: [Time(value: 16.0)]),
    Task(name: "Bibellesen", duration: 3000.0, cost: [Time(value: 1.0)], award: [Faith(value: 15.0)]),
    Task(name: "Beten", duration: 4000.0, cost: [Time(value: 1.0)], award: [Faith(value: 15.0)]),
    Task(
      name: "Kollekte",
      description: "Regelmäßige Spenden der Mitglieder.",
      duration: 3000.0,
      cost: [Time(value: 1.0)],
      award: [
        Money(
          value: 1.0, 
          multiplierResourceName: "Member", 
          multiplierValue: 0.6
        )
      ],
    ),
    Task(
      name: "Gottesdienst in der Wohnung",
      description: "Ein festliches Treffen für alle.",
      duration: 5000.0,
      cost: [Time(value: 4.0), Faith(value: 20.0)],
      award: [Member(value: 3.0), Faith(value: 10.0)],
      modifier: [AddTask(task: "Saal suchen")],
    ),
    Task(
      name: "Saal suchen",
      description: "Besichtige mögliche Räumlichkeiten.",
      duration: 7000.0,
      cost: [Time(value: 3.0), Money(value: 50.0)],
      award: [Publicity(value: 2.0)],
      modifier: [AddTask(task: "Saal mieten")],
    ),
    Task(
      name: "Saal mieten",
      description: "MEILENSTEIN: Der erste eigene Raum! Erhöht Limit auf 140.",
      duration: 15000.0,
      isMilestone: true,
      cost: [Time(value: 2.0), Money(value: 200.0), Member(value: 30.0)],
      award: [Publicity(value: 15.0)],
      modifier: [
        MessageModifier(message: "STRUKTUR: Ein eigener Saal bietet Platz für viele neue Menschen (Limit 140)."),
        SetMax(ressource: "Member", newMax: 140.0),
        RemoveTask(task: "Saal mieten"),
        AddTask(task: "Saal instand halten"),
        AddTask(task: "Hauskreisleiter einsetzen"),
      ],
    ),
    Task(
      name: "Saal instand halten",
      description: "WARTUNG: Sorge für Sauberkeit und Technik in deinem neuen Raum.",
      duration: 10000.0,
      cost: [Time(value: 2.0), Money(value: 10.0)],
      award: [Wisdom(value: 2.0)],
    ),
    Task(
      name: "Hauskreisleiter einsetzen",
      description: "DELEGATION: Du gibst persönliche Kontakte ab und vertraust ehrenamtlichen Leitern eigene "
          "Kleingruppen an. Das entlastet dich strukturell - kostet dich aber automatisch etwas eigene Zeit mit "
          "Gott, solange die Leiter noch unerfahren sind. Der Abzug skaliert mit der Größe deiner Bewegung.",
      duration: 12000.0,
      once: true,
      cost: [Time(value: 4.0), Wisdom(value: 15.0), Faith(value: 10.0)],
      award: [Wisdom(value: 10.0), Member(value: 0.5)],
      modifier: [
        MessageModifier(
          message: "DELEGATION: Deine Kleingruppenleiter übernehmen jetzt eigenständig Verantwortung - aber "
              "unerfahren zieht das automatisch etwas Glauben ab. Schule sie, um das umzukehren!",
        ),
        AddTask(task: "Hauskreisleiter schulen"),
        AutoExecuteModifier(
          intervalMs: 25000,
          modifiers: [
            MultiplyRes(targetResName: "Member", factorResName: "Member", multiplier: 0.01),
            SubtractRes(ressources: [Faith(value: 1.0, multiplierResourceName: "Member", multiplierValue: 0.015)]),
          ],
        ),
      ],
    ),
    Task(
      name: "Hauskreisleiter schulen",
      description: "DELEGATION: Investiere immer wieder in die Ausbildung deiner Kleingruppenleiter. Gut "
          "geschulte Leiter geben selbst geistlich weiter - das bringt bei jeder Schulung einen kleinen "
          "Glaubenszufluss, der den automatischen Delegationsabzug teilweise ausgleicht. Anders als der Abzug "
          "läuft dieser Zufluss NICHT von selbst weiter - du musst aktiv dranbleiben.",
      duration: 14000.0,
      cost: [Time(value: 3.0), Wisdom(value: 10.0)],
      award: [
        Wisdom(value: 8.0),
        Faith(value: 1.0, multiplierResourceName: "Member", multiplierValue: 0.01),
      ],
    ),
    Task(
      name: "Rechnung nicht bezahlt",
      description: "KRITISCH: Bezahle sofort, um Mahngebühren zu vermeiden.",
      duration: 5000.0,
      timeToSolve: 45000.0,
      cost: [Money(value: 30.0)],
      modifier: [
        MessageModifier(message: "ERLEDIGT: Die Finanzen sind wieder im Reinen."),
        RemoveTask(task: "Rechnung nicht bezahlt"),
      ],
      missed: [
        SubtractRes(ressources: [Money(value: 50.0)]),
        MessageModifier(message: "MAHNUNG: Hohe Verzugsgebühren wurden abgezogen!"),
        RemoveTask(task: "Rechnung nicht bezahlt"),
        AddTask(task: "Rechnung nicht bezahlt"),
      ],
    ),
  ],
);
