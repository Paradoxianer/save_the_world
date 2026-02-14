import 'package:flutter/material.dart';
import 'package:save_the_world_flutter_app/globals.dart';

class LevelList extends StatelessWidget {
  const LevelList({super.key});

  @override
  Widget build(BuildContext context) {
    List<int> stageList = levels.keys.toList();
    return ListView.builder(
      itemBuilder: (BuildContext context, int index) {
        final int memberThreshold = stageList[index];
        final String stageName = levels[memberThreshold] ?? "Unbekannt";
        
        return ListTile(
          contentPadding: const EdgeInsets.all(0.0),
          leading: Container(
              padding: const EdgeInsets.all(5.0),
              child: Text(
                index.toString(),
                textScaler: const TextScaler.linear(2.0),
              )
          ),
          title: Text("bis $memberThreshold Mitglieder"),
          subtitle: Text(stageName),
        );
      },
      itemCount: levels.length,
    );
  }
}
