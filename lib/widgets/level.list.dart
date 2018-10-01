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
          leading: Text("Mitglieder: " + stageList[index].toString()),
          title: Text(stages[stageList[index]]),
        );
      },
      itemCount: stages.length,
    );
  }
}
