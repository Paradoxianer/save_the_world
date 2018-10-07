import 'package:flutter/material.dart';
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
