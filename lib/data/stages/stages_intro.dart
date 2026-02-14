import 'package:flutter/material.dart';
import 'package:save_the_world_flutter_app/models/addres.model.dart';
import 'package:save_the_world_flutter_app/models/addtask.model.dart';
import 'package:save_the_world_flutter_app/models/faith.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/member.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/message.modifier.dart';
import 'package:save_the_world_flutter_app/models/modifier.model.dart';
import 'package:save_the_world_flutter_app/models/money.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/publicity.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/removetask.model.dart';
import 'package:save_the_world_flutter_app/models/ressource.model.dart';
import 'package:save_the_world_flutter_app/models/setmax.model.dart';
import 'package:save_the_world_flutter_app/models/stage.model.dart';
import 'package:save_the_world_flutter_app/models/subtractres.model.dart';
import 'package:save_the_world_flutter_app/models/task.model.dart';
import 'package:save_the_world_flutter_app/models/time.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/wisdome.ressource.model.dart';

final List<Stage> introStages = [
  // STAGE 0: Einstieg (Tutorial mit Snackbar-Begleitung)
  Stage(
    level: 0,
    member: 20,
    description: "Hausgemeinde - Ruhe finden, Gott suchen.",
    activeTasks: ["Bibellesen"],
    randomTasks: [],
    allTasks: [
      Task(
        name: "Bibellesen",
        description: "In der Stille auf Gottes Wort hören.",
        duration: 3000.0,
        cost: [Time(value: 1.0)],
        award: [Faith(value: 10.0), Wisdom(value: 5.0)],
        modifier: [
          AddTask(task: "Beten für andere"),
          MessageModifier(message: "Wunderbar! Durch Gottes Wort wächst dein Glaube. Jetzt kannst du für andere beten."),
        ],
      ),
      Task(
        name: "Beten für andere",
        description: "Die Anliegen deiner Mitmenschen vor Gott bringen.",
        duration: 4000.0,
        cost: [Time(value: 1.0)],
        award: [Faith(value: 5.0), Member(value: 0.2)],
        modifier: [
          AddTask(task: "Hausbesuch"),
          MessageModifier(message: "Dein Gebet zeigt Wirkung! Die ersten Menschen interessieren sich für deine kleine Gemeinde."),
        ],
      ),
      Task(
        name: "Hausbesuch",
        description: "Einfach mal vorbeischauen und zuhören.",
        duration: 6000.0,
        cost: [Time(value: 2.0), Faith(value: 10.0)],
        award: [Member(value: 0.5), Wisdom(value: 2.0)],
        modifier: [
          AddTask(task: "Schlafen"),
          AddTask(task: "Freizeit"),
          MessageModifier(message: "Persönliche Beziehungen sind das Fundament. Vergiss aber nicht, dich auch auszuruhen!"),
        ],
      ),
      Task(
        name: "Schlafen",
        description: "Neue Kraft tanken für den nächsten Tag.",
        duration: 10000.0,
        cost: [Time(value: 8.0)],
        award: [Time(value: 16.0)],
      ),
      Task(
        name: "Freizeit",
        description: "Durchatmen und die Schöpfung genießen.",
        duration: 9000.0,
        cost: [Publicity(value: 0.1)],
        award: [Time(value: 0.3)],
      ),
    ],
  ),

  // STAGE 1: Gemeinschaftsgruppe
  Stage(
    level: 1,
    member: 40,
    description: "Gemeinschaftsgruppe - Wir werden mehr.",
    activeTasks: ["Bibellesen", "Beten für andere", "Hausbesuch", "Schlafen", "Freizeit", "Kasse führen"],
    randomTasks: ["Rechnung nicht bezahlt", "Kassendifferenz finden"],
    allTasks: [
      Task(
        name: "Kasse führen",
        description: "Die ersten Spenden wollen ordentlich verwaltet werden.",
        duration: 4000.0,
        cost: [Time(value: 2.0)],
        award: [Money(value: 1.0)],
        modifier: [
          AddTask(task: "Gottesdienst vorbereiten"),
          MessageModifier(message: "Deine Gemeinde wächst! Zeit, den ersten Gottesdienst zu planen."),
        ],
      ),
      Task(
        name: "Gottesdienst vorbereiten",
        description: "Die Predigt vorbereiten.",
        duration: 8000.0,
        cost: [Time(value: 2.0), Faith(value: 100.0)],
        award: [Faith(value: 101.0)],
        modifier: [RemoveTask(task: "Gottesdienst vorbereiten"), AddTask(task: "Predigt schreiben")],
      ),
      Task(
        name: "Predigt schreiben",
        description: "Worte finden.",
        duration: 8000.0,
        cost: [Time(value: 8.0), Faith(value: 120.0)],
        award: [Member(value: 0.02), Faith(value: 70.0)],
        modifier: [RemoveTask(task: "Predigt schreiben"), AddTask(task: "Gottesdienst halten")],
      ),
      Task(
        name: "Gottesdienst halten",
        description: "Gemeinsam feiern.",
        duration: 4000.0,
        cost: [Member(value: 2.0), Time(value: 2.5), Faith(value: 200.0)],
        award: [Faith(value: 270.0), Member(value: 2.5), Money(value: 35.0)],
        modifier: [RemoveTask(task: "Gottesdienst halten"), AddTask(task: "Gottesdienst vorbereiten")],
      ),
      Task(
        name: "studieren",
        description: "man lernt was",
        cost: [Money(value: 200.0), Time(value: 8.0)],
        award: [Faith(value: 50.0), Wisdom(value: 50.0)],
      ),
    ],
  ),
];
