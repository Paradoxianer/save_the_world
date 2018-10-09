import 'package:flutter/material.dart';
import 'package:save_the_world_flutter_app/globals.dart';

class LevelList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<int> stageList = stages.keys.toList();
    return ListView.builder(
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          contentPadding: EdgeInsets.all(0.0),
          leading: Container(
              padding: EdgeInsets.all(5.0),
              child: Text(index.toString(),
                  textScaleFactor: 2.0
              )
          ),
          title: Text("bis " + stageList[index].toString() + " Mitglieder"),
          subtitle: Text(stages[stageList[index]]),
        );
      },
      itemCount: stages.length,
    );
  }
}
