import 'package:flutter/material.dart';
import 'package:save_the_world_flutter_app/globals.dart';
import 'package:save_the_world_flutter_app/models/game.ressource.model.dart';

class StageItem extends StatefulWidget {
  final double size;

  const StageItem({super.key, this.size = 30.0});

  @override
  State<StageItem> createState() => StageItemState();
}

class StageItemState extends State<StageItem> {
  late Game game;

  @override
  void initState() {
    super.initState();
    game = Game.getInstance();
    game.addStageListener(valueChanged);
  }

  @override
  void dispose() {
    game.removeListener(valueChanged);
    super.dispose();
  }

  void valueChanged() {
    if (mounted) {
      debugPrint("show the dialog");
      showNewStage(context);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Icon(Icons.home, size: widget.size),
        Text(
          game.stage.toString(),
          textScaler: TextScaler.linear(widget.size / 30.0),
        ),
      ],
    );
  }
}

void showNewStage(BuildContext context) {
  showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        List<int> stageList = levels.keys.toList();
        final currentStage = Game.getInstance().stage;
        final stageTitle = levels[stageList[currentStage]] ?? "Unbekannt";
        final maxMembers = stageList[currentStage].toString();

        return SimpleDialog(
            title: const Text('Gratulation'),
            children: <Widget>[
              Stack(children: <Widget>[
                Align(
                    alignment: Alignment.center,
                    child: Image.asset('assets/icons/award.png')),
                Positioned(
                    left: 124.0,
                    top: 36.0,
                    child: Text(
                      currentStage.toString(),
                      textScaler: const TextScaler.linear(4),
                    ))
              ]),
              const Text("\n du bist jetzt eine", textAlign: TextAlign.center),
              Text("$stageTitle\n", textAlign: TextAlign.center),
              Text("du kannst jetzt bis $maxMembers Mitglieder erreichen",
                  textAlign: TextAlign.center),
            ]);
      });
}
