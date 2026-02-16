import 'package:save_the_world_flutter_app/models/addtask.model.dart';
import 'package:save_the_world_flutter_app/models/faith.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/member.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/message.modifier.dart';
import 'package:save_the_world_flutter_app/models/money.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/multiplyres.model.dart';
import 'package:save_the_world_flutter_app/models/publicity.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/subtractres.model.dart';
import 'package:save_the_world_flutter_app/models/task.model.dart';
import 'package:save_the_world_flutter_app/models/time.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/wisdome.ressource.model.dart';

// --- BASIS TASKS ---
final Task baseSleep = Task(
  name: "Schlafen",
  description: "Erholung für den Visionär.",
  duration: 8000.0,
  cost: [Time(value: 8.0)],
  award: [Time(value: 16.0)],
);

final Task baseBible = Task(
  name: "Bibellesen",
  description: "Geistliches Fundament vertiefen.",
  duration: 3000.0,
  cost: [Time(value: 1.0)],
  award: [Faith(value: 20.0), Wisdom(value: 10.0)],
);

// --- FINANZEN ---
final Task collectMoney = Task(
  name: "Kollekte",
  description: "Sammelt Spenden der Mitglieder. Skaliert mit Gemeindegröße.",
  duration: 3000.0,
  cost: [Time(value: 1.0)],
  modifier: [
    MultiplyRes(targetResName: "Money", factorResName: "Member", multiplier: 0.5),
  ],
);

// --- KRISEN & SPIRITUALITÄT ---
final Task holySpiritWorking = Task(
  name: "Der Heilige Geist möchte wirken",
  description: "KRITISCH: Gottes Wirken hat Vorrang!",
  duration: 1000.0,
  timeToSolve: 8000.0,
  award: [Faith(value: 50.0), Wisdom(value: 5.0)],
  online: [MessageModifier(message: "GEISTLICH: Ein Moment der Gnade! Reagiere sofort.")],
  missed: [
    SubtractRes(ressources: [Faith(value: 20.0)]),
    MessageModifier(message: "Das Wirken Gottes wurde im Alltagsstress übersehen."),
  ],
);

// --- HOCHZEITS-QUESTREIHE (ZENTRAL) ---
final Task weddingPhase1 = Task(
  name: "Heiratsvorbereitung 1",
  description: "In einer Beziehung muss man richtig streiten und versöhnen lernen.",
  duration: 10000.0,
  cost: [Time(value: 1.5), Faith(value: 50.0), Wisdom(value: 50.0)],
  award: [Faith(value: 60.0), Wisdom(value: 60.0)],
  modifier: [AddTask(task: "Heiratsvorbereitung 2")],
);

final Task weddingPhase2 = Task(
  name: "Heiratsvorbereitung 2",
  description: "Ihr müsst verstehen, man tickt unterschiedlich in einer Beziehung.",
  duration: 10000.0,
  cost: [Time(value: 1.5), Faith(value: 50.0), Wisdom(value: 50.0)],
  modifier: [AddTask(task: "Hochzeit")],
);

final Task actualWedding = Task(
  name: "Hochzeit",
  description: "Sie dürfen die Braut jetzt küssen!",
  duration: 10000.0,
  cost: [Time(value: 3.0), Faith(value: 50.0), Wisdom(value: 50.0)],
  award: [Member(value: 0.5), Faith(value: 100.0), Wisdom(value: 60.0), Money(value: 200.0)],
);

final Task someoneWantsToMarry = Task(
  name: "Jemand möchte heiraten",
  description: "Zwei Mitglieder kommen zu dir: Wir möchten heiraten!",
  duration: 5000.0,
  timeToSolve: 20000.0,
  cost: [Time(value: 0.5), Wisdom(value: 20.0)],
  online: [MessageModifier(message: "FREUDE: Ein Paar aus der Gemeinde möchte heiraten!")],
  modifier: [AddTask(task: "Heiratsvorbereitung 1")],
);

// --- TODESFALL-QUESTREIHE ---
final Task funeralGeneral = Task(
  name: "Beerdigung eines Generals",
  description: "KRITISCH: Ein prägender Leiter ist heimgegangen. Ehre sein Erbe.",
  duration: 15000.0,
  timeToSolve: 40000.0,
  cost: [Faith(value: 50.0), Wisdom(value: 50.0)],
  award: [Faith(value: 100.0), Member(value: 1.0)],
  online: [MessageModifier(message: "TRAUER: Ein wichtiger General der Armee ist verstorben.")],
  missed: [
    SubtractRes(ressources: [Faith(value: 100.0)]),
    MessageModifier(message: "Die Bewegung ist verunsichert. Der Glaube sinkt massiv."),
  ],
);
