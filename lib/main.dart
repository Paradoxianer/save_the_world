import 'package:flutter/material.dart';
import 'package:save_the_world_flutter_app/models/ressource.model.dart';
import 'package:save_the_world_flutter_app/widgets/ressourcetable.item.dart';
import 'home_page.dart';

void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    List<Ressource> ressourceList = new List<Ressource>();
    ressourceList.add(Ressource(name: "test",description: "bla",icon:Icons.add,value: 200.toDouble(),modifer: null));
    ressourceList.add(Ressource(name: "test",description: "bla",icon:Icons.map,value: 20.toDouble(),modifer: null));
    ressourceList.add(Ressource(name: "test",description: "bla",icon:Icons.attach_money,value: -50.toDouble(),modifer: null));
    ressourceList.add(Ressource(name: "test",description: "bla",icon:Icons.public,value: 40.toDouble(),modifer: null));
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
                      child: Table(
                      children:[
                        TableRow(
                          children: [
                            Column(
                              children: <Widget>[
                                Icon(Icons.attach_money),
                                Text("100 €"),
                              ],
                            ),
                            Column(
                              children: <Widget>[
                                Icon(Icons.school),
                                Text("100"),
                              ],
                            ),
                            Column(
                              children: <Widget>[
                                Icon(Icons.whatshot),
                                Text("10"),
                              ],
                            ),
                            Column(
                              children: <Widget>[
                                Icon(Icons.public),
                                Text("10"),
                              ],
                            ),
                            Column(
                              children: <Widget>[
                                Icon(Icons.accessibility_new),
                                Text("10"),
                              ],
                            ),
                          ],
                        ),
                        TableRow(
                          children: [
                            Column(
                              children: <Widget>[
                                Icon(Icons.poll),
                                Text("50"),
                              ],
                            ),
                            Column(
                              children: <Widget>[
                                Icon(Icons.book),
                                Text("70"),
                              ],
                            ),
                            Column(
                              children: <Widget>[
                                Icon(Icons.show_chart),
                                Text("10"),
                              ],
                            ),
                            Column(
                              children: <Widget>[
                                Icon(Icons.group),
                                Text("10"),
                              ],
                            ),
                            Column(
                              children: <Widget>[
                                Icon(Icons.accessibility_new),
                                Text("10"),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    ),
                  ],
                )

            ),
            title: Text('Rette die Welt'),
          ),
          body: TabBarView(
            children: [
              new RessourceTable(ressourceList: ressourceList),
            ],
          ),
        ),
      ),
    );
  }
}

