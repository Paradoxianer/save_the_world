import 'package:save_the_world_flutter_app/models/addtask.model.dart';
import 'package:save_the_world_flutter_app/models/faith.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/member.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/modifier.model.dart';
import 'package:save_the_world_flutter_app/models/money.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/publicity.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/removetask.model.dart';
import 'package:save_the_world_flutter_app/models/ressource.model.dart';
import 'package:save_the_world_flutter_app/models/setmax.model.dart';
import 'package:save_the_world_flutter_app/models/subtractres.model.dart';
import 'package:save_the_world_flutter_app/models/task.model.dart';
import 'package:save_the_world_flutter_app/models/time.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/wisdome.ressource.model.dart';

final List<String> activeTasks = <String>[
  "Bibellesen",
  "Gottesdienst vorbereiten",
  "studieren",
  "Wirtschaftsmission",
  "Beten für andere",
  "Kasse führen",
  "Seelsorge",
  "Mails...",
  "Spender anschreiben",
  "Einen Basar planen",
  "die Nacht durcharbeiten",
  "schlafen",
  "Freizeit",
  "Einen Gottesdienstraum zu Mieten suchen",
];

final List<String> randomTasks = <String>[
  "Rechnung nicht bezahlt",
  "Der Heilige Geist möchte wirken",
];

