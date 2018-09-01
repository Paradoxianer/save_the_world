import 'package:flutter/material.dart';
import 'package:save_the_world_flutter_app/models/faith.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/member.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/money.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/publicity.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/ressource.model.dart';
import 'package:save_the_world_flutter_app/models/task.model.dart';
import 'package:save_the_world_flutter_app/models/time.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/wisdome.ressource.model.dart';
import 'package:save_the_world_flutter_app/widgets/ressourcetable.item.dart';
import 'package:save_the_world_flutter_app/widgets/task.item.dart';

void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    List<Ressource> cost = new List<Ressource>();
    cost.add(Money(value:100.0));
    cost.add(Ressource(name: "Time",description: "bla",icon:Icons.access_time,value: 50.toDouble(),modifier: null));
    cost.add(Ressource(name: "Wisdome",description: "bla",icon:Icons.school,value: 40.toDouble(),modifier: null));
    cost.add(Ressource(name: "Belive",description: "bla",icon:Icons.add,value: 24.toDouble(),modifier: null));
    List<Ressource> award = new List<Ressource>();
    award.add(Ressource(name: "Wisdome",description: "bla",icon:Icons.school,value: 200.toDouble(),modifier: null));
    award.add(Ressource(name: "Belive",description: "bla",icon:Icons.add,value: 200.toDouble(),modifier : null));

    List<Task> tasks = new List<Task>();
    tasks.add(Task(
        name: "studieren",
        description: "wenn du studierst lernst du!!",
        cost: cost,
        award: award,
        require: null,
        modifer: null
    ));
    return MaterialApp(
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            bottom: PreferredSize(
                preferredSize:  const Size.fromHeight(50.0),
                child: Row(
                  children: <Widget>[
                    FittedBox(
                      child:
                      IconButton(
                        icon: Icon(Icons.home),
                        onPressed: null,
                      ),
                    ),
                    Expanded(
                      child: RessourceTable(
                        ressourceList: globalRes,
                        size: 25.0,
                      )
                    ),
                  ],
                )

            ),
            title: Text('Rette die Welt'),
          ),
          body: TabBarView(
            children: [
              ListView.builder(
                  itemBuilder: (BuildContext context, int index) =>
                      TaskItem(task : toDo[index]),
                itemCount: toDo.length,
              )
              //new RessourceTable(ressourceList: ressourceList),
            ],
          ),
        ),
      ),
    );
  }
}
final List<Ressource> globalRes = <Ressource>[
  Faith(value: 100.0),
  Money(value: 100.0),
  Time(value: 24.0),
  Member(value:1.0),
  Publicity(value: 0.0),
  Wisdome(value: 10.0)

];

final List<Task> toDo = <Task>[
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
    description: "wenn du für andere betest, dann passiert was",
    cost:<Ressource>[
      Time(value:8.0),
      Faith(value:100.0)
    ],
    award: <Ressource> [
      Member(value: 0.2),
    ],
  ),
];
