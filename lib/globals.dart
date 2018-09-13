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

final List<Task> testTasks = <Task>[
  Task(
      name: "Ein zwischenmenschliches Problem klären",
      description: "Ein Gemeindemitglied kommt zu dir: Ich bin soooo sauer!!!!!!",
      cost: <Ressource>[
        Time(value: 3.0),
        Wisdome(value: 100.0)
      ],
      award: <Ressource>[
        Member(value: 0.25),
        Wisdome(value: 101.0)
      ],
      duration: 6000.0,
      timeToSolve: 6000.0,
      missed: <Modifier>[
        SubtractRes(
            ressources: <Ressource>[
              Member(value: 0.5)
            ]
        ),
        AddTask(
            task: "Ein zwischenmenschliches Problem klären"
        )
      ]
  ),
  Task(
    name: "studieren",
    description: "man lernt was",
    cost: <Ressource>[
      Money(value: 200.0),
      Time(value: 8.0),
    ],
    award: <Ressource>[
      Faith(value: 50.00),
      Wisdome(value: 50.0),
    ],
  ),
  Task(
    name: "Wirtschaftsmission",
    description: "durch die Kneipen ziehen und Geld sammeln",
    cost: <Ressource>[
      Money(value: 20.0),
      Time(value: 4.5),
    ],
    award: <Ressource>[
      Money(value: 100.00),
      Publicity(value: 1.0),
    ],
  ),
  Task(
    name: "Beten für andere",
    description: "wenn du für andere betest, dann passiert was",
    cost: <Ressource>[
      Time(value: 1.0),
    ],
    award: <Ressource>[
      Faith(value: 1.0),
      Member(value: 0.10),
    ],
  ),
  Task(
      name: "Predigt schreiben",
      description: "wenn du eine Predigt geschrieben hast... kannst du auch eine halten :-D",
      cost: <Ressource>[
        Time(value: 8.0),
        Faith(value: 100.0)
      ],
      award: <Ressource>[
        Member(value: 0.02),
        Faith(value: 60.0)
      ],
      duration: 8000.0,
      modifer: <Modifier>[
        AddTask(
            task: "Gottesdienst halten"
        ),
        RemoveTask(
            task: "Predigt schreiben"
        )
      ]
  ),
  Task(
      name: "Kasse führen",
      description: "die Kasse die muss in Ordnung sein",
      cost: <Ressource>[
        Time(value: 2.0)
      ],
      award: <Ressource>[
        Money(value: 0.10),
      ],
      duration: 4000.0
  ),
  Task(
      name: "Korps aufräumen",
      description: "immer schön Ordnung schaffen. Wenn nicht gibt ein Problem mit den Mitgliedern :)",
      cost: <Ressource>[
        Time(value: 1.0)
      ],
      award: null,
      timeToSolve: 20000.0,
      duration: 2000.0
  ),
  Task(
    name: "Seelsorge",
    description: "Pastor... ich hab da ein Problem",
    cost: <Ressource>[
      Time(value: 1.0),
      Wisdome(value: 1.0)
    ],
    award: <Ressource>[
      Wisdome(value: 2.0),
      Member(value: 0.25)
    ],
  ),
  Task(
      name: "Bibellesen",
      description: "Zeit mit Gott",
      cost: <Ressource>[
        Time(value: 1.0),
      ],
      award: <Ressource>[
        Faith(value: 5.0),
        Wisdome(value: 2.0)
      ],
      duration: 2000.0
  ),
  Task(
      name: "Mails...",
      description: "Sie haben Post",
      cost: <Ressource>[
        Time(value: 1.0)
      ],
      award: null,
      timeToSolve: 50000.0,
      duration: 2000.0,
      missed: <Modifier>[
        AddTask(task: "Rechnung nicht bezahlt")
      ]
  ),
  Task(
      name: "schlafen",
      description: "Sollte man auch mal tun... das Gehirn benötig 8 Stunden Schlaf um \"schlauer zu werden\"",
      cost: <Ressource>[
        Time(value: 8.0)
      ],
      award: <Ressource>[
        Time(value: 16.0)
      ],
      duration: 16000.0
  ),
  Task(
      name: "Spender anschreiben",
      description: "vielleicht bringt ja ein netter Brief was",
      cost: <Ressource>[
        Time(value: 4.0),
        Faith(value: 50.0)
      ],
      award: <Ressource>[
        Faith(value: 40.0),
        Money(value: 10.0)
      ],
      duration: 8000.0
  )
];


final List<Task> hiddenTasks = <Task>[
  Task(
      name: "Gottesdienst halten",
      description: "schön mit Predigt, lieder und natürlich Bibelles",
      cost: <Ressource>[
        Member(value: 2.0),
        Time(value: 2.0),
        Faith(value: 200.0)
      ],
      award: <Ressource>[
        Faith(value: 250.0),
        Member(value: 2.5),
        Money(value: 20.0)
      ],
      duration: 4000.0,
      modifer: <Modifier>[
        RemoveTask(
            task: "Gottesdienst halten"
        ),
        AddTask(
            task: "Predigt schreiben"
        )
      ]
  ),
  Task(
      name: "Ein zwischenmenschliches Problem klären",
      description: "Ein Gemeindemitglied kommt zu dir: Ich bin soooo sauer!!!!!!",
      cost: <Ressource>[
        Time(value: 3.0),
        Wisdome(value: 100.0)
      ],
      award: <Ressource>[
        Member(value: 0.25),
        Wisdome(value: 101.0)
      ],
      duration: 6000.0,
      timeToSolve: 6000.0
  ),
  Task(
      name: "Rechnung nicht bezahlt",
      description: "ohoh du hast wohl die Rechnung nicht bezahlt",
      cost: <Ressource>[
        Money(value: 25.0),
      ],
      award: <Ressource>[
        Wisdome(value: 1.0)
      ],
      duration: 1000.0,
      timeToSolve: 60000.0,
      missed: <Modifier>[
        AddTask(
            task: "Rechnung nicht bezahlt"
        ),
        AddTask(
            task: "Rechnung nicht bezahlt"
        )
      ]
  ),
];