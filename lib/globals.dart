import 'package:save_the_world_flutter_app/models/addtask.model.dart';
import 'package:save_the_world_flutter_app/models/faith.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/member.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/modifier.model.dart';
import 'package:save_the_world_flutter_app/models/money.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/publicity.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/removetask.model.dart';
import 'package:save_the_world_flutter_app/models/ressource.model.dart';
import 'package:save_the_world_flutter_app/models/subtractres.model.dart';
import 'package:save_the_world_flutter_app/models/task.model.dart';
import 'package:save_the_world_flutter_app/models/time.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/wisdome.ressource.model.dart';

final List<String> credit = <String>[
  "Icon made by freepik from www.flaticon.com",
  "Icon made by becris from www.flaticon.com",
  "Icon made by fjstudio from www.flaticon.com"
];

final Map<int, String> levels = {
  20: "Hausgemeinde",
  40: "Gemeinschaftsgruppe",
  80: "Kleine Gemeinde",
  140: "Mittlere Gemeinde",
  200: "Mittelgroße Gemeinde",
  400: "Große Gemeinde",
  600: "Sehr große Gemeinde",
  800: "Fast eine MegaChurch",
  1100: "MegaChurch Level 1",
  1800: "MegaChurch Level 2",
  2800: "MegaChurch Level 3",
  4500: "Beeinflussende Kirche Level 1",
  10000: "Beeinflussende Kirche Level 2",
  20000: "Beeinflussende Kirche Level 3",
  50000: "Eine Bewegung Level 1",
  100000: "Eine Bewegung Level 2",
  250000: "Eine Bewegung Level 3",
  500000: "Globale Bewegung Level 1",
  1000000: "Globale Bewegung Level 2",
  1500000: "Globale Bewegung Level 3",
  2500000: "Globale Größe Level 1",
  5000000: "Globale Größe Level 2",
  7500000: "Globale Größe Level 3",
  10000000: "Globaler Beeinflusser Level 1",
  20000000: "Globaler Beeinflusser Level 2",
  40000000: "Globaler Beeinflusser Level 3",
  80000000: "Denomination Level 1",
  160000000: "Denomination Level 2",
  320000000: "Denomination Level 3",
  1280000000: "Weltkirche Level 1",
  2560000000: "Weltkirche Level 2",
  5120000000: "Weltkirche Level 3",
  7600000000: "Du hast die Welt gerettet - Jesus kommt wieder - YEAH"
};

