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

// --- BASIS TASKS ---
final Task baseSleep = Task(
  name: "Schlafen",
  description: "Erholung für den Visionär.",
  duration: 8000.0,
  cost: [Time(value: 8.0)],
  award: [Time(value: 24.0)],
);

final Task baseFreeTime = Task(
  name: "Freizeit",
  description: "Kleine Pause zum Durchatmen.",
  duration: 20000.0,
  cost: [],
  award: [Time(value: 1.0)],
);

/// Sicherheitsnetz ab Stage 2 (siehe Issue #82): Schlafen bleibt bewusst
/// riskant (kostet 8 Zeit) - wer nicht selbst aufpasst, kann unter diese
/// Schwelle fallen und sich nicht mehr freischlafen. Diese Aufgabe ist der
/// Ausweg: kostenlos, aber quälend langsam, damit Zeit-Mismanagement echte
/// Konsequenzen (Stress/Zeitverlust) hat statt risikofrei zu sein. Wird nur
/// EINMAL in Stage 2 aktiv eingeführt und vererbt sich von da an automatisch
/// in jede folgende Stufe weiter (siehe initStage()-Vererbungsprinzip).
/// Spätere Erweiterung: per Rewarded-Ad Zeit dazukaufen (siehe Issue #59).
final Task burnoutRecovery = Task(
  name: "Vom Burnout erholen",
  description: "Du hast dich komplett verausgabt. Es dauert quälend lange, aber ganz langsam kehrt etwas Kraft zurück.",
  duration: 60000.0,
  cost: [],
  award: [Time(value: 4.0)],
);

final Task baseBible = Task(
  name: "Bibellesen",
  description: "Geistliches Fundament vertiefen.",
  duration: 3000.0,
  cost: [Time(value: 1.0)],
  award: [Faith(value: 20.0), Wisdom(value: 10.0)],
);

/// Gehört wie baseBible in JEDE Stage als aktive Kernaufgabe. Organisation
/// (Delegation, Hauptamtliche, Automatisierung) zieht automatisch Glauben ab
/// - Bibellesen und Beten sind der einzige manuelle Gegen-Hebel, den der
/// Spieler dafür in der Hand hat. Ohne beide in jeder Stage wäre der
/// automatische Glaubensabzug nicht gegensteuerbar.
final Task basePrayer = Task(
  name: "Beten",
  description: "Im Gebet für die Bewegung eintreten - das geistliche Fundament, das keine Organisation ersetzt.",
  duration: 4000.0,
  cost: [Time(value: 1.0)],
  award: [Faith(value: 15.0)],
);

// --- FINANZEN ---
final Task collectMoney = Task(
  name: "Kollekte",
  description: "Sammelt Spenden der Mitglieder. Skaliert mit Gemeindegröße.",
  duration: 3000.0,
  cost: [Time(value: 1.0)],
  award: [
    Money(
      value: 1.0, 
      multiplierResourceName: "Member", 
      multiplierValue: 0.5
    )
  ],
);

