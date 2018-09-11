import 'package:save_the_world_flutter_app/models/faith.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/member.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/money.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/publicity.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/ressource.model.dart';
import 'package:save_the_world_flutter_app/models/task.model.dart';
import 'package:save_the_world_flutter_app/models/time.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/wisdome.ressource.model.dart';

class Game{
  static Map<String,Ressource> ressources = new Map<String,Ressource>();

  static List<Task> tasks;

  Game(){
    ressources[Faith().name]=Faith(value: 100.0);
    ressources[Money().name]=Money(value: 10.0);
    ressources[Time().name]=Time(value: 24.0);
    ressources[Member().name]=Member(value:1.0);
    ressources[Publicity().name]=Publicity(value: 1.0);
    ressources[Wisdome().name]=Wisdome(value: 10.0);
    tasks = <Task>[
      Task(
        name: "studieren",
        description: "man lernt was",
        cost:<Ressource>[
          Money(value:200.0),
          Time(value:1.5),
        ],
        award: <Ressource> [
          Faith(value: 2.00),
          Wisdome(value: 2.0),
        ],
      ),
      Task(
        name: "Wirtschaftsmission",
        description: "durch die Kneipen ziehen und Geld sammeln",
        cost:<Ressource>[
          Money(value:20.0),
          Time(value:4.0),
        ],
        award: <Ressource> [
          Money(value: 100.00),
          Publicity(value: 2.0),
        ],
      ),
      Task(
        name: "Beten für andere",
        description: "wenn du für andere betest, dann passiert was",
        cost:<Ressource>[
          Time(value:1.0),
        ],
        award: <Ressource> [
          Faith(value: 1.0),
        ],
      ),
      Task(
        name: "Predigt schreiben",
        description: "wenn du eine Predigt geschrieben hast... kannst du auch eine halten :-D",
        cost:<Ressource>[
          Time(value:8.0),
          Faith(value:100.0)
        ],
        award: <Ressource> [
          Member(value: 0.02),
        ],
      ),
      Task(
        name: "Kasse führen",
        description: "die Kasse die muss in Ordnung sein",
        cost:<Ressource>[
          Time(value:2.0)
        ],
        award: <Ressource> [
          Money(value: 1.0),
        ],
          duration: 1000.0
      ),
      Task(
          name: "Korps aufräumen",
          description: "immer schön Ordnung schaffen. Wenn nicht gibt ein Problem mit den Mitgliedern :)",
          cost:<Ressource>[
            Time(value:1.0)
          ],
          award: null,
          timeToSolve: 1000.0
      ),
      Task(
        name: "Seelsorge",
        description: "Pastor... ich hab da ein Problem",
        cost:<Ressource>[
          Time(value:1.0),
          Wisdome(value: 1.0)
        ],
        award: <Ressource> [
          Wisdome(value: 1.5)
        ],
      ),
      Task(
        name: "Bibellesen",
        description: "Zeit mit Gott",
        cost: <Ressource>[
          Time(value: 1.0),
        ],
        award: <Ressource>[
          Faith(value: 2.0),
          Wisdome(value: 1.5)
        ],
      ),
      Task(
          name: "Mails...",
          description: "Sie haben Post",
          cost:<Ressource>[
            Time(value:1.0)
          ],
          award: null,
          timeToSolve: 50000.0
      ),
      Task(
        name: "schlafen",
        description: "Sollte man auch mal tun... das Gehirn benötig 8 Stunden Schlaf um \"schlauer zu werden\"",
        cost:<Ressource>[
          Time(value:8.0)
        ],
        award: <Ressource> [
          Time(value: 16.0)
        ],
      ),
    ];
  }
}