final List<Task> testTasks = <Task>[
  Task(
    name: "Ein zwischenmenschliches Problem klären",
    description: "Ein Gemeindemitglied kommt zu dir: Ich bin soooo sauer!!!!!!",
    cost: [Time(value: 3.0), Wisdom(value: 100.0)],
    award: [Member(value: 0.25), Wisdom(value: 101.0)],
    duration: 6000.0,
    timeToSolve: 6000.0,
    modifier: [
      RemoveTask(task: "Ein zwischenmenschliches Problem klären")
    ],
    missed: [
      RemoveTask(task: "Ein zwischenmenschliches Problem klären"),
      SubtractRes(ressources: [Member(value: 0.5)]),
      AddTask(task: "Ein zwischenmenschliches Problem klären")
    ],
  ),
  Task(
      name: "Gottesdienst vorbereiten",
      description:
      "dann muss noch die Predigt vorbereitet werden aber bald gibt es einen Gottesdienst",
      cost: [Time(value: 1.0), Faith(value: 100.0)],
      award: [Faith(value: 101.0)],
      duration: 8000.0,
      modifier: [
        AddTask(task: "Predigt schreiben"),
        RemoveTask(task: "Gottesdienst vorbereiten")
      ]),
  Task(
    name: "studieren",
    description: "man lernt was",
    cost: [
      Money(value: 200.0),
      Time(value: 8.0),
    ],
    award: [
      Faith(value: 50.00),
      Wisdom(value: 50.0),
    ],
  ),
  Task(
    name: "Wirtschaftsmission",
    description: "durch die Kneipen ziehen und Geld sammeln",
    cost: [
      Money(value: 20.0),
      Time(value: 4.5),
    ],
    award: [
      Money(value: 100.00),
      Publicity(value: 1.0),
    ],
  ),
  Task(
    name: "Beten für andere",
    description: "wenn du für andere betest, dann passiert was",
    cost: [
      Time(value: 1.0),
    ],
    award: [
      Faith(value: 1.0),
      Member(value: 0.10),
    ],
  ),
  Task(
      name: "Kasse führen",
      description: "die Kasse die muss in Ordnung sein",
      cost: [Time(value: 2.0)],
      award: [
        Money(value: 0.10),
      ],
      duration: 4000.0,
      timeToSolve: 100000.0,
      modifier: [
        AddTask(task: "Buchen"),
        RemoveTask(task: "Kasse führen")
      ]),
  Task(
      name: "Korps aufräumen",
      description:
      "immer schön Ordnung schaffen. Wenn nicht gibt ein Problem mit den Mitgliedern :)",
      cost: [Time(value: 1.0)],
      award: [],
      timeToSolve: 70000.0,
      duration: 20000.0,
      missed: [
        AddTask(task: "Ein zwischenmenschliches Problem klären"),
        RemoveTask(task: "Korps aufräumen"),
        AddTask(task: "Korps aufräumen"),
      ],
      modifier: [
        AddTask(task: "Korps fegen und putzen"),
        RemoveTask(task: "Korps aufräumen")
      ]
  ),
  Task(
    name: "Seelsorge",
    description: "Pastor... ich hab da ein Problem",
      cost: [Time(value: 1.0), Wisdom(value: 1.0)],
      award: [Wisdom(value: 2.0), Member(value: 0.25)],
      modifier: [
        RemoveTask(task: "Seelsorge"),
        AddTask(task: "Seelsorge"),
      ]
  ),
  Task(
      name: "Bibellesen",
      description: "Zeit mit Gott",
      cost: [
        Time(value: 1.0),
      ],
      award: [Faith(value: 5.0), Wisdom(value: 2.0)],
      duration: 2000.0),
  Task(
      name: "Mails...",
      description: "Sie haben Post",
      cost: [Time(value: 1.0)],
      award: [],
      timeToSolve: 90000.0,
      duration: 2000.0,
      missed: [
        RemoveTask(task: "Mails..."),
        AddTask(task: "Mails..."),
        AddTask(task: "Rechnung nicht bezahlt")
      ],
      modifier: [
        AddTask(task: "Mails beantworten"),
        RemoveTask(task: "Mails...")
      ]
  ),
  Task(
      name: "schlafen",
      description:
      "Sollte man auch mal tun... das Gehirn benötig 8 Stunden Schlaf um \"schlauer zu werden\"",
      cost: [Time(value: 8.0)],
      award: [Time(value: 16.0)],
      duration: 16000.0),
  Task(
      name: "die Nacht durcharbeiten",
      description:
      "Ahhhh.... ich muss noch so viel machen... ich brauche mehr Zeit",
      cost: [
        Faith(value: 5.0),
        Wisdom(value: 10.0),
        Publicity(value: 10.0),
      ],
      award: [Time(value: 6.0)],
      duration: 8000.0),
  Task(
      name: "Spender anschreiben",
      description: "vielleicht bringt ja ein netter Brief was",
      cost: [Time(value: 4.0), Faith(value: 50.0)],
      award: [Faith(value: 40.0), Money(value: 10.0)],
      duration: 8000.0),
  Task(
      name: "Einen Basar planen",
      description:
      "hmm ein Basar spült vielleicht ein bisschen Geld in die Kasse",
      cost: [
        Time(value: 3.0),
        Faith(value: 10.0),
        Wisdom(value: 2.0)
      ],
      award: [Faith(value: 8.0)],
      duration: 6000.0,
      modifier: [
        AddTask(task: "Alle für den Basar anfragen"),
        RemoveTask(task: "Einen Basar planen")
      ]),
  Task(
      name: "Freizeit",
      description:
      "du hast echt zu viel gearbeitet... jetzt musst du ersteinmal warten...",
      cost: [],
      award: [Time(value: 0.3)],
      duration: 9000.0)
];

