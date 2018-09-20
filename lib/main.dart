import 'package:flutter/material.dart';
import 'package:save_the_world_flutter_app/models/game.ressource.model.dart';
import 'package:save_the_world_flutter_app/widgets/ressourcetable.item.dart';
import 'package:save_the_world_flutter_app/widgets/task.list.dart';

void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
                        ressourceList: Game.ressources.values.toList(),
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
              TaskList()
            ],
          ),
        ),
      ),
    );
  }
}
