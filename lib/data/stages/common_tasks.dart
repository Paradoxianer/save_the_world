import 'package:save_the_world_flutter_app/models/addtask.model.dart';
import 'package:save_the_world_flutter_app/models/faith.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/member.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/message.modifier.dart';
import 'package:save_the_world_flutter_app/models/money.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/publicity.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/removetask.model.dart';
import 'package:save_the_world_flutter_app/models/subtractres.model.dart';
import 'package:save_the_world_flutter_app/models/task.model.dart';
import 'package:save_the_world_flutter_app/models/time.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/wisdome.ressource.model.dart';

// --- LIBRARY EXPORT ---
final Task Schlafen = Task(
  name: "Schlafen",
  description: "Erholung für den Visionär.",
  duration: 8000.0,
  timeToSolve: Infinity,
  isMilestone: false,
  cost: [Time(value: 8.0)],
  award: [Time(value: 16.0)],
);

final Task Freizeit = Task(
  name: "Freizeit",
  description: "Kleine Pause zum Durchatmen.",
  duration: 20000.0,
  timeToSolve: Infinity,
  isMilestone: false,
  cost: [],
  award: [Time(value: 1.0)],
);

final Task Bibellesen = Task(
  name: "Bibellesen",
  description: "Geistliches Fundament vertiefen.",
  duration: 3000.0,
  timeToSolve: Infinity,
  isMilestone: false,
  cost: [Time(value: 1.0)],
  award: [Faith(value: 20.0), Wisdom(value: 10.0)],
);

final Task Kollekte = Task(
  name: "Kollekte",
  description: "Sammelt Spenden der Mitglieder. Skaliert mit Gemeindegröße.",
  duration: 3000.0,
  timeToSolve: Infinity,
  isMilestone: false,
  cost: [Time(value: 1.0)],
  award: [Money(value: 1.0, multiplierResourceName: "Member", multiplierValue: 0.5)],
);

final Task DerHeiligeGeistmöchtewirken = Task(
name: "Der Heilige Geist möchte wirken",
description: "KRITISCH: Gottes Wirken hat Vorrang!",
duration: 1000.0,
timeToSolve: 8000.0,
isMilestone: false,
cost: [],
award: [Faith(value: 50.0), Wisdom(value: 5.0)],
online: [MessageModifier(message: "GEISTLICH: Ein Moment der Gnade! Reagiere sofort.")],
missed: [// Unknown Modifier, MessageModifier(message: "Das Wirken Gottes wurde im Alltagsstress übersehen.")],
);

final Task Jemandmöchteheiraten = Task(
name: "Jemand möchte heiraten",
description: "Zwei Mitglieder kommen zu dir: Wir möchten heiraten!",
duration: 5000.0,
timeToSolve: 20000.0,
isMilestone: false,
cost: [Time(value: 0.5), Faith(value: 20.0)],
award: [],
modifier: [AddTask(task: "Ehevorbereitung 1"), RemoveTask(task: "Jemand möchte heiraten")],
);

final Task BeerdigungeinesGenerals = Task(
name: "Beerdigung eines Generals",
description: "KRITISCH: Ein prägender Leiter ist heimgegangen. Ehre sein Erbe.",
duration: 15000.0,
timeToSolve: 40000.0,
isMilestone: false,
cost: [Faith(value: 50.0), Wisdom(value: 50.0)],
award: [Faith(value: 100.0), Member(value: 1.0)],
online: [MessageModifier(message: "TRAUER: Ein wichtiger General der Armee ist verstorben.")],
missed: [// Unknown Modifier, MessageModifier(message: "Die Bewegung ist verunsichert. Der Glaube sinkt massiv.")],
);

final Task Ehevorbereitung1 = Task(
name: "Ehevorbereitung 1",
description: "Lasst uns über Kommunikation in der Ehe und zwischen Mann und Frau reden",
duration: 5000.0,
timeToSolve: Infinity,
isMilestone: false,
cost: [Time(value: 2.0), Wisdom(value: 10.0)],
award: [],
modifier: [AddTask(task: "Ehevorbereitung 2"), RemoveTask(task: "Ehevorbereitung 1")],
);

final Task Ehevorbereitung2 = Task(
name: "Ehevorbereitung 2",
description: "Lass uns über Konflikte zwischen Mann und Frau reden",
duration: 5000.0,
timeToSolve: Infinity,
isMilestone: false,
cost: [Time(value: 2.0), Wisdom(value: 10.0)],
award: [],
modifier: [AddTask(task: "Ehevorbereitung 3"), RemoveTask(task: "Ehevorbereitung 2")],
);

final Task Ehevorbereitung3 = Task(
name: "Ehevorbereitung 3",
description: "Lass uns über Verbindlichkeit reden.",
duration: 5000.0,
timeToSolve: Infinity,
isMilestone: false,
cost: [Money(value: 2.0), Wisdom(value: 15.0)],
award: [],
modifier: [AddTask(task: "Ehevorbereitung 4"), RemoveTask(task: "Ehevorbereitung 3")],
);

final Task Ehevorbereitung4 = Task(
name: "Ehevorbereitung 4",
description: "Lass uns über Verbundenheit reden",
duration: 5000.0,
timeToSolve: Infinity,
isMilestone: false,
cost: [Time(value: 2.0), Wisdom(value: 15.0)],
award: [],
modifier: [AddTask(task: "Ehevorbereitung 5"), RemoveTask(task: "Ehevorbereitung 4")],
);

final Task Ehevorbereitung5 = Task(
name: "Ehevorbereitung 5",
description: "Lass uns über Abenteuer in der Beziehung reden",
duration: 5000.0,
timeToSolve: Infinity,
isMilestone: false,
cost: [Time(value: 2.0), Wisdom(value: 10.0)],
award: [],
modifier: [AddTask(task: "Hochzeitsplanung"), RemoveTask(task: "Ehevorbereitung 5")],
);

final Task Hochzeitsplanung = Task(
name: "Hochzeitsplanung",
description: "...",
duration: 10000.0,
timeToSolve: Infinity,
isMilestone: false,
cost: [Time(value: 4.0), Wisdom(value: 20.0)],
award: [],
modifier: [RemoveTask(task: "Hochzeitsplanung"), AddTask(task: "Hochzeit")],
);

final Task Hochzeit = Task(
name: "Hochzeit",
description: "...",
duration: 5000.0,
timeToSolve: Infinity,
isMilestone: false,
cost: [Time(value: 6.0), Faith(value: 20.0)],
award: [Money(value: 0.0, multiplierResourceName: "Member", multiplierValue: 0.5), Wisdom(value: 0.0, multiplierResourceName: "Member", multiplierValue: 0.5), Publicity(value: 0.0, multiplierResourceName: "Member", multiplierValue: 0.5)],
modifier: [RemoveTask(task: "Hochzeit")],
);

