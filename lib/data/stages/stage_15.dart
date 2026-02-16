import 'package:save_the_world_flutter_app/models/message.modifier.dart';
import 'package:save_the_world_flutter_app/models/money.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/publicity.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/stage.model.dart';
import 'package:save_the_world_flutter_app/models/setmax.model.dart';
import 'package:save_the_world_flutter_app/models/task.model.dart';
import 'package:save_the_world_flutter_app/models/time.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/wisdome.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/member.ressource.model.dart';
import 'package:save_the_world_flutter_app/data/stages/common_tasks.dart';

final Stage stage15 = Stage(
  level: 15,
  member: 100000,
  description: "Eine Bewegung Level 2 - Ausbildung und globale Verwaltung.",
  activeTasks: ["Bibellesen", "Kollekte", "Globale Leiter-Akademie", "Internationale Verwaltung"],
  randomTasks: ["Beerdigung eines Generals", "Der Heilige Geist möchte wirken"],
  allTasks: [
    baseBible,
    baseSleep,
    collectMoney,
    holySpiritWorking,
    funeralGeneral,
    Task(
      name: "Globale Leiter-Akademie",
      description: "DNA-Transfer im großen Stil. Hunderte neue Offiziere (Inspiration: Tabelle).",
      duration: 60000.0,
      cost: [Money(value: 100000.0), Time(value: 20.0), Wisdom(value: 1000.0)],
      award: [Wisdom(value: 2000.0), Member(value: 1000.0)],
    ),
    Task(
      name: "Internationale Verwaltung professionalisieren",
      description: "MEILENSTEIN: Effizienz für den Sprung auf 250.000.",
      duration: 70000.0,
      cost: [Money(value: 200000.0), Wisdom(value: 3000.0)],
      modifier: [
        MessageModifier(message: "STRUKTUR: Euer globales Netzwerk ist stabil. Limit 250.000!"),
        SetMax(ressource: "Member", newMax: 250000.0),
      ],
    ),
  ],
);