// --- KRISEN & SPIRITUALITÄT ---
final Task holySpiritWorking = Task(
  name: "Der Heilige Geist möchte wirken",
  description: "Gottes Wirken hat Vorrang!",
  duration: 1000.0,
  timeToSolve: 8000.0,
  award: [Faith(value: 50.0), Wisdom(value: 5.0)],
  online: [MessageModifier(message: "GEISTLICH: Ein Moment der Gnade! Reagiere sofort.")],
  missed: [
    SubtractRes(ressources: [Faith(value: 20.0)]),
    MessageModifier(message: "Das Wirken Gottes wurde im Alltagsstress übersehen."),
  ],
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

// --- HOCHZEITS-QUESTREIHE ---

final Task Jemandmchteheiraten = Task(
  name: "Jemand möchte heiraten",
  description: "Zwei Mitglieder kommen zu dir: Wir möchten heiraten!",
  duration: 5000.0,
  timeToSolve: 20000.0,
  isMilestone: false,
  cost: [Time(value: 0.5), Wisdom(value: 20.0)],
  award: [],
  modifier: [AddTask(task: "Ehevorbereitung 1"), RemoveTask(task: "Jemand möchte heiraten")],
  online: [MessageModifier(message: "FREUDE: Ein Paar aus der Gemeinde möchte heiraten!")],
);

final Task Ehevorbereitung1 = Task(
  name: "Ehevorbereitung 1",
  description: "Lass uns über Kommunikaton zwischen Mann und Frau in der Ehe reden.",
  duration: 5000.0,
  isMilestone: false,
  cost: [Time(value: 2.0)],
  award: [Wisdom(value: 2.0)],
  modifier: [AddTask(task: "Ehevorbereitung 2"), RemoveTask(task: "Ehevorbereitung 1")],
);

final Task Ehevorbereitung2 = Task(
  name: "Ehevorbereitung 2",
  description: "Lass uns über Konflikte in der Ehe reden",
  duration: 5000.0,
  isMilestone: false,
  cost: [Time(value: 2.0)],
  award: [Wisdom(value: 2.0)],
  modifier: [AddTask(task: "Ehevorbereitung 3"), RemoveTask(task: "Ehevorbereitung 2")],
);

final Task Ehevorbereitung3 = Task(
  name: "Ehevorbereitung 3",
  description: "Lass uns über Verbindlichkeit reden",
  duration: 5000.0,
  isMilestone: false,
  cost: [Time(value: 2.0)],
  award: [Wisdom(value: 2.0)],
  modifier: [AddTask(task: "Ehevorbereitung 4"), RemoveTask(task: "Ehevorbereitung 3")],
);

final Task Ehevorbereitung4 = Task(
  name: "Ehevorbereitung 4",
  description: "Lass uns über Verbundenheit reden",
  duration: 5000.0,
  isMilestone: false,
  cost: [Time(value: 2.0)],
  award: [Wisdom(value: 2.0)],
  modifier: [AddTask(task: "Ehevorbereitung 5"), RemoveTask(task: "Ehevorbereitung 4")],
);

final Task Ehevorbereitung5 = Task(
  name: "Ehevorbereitung 5",
  description: "Lass uns über Abenteuer in der Ehe sprechen",
  duration: 5000.0,
  isMilestone: false,
  cost: [Time(value: 2.0)],
  award: [Wisdom(value: 2.0)],
  modifier: [AddTask(task: "Hochzeitsvorbereitung"), RemoveTask(task: "Ehevorbereitung 5")],
);

final Task Hochzeitsvorbereitung = Task(
  name: "Hochzeitsvorbereitung",
  description: "Lass uns über die Hochzeitszeremoine sprechen",
  duration: 5000.0,
  isMilestone: false,
  cost: [Time(value: 2.0)],
  award: [Wisdom(value: 2.0)],
  modifier: [AddTask(task: "Hochzeit"), RemoveTask(task: "Hochzeitsvorbereitung")],
);

/// Komplette Hochzeits-Questreihe. Eine Stage, die "Jemand möchte heiraten"
/// in randomTasks führt, MUSS diese Liste per Spread in allTasks aufnehmen,
/// sonst bricht die Chain ab: `...weddingQuestline,`
final List<Task> weddingQuestline = [
  Jemandmchteheiraten,
  Ehevorbereitung1,
  Ehevorbereitung2,
  Ehevorbereitung3,
  Ehevorbereitung4,
  Ehevorbereitung5,
  Hochzeitsvorbereitung,
  Hochzeit,
];

final Task Hochzeit = Task(
  name: "Hochzeit",
  description: "Endlich ist es soweit",
  duration: 5000.0,
  isMilestone: false,
  cost: [Time(value: 4.0), Faith(value: 2.0, multiplierResourceName: "Member", multiplierValue: 1.0)],
  award: [Money(value: 0.0, multiplierResourceName: "Member", multiplierValue: 2.0), Publicity(value: 0.0, multiplierResourceName: "Member", multiplierValue: 2.0), Member(value: 0.0, multiplierResourceName: "Member", multiplierValue: 0.05)],
  modifier: [RemoveTask(task: "Hochzeit")],
);