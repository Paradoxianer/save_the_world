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

final Stage stage12 = Stage(
  level: 12,
  member: 10000,
  description: "Beeinflussende Kirche Lvl. 2 - Dein Wirken prägt das Land.",
  activeTasks: [ "Bibellesen", "Beten",
    "Schlafen",
    "Regionalleiter einsetzen",
    "Leiter-Akademie gründen"
  ],
  randomTasks: [
    "Skandal in einem Land bedroht das globale Netzwerk",
    "Politischer Druck",
    "Der Heilige Geist möchte wirken",
  ],
  allTasks: [
    baseBible,
    basePrayer,
    baseSleep,
    holySpiritWorking,
    Task(
      name: "Regionalleiter einsetzen",
      description: "Ausgebildete Leiter aus den eigenen Schulen übernehmen Verantwortung für ihre Region - "
          "nicht als ferne Zentrale, sondern als Menschen, die vor Ort wirklich präsent sind.",
      duration: 30000.0,
      cost: [Money(value: 20000.0), Wisdom(value: 500.0)],
      award: [Wisdom(value: 200.0), Member(value: 0.5)],
      modifier: [
        MessageModifier(message: "STRUKTUR: Regionalleiter tragen jetzt Verantwortung vor Ort."),
        AddTask(task: "Ein Netzwerk aus Regionalleitern etablieren"),
      ],
    ),
    Task(
      name: "Leiter-Akademie gründen",
      description: "SYSTEM: Eine Akademie zur Ausbildung hochkarätiger Führungskräfte.",
      duration: 40000.0,
      cost: [Money(value: 80000.0), Wisdom(value: 1000.0)],
      modifier: [
        MessageModifier(message: "MULTIPLIKATION: Die Akademie generiert nun passiv Weisheit."),
        AutoExecuteModifier(
            intervalMs: 20000,
            modifiers: [
              MultiplyRes(targetResName: "Wisdom", factorResName: "Member", multiplier: 0.02),
            ]),
        RemoveTask(task: "Leiter-Akademie gründen"),
      ],
    ),
    Task(
      name: "Ein Netzwerk aus Regionalleitern etablieren",
      description: "MEILENSTEIN: Genug Regionen haben eigene, vertrauenswürdige Leiter - die Bewegung trägt "
          "sich nicht mehr nur zentral, sondern durch ein Netz von Menschen, die sich wirklich kennen "
          "(Limit 20.000).",
      duration: 60000.0,
      isMilestone: true,
      cost: [Money(value: 100000.0), Faith(value: 5000.0), Wisdom(value: 2000.0)],
      award: [Member(value: 1.0)],
      modifier: [
        SetMax(ressource: "Member", newMax: 20000.0),
        MessageModifier(
          message: "NÄHE TROTZ GRÖSSE: Regionalleiter halten die Bewegung persönlich zusammen. Limit auf "
              "20.000 erhöht.",
        ),
        RemoveTask(task: "Ein Netzwerk aus Regionalleitern etablieren"),
        AddTask(task: "Regionalleiter regelmäßig besuchen"),
        AddTask(task: "Für Regionalleiter beten"),
      ],
    ),
    Task(
      name: "Regionalleiter regelmäßig besuchen",
      description: "WARTUNG: Nicht nur einsetzen und vergessen - echte Besuche vor Ort halten die "
          "Beziehung lebendig und verhindern, dass Regionen sich selbst überlassen bleiben.",
      duration: 25000.0,
      cost: [Time(value: 6.0), Wisdom(value: 200.0)],
      award: [Faith(value: 100.0), Publicity(value: 50.0)],
    ),
    Task(
      name: "Für Regionalleiter beten",
      description: "WARTUNG: Besuche allein reichen nicht - im Gebet für die Regionalleiter einzustehen, "
          "trägt sie auch dann, wenn du nicht selbst vor Ort sein kannst.",
      duration: 10000.0,
      cost: [Time(value: 2.0), Faith(value: 20.0)],
      award: [Faith(value: 60.0), Wisdom(value: 20.0)],
    ),
    Task(
      name: "Politischer Druck",
      description: "KRISE: Neue Gesetze erschweren die Arbeit. Diplomatische Weisheit ist gefragt.",
      duration: 12000.0,
      timeToSolve: 50000.0,
      cost: [Wisdom(value: 800.0), Publicity(value: 500.0)],
      award: [Wisdom(value: 200.0)],
      modifier: [
        MessageModifier(message: "DIPLOMATISCH GELÖST: Der Druck von außen konnte abgewendet werden."),
        RemoveTask(task: "Politischer Druck"),
      ],
      missed: [
        SubtractRes(ressources: [Money(value: 10000.0), Publicity(value: 1000.0)]),
        MessageModifier(message: "REPRESSION: Juristische Folgen kosten Geld und Ansehen."),
        RemoveTask(task: "Politischer Druck"),
        AddTask(task: "Politischer Druck"),
      ],
    ),
    Task(
      name: "Skandal in einem Land bedroht das globale Netzwerk",
      description: "KRISE: Ein Fehlverhalten oder eine Kontroverse an einem einzelnen Standort verbreitet "
          "sich durch die internationale Vernetzung rasend schnell - und beschädigt den Ruf überall, "
          "unverhältnismäßig zur tatsächlichen Größe der Bewegung.",
      duration: 8000.0,
      timeToSolve: 30000.0,
      cost: [Wisdom(value: 600.0), Publicity(value: 2000.0)],
      award: [Wisdom(value: 100.0)],
      modifier: [
        MessageModifier(message: "EINGEDÄMMT: Offene Kommunikation hat verhindert, dass sich der Schaden ausbreitet."),
        RemoveTask(task: "Skandal in einem Land bedroht das globale Netzwerk"),
      ],
      missed: [
        SubtractRes(ressources: [Publicity(value: 5000.0), Faith(value: 1000.0)]),
        MessageModifier(message: "AUSGEBREITET: Ein lokaler Vorfall hat dem globalen Ruf massiv geschadet."),
        RemoveTask(task: "Skandal in einem Land bedroht das globale Netzwerk"),
        AddTask(task: "Skandal in einem Land bedroht das globale Netzwerk"),
      ],
    ),
  ],
);
