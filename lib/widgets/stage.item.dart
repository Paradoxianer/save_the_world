import 'package:flutter/material.dart';
import 'package:save_the_world_flutter_app/globals.dart';
import 'package:save_the_world_flutter_app/models/game.ressource.model.dart';

class StageItem extends StatefulWidget {
  double size;

  StageItem([this.size = 30.0]);

  @override
  StageItemState createState() => StageItemState(size);
}

class StageItemState extends State<StageItem> {
  Game game;
  double size;


  StageItemState([this.size = 30.0]) {
    game = Game.getInstance();
    game.addStageListener(valueChanged);
  }

  valueChanged() {
    print("show the dialog");
    showNewStage(context);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Icon(Icons.home, size: size),
        Text(Game.getInstance().stage.toString(),
            textScaleFactor: (size / 30.0)),
      ],
    );
  }
}

void showNewStage(BuildContext context) {
  showDialog(
      context: context,
      barrierDismissible: true, // user must tap button for close dialog!
      builder: (BuildContext context) {
        List<int> stageList = levels.keys.toList();
        return SimpleDialog(
            title: Text('Gratulation'),
            children: <Widget>[
              Stack(
                  children: <Widget>[
                    Align(
                        alignment: Alignment.center,
                        child: Image.asset('assets/icons/award.png')
                    ),
                    Positioned(
                        left: 124.0,
                        top: 36.0,
                        child: Text(Game
                            .getInstance()
                            .stage
                            .toString(),
                            textScaleFactor: (4)
                        )
                    )
                  ]
              ),
              Text("\n du bist jetzt eine", textAlign: TextAlign.center),
              Text("" + levels[stageList[Game
                  .getInstance()
                  .stage]] + "\n", textAlign: TextAlign.center),
              Text("du kannst jetzt bis " + stageList[Game
                  .getInstance()
                  .stage].toString() + " Mitglieder erreichen",
                  textAlign: TextAlign.center),

            ]
        );
      }
  );
}
