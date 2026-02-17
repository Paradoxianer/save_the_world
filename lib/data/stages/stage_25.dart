import 'package:save_the_world_flutter_app/models/autoexecute.model.dart';
import 'package:save_the_world_flutter_app/models/faith.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/member.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/message.modifier.dart';
import 'package:save_the_world_flutter_app/models/money.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/multiplyres.model.dart';
import 'package:save_the_world_flutter_app/models/publicity.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/stage.model.dart';
import 'package:save_the_world_flutter_app/models/setmax.model.dart';
import 'package:save_the_world_flutter_app/models/task.model.dart';
import 'package:save_the_world_flutter_app/models/time.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/wisdome.ressource.model.dart';
import 'package:save_the_world_flutter_app/data/stages/common_tasks.dart';

final Stage stage25 = Stage(
  level: 25,
  member: 60000000,
  description: "Globaler Beeinflusser Level 2 - Strategische Welt-Allianz.",
  activeTasks: ["Bibellesen", "Kollekte", "Finanz-Stiftung (Endowment)", "Strategisches Mentoring (Exponential)"],
  randomTasks: ["Der Heilige Geist möchte wirken", "Diplomatische Krise in einem Schurkenstaat", "Theologische Grundsatzfrage (Krise)"],
  allTasks: [
    baseBible,
    baseSleep,
    collectMoney,
    holySpiritWorking,
    funeralGeneral,
    Task(
      name: "Kollekte",
      duration: 3000.0,
      cost: [Time(value: 1.0)],
      modifier: [MultiplyRes(targetResName: "Money", factorResName: "Member", multiplier: 80.0)],
    ),
    Task(
      name: "Finanz-Stiftung (Endowment)",
      description: "Kapitalanlage der Weltkirche. Das Geld arbeitet passiv für die Mission.",
      duration: 250000.0,
      cost: [Money(value: 100000000.0), Wisdom(value: 40000.0)],
      modifier: [
        AutoExecuteModifier(
          intervalMs: 120000,
          modifiers: [
            // Zinseszinseffekt: Kapital generiert neues Geld
            MultiplyRes(targetResName: "Money", factorResName: "Money", multiplier: 0.05),
            MessageModifier(message: "STIFTUNG: Eure Rücklagen haben Dividenden ausgeschüttet."),
          ]
        ),
      ],
    ),
    Task(
      name: "Strategisches Mentoring (Exponential)",
      description: "Höchste Stufe der Jüngerschaft. Multiplikation der Leiter in Lichtgeschwindigkeit.",
      duration: 180000.0,
      cost: [Wisdom(value: 50000.0), Faith(value: 20000.0)],
      modifier: [
        AutoExecuteModifier(
          intervalMs: 20000,
          modifiers: [
            // Exponentielles Wachstum: 0,8% Zuwachs alle 20 Sek.
            MultiplyRes(targetResName: "Member", factorResName: "Member", multiplier: 0.008),
          ]
        ),
      ],
    ),
    Task(
      name: "Anerkennung als Weltorganisation",
      description: "MEILENSTEIN: Status als unverzichtbare globale Instanz (Limit 120.000.000).",
      duration: 400000.0,
      cost: [Wisdom(value: 80000.0), Time(value: 150.0), Faith(value: 50000.0)],
      modifier: [
        MessageModifier(message: "WELTMACHT: Eure Allianz ist nun ein globaler Player. Limit 120.000.000!"),
        SetMax(ressource: "Member", newMax: 120000000.0),
      ],
    ),
  ],
);