final List<Task> taskLista = <Task>[
  Task(
    name: "Ein zwischenmenschliches Problem klären",
    description: "Ein Gemeindemitglied kommt zu dir: Ich bin soooo sauer!!!!!!",
    duration: 6000.0,
    timeToSolve: 6000.0,
    cost: <Ressource>[
      Time(value: 3.0),
      Wisdom(value: 100.0)
    ],
    award: <Ressource>[
      Member(value: 0.25),
      Wisdom(value: 101.0)
    ],
    missed: <Modifier>[
      RemoveTask(task: "Ein zwischenmenschliches Problem klären"),
      SubtractRes(ressources: <Ressource>[
        Member(value: 0.5)
      ]
      ),
      AddTask(task: "Streit in der Gemeinde")
    ],
    modifier: <Modifier>[
      RemoveTask(task: "Ein zwischenmenschliches Problem klären")
    ],
  ), Task(
    name: "Streit in der Gemeinde",
    description: "Es ist eskaliert: Das ist mir echt zu viel der ist sooooo doof",
    timeToSolve: 6000.0,
    cost: <Ressource>[
      Time(value: 3.0),
      Wisdom(value: 100.0),
      Faith(value: 20.0)
    ],
    award: <Ressource>[
      Member(value: 0.1),
      Wisdom(value: 101.0),
      Faith(value: 20.5),
      Publicity(value: 2.0)
    ],
    missed: <Modifier>[
      RemoveTask(task: "Streit in der Gemeinde"),
      SubtractRes(ressources: <Ressource>[
        Member(value: 2.5)
      ]
      ),
      AddTask(task: "Streit in der Gemeinde")
    ],
    modifier: <Modifier>[
      RemoveTask(task: "Streit in der Gemeinde")
    ],
  ), Task(
    name: "Gottesdienst vorbereiten",
    description: "dann muss noch die Predigt vorbereitet werden aber bald gibt es einen Gottesdienst",
    duration: 8000.0,
    cost: <Ressource>[
      Time(value: 1.0), Faith(value: 100.0)],
    award: <Ressource>[
      Faith(value: 101.0)],
  ), Task(
    name: "Predigt schreiben",
    description: "erst wenn du eine Predigt geschrieben hast... kannst du auch eine halten :-D",
    duration: 8000.0,
    cost: <Ressource>[
      Time(value: 8.0), Faith(value: 120.0)],
    award: <Ressource>[
      Member(value: 0.02), Faith(value: 60.0)],
    modifier: <Modifier>[
      RemoveTask(task: "Predigt schreiben"),
      AddTask(task: "Gottesdienst halten")
    ],
  ), Task(
    name: "Gottesdienst halten",
    description: "schön mit Predigt, Lieder und natürlich Bibellesen",
    duration: 4000.0,
    cost: <Ressource>[
      Member(value: 2.0),
      Time(value: 2.5),
      Faith(value: 200.0)
    ],
    award: <Ressource>[
      Faith(value: 250.0),
      Member(value: 2.5),
      Money(value: 20.0)
    ],
    modifier: <Modifier>[
      RemoveTask(task: "Gottesdienst halten"),
      AddTask(task: "Gottesdienst vorbereiten")
    ],
  ), Task(
    name: "studieren",
    description: "man lernt was",
    cost: <Ressource>[
      Money(value: 200.0), Time(value: 8.0)],
    award: <Ressource>[
      Faith(value: 50.00), Wisdom(value: 50.0)],
  ), Task(
    name: "Wirtschaftmission",
    description: "durch die Kneipen ziehen und Geld sammeln",
    cost: <Ressource>[
      Money(value: 20.0), Time(value: 4.5),
    ],
    award: <Ressource>[
      Money(value: 100.00), Publicity(value: 1.0),
    ],
  ), Task(
    name: "Beten für andere",
    description: "wenn du für andere betest, dann passiert was",
    cost: <Ressource>[
      Time(value: 1.0)],
    award: <Ressource>[
      Faith(value: 1.0), Member(value: 0.10),
    ],
  ), Task(
    name: "Kasse führen",
    description: "die Kasse die muss in Ordnung sein",
    duration: 4000.0,
    timeToSolve: 100000.0,
    cost: <Ressource>[
      Time(value: 2.0)],
    award: <Ressource>[
      Money(value: 0.10)],
    missed: <Modifier>[
      AddTask(task: "Kassendifferenz finden"),
      RemoveTask(task: "Kasse führen"),
      AddTask(task: "Buchen")
    ],
    modifier: <Modifier>[
      AddTask(task: "Buchen"),
      RemoveTask(task: "Kasse führen")
    ],
  ), Task(
    name: "Buchen",
    description: "alle Ein und Ausgaben immer schön ins Programm eintragen, damit hier alles stimmt",
    duration: 2000.0,
    timeToSolve: 100000.0,
    cost: <Ressource>[
      Time(value: 0.5)],
    award: <Ressource>[
      Wisdom(value: 0.05), Publicity(value: 0.05)],
    missed: <Modifier>[
      AddTask(task: "Kassendifferenz finden"),
      RemoveTask(task: "Buchen"),
      AddTask(task: "Buchen")
    ],
    modifier: <Modifier>[
      RemoveTask(task: "Buchen"),
      AddTask(task: "Abrechnung")
    ],
  ), Task(
    name: "Abrechnung",
    description: "muss auch stimmen",
    duration: 2000.0,
    timeToSolve: 400000.0,
    cost: <Ressource>[
      Time(value: 0.5)],
    award: <Ressource>[
      Wisdom(value: 0.01), Publicity(value: 0.05)],
    missed: <Modifier>[
      RemoveTask(task: "Abrechnung"),
      AddTask(task: "Abrechnung"),
      AddTask(task: "Kassendifferenz finden")
    ],
    modifier: <Modifier>[
      RemoveTask(task: "Abrechnung"), AddTask(task: "Kasse führen"),
    ],
  ), Task(
    name: "Rechnung nicht bezahlt",
    description: "ohoh du hast wohl die Rechnung nicht bezahlt",
    duration: 10000.0,
    timeToSolve: 60000.0,
    cost: <Ressource>[
      Money(value: 30.0)],
    award: <Ressource>[
      Wisdom(value: 0.5)],
    missed: <Modifier>[
      RemoveTask(task: "Rechnung nicht bezahlt"),
      AddTask(task: "Rechnung nicht bezahlt"),
      SubtractRes(ressources: <Ressource>[Money(value: 5.0)])
    ],
    modifier: <Modifier>[
      RemoveTask(task: "Rechnung nicht bezahlt")],
  ), Task(
    name: "Kassendifferenz finden",
    description: "Mist die Kasse stimmt nicht mit der Abrechnung überein... den Fehler muss ich finden..",
    duration: 10000.0,
    timeToSolve: 70000.0,
    cost: <Ressource>[
      Time(value: 2.0)],
    award: <Ressource>[
      Wisdom(value: 0.05), Publicity(value: 0.05)],
    missed: <Modifier>[
      RemoveTask(task: "Kassendifferenz finden"),
      AddTask(task: "Kassendifferenz finden"),
      SubtractRes(ressources: <Ressource>[Money(value: 15.0)])
    ],
    modifier: <Modifier>[
      RemoveTask(task: "Kassendifferenz finden")],
  ), Task(
    name: "Seelsorge",
    description: "Pastor... ich hab da ein Problem",
    cost: <Ressource>[
      Time(value: 1.0), Wisdom(value: 3.0)],
    award: <Ressource>[
      Wisdom(value: 3.5), Member(value: 0.25)],
    modifier: <Modifier>[
      RemoveTask(task: "Seelsorge"),
      AddTask(task: "Seelsorge"),
    ],
  ), Task(
    name: "Bibellesen",
    description: "Zeit mit Gott",
    duration: 2000.0,
    cost: <Ressource>[
      Time(value: 1.0)],
    award: <Ressource>[
      Faith(value: 5.0), Wisdom(value: 2.0)],
  ), Task(
    name: "Mails...",
    description: "Sie haben Post",
    duration: 2000.0,
    timeToSolve: 90000.0,
    cost: <Ressource>[
      Time(value: 1.0)],
    missed: <Modifier>[
      RemoveTask(task: "Mails..."),
      AddTask(task: "Mails..."),
      AddTask(task: "Rechnung nicht bezahlt")
    ],
    modifier: <Modifier>[
      RemoveTask(task: "Mails..."), AddTask(task: "Mails beantworten")],
  ), Task(
    name: "Mails beantworten",
    description: "Sie haben Post",
    duration: 2000.0,
    timeToSolve: 90000.0,
    cost: <Ressource>[
      Time(value: 0.5)],
    award: <Ressource>[
      Publicity(value: 0.5)],
    missed: <Modifier>[
      SubtractRes(
          ressources: <Ressource>[Publicity(value: 1.0)]),
      RemoveTask(task: "Mails beantworten"),
      AddTask(task: "Mails...")
    ],
    modifier: <Modifier>[
      RemoveTask(task: "Mails beantworten"),
      AddTask(task: "Mails...")
    ],
  ), Task(
    name: "Spender anschreiben",
    description: "vielleicht bringt ja ein netter Brief was",
    duration: 8000.0,
    cost: <Ressource>[
      Time(value: 4.0), Faith(value: 50.0), Publicity(value: 1.0)],
    award: <Ressource>[
      Faith(value: 40.0), Money(value: 10.0)],
    modifier: <Modifier>[
      RemoveTask(task: "Spender anschreiben"),
      AddTask(task: "Spender anschreiben"),
      AddTask(task: "Spender danken")
    ],
  ), Task(
    name: "Spender danken",
    description: "ich glaube ich sollte mich für die Spenden bedanken",
    duration: 8000.0,
    timeToSolve: 100000.0,
    cost: <Ressource>[
      Time(value: 1.0), Faith(value: 50.0), Wisdom(value: 10.0)],
    award: <Ressource>[
      Money(value: 5.00),
      Publicity(value: 2.5)
    ],
    missed: <Modifier>[
      SubtractRes(
          ressources: <Ressource>[Publicity(value: 2.0)]),
      RemoveTask(task: "Spender danken")
    ],
    modifier: <Modifier>[
      RemoveTask(task: "Spender danken")],
  ), Task(
    name: "schlafen",
    description: "Sollte man auch mal tun... das Gehirn benötig 8 Stunden Schlaf um \"schlauer zu werden\"",
    duration: 16000.0,
    cost: <Ressource>[
      Time(value: 8.0)],
    award: <Ressource>[
      Time(value: 18.0)],
  ), Task(
    name: "Die Nacht durcharbeiten",
    description: "Ahhhh.... ich muss noch so viel machen... ich brauche mehr Zeit",
    duration: 8000.0,
    cost: <Ressource>[
      Faith(value: 5.0),
      Wisdom(value: 10.0),
      Publicity(value: 10.0)
    ],
    award: <Ressource>[
      Time(value: 6.0)],
  ), Task(
    name: "Einen Basar planen",
    description: "hmm ein Basar spült vielleicht ein bisschen Geld in die Kasse",
    duration: 6000.0,
    cost: <Ressource>[
      Time(value: 3.0),
      Faith(value: 10.0),
      Wisdom(value: 2.0)
    ],
    award: <Ressource>[
      Faith(value: 8.0)],
    modifier: <Modifier>[
      AddTask(task: "Alle für den Basar anfragen"),
      RemoveTask(task: "Einen Basar planen")
    ],
  ), Task(
    name: "Alle für den Basar anfragen",
    description: "ein Basar mach nur mit vielen Angeboten sinn",
    duration: 17000.0,
    cost: <Ressource>[
      Member(value: 5.0),
      Time(value: 8.0),
      Faith(value: 10.0),
      Wisdom(value: 5.0)
    ],
    award: <Ressource>[
      Faith(value: 6.0), Wisdom(value: 2.0)],
    modifier: <Modifier>[
      AddTask(task: "Basar"),
      RemoveTask(task: "Alle für den Basar anfragen")
    ],
  ), Task(
    name: "Basar",
    description: "jippi ein Basar",
    duration: 20000.0,
    cost: <Ressource>[
      Money(value: 100.0),
      Time(value: 10.0),
      Wisdom(value: 10.0)
    ],
    award: <Ressource>[
      Member(value: 5.3),
      Money(value: 800.0),
      Wisdom(value: 20.0)
    ],
    modifier: <Modifier>[
      AddTask(task: "Einen Basar planen"),
      RemoveTask(task: "Basar")
    ],
  ), Task(
    name: "Freizeit",
    description: "du hast echt zu viel gearbeitet... jetzt musst du ersteinmal warten...",
    duration: 9000.0,
    cost: <Ressource>[
      Publicity(value: 0.1)],
    award: <Ressource>[
      Time(value: 0.3)],
  ), Task(
    name: "Wirtschaftsmission",
    description: "durch die Kneipen ziehen Infomaterial verteilen, mit Menschen quatschen und Geld sammeln",
    cost: <Ressource>[
      Money(value: 20.0),
      Time(value: 4.5)
    ],
    award: <Ressource>[
      Money(value: 100.00),
      Publicity(value: 1.5)
    ],
    modifier: <Modifier>[
      RemoveTask(task: "Wirtschaftsmission"),
      AddTask(task: "Wirtschaftsmission")
    ],
  ), Task(
    name: "Hauskreis gründen",
    description: "Hmm... so Gemeinschaft und gemeinsam Bibellernen... ich glaube das wäre gut!",
    duration: 20000.0,
    cost: <Ressource>[
      Member(value: 1.0),
      Time(value: 1.0),
      Faith(value: 100.0),
      Wisdom(value: 100.0)
    ],
    award: <Ressource>[
      Faith(value: 101.0), Wisdom(value: 50.0)],
    modifier: <Modifier>[
      RemoveTask(task: "Hauskreis gründen"),
      AddTask(task: "Erstes Hauskreistreffen"),
    ],
  ), Task(
    name: "Erstes Hauskreistreffen",
    description: "lasst uns ersteinmal klären ob wir wirklich nen Hauskreis wollen",
    duration: 20000.0,
    cost: <Ressource>[
      Member(value: 2.0),
      Time(value: 2.5),
      Faith(value: 200.0)
    ],
    award: <Ressource>[
      Member(value: 3.0),
        Faith(value: 10.0),
      Wisdom(value: 5.0)
    ],
    modifier: <Modifier>[
      RemoveTask(task: "Erstes Hauskreistreffen"),
      AddTask(task: "Hauskreis vorbereiten"),
    ],
  ), Task(
    name: "Hauskreis vorbereiten",
    description: "Ich freu mich lecker Essen, Gemeinschaft, Bibellesen... aber ich sollte noch mal checken ob alle kommen und ein Thema brauchen wir auch noch.",
    duration: 10000.0,
    cost: <Ressource>[
      Time(value: 1.5),
        Faith(value: 10.0),
      Wisdom(value: 10.0)
    ],
    award: <Ressource>[
      Faith(value: 11.0),
      Wisdom(value: 11.0)
    ],
    modifier: <Modifier>[
      RemoveTask(task: "Hauskreis vorbereiten"), AddTask(task: "Hauskreis")],
  ), Task(
    name: " Hauskreis",
    description: "lecker Essen, Gemeinschaft, Bibellesen... Super!",
    duration: 10000.0,
    cost: <Ressource>[
      Time(value: 2.0),
      Member(value: 4.0)
    ],
    award: <Ressource>[
      Faith(value: 5.0),
        Wisdom(value: 5.0),
      Member(value: 4.5)
    ],
    modifier: <Modifier>[
      RemoveTask(task: "Hauskreis"),
      AddTask(task: "Hauskreis vorbereiten")
    ],
  ), Task(
    name: "Einen Gottesdienstraum zu Mieten suchen",
    description: "wir sind so groß... wir sollten jetzt wirklich anfangen einen kleinen Saal für den Gottesdienst zu miieten.. dafür müssen aber alle schön suchen... aber wenn wir das schaffen schaffen wir alles",
    duration: 100000.0,
    cost: <Ressource>[
      Member(value: 16.0),
        Faith(value: 500.0),
        Time(value: 10.0),
      Wisdom(value: 200.0)
    ],
    award: <Ressource>[
      Member(value: 17.0),
        Faith(value: 550.0),
      Wisdom(value: 220.0)
    ],
    modifier: <Modifier>[
      RemoveTask(task: "Einen Gottesdienstraum zu Mieten suchen.."),
      SetMax(ressource: "Member", newMax: 40.0),
    ],
  )
];