final List<Task> onHoldTaks = <Task>[
  Task(
      name: "Predigt schreiben",
      description:
      "wenn du eine Predigt geschrieben hast... kannst du auch eine halten :-D",
      cost: [Time(value: 8.0), Faith(value: 100.0)],
      award: [Member(value: 0.02), Faith(value: 60.0)],
      duration: 8000.0,
      modifier: [
        AddTask(task: "Gottesdienst halten"),
        RemoveTask(task: "Predigt schreiben")
      ]),
  Task(
      name: "Gottesdienst halten",
      description: "schön mit Predigt, Lieder und natürlich Bibellesen",
      cost: [
        Member(value: 2.0),
        Time(value: 2.0),
        Faith(value: 200.0)
      ],
      award: [
        Faith(value: 250.0),
        Member(value: 2.5),
        Money(value: 20.0)
      ],
      duration: 4000.0,
      modifier: [
        RemoveTask(task: "Gottesdienst halten"),
        AddTask(task: "Gottesdienst vorbereiten")
      ]),
  Task(
      name: "Rechnung nicht bezahlt",
      description: "ohoh du hast wohl die Rechnung nicht bezahlt",
      cost: [
        Money(value: 25.0),
      ],
      award: [Wisdom(value: 1.0)],
      duration: 10000.0,
      timeToSolve: 60000.0,
      modifier: [RemoveTask(task: "Rechnung nicht bezahlt")],
      missed: [
        AddTask(task: "Rechnung nicht bezahlt"),
        SubtractRes(ressources: [Money(value: 5.0)])
      ]),
  Task(
      name: "Buchen",
      description: "alle Ein und Ausgaben immer schön buchen",
      cost: [
        Time(value: 0.5),
      ],
      award: [Wisdom(value: 0.01), Publicity(value: 0.01)],
      timeToSolve: 100000.0,
      duration: 1000.0,
      modifier: [
        AddTask(task: "Abrechnung"),
        RemoveTask(task: "Buchen")
      ]),
  Task(
      name: "Abrechnung",
      description: "muss auch stimmen",
      cost: [
        Time(value: 0.5),
      ],
      award: [Wisdom(value: 0.01), Publicity(value: 0.01)],
      timeToSolve: 900000.0,
      duration: 1000.0,
      modifier: [
        AddTask(task: "Kasse führen"),
        RemoveTask(task: "Abrechnung")
      ]),
  Task(
      name: "Alle für den Basar anfragen",
      description: "ein Basar mach nur mit vielen Angeboten sinn",
      cost: [
        Member(value: 5.0),
        Time(value: 8.0),
        Faith(value: 10.0),
        Wisdom(value: 5.0)
      ],
      award: [Faith(value: 6.0), Wisdom(value: 2.0)],
      duration: 16000.0,
      modifier: [
        AddTask(task: "Basar"),
        RemoveTask(task: "Alle für den Basar anfragen")
      ]),
  Task(
      name: "Basar",
      description: "jippi ein Basar",
      cost: [
        Money(value: 100.0),
        Time(value: 10.0),
        Wisdom(value: 10.0)
      ],
      award: [
        Member(value: 5.3),
        Money(value: 800.0),
        Wisdom(value: 20.0)
      ],
      duration: 20000.0,
      modifier: [
        AddTask(task: "Einen Basar planen"),
        RemoveTask(task: "Basar")
      ]),
  Task(
      name: "Mails beantworten",
      description: "Sie haben Post",
      cost: [Time(value: 0.5)],
      award: [Publicity(value: 0.5)],
      timeToSolve: 90000.0,
      duration: 2000.0,
      missed: [
        SubtractRes(
            ressources: [
              Publicity(value: 1.0)
            ]
        )
      ],
      modifier: [
        RemoveTask(task: "Mails beantworten"),
        AddTask(task: "Mails...")
      ]
  ),
  Task(
      name: "Korps fegen und putzen",
      description:
      "Na hier siehts aber aus.. früher hätte ich das ja selber gemacht... aber hier muss mal gewischt werden",
      cost: [Time(value: 1.0)],
      award: [
        Publicity(value: 0.1),
        Member(value: 0.05)
      ],
      timeToSolve: 70000.0,
      duration: 20000.0,
      missed: [
        AddTask(task: "Ein zwischenmenschliches Problem klären"),
        RemoveTask(task: "Korps fegen und putzen"),
        AddTask(task: "Korps fegen und putzen"),
      ],
      modifier: [
        AddTask(task: "Korps aufräumen"),
        RemoveTask(task: "Korps fegen und putzen")
      ]
  ),
];
