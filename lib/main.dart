import 'package:flutter/material.dart';
import 'home_page.dart';

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
              Icon(Icons.directions_car),
              Icon(Icons.directions_transit),
              Icon(Icons.directions_bike),
            ],
          ),
        ),
      ),
    );
  }
}

/*
tabs: [
                Tab(text: "100 €",icon: Icon(Icons.home)),
                Tab(text: "100 €",icon: Icon(Icons.attach_money)),
                Tab(text: "10",icon: Icon(Icons.school)),
                Tab(text: "20",icon: Icon(Icons.whatshot)),
                Tab(text: "20",icon: Icon(Icons.public)),
                Tab(text: "20",icon: Icon(Icons.poll)),
                Tab(text: "20",icon: Icon(Icons.book)),
                Tab(text: "20",icon: Icon(Icons.show_chart)),
                Tab(text: "20",icon: Icon(Icons.group)),
              ],
 */