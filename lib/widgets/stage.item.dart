import 'package:flutter/material.dart';
import 'package:save_the_world_flutter_app/globals.dart';
import 'package:save_the_world_flutter_app/models/game.ressource.model.dart';
import 'package:save_the_world_flutter_app/widgets/celebration_dialog.dart';

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
      debugPrint("Celebrating new stage: ${game.stage}");
      showCelebration(context, game.stage);
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
          style: TextStyle(
            fontSize: widget.size * 0.5,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
